  /// Checks if a specific flight is eligible for EU compensation
  /// 
  /// [flightNumber] - The flight number to check (e.g., 'LH123')
  /// [date] - Optional date string in YYYY-MM-DD format for checking historical flights
  /// 
  /// Returns a map with eligibility information including:
  /// - isEligible: Whether the flight is eligible for compensation
  /// - reason: The reason for eligibility or ineligibility
  /// - compensation: The estimated compensation amount (if eligible)
  /// - flightData: The normalized flight data
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    foundation.debugPrint('🔍 AviationStackService: Checking compensation eligibility for flight $flightNumber on ${date ?? "today"}');
    
    try {
      // First try to get data from Python backend
      if (_usingPythonBackend && pythonBackendUrl != null) {
        String endpoint = '/flight_eligibility?flight_number=$flightNumber';
        if (date != null) {
          endpoint = '$endpoint&date=$date';
        }
        
        try {
          final backendData = await _fetchFromPythonBackend(endpoint);
          if (backendData.isNotEmpty && backendData.containsKey('isEligible')) {
            foundation.debugPrint('✅ AviationStackService: Received eligibility data from Python backend');
            return backendData;
          }
        } catch (e) {
          foundation.debugPrint('⚠️ AviationStackService: Error fetching eligibility from Python backend: $e');
        }
      }
      
      // If Python backend fails or is not used, try direct API
      // Get flight data from AviationStack API
      String url = '$baseUrl/flights?access_key=$_apiKey&flight_number=$flightNumber';
      
      // If date is provided, add it to the query
      if (date != null) {
        // Format date for API (API requires YYYY-MM-DD format)
        url += '&date=$date';
      }
      
      final response = await http.get(Uri.parse(url)).timeout(_apiTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final flights = _tryProcessFlightsData(data);
        
        if (flights.isEmpty) {
          return {
            'isEligible': false,
            'reason': 'Flight not found',
            'flightData': null,
          };
        }
        
        // Process the first matching flight (most relevant)
        final flight = flights.first;
        final eligibilityResult = _isEligibleForEUCompensation(flight);
        
        foundation.debugPrint('✅ AviationStackService: Successfully checked eligibility for flight $flightNumber');
        return {
          'isEligible': eligibilityResult['isEligible'],
          'reason': eligibilityResult['reason'],
          'compensation': eligibilityResult['compensation'],
          'flightData': flight,
        };
      } else {
        throw Exception('Failed to fetch flight data: ${response.statusCode}');
      }
    } catch (e) {
      foundation.debugPrint('❌ AviationStackService: Error checking eligibility: $e');
      
      // Fallback to mock data in case of error
      final mockFlight = _getMockFlightData(flightNumber);
      final eligibilityResult = _isEligibleForEUCompensation(mockFlight);
      
      foundation.debugPrint('⚠️ AviationStackService: Using mock data for eligibility check');
      return {
        'isEligible': eligibilityResult['isEligible'],
        'reason': eligibilityResult['reason'],
        'compensation': eligibilityResult['compensation'],
        'flightData': mockFlight,
      };
    }
  }
