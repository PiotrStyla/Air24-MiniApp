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
  final String? pythonBackendUrl = 'http://PiotrS.pythonanywhere.com';

  /// Whether to use the Python backend first
  final bool usePythonBackend = false;

  // Caching for airport and airline data to avoid repeated API calls.
  Map<String, String> _airportCountryCache = {};
  Map<String, String> _airlineCountryCache = {};
  bool _isAirportCacheInitialized = false;
  bool _isAirlineCacheInitialized = false;

  /// Creates an instance of the AviationStackService
  AviationStackService({
    required this.baseUrl,
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

  /// Fetches all paginated data from a given AviationStack endpoint (e.g., 'airports', 'airlines').
  Future<List<dynamic>> _fetchAllPaginatedData(String endpoint) async {
    final apiKey = await _getApiKey();
    List<dynamic> allData = [];
    int offset = 0;
    const limit = 1000; // Use the max limit to reduce number of calls
    int totalAvailable = 0;

    foundation.debugPrint('AviationStackService: Starting paginated fetch for "$endpoint"...');

    do {
      final uri = Uri.parse('$baseUrl/$endpoint?access_key=$apiKey&limit=$limit&offset=$offset');
      try {
        final response = await http.get(uri).timeout(const Duration(seconds: 30));
        if (response.statusCode == 200) {
          final pageData = json.decode(response.body);
          final List<dynamic> data = pageData['data'] ?? [];
          allData.addAll(data);

          totalAvailable = pageData['pagination']['total'] ?? 0;
          offset += data.length;

          foundation.debugPrint('AviationStackService: Fetched ${data.length} items from "$endpoint". Total fetched: ${allData.length}/$totalAvailable');

        } else {
          foundation.debugPrint('AviationStackService: Failed to fetch data for "$endpoint". Status: ${response.statusCode}, Body: ${response.body}');
          throw Exception('Failed to load paginated data from $endpoint');
        }
      } catch (e) {
        foundation.debugPrint('AviationStackService: Error fetching paginated data for "$endpoint": $e');
        rethrow;
      }
    } while (allData.length < totalAvailable && totalAvailable > 0 && offset < totalAvailable);
    
    foundation.debugPrint('AviationStackService: Finished paginated fetch for "$endpoint". Total items: ${allData.length}');
    return allData;
  }

  /// Initializes the airport cache by fetching all airports from the API.
  Future<void> _initializeAirportCache() async {
    if (_isAirportCacheInitialized) return;
    foundation.debugPrint('AviationStackService: Initializing airport cache...');
    try {
      final airports = await _fetchAllPaginatedData('airports');
      _airportCountryCache = {
        for (var airport in airports)
          if (airport['iata_code'] != null && airport['country_iso2'] != null)
            airport['iata_code']: airport['country_iso2']
      };
      _isAirportCacheInitialized = true;
      foundation.debugPrint('AviationStackService: Airport cache initialized with ${_airportCountryCache.length} entries.');
    } catch (e) {
      foundation.debugPrint('AviationStackService: Failed to initialize airport cache: $e');
      // In a real app, you might want to handle this more gracefully, e.g., retry.
    }
  }

  /// Initializes the airline cache by fetching all airlines from the API.
  Future<void> _initializeAirlineCache() async {
    if (_isAirlineCacheInitialized) return;
    foundation.debugPrint('AviationStackService: Initializing airline cache...');
    try {
      final airlines = await _fetchAllPaginatedData('airlines');
      _airlineCountryCache = {
        for (var airline in airlines)
          if (airline['iata_code'] != null && airline['country_iso2'] != null)
            airline['iata_code']: airline['country_iso2']
      };
      _isAirlineCacheInitialized = true;
      foundation.debugPrint('AviationStackService: Airline cache initialized with ${_airlineCountryCache.length} entries.');
    } catch (e) {
      foundation.debugPrint('AviationStackService: Failed to initialize airline cache: $e');
    }
  }

  // Normalizes a single flight data object, handling API inconsistencies gracefully.
  // Normalizes a single flight data object, handling API inconsistencies gracefully.
  Map<String, dynamic> _normalizeSingleFlightData(dynamic flight) {
    if (flight is! Map<String, dynamic>) return {};

    // Defensively extract data, as API can return strings instead of maps.
    final departureData = flight['departure'];
    final arrivalData = flight['arrival'];
    final airlineData = flight['airline'];
    final flightDetails = flight['flight'] ?? {};
    final aircraftData = flight['aircraft'];

    String depIata = 'N/A';
    String depScheduled = '';
    int depDelay = 0;
    if (departureData is Map<String, dynamic>) {
      depIata = departureData['iata'] ?? 'N/A';
      depScheduled = departureData['scheduled'] ?? '';
      depDelay = departureData['delay'] ?? 0;
    }

    String arrIata = 'N/A';
    String arrScheduled = '';
    int arrDelay = 0;
    if (arrivalData is Map<String, dynamic>) {
      arrIata = arrivalData['iata'] ?? 'N/A';
      arrScheduled = arrivalData['scheduled'] ?? '';
      arrDelay = arrivalData['delay'] ?? 0;
    }

    String airlineName = 'Unknown Airline';
    String airlineIata = 'N/A';
    if (airlineData is Map<String, dynamic>) {
      airlineName = airlineData['name'] ?? 'Unknown Airline';
      airlineIata = airlineData['iata'] ?? 'N/A';
    }

    String aircraftRegistration = 'Unknown';
    if (aircraftData is Map<String, dynamic>) {
      aircraftRegistration = aircraftData['registration'] ?? 'Unknown';
    }

    // A flight's delay is typically measured on arrival.
    final finalDelay = arrDelay > 0 ? arrDelay : depDelay;

    return {
      'airline_name': airlineName,
      'airline_iata': airlineIata,
      'flight_iata': flightDetails['iata'] ?? '',
      'departure_airport_iata': depIata,
      'arrival_airport_iata': arrIata,
      'status': flight['flight_status'] ?? 'Unknown',
      'aircraft_registration': aircraftRegistration,
      'departure_scheduled_time': depScheduled,
      'arrival_scheduled_time': arrScheduled,
      'delay_minutes': finalDelay,
      'raw_data': flight, // Keep original data for deeper analysis if needed
    };
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

  // Definitive list of EU member states and EEA/Schengen countries for EC 261/2004 regulation.
  static const List<String> _euCountryCodes = [
    // EU Member States (ISO 3166-1 alpha-2)
    'AT', // Austria
    'BE', // Belgium
    'BG', // Bulgaria
    'HR', // Croatia
    'CY', // Cyprus
    'CZ', // Czech Republic
    'DK', // Denmark
    'EE', // Estonia
    'FI', // Finland
    'FR', // France
    'DE', // Germany
    'GR', // Greece
    'HU', // Hungary
    'IE', // Ireland
    'IT', // Italy
    'LV', // Latvia
    'LT', // Lithuania
    'LU', // Luxembourg
    'MT', // Malta
    'NL', // Netherlands
    'PL', // Poland
    'PT', // Portugal
    'RO', // Romania
    'SK', // Slovakia
    'SI', // Slovenia
    'ES', // Spain
    'SE', // Sweden
    // Non-EU but covered by regulation (EEA/Schengen)
    'IS', // Iceland
    'LI', // Liechtenstein
    'NO', // Norway
    'CH', // Switzerland
  ];

  /// Check if the flight is covered by EU regulation EC 261/2004 using cached data.
  Future<bool> _isFlightCoveredByEURegulation(Map<String, dynamic> flight) async {
    // This check is now primarily defensive. Caches should be initialized higher up.
    if (!_isAirportCacheInitialized || !_isAirlineCacheInitialized) {
      foundation.debugPrint('Warning: Caches not initialized. Initializing defensively.');
      await _initializeAirportCache();
      await _initializeAirlineCache();
    }

    final depAirportIata = flight['departure_airport_iata']?.toString().toUpperCase() ?? '';
    final arrAirportIata = flight['arrival_airport_iata']?.toString().toUpperCase() ?? '';
    final airlineIata = flight['airline_iata']?.toString().toUpperCase() ?? '';

    // Look up country codes from the cache.
    final depCountry = _airportCountryCache[depAirportIata] ?? '';
    final arrCountry = _airportCountryCache[arrAirportIata] ?? '';
    final airlineCountry = _airlineCountryCache[airlineIata] ?? '';

    final bool isDepEU = _euCountryCodes.contains(depCountry);
    final bool isArrEU = _euCountryCodes.contains(arrCountry);
    final bool isAirlineEU = _euCountryCodes.contains(airlineCountry);

    // Rule 1: Flight departs from an EU/EEA airport (regardless of airline).
    if (isDepEU) {
      return true;
    }
    
    // Rule 2: Flight arrives at an EU/EEA airport AND is operated by an EU/EEA airline.
    if (isArrEU && isAirlineEU) {
      return true;
    }

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
  Future<Map<String, dynamic>> _calculateEligibility(Map<String, dynamic> flight, {bool relaxEligibilityForDebugging = false}) async {
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

    if (!await _isFlightCoveredByEURegulation(flight)) {
      reason = 'Flight not covered by EU Regulation EC 261/2004.';
      if (relaxEligibilityForDebugging) {
         foundation.debugPrint('AviationStackService: _calculateEligibility: Flight ${flight['flight_iata']} NOT covered by EU Reg (dep: ${flight['departure_airport_iata']}, arr: ${flight['arrival_airport_iata']}, airline: ${flight['airline_iata']}) but showing due to relax mode.');
      } else {
        return {
          'isEligible': false,
          'estimatedCompensation': 0,
          'reason': reason,
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
    } else if (status.contains('diverted')) {
      isEligible = true;
      estimatedCompensation = _calculateCompensationAmount(distanceKm);
      reason = 'Flight diverted (EU regulation EC 261/2004)';
    } else {
      reason = 'Flight status ($status) or delay ($delayMinutes min) does not meet criteria.';
    }

    return {
      'isEligible': isEligible,
      'estimatedCompensation': estimatedCompensation,
      'reason': reason,
    };
  }

  /// Process flight data to determine compensation eligibility
  Future<List<Map<String, dynamic>>> _processCompensationEligibility(
    List<Map<String, dynamic>> flights, {
    bool relaxEligibilityForDebugging = false,
  }) async {
    final List<Map<String, dynamic>> eligibleFlights = [];

    for (var flight in flights) {
      final eligibilityDetails = await _calculateEligibility(flight, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
      if (relaxEligibilityForDebugging || (eligibilityDetails['isEligible'] as bool? ?? false)) {
        // Enrich the original flight object with eligibility details
        flight['eligibility_details'] = eligibilityDetails;
        eligibleFlights.add(flight);
      }
    }
    foundation.debugPrint('AviationStackService: Processed ${flights.length} flights, found ${eligibleFlights.length} eligible flights.');
    return eligibleFlights;
  }

  // Fetches flights eligible for EU compensation.
  // Production-ready: Tries Python backend, falls back to live API, throws exception on failure.
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72,
    bool relaxEligibilityForDebugging = false,
  }) async {
    // Initialize caches before any processing to ensure data is ready.
    await _initializeAirportCache();
    await _initializeAirlineCache();

    List<Map<String, dynamic>> allFlights = [];

    if (usePythonBackend) {
      try {
        foundation.debugPrint('AviationStackService: Attempting to fetch flights from Python backend.');
        final uri = Uri.parse('$pythonBackendUrl/eligible_flights').replace(queryParameters: {'hours': hours.toString()});
        final response = await http.get(uri).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          allFlights = await _tryProcessFlightsData(data);
          foundation.debugPrint('AviationStackService: Successfully fetched ${allFlights.length} flights from Python backend.');
          return await _processCompensationEligibility(allFlights, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
        } else {
          foundation.debugPrint('AviationStackService: Python backend error: ${response.statusCode}, falling back to direct API.');
        }
      } catch (e) {
        foundation.debugPrint('AviationStackService: Error fetching from Python backend: $e, falling back to direct API.');
      }
    }

    // Fallback to direct AviationStack API if Python backend is disabled or fails
    try {
      foundation.debugPrint('AviationStackService: Attempting to fetch flights from AviationStack API for multiple statuses.');
      final apiKey = await _getApiKey();
      final statusesToFetch = ['cancelled', 'diverted', 'delayed', 'landed'];
      
      for (final status in statusesToFetch) {
        foundation.debugPrint('AviationStackService: Fetching flights with status: $status');
        try {
          final uri = Uri.parse('$baseUrl/flights').replace(queryParameters: {
            'access_key': apiKey,
            'flight_status': status,
            'limit': '100',
          });

          final response = await http.get(uri).timeout(const Duration(seconds: 20));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final flights = await _tryProcessFlightsData(data);
            allFlights.addAll(flights);
            foundation.debugPrint('AviationStackService: Successfully fetched ${flights.length} flights for status: $status.');
          } else {
            foundation.debugPrint('AviationStackService: AviationStack API error for status $status: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
           foundation.debugPrint('AviationStackService: Error fetching from AviationStack API for status $status: $e');
        }
      }
      
      if (allFlights.isEmpty) {
        foundation.debugPrint('AviationStackService: No flights found after checking all statuses.');
      }

    } catch (e) {
      foundation.debugPrint('AviationStackService: A general error occurred during flight fetching: $e');
      throw Exception('Failed to load flights. Please check your connection and try again.');
    }

    return await _processCompensationEligibility(allFlights, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
  }

  // Fetches recent arrivals for a specific airport.
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 360,
  }) async {
    if (airportIcao.isEmpty) {
      throw ArgumentError('ICAO code cannot be empty');
    }
    
    try {
      final now = DateTime.now();
      final minutesAgo = now.subtract(Duration(minutes: minutesBeforeNow));
      final formattedDate = _formatDate(minutesAgo.toIso8601String());
      
      final queryParams = {
        'access_key': await _getApiKey(),
        'arr_icao': airportIcao,
        'flight_date': formattedDate,
        'limit': '100',
      };
      
      final uri = Uri.parse('$baseUrl/flights').replace(queryParameters: queryParams);
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      
      if (response.statusCode != 200) {
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      
      if (data['error'] != null) {
        throw Exception('API error: ${data['error']['message'] ?? 'Unknown API error'}');
      }
      
      final flightData = data['data'];
      if (flightData == null || flightData is! List) {
        throw Exception('Invalid data format from API.');
      }
      
      final flights = _normalizeFlightData(flightData);
      foundation.debugPrint('Retrieved ${flights.length} recent arrivals for $airportIcao');
      return flights;
    } catch (e) {
      foundation.debugPrint('AviationStackService: Error fetching recent arrivals: $e');
      rethrow; // Rethrow the exception to be handled by the caller.
    }
  }
  
  // Checks compensation eligibility for a specific flight.
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    // Initialize caches before any processing to ensure data is ready.
    await _initializeAirportCache();
    await _initializeAirlineCache();

    if (usePythonBackend) {
      try {
        final uri = Uri.parse('$pythonBackendUrl/check_eligibility').replace(queryParameters: {
          'flight_number': flightNumber,
          if (date != null) 'flight_date': date,
        });
        
        final response = await http.get(uri).timeout(const Duration(seconds: 15));
        
        if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['error'] != null) {
              throw Exception('Python backend error: ${data['error']}');
            }
            final flight = data['flight'] ?? data['data'];
            if (flight == null) {
              throw Exception('Flight $flightNumber not found in Python backend response');
            }
            // Assuming the backend provides full eligibility details.
            return Map<String, dynamic>.from(flight);
        } else {
            foundation.debugPrint('Python backend error: ${response.statusCode}, falling back to direct API.');
        }
      } catch (e) {
        foundation.debugPrint('Error from Python backend: $e, falling back to direct API');
      }
    }
    
    // Fallback to direct Aviation Stack API
    try {
      final apiKey = await _getApiKey();
      final uri = Uri.parse('$baseUrl/flights').replace(queryParameters: {
        'access_key': apiKey,
        'flight_iata': flightNumber,
        if (date != null) 'flight_date': date,
      });
      
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      
      if (response.statusCode != 200) {
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw Exception('API Error: ${data['error']['message']}');
      }
      
      final flights = data['data'] as List<dynamic>;
      if (flights.isEmpty) {
        throw Exception('Flight $flightNumber not found');
      }
      
      final flight = _normalizeSingleFlightData(flights[0]);
      final eligibilityDetails = await _calculateEligibility(flight);
      
      return {
        ...flight,
        'eligible': eligibilityDetails['isEligible'],
        'reason': eligibilityDetails['reason'],
        'potentialCompensationAmount': eligibilityDetails['estimatedCompensation'],
      };
    } catch (e) {
      foundation.debugPrint('Error checking compensation eligibility: $e');
      rethrow; // Rethrow the exception to be handled by the caller.
    }
  }
}
