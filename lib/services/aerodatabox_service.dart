import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';

class AeroDataBoxService {
  // No API key needed for backend proxy
  final String apiBaseUrl;
  
  // Longer timeout for mobile devices with potentially slower connections
  static const int timeoutSeconds = 60; // Increased to 60 seconds
  
  AeroDataBoxService({
    // Default URL that works for most setups
    // - Use 10.0.2.2:8000 for Android emulator
    // - Use localhost:8000 for iOS simulator or web
    // - Use your actual IP address for physical devices
    String? baseUrl,
  }) : apiBaseUrl = baseUrl ?? _getDefaultApiBaseUrl();
  
  /// Automatically determine the best API base URL based on platform
  static String _getDefaultApiBaseUrl() {
    // For web, use relative URL to avoid CORS issues
    if (kIsWeb) return '/api';
    
    // For Android emulator, use 10.0.2.2 which routes to host's localhost
    if (Platform.isAndroid) {
      // Check if running on emulator (this is a heuristic, not foolproof)
      try {
        if (Platform.environment.containsKey('ANDROID_EMU')) {
          return 'http://10.0.2.2:8000';
        }
      } catch (_) {}
    }
    
    // For iOS simulator, use localhost
    if (Platform.isIOS) {
      return 'http://localhost:8000';
    }
    
    // For physical devices, use the computer's actual IP address
    // This IP address must be accessible from your device on the same network
    return 'http://192.168.0.179:8000'; // Your computer's actual IP address
  }
  
  /// Helper method to make API requests with consistent error handling and timeout
  Future<http.Response> _makeApiRequest(Uri uri) async {
    debugPrint('Making API request to: $uri');
    try {
      final response = await http.get(uri).timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          debugPrint('Request timed out after $timeoutSeconds seconds');
          throw TimeoutException('Connection timed out. Please check your network connection and server status.');
        },
      );
      
      debugPrint('Response status: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('Error during API request: $e');
      rethrow;
    }
  }

  /// Fetch recent arrivals for a given airport ICAO code from your FastAPI backend.
  /// Returns a list of arrivals within the past [minutesBeforeNow] (max 720 = 12h).
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 120, // up to 720 (12h)
  }) async {
    final url = Uri.parse('$apiBaseUrl/recent-arrivals?icao=$airportIcao');
    debugPrint('Request URL: $url');
    try {
      // Use the helper method with consistent timeout handling
      final response = await _makeApiRequest(url);
      
      debugPrint('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        // arrivals are in the 'arrivals' key
        if (jsonResp.containsKey('arrivals')) {
          final arrivals = List<Map<String, dynamic>>.from(jsonResp['arrivals']);
          debugPrint('Received ${arrivals.length} arrivals');
          return arrivals;
        } else if (jsonResp.containsKey('message')) {
          // Server returned a message but no arrivals
          debugPrint('Server message: ${jsonResp['message']}');
          return [];
        } else {
          debugPrint('No arrivals found in response');
          return [];
        }
      } else if (response.statusCode == 204) {
        // No content
        debugPrint('No content returned from server');
        return [];
      } else {
        debugPrint('Error response: ${response.body}');
        throw Exception('Backend API failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception in getRecentArrivals: $e');
      rethrow;
    }
  }
  
  /// Get flight status by flight number and optional date
  /// Returns flight details including delay information
  Future<List<Map<String, dynamic>>> getFlightStatus({
    required String flightNumber,
    String? date, // Optional date in YYYY-MM-DD format
  }) async {
    final queryParams = {
      'flight_number': flightNumber,
    };
    
    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }
    
    final uri = Uri.parse('$apiBaseUrl/flight-status').replace(queryParameters: queryParams);
    
    try {
      // Use the helper method with consistent timeout handling
      final response = await _makeApiRequest(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        if (jsonResp.containsKey('flights')) {
          final flights = List<Map<String, dynamic>>.from(jsonResp['flights']);
          debugPrint('Received ${flights.length} flights');
          return flights;
        } else {
          debugPrint('No flights found in response');
          return [];
        }
      } else {
        debugPrint('Error response: ${response.body}');
        throw Exception('Backend API failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception in getFlightStatus: $e');
      rethrow;
    }
  }
  
  // No mock data methods - using real API data only
  
  /// Check if a flight is eligible for EU261 compensation
  /// Returns compensation details including eligibility and potential amount
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date, // Optional date in YYYY-MM-DD format
  }) async {
    final queryParams = {
      'flight_number': flightNumber,
    };
    
    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }
    
    final uri = Uri.parse('$apiBaseUrl/compensation-check').replace(queryParameters: queryParams);
    
    try {
      final response = await _makeApiRequest(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        if (jsonResp.containsKey('results') && jsonResp['results'].isNotEmpty) {
          final results = List<Map<String, dynamic>>.from(jsonResp['results']);
          return results.first;
        } else {
          debugPrint('No compensation results found in response');
          return {
            'flightNumber': flightNumber,
            'isEligibleForCompensation': false,
            'message': 'No compensation data available for this flight',
          };
        }
      } else {
        debugPrint('Error response: ${response.body}');
        throw Exception('Backend API failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception in checkCompensationEligibility: $e');
      rethrow;
    }
  }
}
