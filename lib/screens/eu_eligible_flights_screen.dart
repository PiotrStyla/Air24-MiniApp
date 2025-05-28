import 'package:flutter/material.dart';
import '../services/aviation_stack_service.dart';
import 'compensation_claim_form_screen.dart';

class EUEligibleFlightsScreen extends StatefulWidget {
  const EUEligibleFlightsScreen({super.key});

  @override
  State<EUEligibleFlightsScreen> createState() => _EUEligibleFlightsScreenState();
}

class _EUEligibleFlightsScreenState extends State<EUEligibleFlightsScreen> {
  late Future<List<Map<String, dynamic>>> _flightsFuture;
  String _carrierFilter = '';
  // Fixed at 72 hours - no time filter selection needed
  static const int _hoursFilter = 72;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _flightsFuture = _loadFlights();
  }

  Future<List<Map<String, dynamic>>> _loadFlights() async {
    try {
      debugPrint('Attempting to load EU compensation eligible flights...');
      final service = AviationStackService();
      return await service.getEUCompensationEligibleFlights(hours: _hoursFilter);
    } catch (e) {
      debugPrint('Error loading flights: $e');
      // Rethrow to be handled by the FutureBuilder error handler
      rethrow;
    }
  }
  
  Future<void> _retryConnection() async {
    setState(() {
      _flightsFuture = _loadFlights();
    });
  }

  int _calculateDelayMinutes(Map<String, dynamic> scheduled, Map<String, dynamic> actual) {
    try {
      final scheduledStr = scheduled['utc'] ?? scheduled['local'];
      final actualStr = actual['utc'] ?? actual['local'];
      
      if (scheduledStr != null && actualStr != null) {
        final scheduledTime = DateTime.parse(scheduledStr);
        final actualTime = DateTime.parse(actualStr);
        return actualTime.difference(scheduledTime).inMinutes;
      }
    } catch (e) {
      debugPrint('Error calculating delay: $e');
    }
    return 0;
  }

  String _formatDelay(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours h ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}'.trim();
    }
  }
  
  void _openCompensationForm(BuildContext context, Map<String, dynamic> flight) {
    // Extract data for the form in a structured way
    // Following AviationStack format exclusively
    Map<String, dynamic> formattedFlight = {};
    
    // Log all available keys for debugging
    debugPrint('Available flight data keys: ${flight.keys.join(', ')}');
    
    // Extract airline from AviationStack format
    if (flight['airline'] is Map) {
      formattedFlight['airline'] = flight['airline']['name'] ?? 'Unknown Airline';
    } else if (flight['airline'] is String) {
      formattedFlight['airline'] = flight['airline'];
    }
    
    // Extract flight number - AviationStack uses 'flight' object with 'iata' property
    if (flight['flight'] is Map) {
      formattedFlight['flight_number'] = flight['flight']['iata'] ?? '';
    } else {
      formattedFlight['flight_number'] = flight['number'] ?? flight['flightNumber'] ?? '';
    }
    
    // Extract departure info from AviationStack format
    if (flight['departure'] is Map) {
      // Airport info
      formattedFlight['departure_airport'] = '${flight['departure']['airport'] ?? 'Unknown'} ' +
          '(${flight['departure']['iata'] ?? flight['departure']['icao'] ?? ''})';
      
      // Date/time info - AviationStack uses 'scheduled' property
      formattedFlight['departure_date'] = flight['departure']['scheduled'] ?? '';
    } else if (flight['departureAirport'] != null || flight['departure_airport'] != null) {
      // Fallback for already formatted data
      formattedFlight['departure_airport'] = flight['departureAirport'] ?? flight['departure_airport'] ?? 'Unknown Airport';
      formattedFlight['departure_date'] = flight['departureTime'] ?? flight['departure_date'] ?? 'Unknown Date';
    }
    
    // Extract arrival info from AviationStack format
    if (flight['arrival'] is Map) {
      // Airport info
      formattedFlight['arrival_airport'] = '${flight['arrival']['airport'] ?? 'Unknown'} ' +
          '(${flight['arrival']['iata'] ?? flight['arrival']['icao'] ?? ''})';
    } else if (flight['arrivalAirport'] != null || flight['arrival_airport'] != null) {
      // Fallback for already formatted data
      formattedFlight['arrival_airport'] = flight['arrivalAirport'] ?? flight['arrival_airport'] ?? 'Unknown Airport';
    }
    
    // Extract delay information - AviationStack has 'arrival.delay' property
    if (flight['arrival'] is Map && flight['arrival']['delay'] != null) {
      formattedFlight['delay_minutes'] = flight['arrival']['delay'];
    } else if (flight['delay_minutes'] != null) {
      formattedFlight['delay_minutes'] = flight['delay_minutes'];
    } else if (flight['delayMinutes'] != null) {
      formattedFlight['delay_minutes'] = flight['delayMinutes'];
    }
    
    // Add status information - AviationStack uses 'flight_status'
    if (flight['flight_status'] != null) {
      formattedFlight['status'] = flight['flight_status'];
    } else if (flight['status'] != null) {
      formattedFlight['status'] = flight['status'];
    }
    
    // Extract compensation amount
    int amount = 0;
    if (flight['potentialCompensationAmount'] != null) {
      amount = flight['potentialCompensationAmount'] is int 
          ? flight['potentialCompensationAmount'] 
          : int.tryParse(flight['potentialCompensationAmount'].toString()) ?? 0;
    } else {
      amount = _calculateCompensationAmount(flight);
    }
    
    if (amount > 0) {
      formattedFlight['compensation_amount_eur'] = amount;
    }
    
    debugPrint('Formatted flight data for form (AviationStack format): $formattedFlight');
    
    // Navigate to the compensation form with structured data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CompensationClaimFormScreen(flightData: formattedFlight),
      ),
    );
  }

  String _getCompensationAmount(Map<String, dynamic> flight) {
    final int amount = _calculateCompensationAmount(flight);
    
    if (amount <= 0) {
      return 'Eligible (calculation needed)';
    }
    
    return '€$amount';
  }

  int _calculateCompensationAmount(Map<String, dynamic> flight) {
    try {
      if (flight.containsKey('potentialCompensationAmount') && 
          flight['potentialCompensationAmount'] is num && 
          flight['potentialCompensationAmount'] > 0) {
        return flight['potentialCompensationAmount'].toInt();
      }
      
      final distance = flight['distance'] as int? ?? _estimateFlightDistance(flight);
      
      if (distance <= 1500) {
        return 250; // Short flights up to 1500 km: €250
      } else if (distance <= 3500) {
        return 400; // Medium flights 1500-3500 km: €400
      } else {
        return 600; // Long flights over 3500 km: €600
      }
    } catch (e) {
      debugPrint('Error calculating compensation amount: $e');
      return 0;
    }
  }

  int _estimateFlightDistance(Map<String, dynamic> flight) {
    // Default distance categories for compensation calculation
    if (flight['isLongHaul'] == true) {
      return 4000; // Long-haul flight
    } else if (flight['isMediumHaul'] == true) {
      return 2500; // Medium-haul flight
    } else {
      return 1000; // Assume short-haul flight
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EU-wide Compensation Eligible Flights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _flightsFuture = _loadFlights();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Filter by airline',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _carrierFilter = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.schedule, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      Text('Last 72 hours', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _flightsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          'API Connection Issue', 
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'We are having trouble connecting to the flight data service. '
                            'This may be a temporary issue with the AviationStack API.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (snapshot.error != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              'Error details: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _flightsFuture = _loadFlights();
                            });
                          },
                          label: const Text('Retry Connection'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Return to Home'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flight_land, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No Eligible Flights Found',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'We have checked flights across major EU airports in the last $_hoursFilter hours, ' +
                            'but no flights meet EU261 compensation criteria at the moment.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.update),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _flightsFuture = _loadFlights();
                            });
                          },
                          label: const Text('Check Again'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Try filtering for specific airlines or checking later', 
                          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                final allFlights = snapshot.data!;
                
                // Apply filters
                final List<Map<String, dynamic>> filteredFlights = allFlights.where((flight) {
                  final airlineName = flight['airline'] is Map ? 
                    flight['airline']['name']?.toString().toLowerCase() ?? '' : 
                    flight['airline']?.toString().toLowerCase() ?? '';
                    
                  final passesCarrierFilter = _carrierFilter.isEmpty || 
                    airlineName.contains(_carrierFilter.toLowerCase());
                  
                  return passesCarrierFilter;
                }).toList();

                if (filteredFlights.isEmpty) {
                  return Center(
                    child: Text('No flights found matching "${_carrierFilter}" filter.'),
                  );
                }

                return ListView.separated(
                  itemCount: filteredFlights.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final flight = filteredFlights[idx];
                    // Handle airline (Map or String)
                    final airline = flight['airline'];
                    String airlineName = '';
                    if (airline is Map && airline.containsKey('name')) {
                      airlineName = airline['name'] ?? '';
                    } else if (airline is String) {
                      airlineName = airline;
                    }
                    
                    // Handle movement (Map or String)
                    final movement = flight['movement'];
                    Map<String, dynamic> airport = {};
                    Map<String, dynamic> scheduled = {};
                    Map<String, dynamic> revised = {};
                    Map<String, dynamic> actual = {};
                    if (movement is Map) {
                      airport = movement['airport'] is Map ? 
                        Map<String, dynamic>.from(movement['airport']) : {};
                      scheduled = movement['scheduledTime'] is Map ? 
                        Map<String, dynamic>.from(movement['scheduledTime']) : {};
                      revised = movement['revisedTime'] is Map ? 
                        Map<String, dynamic>.from(movement['revisedTime']) : {};
                      actual = movement['actualTime'] is Map ? 
                        Map<String, dynamic>.from(movement['actualTime']) : {};
                    }
                    
                    // Handle aircraft (Map or String)
                    final aircraft = flight['aircraft'];
                    String aircraftModel = '';
                    if (aircraft is Map && aircraft.containsKey('model')) {
                      aircraftModel = aircraft['model'] ?? '';
                    } else if (aircraft is String) {
                      aircraftModel = aircraft;
                    }
                    
                    String flightNumber = (flight['number'] ?? '').toString();
                    String airportCode = airport['iata'] ?? airport['icao'] ?? '';
                    String airportName = airport['name'] ?? '';

                    String titleText = '';
                    if (flightNumber.isNotEmpty && airlineName.isNotEmpty) {
                      titleText = '$flightNumber - $airlineName';
                    } else if (flightNumber.isNotEmpty) {
                      titleText = flightNumber;
                    } else {
                      titleText = airlineName;
                    }

                    return ListTile(
                      leading: Icon(Icons.flight_land, size: 32, color: Colors.blueGrey),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              titleText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.verified, color: Colors.green, size: 20),
                          const Text(' EU Compensation',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (airportCode.isNotEmpty || airportName.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Arrival: ${airportCode.isNotEmpty ? airportCode : ''} ${airportName.isNotEmpty ? '($airportName)' : ''}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('Scheduled: ${scheduled['local'] ?? scheduled['utc'] ?? ''}'),
                            ],
                          ),
                          if (revised['local'] != null && revised['local'] != scheduled['local'])
                            Row(
                              children: [
                                Icon(Icons.update, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
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
                                const SizedBox(width: 4),
                                Text(
                                  'Actual: ${actual['local']}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Status: ${flight['status'] ?? ''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: flight['status'] == 'Delayed' || flight['status'] == 'Diverted' ? Colors.orange[700] : 
                                         flight['status'] == 'Cancelled' ? Colors.red : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          if (_calculateDelayMinutes(scheduled, actual) > 0)
                            Row(
                              children: [
                                Icon(Icons.timelapse, size: 16, color: _calculateDelayMinutes(scheduled, actual) >= 180 ? Colors.red : Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  'Delay: ${_formatDelay(_calculateDelayMinutes(scheduled, actual))}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _calculateDelayMinutes(scheduled, actual) >= 180 ? Colors.red : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.euro, size: 16, color: Colors.green),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Potential Compensation: ${_getCompensationAmount(flight)}',
                                  style: const TextStyle(
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
                              const SizedBox(width: 4),
                              Text(
                                'Aircraft: ${aircraftModel.isNotEmpty ? aircraftModel : flight['aircraft']?['model'] ?? 'Unknown'}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () => _openCompensationForm(context, flight),
                            icon: const Icon(Icons.description, size: 16),
                            label: const Text('Pre-fill Compensation Form'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
