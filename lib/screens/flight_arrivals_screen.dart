import 'package:flutter/material.dart';
import '../services/aerodatabox_service.dart';
import 'dart:io';

class FlightArrivalsScreen extends StatefulWidget {
  final String airportIcao;
  const FlightArrivalsScreen({Key? key, required this.airportIcao}) : super(key: key);

  @override
  State<FlightArrivalsScreen> createState() => _FlightArrivalsScreenState();
}

class _FlightArrivalsScreenState extends State<FlightArrivalsScreen> {
  late Future<List<Map<String, dynamic>>> _arrivalsFuture;
  late AeroDataBoxService _service;

  @override
  void initState() {
    super.initState();
    _arrivalsFuture = _loadArrivals();
  }

  Future<List<Map<String, dynamic>>> _loadArrivals() async {
    final apiKey = await File('rapidapi_key.txt').readAsString();
    _service = AeroDataBoxService();
    return _service.getRecentArrivals(airportIcao: widget.airportIcao, minutesBeforeNow: 720);
  }

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
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final arrivals = snapshot.data ?? [];
          if (arrivals.isEmpty) {
            return const Center(child: Text('No arrivals found.'));
          }
          return ListView.separated(
            itemCount: arrivals.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, idx) {
              final a = arrivals[idx];
              final movement = a['movement'] ?? {};
              final airport = movement['airport'] ?? {};
              final scheduled = movement['scheduledTime'] ?? {};
              final revised = movement['revisedTime'] ?? {};
              final airline = a['airline'] ?? {};
              final aircraft = a['aircraft'] ?? {};
              return ListTile(
                leading: Icon(Icons.flight_land),
                title: Text('${a['number'] ?? ''} - ${airline['name'] ?? ''}'),
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
