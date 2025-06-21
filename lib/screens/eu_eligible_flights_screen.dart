import 'package:flutter/material.dart';
import '../services/aviation_stack_service.dart';
import 'compensation_claim_form_screen.dart';
import '../utils/translation_helper.dart';
import '../services/manual_localization_service.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';

class EUEligibleFlightsScreen extends StatefulWidget {
  const EUEligibleFlightsScreen({super.key});

  @override
  State<EUEligibleFlightsScreen> createState() => _EUEligibleFlightsScreenState();
}

class _EUEligibleFlightsScreenState extends State<EUEligibleFlightsScreen> {
  late Future<List<Map<String, dynamic>>> _flightsFuture;
  String _carrierFilter = '';
  static const int _hoursFilter = 72;

  @override
  void initState() {
    super.initState();
    _flightsFuture = _loadFlights();
  }

  Future<List<Map<String, dynamic>>> _loadFlights() async {
    foundation.debugPrint('Attempting to load EU compensation eligible flights for the last $_hoursFilter hours...');
            final service = AviationStackService(baseUrl: 'http://api.aviationstack.com/v1');

    try {
      final flights = await service.getEUCompensationEligibleFlights(hours: _hoursFilter);
      foundation.debugPrint('Successfully loaded ${flights.length} eligible flights.');
      return flights;
    } catch (e) {
      foundation.debugPrint('Error loading flights in _loadFlights: $e');
      // Propagate the error to be handled by the FutureBuilder.
      throw Exception('Failed to load flight data: $e');
    }
  }

