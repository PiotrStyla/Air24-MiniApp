import 'package:flutter/material.dart';
import '../services/aviation_stack_service.dart';
import 'claim_submission_screen.dart';
import 'dart:io';

class CompensationEligibleFlightsScreen extends StatefulWidget {
  final String airportIcao;
  const CompensationEligibleFlightsScreen({Key? key, required this.airportIcao}) : super(key: key);

  @override
  State<CompensationEligibleFlightsScreen> createState() => _CompensationEligibleFlightsScreenState();
}

class _CompensationEligibleFlightsScreenState extends State<CompensationEligibleFlightsScreen> {
  late Future<List<Map<String, dynamic>>> _arrivalsFuture;
  late AviationStackService _service;

  String _carrierFilter = '';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _arrivalsFuture = _loadArrivals();
  }

  Future<List<Map<String, dynamic>>> _loadArrivals() async {
    try {
      // Initialize AviationStackService to get flight data
      // Using only AviationStack as the source for all flight data
      _service = AviationStackService(baseUrl: 'http://api.aviationstack.com/v1', pythonBackendUrl: 'YOUR_PYTHON_BACKEND_URL_HERE');
      return await _service.getRecentArrivals(airportIcao: widget.airportIcao, minutesBeforeNow: 720);
    } catch (e) {
      print('Error loading arrivals: $e');
      // Rethrow to be caught by the FutureBuilder
      rethrow;
    }
  }
  
  // Calculate delay in minutes between scheduled and actual times
  int _calculateDelayMinutes(Map<String, dynamic> scheduled, Map<String, dynamic> actual) {
    try {
      final scheduledStr = scheduled['utc'] ?? scheduled['local'];
      final actualStr = actual['utc'] ?? actual['local'];
      
      if (scheduledStr == null || actualStr == null) return 0;
      
      final scheduledTime = DateTime.tryParse(scheduledStr);
      final actualTime = DateTime.tryParse(actualStr);
      
      if (scheduledTime == null || actualTime == null) return 0;
      
      // Calculate the difference in minutes
      final difference = actualTime.difference(scheduledTime).inMinutes;
      return difference > 0 ? difference : 0;
    } catch (e) {
      print('Error calculating delay: $e');
      return 0;
    }
  }
  
  // Format delay minutes into a human-readable format
  String _formatDelay(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours h ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}'.trim();
    }
  }
  
  // Get compensation amount based on flight data
  String _getCompensationAmount(Map<String, dynamic> flight) {
    // Default value if not specified
    final int amount = _calculateCompensationAmount(flight);
    
    if (amount <= 0) {
      return 'Eligible (calculation needed)';
    }
    
    return '€$amount';
  }
  
  // Calculate compensation amount based on flight distance and delay
  int _calculateCompensationAmount(Map<String, dynamic> flight) {
    try {
      // If the flight data already contains a compensation amount, use that
      if (flight.containsKey('potentialCompensationAmount') && 
          flight['potentialCompensationAmount'] is int && 
          flight['potentialCompensationAmount'] > 0) {
        return flight['potentialCompensationAmount'];
      }
      
      // Otherwise, estimate based on flight data
      // Get flight distance if available
      final distance = flight['distance'] as int? ?? _estimateFlightDistance(flight);
      
      // Calculate based on EU261 rules
      if (distance <= 1500) {
        return 250; // Short flights (<1500km)
      } else if (distance <= 3500) {
        return 400; // Medium flights (1500-3500km)
      } else {
        return 600; // Long flights (>3500km)
      }
    } catch (e) {
      print('Error calculating compensation amount: $e');
      return 0;
    }
  }
  
  // Estimate flight distance based on airports (simplified)
  int _estimateFlightDistance(Map<String, dynamic> flight) {
    try {
      // Common route distances (very simplified)
      final String departure = flight['movement']?['airport']?['icao'] ?? '';
      final String arrival = widget.airportIcao;
      
      // Some common European routes (simplified)
      if ((departure.startsWith('LH') || arrival.startsWith('LH')) ||
          (departure.startsWith('EG') && arrival.startsWith('ED')) ||
          (departure.startsWith('ED') && arrival.startsWith('EG'))) {
        return 1000; // Germany-UK routes (short)
      } else if ((departure.startsWith('EG') && arrival.startsWith('LE')) ||
                 (departure.startsWith('LE') && arrival.startsWith('EG'))) {
        return 2000; // UK-Spain routes (medium)
      } else if ((departure.startsWith('LT') && arrival.startsWith('EG')) ||
                 (departure.startsWith('EG') && arrival.startsWith('LT'))) {
        return 3800; // Cyprus-UK routes (long)
      }
      
      // Default to medium distance if unknown
      return 2500;
    } catch (e) {
      print('Error estimating flight distance: $e');
      return 2500; // Default to medium distance
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Compensation Eligible Arrivals at ${widget.airportIcao}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _arrivalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _arrivalsFuture = _loadArrivals();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final arrivals = snapshot.data ?? [];

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
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Carrier name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => setState(() => _carrierFilter = val),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      child: Text(_selectedDate == null ? 'Pick Date' : _selectedDate!.toIso8601String().substring(0, 10)),
                    ),
                    if (_selectedDate != null)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => setState(() => _selectedDate = null),
                        tooltip: 'Clear date',
                      )
                  ],
                ),
              ),
              Expanded(
                child: filteredArrivals.isEmpty
                    ? const Center(child: Text('No compensation-eligible arrivals found for filter.'))
                    : ListView.separated(
                        itemCount: filteredArrivals.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, idx) {
                          final a = filteredArrivals[idx];
                          // Handle airline (Map or String)
                          final airline = a['airline'];
                          String airlineName;
                          if (airline is Map && airline.containsKey('name')) {
                            airlineName = airline['name'] ?? '';
                          } else if (airline is String) {
                            airlineName = airline;
                          } else {
                            airlineName = '';
                          }
                          // Handle movement (Map or String)
                          final movement = a['movement'];
                          Map<String, dynamic> airport = {};
                          Map<String, dynamic> scheduled = {};
                          Map<String, dynamic> revised = {};
                          Map<String, dynamic> actual = {};
                          if (movement is Map) {
                            airport = movement['airport'] is Map ? Map<String, dynamic>.from(movement['airport']) : {};
                            scheduled = movement['scheduledTime'] is Map ? Map<String, dynamic>.from(movement['scheduledTime']) : {};
                            revised = movement['revisedTime'] is Map ? Map<String, dynamic>.from(movement['revisedTime']) : {};
                            actual = movement['actualTime'] is Map ? Map<String, dynamic>.from(movement['actualTime']) : {};
                          }
                          // Handle aircraft (Map or String)
                          final aircraft = a['aircraft'];
                          String aircraftModel = '';
                          if (aircraft is Map && aircraft.containsKey('model')) {
                            aircraftModel = aircraft['model'] ?? '';
                          } else if (aircraft is String) {
                            aircraftModel = aircraft;
                          }
                          String flightNumber = (a['number'] ?? '').toString();
                          String titleText = '';
                          if (flightNumber.isNotEmpty && airlineName.isNotEmpty) {
                            titleText = '$flightNumber - $airlineName';
                          } else if (flightNumber.isNotEmpty) {
                            titleText = flightNumber;
                          } else {
                            titleText = airlineName;
                          }
                          return ListTile(
                            onTap: () {
                              // Extract details for prefill based on actual structure
                              String? flightNumber = (a['flightNumber'] ?? '').toString().isNotEmpty ? a['flightNumber'].toString() : null;
                              String? depIcao = (a['departureIcao'] ?? '').toString();
                              String? arrIcao = widget.airportIcao; // Arrival is the queried airport
                              DateTime? schedDate;
                              if (a['scheduledArrivalUtc'] != null && a['scheduledArrivalUtc'].toString().isNotEmpty) {
                                try {
                                  // Remove 'Z' if present for DateTime.parse
                                  String dateStr = a['scheduledArrivalUtc'].toString().replaceAll('Z', '');
                                  schedDate = DateTime.parse(dateStr);
                                } catch (_) {}
                              }
                              print('DEBUG: Flight object: ' + a.toString());
                              print('Prefill: flightNumber=$flightNumber, depIcao=$depIcao, arrIcao=$arrIcao, schedDate=$schedDate');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ClaimSubmissionScreen(
                                    key: ValueKey('${flightNumber ?? ''}_${schedDate?.toIso8601String() ?? ''}'),
                                    prefillFlightNumber: flightNumber,
                                    prefillDepartureAirport: depIcao,
                                    prefillArrivalAirport: arrIcao,
                                    prefillFlightDate: schedDate,
                                    prefillReason: 'delay',
                                  ),
                                ),
                              );
                            },
                            leading: Icon(Icons.flight_land, size: 32, color: Colors.blueGrey),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    titleText,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                if (a['compensationEligible'] == true) ...[
                                  SizedBox(width: 8),
                                  Icon(Icons.verified, color: Colors.green, size: 20),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'EU Compensation Eligible',
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Row(
                                  children: [
                                    Icon(Icons.flight_takeoff, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'From: ${airport['name'] ?? airport['icao'] ?? ''}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.schedule, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('Scheduled: ${scheduled['local'] ?? scheduled['utc'] ?? ''}'),
                                  ],
                                ),
                                if (revised['local'] != null && revised['local'] != scheduled['local'])
                                  Row(
                                    children: [
                                      Icon(Icons.update, size: 16, color: Colors.orange),
                                      SizedBox(width: 4),
                                      Text(
                                        'Revised: ${revised['local']}',
                                        style: TextStyle(color: Colors.orange[700]),
                                      ),
                                    ],
                                  ),
                                if (actual['local'] != null)
                                  Row(
                                    children: [
                                      Icon(Icons.flight_land, size: 16, color: Colors.blue),
                                      SizedBox(width: 4),
                                      Text(
                                        'Actual: ${actual['local']}',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      'Status: ${a['status'] ?? ''}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: a['status'] == 'Delayed' || a['status'] == 'Diverted' ? Colors.orange[700] : 
                                               a['status'] == 'Cancelled' ? Colors.red : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                // Calculate and display delay information
                                if (_calculateDelayMinutes(scheduled, actual) > 0)
                                  Row(
                                    children: [
                                      Icon(Icons.timelapse, size: 16, color: Colors.red),
                                      SizedBox(width: 4),
                                      Text(
                                        'Delay: ${_formatDelay(_calculateDelayMinutes(scheduled, actual))}',
                                        style: TextStyle(
                                          color: _calculateDelayMinutes(scheduled, actual) >= 180 ? Colors.red : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                // Display compensation information
                                Divider(height: 16, thickness: 0.5),
                                Row(
                                  children: [
                                    Icon(Icons.euro, size: 16, color: Colors.green),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Potential Compensation: ${_getCompensationAmount(a)}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.flight, size: 16, color: Colors.blueGrey),
                                    SizedBox(width: 4),
                                    Text(
                                      'Aircraft: ${aircraftModel.isNotEmpty ? aircraftModel : a['aircraft']?['model'] ?? 'Unknown'}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
