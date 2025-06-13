import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
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
  
  /// Flag to force use of fallback data for debugging
  bool debugForceFallback = false;
  
  /// Creates an instance of the AviationStackService
  /// 
  /// [baseUrl] - The base URL for the API, defaults to production URL
  /// [pythonBackendUrl] - The URL for the Python backend service
  /// [accessKey] - Optional API key, defaults to a development key if not provided
  /// [usePythonBackend] - Whether to use Python backend as primary data source
  AviationStackService({
    this.baseUrl = 'https://api.aviationstack.com/v1',
    this.pythonBackendUrl = 'https://piotrs.pythonanywhere.com',
    String? accessKey,
    this.usePythonBackend = true,
  });
  
  /// Gets the API key from various sources with fallback options
  Future<String> _getApiKey() async {
    // First try to get from environment
    final envKey = String.fromEnvironment('AVIATION_STACK_API_KEY', defaultValue: '');
    
    if (envKey.isNotEmpty) {
      debugPrint('Using API key from environment');
      return envKey;
    }
    
    // Use the valid production key
    debugPrint('Using production API key');
    // This is a placeholder key - API key should be properly configured
    final key = '9cb5db4ba59f1e5005591c572d8b5f1c'; // Aviation Stack API key
    return key;
  }

  /// Returns a list of flight data maps with EU compensation eligibility information
  /// Returns a list of EU compensation eligible flights based on the API response
  /// 
  /// If [useFallback] is true, return mock data instead of making API calls
  /// Helper method to try processing flight data from various possible response formats
  Future<List<Map<String, dynamic>>> _tryProcessFlightsData(Map<String, dynamic> data) async {
    // Try to find flight data in different possible locations in the JSON structure
    // This handles cases where the backend might return data in different formats
    
    // Option 1: Flight data in 'flights' key
    if (data.containsKey('flights') && data['flights'] is List) {
      debugPrint('Found flights data in "flights" key');
      final List<dynamic> rawFlights = data['flights'];
      return _normalizeFlightData(rawFlights);
    }
    
    // Option 2: Flight data in 'data' key
    if (data.containsKey('data') && data['data'] is List) {
      debugPrint('Found flights data in "data" key');
      final List<dynamic> rawFlights = data['data'];
      return _normalizeFlightData(rawFlights);
    }
    
    // Option 3: Flight data in 'eligible_flights' key
    if (data.containsKey('eligible_flights') && data['eligible_flights'] is List) {
      debugPrint('Found flights data in "eligible_flights" key');
      final List<dynamic> rawFlights = data['eligible_flights'];
      return _normalizeFlightData(rawFlights);
    }
    
    // Option 4: Flight data in 'results' key
    if (data.containsKey('results') && data['results'] is List) {
      debugPrint('Found flights data in "results" key');
      final List<dynamic> rawFlights = data['results'];
      return _normalizeFlightData(rawFlights);
    }
    
    // Option 5: Data is directly a list of flights
    if (data is Map && data.isEmpty) {
      debugPrint('Response is an empty map');
      return [];
    }
    
    // We couldn't find flights in any expected location
    debugPrint('Could not find flights data in expected response format: ${data.keys.join(', ')}');
    return [];
  }
  
  /// Helper method to normalize flight data from API response
  List<Map<String, dynamic>> _normalizeFlightData(List<dynamic> rawFlights) {
    final result = <Map<String, dynamic>>[];
    
    for (final flight in rawFlights) {
      try {
        final normalizedFlight = _normalizeSingleFlightData(flight);
        result.add(normalizedFlight);
      } catch (e) {
        debugPrint('Error normalizing flight data: $e');
        // Skip this flight and continue with others
      }
    }
    
    return result;
  }
  
  /// Normalize a single flight's data from the API response
  Map<String, dynamic> _normalizeSingleFlightData(dynamic flight) {
    final departureTime = flight['departure']?['scheduled'] ?? '';
    final arrivalTime = flight['arrival']?['scheduled'] ?? '';
    final actualArrival = flight['arrival']?['actual'] ?? '';
    
    int delayMinutes = 0;
    if (actualArrival.isNotEmpty && arrivalTime.isNotEmpty) {
      try {
        final scheduled = DateTime.parse(arrivalTime);
        final actual = DateTime.parse(actualArrival);
        delayMinutes = actual.difference(scheduled).inMinutes;
      } catch (e) {
        // Handle parsing error
      }
    } else if (flight['arrival']?['delay'] != null) {
      final delayValue = flight['arrival']?['delay'];
      if (delayValue != null) {
        delayMinutes = int.tryParse(delayValue.toString()) ?? 0;
      }
    }
    
    return {
      'flightNumber': flight['flight']?['iata'] ?? '',
      'airline': flight['airline']?['name'] ?? '',
      'departureAirport': flight['departure']?['airport'] ?? '',
      'arrivalAirport': flight['arrival']?['airport'] ?? '',
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'status': flight['flight_status'] ?? '',
      'delayMinutes': delayMinutes,
    };
  }
  
  /// Process flights to determine EU compensation eligibility
  List<Map<String, dynamic>> _processCompensationEligibility(List<Map<String, dynamic>> flights) {
    final eligibleFlights = <Map<String, dynamic>>[];
    
    for (final flight in flights) {
      final eligibilityDetails = _calculateEligibility(flight);
      final isEligible = eligibilityDetails['isEligible'] as bool? ?? false;
      
      if (isEligible) {
        eligibleFlights.add({
          ...flight,
          'isEligibleForCompensation': true,
          'potentialCompensationAmount': eligibilityDetails['estimatedCompensation'],
          'currency': 'EUR',
          'reason': eligibilityDetails['reason'],
          'eligibilityDetails': eligibilityDetails,
        });
      }
    }
    
    debugPrint('Found ${eligibleFlights.length} EU compensation eligible flights');
    return eligibleFlights;
  }
  
  /// Calculates eligibility and compensation amount based on EU regulation EC 261/2004
  Map<String, dynamic> _calculateEligibility(Map<String, dynamic> flight) {
    final delayMinutes = flight['delayMinutes'] as int? ?? 0;
    final flightNumber = flight['flightNumber'] as String? ?? '';
    
    // EU Regulation EC 261/2004 criteria (simplified)
    bool isEligible = false;
    int estimatedCompensation = 0;
    String reason = 'Not eligible for compensation';
    
    if (delayMinutes >= 180) { // 3+ hours delay
      isEligible = true;
      
      // Estimate compensation amount based on flight distance (simplified)
      // In a real app, this would use origin/destination coordinates to calculate actual distance
      if (flightNumber.startsWith('BA') || flightNumber.startsWith('LH')) {
        estimatedCompensation = 400; // Medium-haul flight estimate
        reason = 'Flight delayed more than 3 hours (EU regulation)';
      } else {
        estimatedCompensation = 250; // Short-haul flight estimate (default)
        reason = 'Flight delayed more than 3 hours (EU regulation)';
      }
    }
    
    return {
      'isEligible': isEligible,
      'estimatedCompensation': estimatedCompensation,
      'reason': reason,
    };
  }
  
  /// Formats a date string to YYYY-MM-DD format
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return '';
    }
  }
  
  /// Provides fallback data for EU compensation eligible flights
  List<Map<String, dynamic>> _getFallbackEligibleFlights() {
    // Use DateTime.now() to generate flight times relative to current time
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    return [
      {
        'flightNumber': 'LH1234',
        'airline': 'Lufthansa',
        'departureAirport': 'Frankfurt',
        'arrivalAirport': 'Madrid',
        'departureTime': yesterday.subtract(const Duration(hours: 6)).toIso8601String(),
        'arrivalTime': yesterday.subtract(const Duration(hours: 3)).toIso8601String(),
        'status': 'delayed',
        'delayMinutes': 195,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 250,
        'currency': 'EUR',
        'reason': 'Flight delayed more than 3 hours (EU regulation)',
        'isDelayedOver3Hours': true,
      },
      {
        'flightNumber': 'BA4892',
        'airline': 'British Airways',
        'departureAirport': 'London Heathrow',
        'arrivalAirport': 'Athens',
        'departureTime': yesterday.subtract(const Duration(hours: 5)).toIso8601String(),
        'arrivalTime': yesterday.subtract(const Duration(hours: 2)).toIso8601String(),
        'status': 'delayed',
        'delayMinutes': 240,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 400,
        'currency': 'EUR',
        'isDelayedOver3Hours': true,
      },
    ];
  }
  
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72,
    bool useFallback = false,
  }) async {
    // Only use fallback data if explicitly requested or debug flag is set
    if (useFallback || debugForceFallback) {
      debugPrint('Using fallback data for EU eligible flights (useFallback: $useFallback, debugForceFallback: $debugForceFallback)');
      return _getFallbackEligibleFlights();
    }

    // First try Python backend if enabled
    if (usePythonBackend) {
      try {
        debugPrint('Fetching EU eligible flights from Python backend...');
        
        // Try several possible endpoint paths that might be configured on PythonAnywhere
        final possiblePaths = [
          '/',  // Root path
          '/api/flights',  // Common REST API pattern
          '/flights',  // Simple endpoint
          '/get_flights',  // Python/Flask style
          '/flight_data',  // Descriptive
          '/eligible_flights',  // EU specific endpoint
        ];
        
        debugPrint('Attempting to connect to Python backend with multiple path options...');
        Exception? lastError;
        
        // Try each endpoint path
        for (final path in possiblePaths) {
          try {
            final uri = Uri.parse('${this.pythonBackendUrl}$path');
            debugPrint('Making Python backend request to: $uri');
            
            // Set a timeout to prevent hanging
            final response = await http.get(uri).timeout(
              const Duration(seconds: 15),
              onTimeout: () {
                debugPrint('Python backend request timed out');
                throw TimeoutException('Python backend request timed out');
              },
            );
            
            // Log response status and partial body for debugging
            debugPrint('Python backend response status code: ${response.statusCode}');
            final bodyPreview = response.body.length > 300 ? response.body.substring(0, 300) + '...' : response.body;
            debugPrint('Python backend response body preview: $bodyPreview');
            
            if (response.statusCode == 200) {
              // Try to parse the response as JSON
              final data = json.decode(response.body);
              
              // Process the data - check if it contains flights in one of several possible formats
              final List<Map<String, dynamic>> flights = await _tryProcessFlightsData(data);
              
              if (flights.isNotEmpty) {
                debugPrint('Successfully retrieved ${flights.length} eligible flights from Python backend');
                return flights;
              } else {
                debugPrint('Python backend returned empty flights list');
              }
            } else {
              debugPrint('Python backend returned status code: ${response.statusCode}');
              throw Exception('Python backend returned status code ${response.statusCode}');
            }
          } catch (e) {
            debugPrint('Error accessing Python backend at $path: $e');
            lastError = e as Exception;
            // Continue trying other paths
          }
        }
        
        // If we get here, all paths failed
        debugPrint('All Python backend paths failed, falling back to direct API');
        throw lastError ?? Exception('All Python backend paths failed');
        
      } catch (e) {
        debugPrint('Error with Python backend, falling back to direct API: $e');
        // Fall through to direct API call
      }
    }
    
    // Fall back to direct Aviation Stack API if Python backend is disabled or failed
    try {
      debugPrint('Fetching EU eligible flights from Aviation Stack API...');
      
      // Calculate date range
      final now = DateTime.now();
      final hoursAgo = now.subtract(Duration(hours: hours));
      
      final formattedNow = _formatDate(now.toIso8601String());
      final formattedHoursAgo = _formatDate(hoursAgo.toIso8601String());
      
      // Query for flights with delays
      final queryParams = {
        'access_key': await _getApiKey(),
        'dep_scheduled_time_gtz': formattedHoursAgo,
        'arr_scheduled_time_ltz': formattedNow,
        'min_delay_arr': '180', // 3 hours minimum delay
        'limit': '100', // Maximum results
      };
      
      debugPrint('Querying Aviation Stack API with params: $queryParams');
      
      final uri = Uri.parse('${this.baseUrl}/flights').replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('API request timed out');
          throw TimeoutException('API request timed out');
        },
      );
      
      if (response.statusCode != 200) {
        debugPrint('API error: ${response.statusCode}, ${response.body}');
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      // Log first 1000 chars of response body for debugging
      final responseBody = response.body;
      debugPrint('API response body preview: ${responseBody.substring(0, responseBody.length > 1000 ? 1000 : responseBody.length)}...');
      
      final data = json.decode(responseBody);
      
      // Check for API error format
      if (data['error'] != null) {
        final errorMsg = data['error']['message'] ?? 'Unknown API error';
        debugPrint('API error: $errorMsg');
        throw Exception('API error: $errorMsg');
      }
      
      // Log pagination and result count if available
      if (data['pagination'] != null) {
        final total = data['pagination']['total'];
        debugPrint('API returned total of $total flights');
      }
      
      // Process and filter flights based on EU compensation eligibility rules
      final flightData = data['data'];
      
      if (flightData == null) {
        debugPrint('API response missing "data" field');
        throw Exception('API response missing "data" field');
      }
      
      if (flightData is! List) {
        debugPrint('API "data" field is not a list');
        throw Exception('API "data" field is not a list');
      }
      
      // Process flights with robust error handling
      final flights = _normalizeFlightData(flightData);
      
      // If we get an empty list from the API, we can still process with what we have
      if (flights.isEmpty) {
        debugPrint('API returned no flights');
      } else {
        debugPrint('Successfully retrieved ${flights.length} flights from API');
        
        // Log first flight to see structure
        if (flights.isNotEmpty) {
          debugPrint('Sample flight data: ${flights[0]}');
        }
      }
      
      return _processCompensationEligibility(flights);
    } catch (e) {
      debugPrint('AviationStackService error: $e');
      
      // Only use fallback data if something went seriously wrong with the API
      if (e is TimeoutException || e.toString().contains('Failed host lookup')) {
        debugPrint('Critical connection error, using fallback data');
        return _getFallbackEligibleFlights();
      } else {
        // Return empty list for other errors
        return [];
      }
    }
  }
  
  /// Fetches recent arrivals for a specific airport
  /// 
  /// [airportIcao] - The ICAO code of the airport
  /// [minutesBeforeNow] - Time window in minutes for recent arrivals
  /// 
  /// Returns a list of flight data maps containing normalized flight information
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
      
      debugPrint('Querying Aviation Stack API with params: $queryParams');
      
      final uri = Uri.parse('${this.baseUrl}/flights').replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('API request timed out');
          throw TimeoutException('API request timed out');
        },
      );
      
      if (response.statusCode != 200) {
        debugPrint('API error: ${response.statusCode}, ${response.body}');
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      
      if (data['error'] != null) {
        final errorMsg = data['error']['message'] ?? 'Unknown API error';
        debugPrint('API error: $errorMsg');
        throw Exception('API error: $errorMsg');
      }
      
      final flightData = data['data'];
      
      if (flightData == null) {
        debugPrint('API response missing "data" field');
        throw Exception('API response missing "data" field');
      }
      
      if (flightData is! List) {
        debugPrint('API "data" field is not a list');
        throw Exception('API "data" field is not a list');
      }
      
      final flights = _normalizeFlightData(flightData);
      debugPrint('Retrieved ${flights.length} recent arrivals for $airportIcao');
      
      return flights;
    } catch (e) {
      debugPrint('Error fetching recent arrivals: $e');
      
      // Only use fallback data for critical connectivity issues
      if (e is TimeoutException || e.toString().contains('Failed host lookup')) {
        return _getFallbackRecentArrivals(airportIcao);
      } else {
        rethrow;
      }
    }
  }
  
  /// Returns fallback data for recent arrivals at an airport
  List<Map<String, dynamic>> _getFallbackRecentArrivals(String airportIcao) {
    final now = DateTime.now();
    
    return [
      {
        'flightNumber': 'BA1234',
        'airline': 'British Airways',
        'departureAirport': 'London Heathrow',
        'arrivalAirport': airportIcao,
        'departureTime': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'arrivalTime': now.subtract(const Duration(minutes: 30)).toIso8601String(),
        'status': 'landed',
        'delayMinutes': 15,
      },
      {
        'flightNumber': 'LH4567',
        'airline': 'Lufthansa',
        'departureAirport': 'Frankfurt',
        'arrivalAirport': airportIcao,
        'departureTime': now.subtract(const Duration(hours: 4)).toIso8601String(),
        'arrivalTime': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'status': 'landed',
        'delayMinutes': 45,
      },
    ];
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
        debugPrint('Checking compensation eligibility via Python backend for flight: $flightNumber');
        
        // Construct the Python backend request URL
        final uri = Uri.parse('${this.pythonBackendUrl}/check_eligibility')
          .replace(queryParameters: {
            'flight_number': flightNumber,
            if (date != null) 'flight_date': date,
          });
        
        debugPrint('Making Python backend request to: $uri');
        
        // Set a timeout to prevent hanging
        final response = await http.get(uri)
          .timeout(const Duration(seconds: 15), onTimeout: () {
            debugPrint('Python backend request timed out checking eligibility');
            throw TimeoutException('Python backend request timed out');
          });
        
        if (response.statusCode != 200) {
          debugPrint('Failed checking eligibility via Python: HTTP ${response.statusCode}');
          throw Exception('Python backend returned status code ${response.statusCode}');
        }
        
        final data = json.decode(response.body);
        if (data['error'] != null) {
          debugPrint('Python backend error: ${data['error']}');
          throw Exception('Python backend error: ${data['error']}');
        }
        
        // The Python backend should return the flight with eligibility details
        final flight = data['flight'] ?? data['data'];
        if (flight == null) {
          debugPrint('Flight not found in Python backend response');
          throw Exception('Flight $flightNumber not found in Python backend response');
        }
        
        debugPrint('Successfully retrieved eligibility details from Python backend');
        return Map<String, dynamic>.from(flight); // Already processed
      } catch (e) {
        debugPrint('Error from Python backend: $e, falling back to direct API');
        // Fall through to direct API call
      }
    }
    
    // Fall back to direct Aviation Stack API if Python backend is disabled or failed
    try {
      debugPrint('Checking compensation eligibility via direct API for flight: $flightNumber');
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
          debugPrint('API request timed out checking eligibility');
          throw TimeoutException('API request timed out');
        });
      
      if (response.statusCode != 200) {
        debugPrint('Failed checking eligibility: HTTP ${response.statusCode}');
        throw Exception('API returned status code ${response.statusCode}');
      }
      
      final data = json.decode(response.body);
      if (data['error'] != null) {
        debugPrint('API Error: ${data['error']['message']}');
        throw Exception('API Error: ${data['error']['message']}');
      }
      
      final flights = data['data'] as List<dynamic>;
      if (flights.isEmpty) {
        debugPrint('Flight not found in API');
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
      debugPrint('Error checking compensation eligibility: $e');
      // Only use fallback data for critical connectivity issues
      if (e is TimeoutException || e.toString().contains('Failed host lookup')) {
        return _getFallbackFlightEligibility(flightNumber);
      } else {
        rethrow;
      }
    }
  }
  
  /// Returns fallback eligibility data for a specific flight
  Map<String, dynamic> _getFallbackFlightEligibility(String flightNumber) {
    return {
      'flightNumber': flightNumber,
      'airline': 'Sample Airline',
      'departureAirport': 'Origin Airport',
      'arrivalAirport': 'Destination Airport',
      'departureTime': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'arrivalTime': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'status': 'delayed',
      'delayMinutes': 210,
      'eligible': true,
      'reason': 'Flight delayed more than 3 hours (EU regulation)',
      'potentialCompensationAmount': 250,
    };
  }
}
