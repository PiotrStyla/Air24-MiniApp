import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'dart:async'; // For TimeoutException
import 'dart:convert'; // For JSON handling

/// Service for interacting with Aviation Stack API to retrieve flight information
/// Used for getting flight details, checking compensation eligibility, and more.
class AviationStackService {
  /// The base URL for the Aviation Stack API
  final String baseUrl;

  /// The URL for the Python backend service
  final String pythonBackendUrl;

  /// Whether to use the Python backend first
  final bool usePythonBackend;

  /// Creates an instance of the AviationStackService
  AviationStackService({
    required this.baseUrl,
    required this.pythonBackendUrl,
    this.usePythonBackend = false, // Default to false
  });

  /// Gets the API key for the Aviation Stack API
  Future<String> _getApiKey() async {
    // For debugging purposes, use a hardcoded key
    // In production, this should be properly secured
    foundation.debugPrint('AviationStackService: Using debug API key');
    const key = '9cb5db4ba59f1e5005591c572d8b5f1c'; // Replace with your actual key if needed
    return key;
  }

  /// Error handler for data retrieval failures
  List<Map<String, dynamic>> _handleDataRetrievalError(String source, dynamic error) {
    foundation.debugPrint('AviationStackService: Error from $source: ${error.toString()}');
    // Consider throwing a custom exception or returning a result object with error info
    return []; // Return empty list on error
  }

