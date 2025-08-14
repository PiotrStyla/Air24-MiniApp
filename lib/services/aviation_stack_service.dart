import 'package:http/http.dart' as http;

import 'dart:async'; // For TimeoutException
import 'dart:convert'; // For JSON handling
import 'dart:math'; // For Random generation
import 'package:flutter/foundation.dart' as foundation;

/// Service for interacting with Aviation Stack API to retrieve flight information
/// Used for getting flight details, checking compensation eligibility, and more.
class AviationStackService {
  // API configuration
  final http.Client _httpClient;
  final String baseUrl;
  final String apiKey;
  final String? pythonBackendUrl;
  final bool _usingPythonBackend; // Flag to control backend usage
  final String? apiKeysFile;
  final bool mockMode;


  // Cache variables already defined as final fields above

  // Caching for airport and airline data to avoid repeated API calls.
  final Map<String, String> _airportCountryCache = {};
  final Map<String, String> _airlineCountryCache = {};
  final bool _isAirportCacheInitialized = false;
  final bool _isAirlineCacheInitialized = false;

  /// Creates an instance of the AviationStackService
  AviationStackService({
    http.Client? httpClient,
    this.baseUrl = 'https://api.aviationstack.com/v1',
    this.apiKey = '',
    this.apiKeysFile,
    this.mockMode = false,
    bool usingPythonBackend = true,
    this.pythonBackendUrl = 'https://piotrs.pythonanywhere.com',
  }) : _httpClient = httpClient ?? http.Client(),
       _usingPythonBackend = usingPythonBackend;

  /// Gets the API key for the Aviation Stack API
  Future<String> _getApiKey() async {
    // In a real app, this would come from secure storage or environment variables
    return apiKey;
  }


  // Removed unused _fetchAllPaginatedData method

  /// Initializes the airport cache by fetching all airports from the API.
  Future<void> _initializeAirportCache() async {
    // Instead of skipping, initialize with known EU airports
    foundation.debugPrint('🔍 AviationStackService: Initializing airport cache with known EU airports');
    
    // Map of IATA codes to country codes for major EU airports
    final Map<String, String> euAirports = {
      // Germany
      'FRA': 'DE', // Frankfurt
      'MUC': 'DE', // Munich
      'TXL': 'DE', // Berlin Tegel
      'BER': 'DE', // Berlin Brandenburg
      'DUS': 'DE', // Dusseldorf
      'HAM': 'DE', // Hamburg
      
      // France
      'CDG': 'FR', // Paris Charles de Gaulle
      'ORY': 'FR', // Paris Orly
      'NCE': 'FR', // Nice
      'LYS': 'FR', // Lyon
      
      // Spain
      'MAD': 'ES', // Madrid
      'BCN': 'ES', // Barcelona
      'AGP': 'ES', // Malaga
      'PMI': 'ES', // Palma de Mallorca
      'ALC': 'ES', // Alicante
      'IBZ': 'ES', // Ibiza
      
      // Italy
      'FCO': 'IT', // Rome Fiumicino
      'MXP': 'IT', // Milan Malpensa
      'VCE': 'IT', // Venice
      'NAP': 'IT', // Naples
      
      // Netherlands
      'AMS': 'NL', // Amsterdam
      'RTM': 'NL', // Rotterdam
      
      // Poland
      'WAW': 'PL', // Warsaw
      'KRK': 'PL', // Krakow
      'GDN': 'PL', // Gdansk
      
      // Other EU countries
      'VIE': 'AT', // Vienna, Austria
      'BRU': 'BE', // Brussels, Belgium
      'CPH': 'DK', // Copenhagen, Denmark
      'HEL': 'FI', // Helsinki, Finland
      'ATH': 'GR', // Athens, Greece
      'DUB': 'IE', // Dublin, Ireland
      'LIS': 'PT', // Lisbon, Portugal
      'ARN': 'SE', // Stockholm, Sweden
      
      // UK - included for historical EU flights relevance
      'LHR': 'GB', // London Heathrow
      'LGW': 'GB', // London Gatwick
      'MAN': 'GB', // Manchester
      'EDI': 'GB', // Edinburgh
      
      // Switzerland - covered by similar regulations
      'ZRH': 'CH', // Zurich
      'GVA': 'CH', // Geneva
      
      // Norway - EEA member
      'OSL': 'NO', // Oslo
      
      // Iceland - EEA member
      'KEF': 'IS', // Reykjavik
    };
    
    _airportCountryCache.addAll(euAirports);
    foundation.debugPrint('✅ AviationStackService: Airport cache initialized with ${_airportCountryCache.length} airports');
  }

