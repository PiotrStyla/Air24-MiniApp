import 'package:flutter/material.dart';
import '../services/aviation_stack_service.dart';
import 'dart:io';

class FlightArrivalsScreen extends StatefulWidget {
  final String airportIcao;
  const FlightArrivalsScreen({Key? key, required this.airportIcao}) : super(key: key);

  @override
  State<FlightArrivalsScreen> createState() => _FlightArrivalsScreenState();
}

class _FlightArrivalsScreenState extends State<FlightArrivalsScreen> {
  late Future<List<Map<String, dynamic>>> _arrivalsFuture;
  late AviationStackService _service;

  @override
  void initState() {
    super.initState();
    _arrivalsFuture = _loadArrivals();
  }

  Future<List<Map<String, dynamic>>> _loadArrivals() async {
    _service = AviationStackService(baseUrl: 'http://api.aviationstack.com/v1', pythonBackendUrl: 'YOUR_PYTHON_BACKEND_URL_HERE');
    return _service.getRecentArrivals(airportIcao: widget.airportIcao, minutesBeforeNow: 720);
  }

  // Filtering state
  String _carrierFilter = '';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Arrivals at ${widget.airportIcao}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _arrivalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final arrivals = snapshot.data ?? [];

          // Filtering logic
          List<Map<String, dynamic>> filteredArrivals = arrivals.where((a) {
            if (a['compensationEligible'] != true) return false;
            final airline = (a['airline'] ?? '').toString().toLowerCase();
            final carrierOk = _carrierFilter.isEmpty || airline.contains(_carrierFilter.toLowerCase());
            if (!carrierOk) return false;
            if (_selectedDate != null) {
              final sched = a['scheduledArrivalUtc'] ?? '';
              if (sched.length < 10) return false;
              final dateString = sched.substring(0, 10);
              final selectedString = _selectedDate!.toIso8601String().substring(0, 10);
              if (dateString != selectedString) return false;
            }
            return true;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
              final aircraft = a['aircraft'] ?? {};
              return ListTile(
                leading: Icon(Icons.flight_land),
                title: Row(
                  children: [
                    Text('${a['number'] ?? ''} - ${airline['name'] ?? ''}'),
                    if (a['compensationEligible'] == true) ...[
                      SizedBox(width: 8),
                      Icon(Icons.verified, color: Colors.green, size: 20),
                      SizedBox(width: 4),
                      Text('EU Compensation Eligible', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ]
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${airport['name'] ?? airport['icao'] ?? ''}'),
                    Text('Scheduled: ${scheduled['local'] ?? scheduled['utc'] ?? ''}'),
                    if (revised['local'] != null && revised['local'] != scheduled['local'])
                      Text('Revised: ${revised['local']}'),
                    Text('Status: ${a['status'] ?? ''}'),
                    if (aircraft['model'] != null)
                      Text('Aircraft: ${aircraft['model']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