  /// Formats a date string to YYYY-MM-DD format
  String _formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      foundation.debugPrint('AviationStackService: Error formatting date $isoDate: $e');
      return isoDate; // Fallback to original if parsing fails
    }
  }

  /// Normalize a single flight's data from the API response
  Map<String, dynamic> _normalizeSingleFlightData(dynamic flight) {
    if (flight is! Map<String, dynamic>) {
      foundation.debugPrint('AviationStackService: _normalizeSingleFlightData received non-map: ${flight.runtimeType}');
      return {}; // Return empty map for invalid input
    }

    final Map<String, dynamic> normalized = {};

    // Flight Status (crucial for eligibility)
    normalized['status'] = flight['flight_status'] ?? flight['status'] ?? 'unknown';

    // Departure Information
    final departure = flight['departure'] as Map<String, dynamic>?;
    final departureAirport = departure?['airport'] as Map<String, dynamic>?;
    normalized['departure_airport_iata'] = departureAirport?['iata'] ?? 'N/A';
    normalized['departure_airport_icao'] = departureAirport?['icao'] ?? 'N/A';
    normalized['departure_actual_time'] = departure?['actual'] ?? departure?['scheduled'] ?? 'N/A';
    normalized['departure_scheduled_time'] = departure?['scheduled'] ?? 'N/A';
    normalized['departure_terminal'] = departure?['terminal'] ?? 'N/A';
    normalized['departure_gate'] = departure?['gate'] ?? 'N/A';

    // Arrival Information
    final arrival = flight['arrival'] as Map<String, dynamic>?;
    final arrivalAirport = arrival?['airport'] as Map<String, dynamic>?;
    normalized['arrival_airport_iata'] = arrivalAirport?['iata'] ?? 'N/A';
    normalized['arrival_airport_icao'] = arrivalAirport?['icao'] ?? 'N/A';
    normalized['arrival_actual_time'] = arrival?['actual'] ?? arrival?['scheduled'] ?? 'N/A';
    normalized['arrival_scheduled_time'] = arrival?['scheduled'] ?? 'N/A';
    normalized['arrival_terminal'] = arrival?['terminal'] ?? 'N/A';
    normalized['arrival_gate'] = arrival?['gate'] ?? 'N/A';

    // Airline Information
    final airline = flight['airline'] as Map<String, dynamic>?;
    normalized['airline_name'] = airline?['name'] ?? 'N/A';
    normalized['airline_iata'] = airline?['iata'] ?? 'N/A';
    normalized['airline_icao'] = airline?['icao'] ?? 'N/A';

    // Flight Information
    final flightDetails = flight['flight'] as Map<String, dynamic>?;
    normalized['flight_number'] = flightDetails?['number'] ?? flight['flight_number'] ?? 'N/A';
    normalized['flight_iata'] = flightDetails?['iata'] ?? flight['flight_iata'] ?? 'N/A';
    normalized['flight_icao'] = flightDetails?['icao'] ?? flight['flight_icao'] ?? 'N/A';

    // Delay Information - Use the value from the backend if available
    if (flight['delayMinutes'] is num) {
        normalized['delay_minutes'] = (flight['delayMinutes'] as num).toInt();
    } else {
        final delay = flight['departure']?['delay'] ?? flight['arrival']?['delay'];
        if (delay is int) {
          normalized['delay_minutes'] = delay;
        } else if (delay is String) {
          normalized['delay_minutes'] = int.tryParse(delay) ?? 0;
        } else {
          normalized['delay_minutes'] = 0;
        }
    }

    // Distance Information - Use the value from the backend if available
    if (flight['distance_km'] is num) {
      normalized['distance_km'] = (flight['distance_km'] as num).toInt();
    }
    
    // Aircraft information
    final aircraft = flight['aircraft'] as Map<String, dynamic>?;
    normalized['aircraft_registration'] = aircraft?['registration'] ?? 'N/A';

    // Live data (if available)
    final live = flight['live'] as Map<String, dynamic>?;
    normalized['live_latitude'] = live?['latitude'];
    normalized['live_longitude'] = live?['longitude'];
    normalized['live_is_ground'] = live?['is_ground'];

    // Add any other top-level fields that might be useful
    normalized['flight_date'] = flight['flight_date'] ?? 'N/A';

    // Debug: Print the raw flight and normalized flight for comparison
    // foundation.debugPrint('AviationStackService: Raw flight data: ${jsonEncode(flight)}');
    // foundation.debugPrint('AviationStackService: Normalized flight data: ${jsonEncode(normalized)}');

    return normalized;
  }

  /// Helper method to normalize flight data from API response
  List<Map<String, dynamic>> _normalizeFlightData(List<dynamic> rawFlights) {
    if (rawFlights.isEmpty) {
      foundation.debugPrint('AviationStackService: _normalizeFlightData received empty list.');
      return [];
    }
    return rawFlights.map((flight) => _normalizeSingleFlightData(flight)).toList();
  }

  /// Helper method to try processing flight data from various possible response formats
  Future<List<Map<String, dynamic>>> _tryProcessFlightsData(Map<String, dynamic> data) async {
    foundation.debugPrint('AviationStackService: _tryProcessFlightsData: Analyzing data structure...');
    // foundation.debugPrint('AviationStackService: Available keys in response: ${data.keys.join(', ')}');

    List<dynamic> flightsList = [];
    if (data['data'] is List) {
      flightsList = data['data'];
    } else if (data['flights'] is List) {
      flightsList = data['flights'];
    } else if (data['pagination'] != null && data['data'] != null && data['data'] is List) {
      // Common AviationStack structure
      flightsList = data['data'];
    
    } else {
      foundation.debugPrint('AviationStackService: _tryProcessFlightsData could not find a list of flights in the response.');
      // Try to see if the response itself is a single flight object wrapped in a map
      // This is a heuristic and might need adjustment based on actual API responses
      if (data.containsKey('flight_status') || data.containsKey('departure')) {
         foundation.debugPrint('AviationStackService: _tryProcessFlightsData attempting to treat root as a single flight.');
         flightsList = [data]; // Treat as a list with one flight
      }
    }

    if (flightsList.isEmpty) {
      foundation.debugPrint('AviationStackService: _tryProcessFlightsData: No flight data found after attempting various keys.');
      return [];
    }
    
    foundation.debugPrint('AviationStackService: _tryProcessFlightsData: Found ${flightsList.length} flights to normalize.');
    return _normalizeFlightData(flightsList);
  }

  // --- EU Compensation Eligibility Logic ---
  static const List<String> _euAirportCodes = [
    // Austria
    'VIE', 'GRZ', 'INN', 'KLU', 'LNZ', 'SZG',
    // Belgium
    'BRU', 'CRL', 'LGG', 'ANR', 'OST',
    // Bulgaria
    'SOF', 'VAR', 'BOJ',
    // Croatia
    'ZAG', 'SPU', 'DBV', 'PUY', 'RJK', 'ZAD', 'OSI',
    // Cyprus
    'LCA', 'PFO',
    // Czech Republic
    'PRG', 'BRQ', 'OSR',
    // Denmark
    'CPH', 'BLL', 'AAL', 'AAR',
    // Estonia
    'TLL', 'TAY',
    // Finland
    'HEL', 'OUL', 'TMP', 'TKU', 'RVN',
    // France (including overseas territories like Cayenne, Fort-de-France, Pointe-à-Pitre, Saint-Denis)
    'CDG', 'ORY', 'NCE', 'LYS', 'MRS', 'TLS', 'BOD', 'NTE', 'SXB', 'MPL', 'LIL', // Mainland
    'CAY', 'FDF', 'PTP', 'RUN', // Overseas
    // Germany
    'FRA', 'MUC', 'BER', 'TXL', 'SXF', 'DUS', 'HAM', 'STR', 'CGN', 'HAJ', 'NUE', 'LEJ', 'DRS', 'BRE', 'FMO',
    // Greece
    'ATH', 'SKG', 'HER', 'RHO', 'CFU', 'CHQ', 'KGS', 'JTR', 'JMK',
    // Hungary
    'BUD', 'DEB',
    // Ireland
    'DUB', 'ORK', 'SNN',
    // Italy
    'FCO', 'MXP', 'LIN', 'VCE', 'BLQ', 'NAP', 'CTA', 'PMO', 'PSA', 'TRN', 'FLR', 'CAG', 'BRI', 'VRN',
    // Latvia
    'RIX',
    // Lithuania
    'VNO', 'KUN', 'PLQ',
    // Luxembourg
    'LUX',
    // Malta
    'MLA',
    // Netherlands
    'AMS', 'EIN', 'RTM',
    // Poland
    'WAW', 'KRK', 'GDN', 'KTW', 'WRO', 'POZ', 'RZE', 'SZZ',
    // Portugal (including Azores and Madeira)
    'LIS', 'OPO', 'FAO', // Mainland
    'PDL', 'TER', 'HOR', // Azores
    'FNC', // Madeira
    // Romania
    'OTP', 'CLJ', 'TSR', 'IAS',
    // Slovakia
    'BTS', 'KSC',
    // Slovenia
    'LJU',
    // Spain (including Canary Islands)
    'MAD', 'BCN', 'PMI', 'AGP', 'ALC', 'VLC', 'SVQ', 'IBZ', 'TFS', 'LPA', // Mainland & Balearics
    'ACE', 'FUE', // Canaries
    // Sweden
    'ARN', 'GOT', 'MMA',
    // Non-EU Schengen countries often included for practical airline purposes
    // Iceland
    'KEF', 'RKV',
    // Norway
    'OSL', 'BGO', 'TRD', 'SVG',
    // Switzerland
    'ZRH', 'GVA', 'BSL'
  ];

  static const List<String> _nonEuSchengenAirports = [
    'KEF', 'RKV', // Iceland
    'OSL', 'BGO', 'TRD', 'SVG', // Norway
    'ZRH', 'GVA', 'BSL' // Switzerland
  ];

  static const List<String> _euAirlines = [
    // Major EU Airlines (IATA codes)
    'AF', // Air France
    'KL', // KLM
    'LH', // Lufthansa
    'BA', // British Airways (Note: UK is no longer EU, but often included in similar contexts or pre-Brexit rules)
    'IB', // Iberia
    'AZ', // ITA Airways (formerly Alitalia)
    'SK', // SAS (Scandinavian Airlines - Denmark, Norway, Sweden. Norway not EU but part of SAS consortium)
    'SN', // Brussels Airlines
    'TP', // TAP Air Portugal
    'A3', // Aegean Airlines
    'OS', // Austrian Airlines
    'LO', // LOT Polish Airlines
    'EI', // Aer Lingus
    'FR', // Ryanair
    'U2', // EasyJet (EasyJet Switzerland is Swiss, EasyJet Europe is Austrian, EasyJet UK is British)
    'VY', // Vueling
    'OK', // Czech Airlines
    'BT', // AirBaltic
    'FI', // Icelandair (Iceland is not EU but EEA/Schengen)
    'DY', // Norwegian Air Shuttle (Norway is not EU but EEA/Schengen)
    'LX', // Swiss International Air Lines (Switzerland is not EU but Schengen)
    // Add more as needed based on common EU carriers
    'W6', // Wizz Air
    'HV', // Transavia
    'RO', // TAROM
    'UX', // Air Europa
    'OU', // Croatia Airlines
    'FB', // Bulgaria Air
    'CY', // Cyprus Airways
    'KM', // Air Malta
    'LG', // Luxair
    'JP', // Adria Airways (ceased operations, but for historical data)
    'JU', // Air Serbia (not EU, but for regional context)
  ];

  /// Check if the flight is covered by EU regulation EC 261/2004
  bool _isFlightCoveredByEURegulation(Map<String, dynamic> flight) {
    final depAirport = flight['departure_airport_iata']?.toString().toUpperCase() ?? '';
    final arrAirport = flight['arrival_airport_iata']?.toString().toUpperCase() ?? '';
    final airlineIata = flight['airline_iata']?.toString().toUpperCase() ?? '';

    bool isDepEU = _euAirportCodes.contains(depAirport) || _nonEuSchengenAirports.contains(depAirport);
    bool isArrEU = _euAirportCodes.contains(arrAirport) || _nonEuSchengenAirports.contains(arrAirport);
    bool isAirlineEU = _euAirlines.contains(airlineIata);

    // Rule 1: Flight departs from an EU/EEA airport (regardless of airline)
    if (isDepEU) return true;
    // Rule 2: Flight arrives at an EU/EEA airport AND is operated by an EU/EEA airline
    if (isArrEU && isAirlineEU) return true;

    return false;
  }

  /// Check for extraordinary circumstances that would exempt the airline from compensation
  bool _checkForExtraordinaryCircumstances(Map<String, dynamic> flight, {bool relaxEligibilityForDebugging = false}) {
    if (relaxEligibilityForDebugging) {
      foundation.debugPrint('AviationStackService: Skipping extraordinary circumstances check due to relaxEligibilityForDebugging=true');
      return false; // Assume no extraordinary circumstances when debugging
    }
    // Simplified check: In a real app, this would involve checking weather, ATC strikes, etc.
    // For now, assume no extraordinary circumstances unless explicitly stated in flight data (which we don't have)
    // Example: if (flight['reason_for_delay']?.toString().toLowerCase().contains('strike') ?? false) return true;
    return false; 
  }

  /// Calculate the compensation amount based on flight distance
  int _calculateCompensationAmount(int distanceKm) {
    if (distanceKm <= 1500) {
      return 250;
    } else if (distanceKm <= 3500) {
      return 400;
    } else {
      return 600;
    }
  }

  /// Estimate the flight distance based on available flight data (placeholder)
  int _estimateFlightDistance(Map<String, dynamic> flight) {
    // Placeholder: In a real app, calculate distance using airport coordinates or use an API
    // For now, return a default distance that might trigger different compensation amounts
    final dep = flight['departure_airport_iata']?.toString() ?? '';
    final arr = flight['arrival_airport_iata']?.toString() ?? '';

    if ((dep.startsWith('L') && arr.startsWith('J')) || (dep.startsWith('J') && arr.startsWith('L'))) {
      return 2000; // Medium haul, e.g., London to JFK (approx)
    } else if (dep.startsWith('E') && arr.startsWith('P')) {
      return 4000; // Long haul
    }
    return 1000; // Short haul default
  }

  /// Calculates eligibility and compensation amount based on EU regulation EC 261/2004
  Map<String, dynamic> _calculateEligibility(Map<String, dynamic> flight, {bool relaxEligibilityForDebugging = false}) {
    final status = flight['status']?.toString().toLowerCase() ?? 'unknown';
    final delayMinutes = flight['delay_minutes'] as int? ?? 0;
    
    // Use distance from normalized data if available, otherwise estimate it.
    final int distanceKm;
    if (flight['distance_km'] != null && flight['distance_km'] is int && flight['distance_km'] > 0) {
      distanceKm = flight['distance_km'];
    } else {
      distanceKm = _estimateFlightDistance(flight);
    }

    bool isEligible = false;
    int estimatedCompensation = 0;
    String reason = 'Not eligible.';

    if (!_isFlightCoveredByEURegulation(flight)) {
      reason = 'Flight not covered by EU Regulation EC 261/2004.';
      if (relaxEligibilityForDebugging) {
         foundation.debugPrint('AviationStackService: _calculateEligibility: Flight ${flight['flight_iata']} NOT covered by EU Reg (dep: ${flight['departure_airport_iata']}, arr: ${flight['arrival_airport_iata']}, airline: ${flight['airline_iata']}) but showing due to relax mode.');
      } else {
        return {
          'isEligible': false,
          'estimatedCompensation': 0,
          'reason': reason,
          'flightDetails': flight
        };
      }
    } else {
       foundation.debugPrint('AviationStackService: _calculateEligibility: Flight ${flight['flight_iata']} IS covered by EU Reg.');
    }

    if (_checkForExtraordinaryCircumstances(flight, relaxEligibilityForDebugging: relaxEligibilityForDebugging)) {
      reason = 'Extraordinary circumstances apply.';
       if (relaxEligibilityForDebugging) {
         foundation.debugPrint('AviationStackService: _calculateEligibility: Flight ${flight['flight_iata']} has extraordinary circumstances but showing due to relax mode.');
      } else {
        return {
          'isEligible': false,
          'estimatedCompensation': 0,
          'reason': reason,
          'flightDetails': flight
        };
      }
    }

    if (status.contains('cancel')) {
      isEligible = true;
      estimatedCompensation = _calculateCompensationAmount(distanceKm);
      reason = 'Flight cancelled (EU regulation EC 261/2004)';
    } else if (delayMinutes >= 180) { // 3 hours delay
      isEligible = true;
      estimatedCompensation = _calculateCompensationAmount(distanceKm);
      reason = 'Flight delayed by $delayMinutes minutes (>= 3 hours) (EU regulation EC 261/2004)';
    } else {
      if (status.contains('delay')) {
        reason = 'Flight delayed by $delayMinutes minutes (< 3 hours).';
      } else if (status == 'scheduled' || status == 'active' || status == 'landed') {
        reason = 'Flight is $status and delay is less than 3 hours.';
      } else {
        reason = 'Flight status is $status, not eligible for cancellation/delay compensation.';
      }
    }
    
    if (relaxEligibilityForDebugging && !isEligible) {
        foundation.debugPrint('AviationStackService: _calculateEligibility: Flight ${flight['flight_iata']} originally NOT eligible (Reason: $reason), but showing due to relax mode.');
        // Keep original reason but allow it to pass through for debugging display
    }

    return {
      'isEligible': isEligible,
      'estimatedCompensation': estimatedCompensation,
      'reason': reason,
      'flightDetails': flight // Include original flight details for context
    };
  }

  /// Process flight data to determine compensation eligibility
  List<Map<String, dynamic>> _processCompensationEligibility(
    List<Map<String, dynamic>> flights, {
    bool relaxEligibilityForDebugging = false,
  }) {
    if (flights.isEmpty) return [];

    final List<Map<String, dynamic>> eligibleFlights = [];
    int totalFlights = flights.length;
    int processedEligible = 0;
    int processedIneligible = 0;

    foundation.debugPrint('AviationStackService: _processCompensationEligibility: Processing ${flights.length} flights. Relax mode: $relaxEligibilityForDebugging');

    for (var flight in flights) {
      final eligibilityResult = _calculateEligibility(flight, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
      
      // In relax mode, we add all flights, but the 'isEligible' flag in eligibilityResult reflects true eligibility
      if (relaxEligibilityForDebugging) {
        eligibleFlights.add({
          ...flight, // Original flight data
          'eligibility_details': eligibilityResult // Eligibility calculation result
        });
        if (eligibilityResult['isEligible'] == true) processedEligible++; else processedIneligible++;
      } else {
        if (eligibilityResult['isEligible'] == true) {
          eligibleFlights.add({
            ...flight,
            'eligibility_details': eligibilityResult
          });
          processedEligible++;
        } else {
          processedIneligible++;
          // foundation.debugPrint('AviationStackService: Flight ${flight['flight_iata']} not eligible: ${eligibilityResult['reason']}');
        }
      }
    }
    foundation.debugPrint('AviationStackService: _processCompensationEligibility: Finished. Total: $totalFlights, Eligible: $processedEligible, Ineligible (but shown in relax): $processedIneligible (if relax mode). Actual eligible added: ${eligibleFlights.length}');
    return eligibleFlights;
  }

  /// Returns EU compensation eligible flights from the past specified hours
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 144, // Increased from 72 to 144 hours (6 days) to find more eligible flights
    bool relaxEligibilityForDebugging = false, // Set to true to see all flights before filtering
  }) async {
    foundation.debugPrint('AviationStackService: getEUCompensationEligibleFlights called. Hours: $hours, RelaxEligibility: $relaxEligibilityForDebugging');
    List<Map<String, dynamic>> allFlights = [];

    if (usePythonBackend) {
      foundation.debugPrint('AviationStackService: Attempting to fetch flights from Python backend.');
      try {
        final String backendUrl = '$pythonBackendUrl/get_flights_for_eligibility?hours=$hours';
        foundation.debugPrint('AviationStackService: PY_BACKEND_REQUEST_URL: $backendUrl');
        final response = await http.get(Uri.parse(backendUrl)).timeout(const Duration(seconds: 30));
        foundation.debugPrint('AviationStackService: PY_BACKEND_RESPONSE_STATUS: ${response.statusCode}');
        foundation.debugPrint('AviationStackService: PY_BACKEND_RESPONSE_BODY: ${response.body.length > 500 ? response.body.substring(0, 500) + "... (truncated)" : response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          foundation.debugPrint('AviationStackService: PY_BACKEND_DECODED_DATA_KEYS: ${data.keys.join(', ')}');
          // Assuming Python backend returns data in a structure that _tryProcessFlightsData can handle
          allFlights = await _tryProcessFlightsData(data);
          foundation.debugPrint('AviationStackService: Successfully fetched ${allFlights.length} flights from Python backend.');
        } else {
          foundation.debugPrint('AviationStackService: PY_BACKEND_ERROR: Status Code ${response.statusCode}');
          foundation.debugPrint('AviationStackService: PY_BACKEND_ERROR_BODY: ${response.body}');
          // Fallback to AviationStack if Python backend fails
          if (!usePythonBackend) { // Only fallback if primary was Python
             foundation.debugPrint('AviationStackService: Falling back to AviationStack API.');
          } else {
            // If pythonBackend was primary and failed, and we are not supposed to fallback, then error out or return empty.
            return _handleDataRetrievalError('Python Backend Primary', 'Status Code: ${response.statusCode}');
          }
        }
      } catch (e, s) {
        foundation.debugPrint('AviationStackService: PY_BACKEND_EXCEPTION: $e');
        foundation.debugPrint('AviationStackService: PY_BACKEND_STACK_TRACE: $s');
        if (!usePythonBackend) { // Only fallback if primary was Python
            foundation.debugPrint('AviationStackService: Falling back to AviationStack API due to Python backend error.');
        } else {
            return _handleDataRetrievalError('Python Backend Primary Exception', e);
        }
      }
    }

    // If not using Python backend, or if it failed and fallback is allowed (usePythonBackend is false implies direct use or fallback)
    if (allFlights.isEmpty || !usePythonBackend) {
      foundation.debugPrint('AviationStackService: Fetching flights directly from AviationStack API.');
      try {
        final apiKey = await _getApiKey();
        // AviationStack's 'flights' endpoint is good for general queries but might need date range for past flights.
        // For recent flights, it's often better to query by date.
        // For simplicity, if 'hours' implies looking into the past, we might need to make multiple date calls.
        // The free tier of AviationStack has limitations on historical data access.
        // Let's assume for now we are looking for flights around the current date or very recent past.
        // A robust solution would iterate dates: DateTime.now(), DateTime.now().subtract(Duration(days:1)), etc.
        final String targetDate = _formatDate(DateTime.now().subtract(Duration(days: hours ~/ 24)).toIso8601String());
        final queryParams = {
          'access_key': apiKey,
          // 'flight_date': targetDate, // Querying by a single past date
          // 'flight_status': 'scheduled,active,landed,cancelled,delayed', // Filter by status if API supports
          'limit': '100', // Max results per page
        };
        // The /flights endpoint without specific date often gives current/future flights.
        // To get past flights effectively, one might need a different endpoint or strategy if not using Python backend as aggregator.
        // For this example, we'll use a generic flights call. The Python backend is preferred for complex past data.
        foundation.debugPrint('AviationStackService: Querying Aviation Stack API with params: $queryParams for date approx ${hours}h ago.');
        final uri = Uri.parse('$baseUrl/flights').replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          allFlights = await _tryProcessFlightsData(data);
          foundation.debugPrint('AviationStackService: Successfully fetched ${allFlights.length} flights from AviationStack API.');
        } else {
          foundation.debugPrint('AviationStackService: AviationStack API error: ${response.statusCode} - ${response.body}');
          return _handleDataRetrievalError('Aviation Stack API', 'Status Code: ${response.statusCode}');
        }
      } catch (e) {
        foundation.debugPrint('AviationStackService: Error fetching from AviationStack API: $e');
        return _handleDataRetrievalError('Aviation Stack API Exception', e);
      }
    }

    return _processCompensationEligibility(allFlights, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
  }





        

  
  /// Fetches recent arrivals for a specific airport
  /// 
  /// [airportIcao] - The ICAO code of the airport
  /// [minutesBeforeNow] - Time window in minutes for recent arrivals
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 360,
  }) async {
    if (airportIcao.isEmpty) {
      throw ArgumentError('ICAO code cannot be empty');
    }
    
    try {
      // Calculate date range
      final now = DateTime.now();
      final minutesAgo = now.subtract(Duration(minutes: minutesBeforeNow));
      final formattedDate = _formatDate(minutesAgo.toIso8601String());
      
      // Build query parameters
      final queryParams = {
        'access_key': await _getApiKey(),
        'arr_icao': airportIcao,
        'flight_date': formattedDate,
        'limit': '100',
      };
      
      foundation.debugPrint('Querying Aviation Stack API with params: $queryParams');
      
      final uri = Uri.parse('${this.baseUrl}/flights').replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          foundation.debugPrint('API request timed out');
          throw TimeoutException('API request timed out');
        },
      );
      
      if (response.statusCode != 200) {
        foundation.debugPrint('API error: ${response.statusCode}, ${response.body}');
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      
      if (data['error'] != null) {
        final errorMsg = data['error']['message'] ?? 'Unknown API error';
        foundation.debugPrint('API error: $errorMsg');
        throw Exception('API error: $errorMsg');
      }
      
      final flightData = data['data'];
      
      if (flightData == null) {
        foundation.debugPrint('API response missing "data" field');
        throw Exception('API response missing "data" field');
      }
      
      if (flightData is! List) {
        foundation.debugPrint('API "data" field is not a list');
        throw Exception('API "data" field is not a list');
      }
      
      final flights = _normalizeFlightData(flightData);
      foundation.debugPrint('Retrieved ${flights.length} recent arrivals for $airportIcao');
      
      return flights;
    } catch (e) {
      return _handleDataRetrievalError('Aviation Stack API - Recent Arrivals', e);
    }
  }
  
  /// Check if a specific flight is eligible for compensation
  /// Returns details about the flight eligibility status
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    // First try Python backend if enabled
    if (usePythonBackend) {
      try {
        foundation.debugPrint('Checking compensation eligibility via Python backend for flight: $flightNumber');
        
        // Construct the Python backend request URL
        final uri = Uri.parse('${this.pythonBackendUrl}/check_eligibility')
          .replace(queryParameters: {
            'flight_number': flightNumber,
            if (date != null) 'flight_date': date,
          });
        
        foundation.debugPrint('Making Python backend request to: $uri');
        
        // Set a timeout to prevent hanging
        final response = await http.get(uri)
          .timeout(const Duration(seconds: 15), onTimeout: () {
            foundation.debugPrint('Python backend request timed out checking eligibility');
            throw TimeoutException('Python backend request timed out');
          });
        
        if (response.statusCode != 200) {
          foundation.debugPrint('Failed checking eligibility via Python: HTTP ${response.statusCode}');
          throw Exception('Python backend returned status code ${response.statusCode}');
        }
        
        final data = json.decode(response.body);
        if (data['error'] != null) {
          foundation.debugPrint('Python backend error: ${data['error']}');
          throw Exception('Python backend error: ${data['error']}');
        }
        
        // The Python backend should return the flight with eligibility details
        final flight = data['flight'] ?? data['data'];
        if (flight == null) {
          foundation.debugPrint('Flight not found in Python backend response');
          throw Exception('Flight $flightNumber not found in Python backend response');
        }
        
        foundation.debugPrint('Successfully retrieved eligibility details from Python backend');
        return Map<String, dynamic>.from(flight); // Already processed
      } catch (e) {
        foundation.debugPrint('Error from Python backend: $e, falling back to direct API');
        // Fall through to direct API call
      }
    }
    
    // Fall back to direct Aviation Stack API if Python backend is disabled or failed
    try {
      foundation.debugPrint('Checking compensation eligibility via direct API for flight: $flightNumber');
      final apiKey = await _getApiKey();
      final uri = Uri.parse('${this.baseUrl}/flights')
        .replace(queryParameters: {
          'access_key': apiKey,
          'flight_iata': flightNumber,
          if (date != null) 'flight_date': date,
        });
      
      // Set a timeout to prevent hanging
      final response = await http.get(uri)
        .timeout(const Duration(seconds: 15), onTimeout: () {
          foundation.debugPrint('API request timed out checking eligibility');
          throw TimeoutException('API request timed out');
        });
      
      if (response.statusCode != 200) {
        foundation.debugPrint('Failed checking eligibility: HTTP ${response.statusCode}');
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      if (data['error'] != null) {
        foundation.debugPrint('API Error: ${data['error']['message']}');
        throw Exception('API Error: ${data['error']['message']}');
      }
      
      final flights = data['data'] as List<dynamic>;
      if (flights.isEmpty) {
        foundation.debugPrint('Flight not found in API');
        throw Exception('Flight $flightNumber not found');
      }
      
      final flight = _normalizeSingleFlightData(flights[0]);
      final eligibilityDetails = _calculateEligibility(flight);
      final eligible = eligibilityDetails['isEligible'] as bool? ?? false;
      final amount = eligible ? (eligibilityDetails['estimatedCompensation'] as int? ?? 0) : 0;
      
      return {
        'flightNumber': flightNumber,
        'eligible': eligible,
        'reason': eligibilityDetails['reason'],
        'potentialCompensationAmount': amount,
        ...flight,
      };
    } catch (e) {
      foundation.debugPrint('Error checking compensation eligibility: $e');
      // Fallback to AviationStack API if Python backend fails
      return {
        'flightNumber': flightNumber,
        'eligible': false,
        'reason': 'Service error: ${e.toString()}',
        'error': 'Service unavailable or exception occurred.'
      };
    }
  }
}