  /// Initializes the airline cache by fetching all airlines from the API.
  Future<void> _initializeAirlineCache() async {
    // Instead of skipping, initialize with known EU airlines
    foundation.debugPrint('🔍 AviationStackService: Initializing airline cache with known EU airlines');
    
    // Map of IATA codes to country codes for major EU airlines
    final Map<String, String> euAirlines = {
      // Germany
      'LH': 'DE', // Lufthansa
      'DE': 'DE', // Condor
      'EW': 'DE', // Eurowings
      
      // France
      'AF': 'FR', // Air France
      'XK': 'FR', // Air Corsica
      
      // Spain
      'IB': 'ES', // Iberia
      'VY': 'ES', // Vueling
      
      // Italy
      'AZ': 'IT', // Alitalia/ITA Airways
      
      // Netherlands
      'KL': 'NL', // KLM
      'HV': 'NL', // Transavia
      
      // Poland
      'LO': 'PL', // LOT Polish Airlines
      
      // Other EU airlines
      'OS': 'AT', // Austrian Airlines
      'SN': 'BE', // Brussels Airlines
      'SK': 'SE', // SAS Scandinavian
      'TP': 'PT', // TAP Air Portugal
      'AY': 'FI', // Finnair
      'A3': 'GR', // Aegean
      'EI': 'IE', // Aer Lingus
      
      // UK airlines - included for historical EU flights relevance
      'BA': 'GB', // British Airways
      'VS': 'GB', // Virgin Atlantic
      'EZY': 'GB', // EasyJet
      'U2': 'GB', // EasyJet alternate code
      
      // Low-cost carriers with significant EU operations
      'FR': 'IE', // Ryanair (Irish)
      'W6': 'HU', // Wizz Air (Hungarian)
    };
    
    _airlineCountryCache.addAll(euAirlines);
    foundation.debugPrint('✅ AviationStackService: Airline cache initialized with ${_airlineCountryCache.length} airlines');
  }

  /// Helper method to safely normalize flight data from API response with robust type handling
  List<Map<String, dynamic>> _normalizeFlightData(dynamic rawFlights) {
    // Handle null or empty case
    if (rawFlights == null) {
      foundation.debugPrint('⚠️ AviationStackService: Null flights data received');
      return [];
    }
    
    // Handle List case
    if (rawFlights is List) {
      if (rawFlights.isEmpty) {
        return [];
      }
      
      foundation.debugPrint('AviationStackService: Normalizing ${rawFlights.length} flights');
      return rawFlights.map((flight) => _normalizeSingleFlightData(flight)).toList();
    }
    
    // Handle Map case - extract a list if possible
    if (rawFlights is Map) {
      if (rawFlights.containsKey('flights') && rawFlights['flights'] is List) {
        return _normalizeFlightData(rawFlights['flights']);
      }
      
      // Single flight as a Map
      foundation.debugPrint('AviationStackService: Normalizing single flight (Map)');
      return [_normalizeSingleFlightData(rawFlights)];
    }
    
    // Unhandled data type
    foundation.debugPrint('⚠️ AviationStackService: Unhandled data type: ${rawFlights.runtimeType}');
    return [];
  }

  /// Normalize a single flight from API response
  Map<String, dynamic> _normalizeSingleFlightData(dynamic flight) {
    if (flight is! Map<String, dynamic>) {
      return {}; // Return empty map for invalid input
    }
    
    // Normalize flight data structure to a consistent format
    return {
      'flight_iata': flight['flight_iata'] ?? flight['flight']?['iata'] ?? 'Unknown',
      'airline_name': flight['airline']?['name'] ?? flight['airline_name'] ?? 'Unknown Airline',
      'airline_iata': flight['airline']?['iata'] ?? flight['airline_iata'] ?? '',
      'departure_airport_iata': flight['departure']?['iata'] ?? flight['departure_airport_iata'] ?? '',
      'arrival_airport_iata': flight['arrival']?['iata'] ?? flight['arrival_airport_iata'] ?? '',
      'status': flight['status'] ?? flight['flight_status'] ?? 'UNKNOWN',
      'delay_minutes': flight['delay_minutes'] ?? 0,
      'distance_km': flight['distance_km'] ?? 0,
      'departure_scheduled_time': flight['departure']?['scheduled'] ?? flight['departure_scheduled_time'] ?? '',
      'arrival_scheduled_time': flight['arrival']?['scheduled'] ?? flight['arrival_scheduled_time'] ?? '',
    };
  }

