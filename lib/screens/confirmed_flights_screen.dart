import 'package:flutter/material.dart';
import 'faq_screen.dart';
import '../models/confirmed_flight.dart';
import '../services/confirmed_flight_storage.dart';
import 'package:intl/intl.dart';

class ConfirmedFlightsScreen extends StatefulWidget {
  const ConfirmedFlightsScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmedFlightsScreen> createState() => _ConfirmedFlightsScreenState();
}

class _ConfirmedFlightsScreenState extends State<ConfirmedFlightsScreen> {
  late Future<List<ConfirmedFlight>> _flightsFuture;

  @override
  void initState() {
    super.initState();
    _flightsFuture = ConfirmedFlightStorage().loadFlights();
  }

  Future<void> _refresh() async {
    setState(() {
      _flightsFuture = ConfirmedFlightStorage().loadFlights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Confirmed Flights'),
        actions: [
          Tooltip(
            message: 'FAQ & Help',
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is a list of flights you have confirmed. Use this list to quickly start a claim, review your travel, or keep a record for future reference.',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ConfirmedFlight>>(
              future: _flightsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No confirmed flights yet.'));
          }
          final flights = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: flights.length,
                          itemBuilder: (context, index) {
                            final flight = flights[index];
                            return ListTile(
                              leading: const Icon(Icons.flight),
                              title: Text('Callsign: ${flight.callsign}'),
                              subtitle: Text('From: ${flight.originAirport ?? '-'}  To: ${flight.destinationAirport ?? '-'}\nDetected: ${DateFormat.yMMMd().add_Hm().format(flight.detectedAt)}'),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tips & Reminders',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                            const SizedBox(height: 6),
                            const Text('• Confirm your flights to enable quick claims.'),
                            const Text('• Only flights confirmed here will be eligible for compensation.'),
                            const Text('• Tap a flight to use it for a claim or view details (feature coming soon).'),
                            const Text('• Swipe left/right to delete flights you no longer need (feature coming soon).'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
