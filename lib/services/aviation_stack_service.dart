import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// AviationStack service for fetching flight data
/// This is the only flight data provider we should use in the app
class AviationStackService {
  // API configuration
  final String apiBaseUrl;
  
  // Longer timeout for potentially slower connections
  static const int timeoutSeconds = 60;
  
  AviationStackService({
    String? baseUrl,
  }) : apiBaseUrl = baseUrl ?? _getDefaultApiBaseUrl();
  
  /// Get the default API base URL
  static String _getDefaultApiBaseUrl() {
    // Cloud server URL with the AviationStack proxy
    const String cloudServerUrl = 'https://PiotrS.pythonanywhere.com';
    return cloudServerUrl;
  }
  
  /// Make a request to the API with extended timeout
  Future<http.Response> _makeRequest(Uri uri) async {
    debugPrint('Making API request to: $uri');
    debugPrint('Using extended timeout (${timeoutSeconds}s) for AviationStack endpoint');
    debugPrint('Cache-busting parameter: ${uri.queryParameters['_nocache']}');
    
    try {
      // Add explicit no-cache headers
      final headers = {
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
        'X-Requested-With': 'XMLHttpRequest',
      };
      
      debugPrint('Using cache-control headers: ${headers.toString()}');
      
      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('API request timed out after $timeoutSeconds seconds');
        },
      );
      
      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Response: ${response.body.substring(0, min(500, response.body.length))}...');
      } else {
        debugPrint('Error response: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Exception in API request: $e');
      rethrow;
    }
  }
  
  /// Get recent flight arrivals for an airport
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 360,
  }) async {
    // Add timestamp parameter to prevent caching
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    final uri = Uri.parse('$apiBaseUrl/arrivals')
        .replace(queryParameters: {
          'airport': airportIcao,
          'minutes': minutesBeforeNow.toString(),
          '_nocache': timestamp.toString(),
        });
    
    try {
      final response = await _makeRequest(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        
        if (jsonResp.containsKey('data') && jsonResp['data'] is List) {
          final flights = List<Map<String, dynamic>>.from(jsonResp['data']);
          return flights.map((flight) => _normalizeFlightData(flight)).toList();
        }
      }
      
      throw Exception('Failed to fetch arrivals: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error fetching arrivals: $e');
      rethrow;
    }
  }
  
  /// Get EU compensation eligible flights
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72, // Fixed at 72 hours
  }) async {
    // Always use real data from the API
    debugPrint('Attempting to load EU compensation eligible flights...');
    debugPrint('Fetching eligible flights with time filter: $hours hours');
    
    // Add a timestamp parameter to prevent caching
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    // Force debug print to show this is a fresh request
    debugPrint('=== FRESH REQUEST @ ${DateTime.now().toIso8601String()} ===');
    
    // Use the dedicated endpoint for EU compensation eligible flights
    final uri = Uri.parse('$apiBaseUrl/eu-compensation-eligible?hours=$hours&_nocache=$timestamp');
    
    try {
      debugPrint('Fetching eligible flights from AviationStack: $uri');
      final response = await _makeRequest(uri);
      
      if (response.statusCode == 200) {
        // Log full response body for debugging
        debugPrint('FULL RESPONSE: ${response.body}');
        
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        
        if (jsonResp.containsKey('flights')) {
          final flights = List<Map<String, dynamic>>.from(jsonResp['flights']);
          debugPrint('Received ${flights.length} flights from AviationStack');
          
          // Log flight data to help diagnose freshness issues
          for (final flight in flights) {
            debugPrint('FLIGHT DATA: ${flight['flight_number']} - ${flight['airline']} - ${flight['departure_date']}');
          }
          
          // Transform to standardized format expected by the UI
          return flights.map((flight) => {
            'flightNumber': flight['flight_number'],
            'airline': flight['airline'] ?? 'Unknown',
            'departureAirport': flight['departure_airport'] ?? 'Unknown',
            'arrivalAirport': flight['arrival_airport'] ?? 'Unknown',
            'departureTime': flight['departure_date'],
            'arrivalTime': flight['arrival_date'],
            'status': flight['status'] ?? 'Delayed',
            'delayMinutes': flight['delay_minutes'] ?? 0,
            'isEligibleForCompensation': true,
            'potentialCompensationAmount': flight['compensation_amount_eur'] ?? 0,
            'distance': flight['distance_km'] ?? 2000,
            'currency': 'EUR',
            'isDelayedOver3Hours': (flight['delay_minutes'] ?? 0) >= 180,
          }).toList();
        }
      }
      
      throw Exception('Failed to fetch eligible flights: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error fetching eligible flights: $e');
      rethrow;
    }
  }
  
  /// Check if a specific flight is eligible for EU261 compensation
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    // Build query parameters
    final queryParams = <String, String>{
      'flight_number': flightNumber,
      // Add timestamp parameter to prevent caching
      '_nocache': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    
    if (date != null) {
      queryParams['date'] = date;
    }

    final uri = Uri.parse('$apiBaseUrl/compensation-check').replace(queryParameters: queryParams);
    debugPrint('Checking compensation with AviationStack at: $uri');
    
    try {
      final response = await _makeRequest(uri);
      debugPrint('Received response from AviationStack with status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        debugPrint('Server response: ${jsonResp.toString()}');
        
        // Transform the response to the format expected by the app UI
        final transformedResponse = <String, dynamic>{};
        
        // Get the first flight from the response if available
        Map<String, dynamic>? flightData;
        if (jsonResp.containsKey('flights') && 
            jsonResp['flights'] is List && 
            (jsonResp['flights'] as List).isNotEmpty) {
          flightData = (jsonResp['flights'] as List).first;
        }
        
        // Map server response fields to UI expected fields
        transformedResponse['isEligibleForCompensation'] = jsonResp['eligible'] ?? false;
        transformedResponse['flightNumber'] = flightData?['flight_number'] ?? flightNumber;
        transformedResponse['airline'] = flightData?['airline'] ?? 'Unknown';
        transformedResponse['departureAirport'] = flightData?['departure_airport'] ?? 'Unknown';
        transformedResponse['arrivalAirport'] = flightData?['arrival_airport'] ?? 'Unknown';
        transformedResponse['delayMinutes'] = flightData?['delay_minutes'] ?? 0;
        transformedResponse['status'] = jsonResp['eligible'] ? 'Delayed' : 'On-time';
        transformedResponse['potentialCompensationAmount'] = flightData?['compensation_amount_eur'] ?? 0;
        transformedResponse['currency'] = 'EUR';
        transformedResponse['isDelayedOver3Hours'] = (flightData?['delay_minutes'] ?? 0) >= 180;
        transformedResponse['isUnderEuJurisdiction'] = true;
        
        debugPrint('Transformed for UI: ${transformedResponse.toString()}');
        return transformedResponse;
      } else {
        debugPrint('Error response: ${response.body}');
        throw Exception('API failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in checkCompensationEligibility: $e');
      rethrow;
    }
  }
  
  /// Normalize flight data to a consistent format
  Map<String, dynamic> _normalizeFlightData(Map<String, dynamic> flight) {
    // Extract relevant information and format it consistently
    final normalized = <String, dynamic>{
      'flightNumber': _extractFlightNumber(flight),
      'airline': _extractAirline(flight),
      'departureAirport': _extractDepartureAirport(flight),
      'arrivalAirport': _extractArrivalAirport(flight),
      'departureTime': _extractDepartureTime(flight),
      'arrivalTime': _extractArrivalTime(flight),
      'status': _extractStatus(flight),
      'delayMinutes': _extractDelayMinutes(flight),
    };
    
    return normalized;
  }
  
  // Helper methods to extract data from AviationStack response
  
  String _extractFlightNumber(Map<String, dynamic> flight) {
    if (flight.containsKey('flight') && flight['flight'] is Map) {
      return flight['flight']['iata'] ?? flight['flight']['icao'] ?? 'Unknown';
    }
    return flight['flight_number'] ?? flight['flightNumber'] ?? 'Unknown';
  }
  
  String _extractAirline(Map<String, dynamic> flight) {
    if (flight.containsKey('airline') && flight['airline'] is Map) {
      return flight['airline']['name'] ?? 'Unknown Airline';
    }
    return flight['airline'] ?? 'Unknown Airline';
  }
  
  String _extractDepartureAirport(Map<String, dynamic> flight) {
    if (flight.containsKey('departure') && flight['departure'] is Map) {
      final departure = flight['departure'];
      if (departure.containsKey('airport') && departure['airport'] is Map) {
        return departure['airport']['iata'] ?? departure['airport']['icao'] ?? 'Unknown';
      }
      return departure['iata'] ?? departure['icao'] ?? 'Unknown';
    }
    return flight['departure_airport'] ?? flight['departureAirport'] ?? 'Unknown';
  }
  
  String _extractArrivalAirport(Map<String, dynamic> flight) {
    if (flight.containsKey('arrival') && flight['arrival'] is Map) {
      final arrival = flight['arrival'];
      if (arrival.containsKey('airport') && arrival['airport'] is Map) {
        return arrival['airport']['iata'] ?? arrival['airport']['icao'] ?? 'Unknown';
      }
      return arrival['iata'] ?? arrival['icao'] ?? 'Unknown';
    }
    return flight['arrival_airport'] ?? flight['arrivalAirport'] ?? 'Unknown';
  }
  
  String _extractDepartureTime(Map<String, dynamic> flight) {
    if (flight.containsKey('departure') && flight['departure'] is Map) {
      final departure = flight['departure'];
      if (departure.containsKey('scheduled')) {
        return departure['scheduled'];
      }
      if (departure.containsKey('scheduledTime') && departure['scheduledTime'] is Map) {
        return departure['scheduledTime']['utc'] ?? departure['scheduledTime']['local'] ?? '';
      }
    }
    return flight['departure_date'] ?? flight['departureTime'] ?? '';
  }
  
  String _extractArrivalTime(Map<String, dynamic> flight) {
    if (flight.containsKey('arrival') && flight['arrival'] is Map) {
      final arrival = flight['arrival'];
      if (arrival.containsKey('scheduled')) {
        return arrival['scheduled'];
      }
      if (arrival.containsKey('scheduledTime') && arrival['scheduledTime'] is Map) {
        return arrival['scheduledTime']['utc'] ?? arrival['scheduledTime']['local'] ?? '';
      }
    }
    return flight['arrival_date'] ?? flight['arrivalTime'] ?? '';
  }
  
  String _extractStatus(Map<String, dynamic> flight) {
    return flight['status'] ?? 'Unknown';
  }
  
  int _extractDelayMinutes(Map<String, dynamic> flight) {
    if (flight.containsKey('delay_minutes')) {
      return flight['delay_minutes'] ?? 0;
    }
    if (flight.containsKey('delay')) {
      return flight['delay'] ?? 0;
    }
    return 0;
  }
  
  /// Helper method to get minimum of two values
  int min(int a, int b) => a < b ? a : b;
}