  void _refreshFlights() {
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
      foundation.debugPrint('Error calculating delay: $e');
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
    // FINAL FIX: This function now correctly extracts flattened data for the form.
    final Map<String, dynamic> formattedFlight = {};

    // Log the raw data to help with any future debugging
    foundation.debugPrint('Pre-filling form with flight data: $flight');

    // Extract data using the correct keys identified from logs
    formattedFlight['airline'] = flight['airline_name'] ?? '';
    formattedFlight['flight_number'] = flight['flight_iata'] ?? '';
    formattedFlight['departure_airport'] = flight['departure_airport_iata'] ?? '';
    formattedFlight['arrival_airport'] = flight['arrival_airport_iata'] ?? '';
    
    // Safely parse and format the departure date
    final departureTimeStr = flight['departure_scheduled_time']?.toString();
    if (departureTimeStr?.isNotEmpty ?? false) {
      try {
        final departureTime = DateTime.parse(departureTimeStr!);
        // The form expects the date in 'yyyy-MM-dd' format
        formattedFlight['departure_date'] = DateFormat('yyyy-MM-dd').format(departureTime);
      } catch (e) {
        foundation.debugPrint('Error parsing departure date: $e. Fallback to today.');
        formattedFlight['departure_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    } else {
      // Fallback to today's date if not available
      formattedFlight['departure_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    // Pass the correctly formatted data to the form screen
    foundation.debugPrint('Formatted flight data for form: $formattedFlight');
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
      foundation.debugPrint('Error calculating compensation amount: $e');
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

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              TranslationHelper.getString(context, 'apiConnectionIssue', fallback: 'API Connection Issue'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(TranslationHelper.getString(context, 'retry', fallback: 'Retry')),
              onPressed: _refreshFlights,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flight_land, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              TranslationHelper.getString(context, 'noEligibleFlightsFound', fallback: 'No Eligible Flights Found'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                TranslationHelper.getString(
                  context,
                  'noEligibleFlightsDescription',
                  fallback: 'We checked for flights in the last {hours} hours, but none met the EU261 compensation criteria.'
                ).replaceAll('{hours}', _hoursFilter.toString()),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(TranslationHelper.getString(context, 'checkAgain', fallback: 'Check Again')),
              onPressed: _refreshFlights,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationHelper.getString(context, 'euWideCompensationEligibleFlights', fallback: 'EU-wide Compensation Eligible Flights')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: TranslationHelper.getString(context, 'forceRefreshData', fallback: 'Force refresh data'),
            onPressed: () {
              // Show a snackbar to indicate refresh is happening
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(TranslationHelper.getString(context, 'forcingFreshDataLoad', fallback: 'Forcing fresh data load...'))),
              );
              // Re-fetch flights using the primary load function
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
                    decoration: InputDecoration(
                      labelText: TranslationHelper.getString(context, 'filterByAirline', fallback: 'Filter by airline'),
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
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 4),
                      Text(
                        TranslationHelper.getString(context, 'lastHours', fallback: 'Last {hours} hours')
                          .replaceAll('{hours}', _hoursFilter.toString()), style: TextStyle(fontWeight: FontWeight.bold)),
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
                } 

                if (snapshot.hasError) {
                  return _buildErrorWidget(context, snapshot.error);
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyStateWidget(context);
                }

                final allFlights = snapshot.data!;
                
                // Apply filters
                final List<Map<String, dynamic>> filteredFlights = allFlights.where((flight) {
                  final airlineName = flight['airline_name']?.toString().toLowerCase() ?? '';
                  final passesCarrierFilter = _carrierFilter.isEmpty || airlineName.contains(_carrierFilter.toLowerCase());
                  return passesCarrierFilter;
                }).toList();

                if (filteredFlights.isEmpty) {
                  return Center(
                    child: Text(TranslationHelper.getString(
                      context, 
                      'noFlightsMatchingFilter', 
                      fallback: 'No flights found matching "{filter}" filter.'
                    ).replaceAll('{filter}', _carrierFilter)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredFlights.length,
                  itemBuilder: (context, idx) {
                    final flight = filteredFlights[idx];

                    // FINAL FIX: Using correct keys from the log data
                    final airlineName = flight['airline_name']?.toString() ?? 'Unknown Airline';
                    final flightNumber = flight['flight_iata']?.toString() ?? '';
                    final departureAirport = flight['departure_airport_iata']?.toString() ?? 'N/A';
                    final arrivalAirport = flight['arrival_airport_iata']?.toString() ?? 'N/A';
                    final status = flight['status']?.toString() ?? 'Unknown';
                    final aircraftModel = flight['aircraft_registration']?.toString() ?? 'Unknown';
                    final departureTimeStr = flight['departure_scheduled_time']?.toString();
                    final departureTime = (departureTimeStr?.isNotEmpty ?? false) ? DateTime.parse(departureTimeStr!) : null;
                    final compensation = flight['eligibility_details']?['estimatedCompensation'] ?? 0;
                    final delayMinutes = flight['delay_minutes'] ?? 0;

                    String titleText = flightNumber.isNotEmpty ? '$airlineName $flightNumber' : airlineName;
                    String routeText = '$departureAirport ➔ $arrivalAirport';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(titleText, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(routeText, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueGrey[700])),
                            const Divider(height: 20),
                            _buildInfoRow(context, Icons.access_time, 'Scheduled', departureTime != null ? DateFormat('E, MMM d, HH:mm').format(departureTime) : 'N/A'),
                            _buildInfoRow(context, Icons.info_outline, 'Status', status, valueColor: status.toLowerCase() == 'cancelled' ? Colors.red : (delayMinutes > 0 ? Colors.orange : Colors.green)),
                            if (delayMinutes > 0)
                              _buildInfoRow(context, Icons.timelapse, 'Delay', _formatDelay(delayMinutes), valueColor: delayMinutes >= 180 ? Colors.red : Colors.orange),
                            _buildInfoRow(context, Icons.euro, 'Potential Compensation', '€$compensation', valueColor: Colors.green[700]),
                            _buildInfoRow(context, Icons.airplanemode_active, 'Aircraft', aircraftModel),
                            const SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  textStyle: const TextStyle(fontSize: 16)
                                ),
                                onPressed: () => _openCompensationForm(context, flight),
                                icon: const Icon(Icons.description),
                                label: Text(TranslationHelper.getString(context, 'prefillCompensationForm', fallback: 'Pre-fill Compensation Form')),
                              ),
                            ),
                          ],
                        ),
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
