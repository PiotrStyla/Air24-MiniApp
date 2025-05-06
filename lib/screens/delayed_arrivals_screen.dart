import 'package:flutter/material.dart';
import '../services/aerodatabox_service.dart';
import '../services/airport_picker.dart';
import '../services/flight_detection_service.dart';

class DelayedArrivalsScreen extends StatefulWidget {
  final String airportIcao;
  final String airportName;

  const DelayedArrivalsScreen({
    Key? key,
    required this.airportIcao,
    required this.airportName,
  }) : super(key: key);

  @override
  State<DelayedArrivalsScreen> createState() => _DelayedArrivalsScreenState();
}

class _DelayedArrivalsScreenState extends State<DelayedArrivalsScreen> {
  late Future<List<Map<String, dynamic>>> _delayedArrivalsFuture;

  @override
  void initState() {
    super.initState();
    _delayedArrivalsFuture = _fetchDelayedArrivals();
  }

  Future<List<Map<String, dynamic>>> _fetchDelayedArrivals() async {
    String apiKey = await DefaultAssetBundle.of(context).loadString('assets/rapidapi_key.txt');
    final service = AeroDataBoxService(apiKey: apiKey.trim());
    final arrivals = await service.getRecentArrivals(airportIcao: widget.airportIcao, minutesBeforeNow: 180);
    return arrivals.where((flight) => (flight['status'] ?? '').toString().toLowerCase() == 'delayed').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delayed Arrivals at ${widget.airportName}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _delayedArrivalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No delayed arrivals found or data unavailable for this airport.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text('Try another airport'),
                    onPressed: () async {
                      final airport = await showAirportPicker(context);
                      if (airport == null) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => DelayedArrivalsScreen(
                            airportIcao: airport.code,
                            airportName: airport.name,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          final flights = snapshot.data ?? [];
          if (flights.isEmpty) {
            return const Center(child: Text('No delayed arrivals found.'));
          }
          return ListView.builder(
            itemCount: flights.length,
            itemBuilder: (context, idx) {
              final flight = flights[idx];
              final movement = flight['movement'] ?? {};
              final scheduled = movement['scheduledTime'] ?? {};
              final origin = movement['airport']?['name'] ?? '';
              final flightNum = flight['number'] ?? '';
              final scheduledTime = scheduled['utc'] ?? scheduled['local'] ?? '';
              return ListTile(
                title: Text('Flight $flightNum from $origin'),
                subtitle: Text('Scheduled: $scheduledTime'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/claim-submission',
                    arguments: {
                      'prefillFlightNumber': flightNum,
                      'prefillDepartureAirport': movement['airport']?['icao'] ?? '',
                      'prefillArrivalAirport': widget.airportIcao,
                      'prefillFlightDate': scheduledTime != '' ? DateTime.tryParse(scheduledTime) : null,
                      'prefillReason': 'delay',
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
