import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('My Confirmed Flights')),
      body: FutureBuilder<List<ConfirmedFlight>>(
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
          );
        },
      ),
    );
  }
}