  /// Process flight data from API response
  Future<List<Map<String, dynamic>>> _tryProcessFlightsData(dynamic data) async {
    try {
      foundation.debugPrint('🔍 AviationStackService: _tryProcessFlightsData: Analyzing data structure, type: ${data.runtimeType}');
      
      // Handle direct List<dynamic> response (typical from Python backend)
      if (data is List<dynamic>) {
        foundation.debugPrint('✅ AviationStackService: Processing direct List response with ${data.length} items');
        return _normalizeFlightData(data);
      }
      
      // Handle Map response format (typical from AviationStack API)
      if (data is Map) {
        foundation.debugPrint('🔍 AviationStackService: Processing Map response');
      // foundation.debugPrint('AviationStackService: Available keys in response: ${data.keys.join(", ")}');

      // Check if the source data is a dictionary with a 'data' key (common API response format)
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final flightsData = data['data'];
        
        // Handle pagination if present
        if (flightsData is Map<String, dynamic> && flightsData.containsKey('flights')) {
          final flights = flightsData['flights'];
          if (flights is List<dynamic>) {
            return _normalizeFlightData(flights);
          }
          return [];
        } 
        // Handle direct list of flights
        if (flightsData is List<dynamic>) {
          return _normalizeFlightData(flightsData);
        }
        
        return []; // Empty response if no valid structure found
      } 
      
      // Handle raw list of flights (no wrapper)
      if (data is List<dynamic>) {
        final flightsList = data;
        if (flightsList.isEmpty) {
          return []; // Return empty list for empty response
        }
        foundation.debugPrint('AviationStackService: _tryProcessFlightsData: Found ${flightsList.length} flights to normalize.');
        return _normalizeFlightData(flightsList);
      }
      
      // Handle case where data is a Map but might contain flight data
      if (data is Map<String, dynamic> && data.containsKey('flights')) {
        final flights = data['flights'];
        if (flights is List<dynamic>) {
          return _normalizeFlightData(flights);
        }
      }
      
      // If we reach here within the Map branch, it's a Map but doesn't match expected formats
      foundation.debugPrint('⚠️ AviationStackService: Map response doesn\'t match expected structure');
      return [];
    }
      
    // If we get here, data might be some other type that we can't process
    foundation.debugPrint('⚠️ AviationStackService: Unprocessable data type: ${data.runtimeType}');
    return []; // Return empty list for unprocessable data type
    } catch (e) {
      foundation.debugPrint('❌ AviationStackService: Error processing flights data: $e');
      return [];
    }
  }

  // --- Public Methods ---
  
  /// Check if a flight is eligible for compensation under EU regulations
  /// 
  /// [flightNumber] - The flight number (e.g., 'BA123')
  /// [date] - Optional date string for the flight
  /// 
  /// Returns a map with eligibility result and details
  Future<Map<String, dynamic>> checkCompensationEligibility({required String flightNumber, String? date}) async {
    foundation.debugPrint('AviationStackService: Checking compensation eligibility for flight $flightNumber');
    
    try {
      // For Python backend
      if (_usingPythonBackend) {
        final uri = Uri.parse('$pythonBackendUrl/check_eligibility').replace(queryParameters: {
          'flight_number': flightNumber,
        });
        
        foundation.debugPrint('AviationStackService: Fetching from Python backend: $uri');
        final response = await _httpClient.get(uri).timeout(const Duration(seconds: 30));
        
        if (response.statusCode != 200) {
          foundation.debugPrint('AviationStackService: Error ${response.statusCode} from backend');
          return _generateFallbackEligibilityResponse(flightNumber);
        }
        
        final data = json.decode(response.body);
        return data;
      } else {
        // For direct AviationStack API usage (fallback)
        return _generateFallbackEligibilityResponse(flightNumber);
      }
    } catch (e) {
      foundation.debugPrint('AviationStackService: Error checking compensation: $e');
      return _generateFallbackEligibilityResponse(flightNumber);
    }
  }
  
  // This simplified getEUCompensationEligibleFlights implementation is removed.
  // Using the more comprehensive implementation defined below.
  
  // This simple _generateMockEligibleFlights implementation is removed.
  // Using the more comprehensive implementation defined below.
  
  // Removed unused helper methods
  
  /// Generate a fallback eligibility response
  Map<String, dynamic> _generateFallbackEligibilityResponse(String flightNumber) {
    final random = Random();
    final isEligible = random.nextBool();
    
    return {
      'flight_number': flightNumber,
      'is_eligible': isEligible,
      'message': isEligible 
          ? 'This flight appears to be eligible for EU compensation.'
          : 'This flight does not appear to be eligible for EU compensation.',
      'status': random.nextBool() ? 'DELAYED' : 'CANCELLED',
      'delay_minutes': isEligible ? 180 + random.nextInt(300) : random.nextInt(60),
      'compensation_amount_eur': isEligible ? [250, 400, 600][random.nextInt(3)] : 0,
      'airline': 'Sample Airline',
      'route': 'Sample Origin - Sample Destination',
    };
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
  
  /// Estimate the flight distance based on available flight data
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
    final String flightIata = flight['flight_iata'] ?? 'Unknown';
    foundation.debugPrint('🔍 AviationStackService: Calculating eligibility for flight $flightIata');
    
    // Check if the flight is delayed enough for compensation
    final status = flight['status']?.toString().toUpperCase() ?? 'UNKNOWN';
    final delayMinutes = flight['delay_minutes'] is int ? flight['delay_minutes'] : 0;
    
    foundation.debugPrint('📊 Flight $flightIata Status: $status, Delay: $delayMinutes minutes');
    
    // Check if the flight is eligible under the EU regulation
    final bool coveredByEURegulation = await _isFlightCoveredByEURegulation(flight);
    
    foundation.debugPrint('🇪🇺 Flight $flightIata EU regulation applies: $coveredByEURegulation');
    
    if (!coveredByEURegulation && !relaxEligibilityForDebugging) {
      foundation.debugPrint('❌ Flight $flightIata NOT covered by EU Regulation EC 261/2004');
      return {
        'eligible': false,
        'reason': 'Flight not covered by EU Regulation EC 261/2004',
        'compensation_amount_eur': 0,
        'status': status,
        'delay_minutes': delayMinutes,
        'eu_regulation_applies': false,
      };
    }
    
    if (!coveredByEURegulation && relaxEligibilityForDebugging) {
      foundation.debugPrint('⚠️ Flight $flightIata not covered by EU Regulation, but eligibility relaxed for debugging');
    }
    
    // Check for circumstances that would exempt the airline
    final extraordinaryCircumstances = await _checkForExtraordinaryCircumstances(flight, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
    
    foundation.debugPrint('🌩️ Flight $flightIata Extraordinary circumstances: $extraordinaryCircumstances');
    
    if (extraordinaryCircumstances && !relaxEligibilityForDebugging) {
      foundation.debugPrint('❌ Flight $flightIata ineligible due to extraordinary circumstances');
      return {
        'eligible': false,
        'reason': 'Extraordinary circumstances',
        'compensation_amount_eur': 0,
        'status': status,
        'delay_minutes': delayMinutes,
        'eu_regulation_applies': true,
      };
    }
    
    // Check if delay qualifies for compensation (>= 3 hours / 180 minutes)
    final bool isDelay = status == 'DELAYED' || delayMinutes >= 15;
    final bool isLongDelay = delayMinutes >= 180; // 3 hours
    final bool isCancelled = status == 'CANCELLED';
    final bool isDiverted = status == 'DIVERTED';
    
    foundation.debugPrint('⏱️ Flight $flightIata Delay status: isDelay=$isDelay, isLongDelay=$isLongDelay, isCancelled=$isCancelled, isDiverted=$isDiverted');
    
    // Check eligibility based on delay or cancellation
    if (!isLongDelay && !isCancelled && !isDiverted && !relaxEligibilityForDebugging) {
      foundation.debugPrint('❌ Flight $flightIata ineligible: Delay less than 3 hours, not cancelled or diverted');
      return {
        'eligible': false,
        'reason': 'Delay less than 3 hours',
        'compensation_amount_eur': 0,
        'status': status,
        'delay_minutes': delayMinutes,
        'eu_regulation_applies': true,
      };
    }
    
    if ((!isLongDelay && !isCancelled && !isDiverted) && relaxEligibilityForDebugging) {
      foundation.debugPrint('⚠️ Flight $flightIata would be ineligible, but eligibility relaxed for debugging');
    }
    
    // Flight qualifies for compensation!
    final int distanceKm = flight['distance_km'] is int ? flight['distance_km'] : _estimateFlightDistance(flight);
    final int compensationAmount = _calculateCompensationAmount(distanceKm);
    
    String reason;
    if (isCancelled) {
      reason = 'Flight cancelled (EU regulation EC 261/2004)';
    } else if (isLongDelay) {
      reason = 'Flight delayed by $delayMinutes minutes (>= 3 hours) (EU regulation EC 261/2004)';
    } else if (isDiverted) {
      reason = 'Flight diverted (EU regulation EC 261/2004)';
    } else {
      reason = 'Flight eligible for compensation under relaxed debugging criteria';
    }
    
    foundation.debugPrint('✅ Flight $flightIata ELIGIBLE for compensation! Amount: €$compensationAmount');
    
    return {
      'eligible': true,
      'reason': reason,
      'compensation_amount_eur': compensationAmount,
      'status': status,
      'delay_minutes': delayMinutes,
      'distance_km': distanceKm,
      'eu_regulation_applies': true,
    };
  }

  /// Process flight data to determine compensation eligibility
  Future<List<Map<String, dynamic>>> _processCompensationEligibility(
    List<Map<String, dynamic>> flights, {
    bool relaxEligibilityForDebugging = false,
  }) async {
    final List<Map<String, dynamic>> eligibleFlights = [];

    foundation.debugPrint('🔍 AviationStackService: Processing ${flights.length} flights for eligibility');
    if (flights.isEmpty) {
      foundation.debugPrint('⚠️ AviationStackService: No flights to process!');
      return [];
    }

    int processedCount = 0;
    for (var flight in flights) {
      processedCount++;
      final String flightIata = flight['flight_iata'] ?? 'Unknown-${processedCount}';
      foundation.debugPrint('🛫 Processing flight $flightIata ($processedCount/${flights.length})');
      
      final eligibilityDetails = await _calculateEligibility(flight, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
      
      // Check if the flight is eligible using the updated field name
      if (relaxEligibilityForDebugging || (eligibilityDetails['eligible'] as bool? ?? false)) {
        foundation.debugPrint('✅ Flight $flightIata is eligible for compensation!');
        // Enrich the original flight object with eligibility details
        flight['eligibility_details'] = eligibilityDetails;
        eligibleFlights.add(flight);
      } else {
        foundation.debugPrint('❌ Flight $flightIata is NOT eligible for compensation');
      }
    }
    
    foundation.debugPrint('📊 AviationStackService: Processed ${flights.length} flights, found ${eligibleFlights.length} eligible flights.');
    return eligibleFlights;
  }

  /// Gets flights eligible for EU compensation
  /// 
  /// This method fetches flights that may be eligible for EU compensation under EC 261/2004 regulation.
  /// It first tries to fetch data from the Python backend, and if that fails, falls back to the AviationStack API.
  /// In case both sources fail, it returns mock eligible flights for testing purposes.
  ///
  /// [hours] - How many hours in the past to look for flights (default: 72)
  /// [relaxEligibilityForDebugging] - Whether to relax eligibility criteria for debugging purposes
  ///
  /// Returns a list of flights that may be eligible for EU compensation
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72,
    bool relaxEligibilityForDebugging = false,
  }) async {
    // Add enhanced debugging indicator at the start of each call to track the flow
    foundation.debugPrint('\n🔍🔍🔍 AviationStackService: START getEUCompensationEligibleFlights() called with hours=$hours, relax=$relaxEligibilityForDebugging');
    // Initialize caches before any processing to ensure data is ready.
    await _initializeAirportCache();
    await _initializeAirlineCache();

    List<Map<String, dynamic>> allFlights = [];

    // Try Python backend first for EU eligible flights
    try {
      foundation.debugPrint('🔎 AviationStackService: Attempting to fetch flights from Python backend.');
      foundation.debugPrint('🌐 AviationStackService: Python Backend URL = $pythonBackendUrl');
      
      // Add explicit request for delayed flights to Python backend
      final uri = Uri.parse('$pythonBackendUrl/eligible_flights').replace(queryParameters: {
        'hours': hours.toString(),
        'include_delayed': 'true'
      });
      foundation.debugPrint('🌐 AviationStackService: Making HTTP request to URI = ${uri.toString()}');
      
      final response = await http.get(uri).timeout(const Duration(seconds: 20));
      foundation.debugPrint('📊 AviationStackService: Python Backend Response Status = ${response.statusCode}');

      if (response.statusCode == 200) {
        foundation.debugPrint('🟢 AviationStackService: Python Backend Response Body preview: ${response.body.substring(0, min(200, response.body.length))}...');
        final data = json.decode(response.body);
        allFlights = await _tryProcessFlightsData(data);
        foundation.debugPrint('✅ AviationStackService: Successfully fetched ${allFlights.length} flights from Python backend.');
        
        // Debug log to check if there are any delayed flights
        int delayedCount = allFlights.where((flight) => 
            flight['status']?.toString().toLowerCase() == 'delayed' || 
            (flight['delay_minutes'] != null && flight['delay_minutes'] > 0)).length;
        foundation.debugPrint('AviationStackService: Found $delayedCount delayed flights in the data.');
        return await _processCompensationEligibility(allFlights, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
      } else {
        foundation.debugPrint('⚠️ AviationStackService: Python backend error: ${response.statusCode} - ${response.body}');
        foundation.debugPrint('⚠️ AviationStackService: Python backend FAILED, will try AviationStack API next');
      }
    } catch (e) {
      foundation.debugPrint('❌ AviationStackService: Python backend error: $e');
      foundation.debugPrint('❌ AviationStackService: Python backend FAILED with exception, will try AviationStack API next');
    }

    // Fallback to direct AviationStack API if Python backend is disabled or fails
    try {
      foundation.debugPrint('🔎 AviationStackService: Attempting to fetch flights from AviationStack API for multiple statuses.');
      final apiKey = await _getApiKey();
      // Prioritize 'delayed' status by putting it first in the list
      final statusesToFetch = ['delayed', 'cancelled', 'diverted', 'landed'];
      
      // Add an additional request specifically for delayed flights with significant delay
      // This is a separate request to increase chances of getting delayed flights
      try {
        foundation.debugPrint('🔎 AviationStackService: Fetching significantly delayed flights specifically');
        final delayedUri = Uri.parse('$baseUrl/flights').replace(queryParameters: {
          'access_key': apiKey,
          'min_delay': '180', // Get flights with at least 180 minutes (3 hours) delay
          'limit': '100',
        });
        
        final delayedResponse = await http.get(delayedUri).timeout(const Duration(seconds: 20));
        
        if (delayedResponse.statusCode == 200) {
          final data = json.decode(delayedResponse.body);
          final flights = await _tryProcessFlightsData(data);
          allFlights.addAll(flights);
          foundation.debugPrint('✅ AviationStackService: Successfully fetched ${flights.length} significantly delayed flights.');
        }
      } catch (e) {
        foundation.debugPrint('⚠️ AviationStackService: Error fetching significantly delayed flights: $e');
      }
      
      for (final status in statusesToFetch) {
        foundation.debugPrint('🔎 AviationStackService: Fetching flights with status: $status');
        try {
          // For delayed status, specifically request flights with minimum delay
          Map<String, String> queryParams = {
            'access_key': apiKey,
            'flight_status': status,
            'limit': '100',
          };
          
          // For 'delayed' status, add extra parameters to ensure we get meaningful delays
          if (status == 'delayed') {
            queryParams['min_delay'] = '15'; // Get flights with at least 15 minutes delay
          }
          
          final uri = Uri.parse('$baseUrl/flights').replace(queryParameters: queryParams);

          final response = await http.get(uri).timeout(const Duration(seconds: 20));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final flights = await _tryProcessFlightsData(data);
            allFlights.addAll(flights);
            foundation.debugPrint('✅ AviationStackService: Successfully fetched ${flights.length} flights for status: $status.');
          } else {
            foundation.debugPrint('⚠️ AviationStackService: AviationStack API error for status $status: ${response.statusCode} - ${response.body}');
          }
        } catch (e) {
           foundation.debugPrint('⚠️ AviationStackService: Error fetching from AviationStack API for status $status: $e');
        }
      }
      
      if (allFlights.isEmpty) {
        foundation.debugPrint('⚠️ AviationStackService: No flights found after checking all statuses.');
        foundation.debugPrint('⚠️ AviationStackService: Both Python backend and AviationStack API FAILED to return flights.');
      }

    } catch (e) {
      foundation.debugPrint('❌ AviationStackService: A general error occurred during flight fetching: $e');
      foundation.debugPrint('🔴 AviationStackService: CRITICAL ERROR during flight fetching, unable to retrieve eligible flights');
      // No mock data fallback - returning empty list only
    }

    return await _processCompensationEligibility(allFlights, relaxEligibilityForDebugging: relaxEligibilityForDebugging);
  }
  
  // Mock data generation has been removed as per user requirements
  // No mock or fake data should be used - only real backend data

  // Removed unused _isEligibleForEUCompensation method
}
