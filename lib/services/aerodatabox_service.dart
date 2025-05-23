import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
    // Cloud server URL - deployed to PythonAnywhere for WiFi and mobile data access
    // This URL connects to the centralized database architecture
    const String cloudServerUrl = 'https://PiotrS.pythonanywhere.com';
    
    // IMPORTANT: We're using the cloud server for both debug and release modes
    // to ensure reliable API access on all devices
    return cloudServerUrl;
    
    // NOTE: The following local development URLs are disabled for now
    // to prevent connection issues. To use local development server,
    // uncomment the code below and comment out the "return cloudServerUrl" line above.
    
    /*
    // When app is in release mode, always use the cloud server
    if (!kDebugMode) return cloudServerUrl;
    
    // In debug mode, we can use different URLs for development
    
    // For web, use relative URL to avoid CORS issues
    if (kIsWeb) return '/api';
    
    // For Android emulator, use 10.0.2.2 which routes to host's localhost
    if (Platform.isAndroid) {
      try {
        if (Platform.environment.containsKey('ANDROID_EMU')) {
          return 'http://10.0.2.2:8001';
        }
      } catch (_) {}
    }
    
    // For iOS simulator, use localhost
    if (Platform.isIOS) {
      return 'http://localhost:8001';
    }
    
    // For physical devices during development, use the computer's local IP
    // This only works when on the same WiFi network
    return 'http://192.168.0.179:8001'; // Your computer's local IP
    */
  }
  
  /// Helper method to make HTTP requests with consistent error handling and timeout
  Future<http.Response> _makeRequest(Uri uri, {int? customTimeout}) async {
    debugPrint('Making API request to: $uri');
    try {
      // Increase timeout for EU-wide compensation endpoint which needs to check multiple airports
      int timeoutSeconds = customTimeout ?? 15;
      
      // Use a longer timeout for the EU compensation endpoint
      if (uri.path.contains('eu-compensation-eligible')) {
        timeoutSeconds = 60; // 60 second timeout for this specific endpoint
        debugPrint('Using extended timeout (60s) for EU compensation endpoint');
      }
      
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

  /// Fetch recent arrivals for a given airport ICAO code from your centralized database
  /// Returns a list of arrivals within the past [minutesBeforeNow]
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 120, // up to 720 (12h)
  }) async {
    // For the centralized database implementation, we'll use mock data from the database
    // since your PythonAnywhere service might not have a dedicated arrivals endpoint yet
    
    // First try to get data from the centralized flights database
    final uri = Uri.parse('$apiBaseUrl/flights');
    
    try {
      final response = await _makeRequest(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        
        if (jsonResp.containsKey('flights') && jsonResp['flights'] is List) {
          final rawFlights = List<Map<String, dynamic>>.from(jsonResp['flights']);
          
          // Filter flights for the requested airport
          final airportArrivals = rawFlights.where((flight) {
            // Check if this flight arrives at the requested airport
            return flight['arrival_airport'] == airportIcao;
          }).toList();
          
          // Transform to the format expected by UI components
          final arrivals = airportArrivals.map((flight) => {
            'flight': {
              'iata': flight['flight_number'],
              'icao': flight['flight_number'],
            },
            'departure': {
              'airport': {
                'iata': flight['departure_airport'],
              },
            },
            'arrival': {
              'airport': {
                'iata': flight['arrival_airport'],
              },
              'scheduledTime': {
                'local': flight['arrival_date'],
              },
              'actualTime': {
                'local': flight['arrival_date'],
              },
            },
            'status': flight['delay_minutes'] > 0 ? 'Delayed' : 'On Time',
            'airline': {
              'name': _getAirlineName(flight['airline']),
            },
            'delay': flight['delay_minutes'],
          }).toList();
          
          return arrivals;
        }
      }
      
      // If we can't get real data, return a limited set of mock data
      return _getMockArrivals(airportIcao);
      
    } catch (e) {
      debugPrint('Error fetching arrivals: $e');
      // Return mock data as fallback
      return _getMockArrivals(airportIcao);
    }
  }
  
  // Helper to get airline name from code
  String _getAirlineName(String? code) {
    if (code == null) return 'Unknown Airline';
    
    final airlineMap = {
      'LO': 'LOT Polish Airlines',
      'LH': 'Lufthansa',
      'BA': 'British Airways',
      'AF': 'Air France',
      'KL': 'KLM',
      'SK': 'SAS',
    };
    
    return airlineMap[code] ?? 'Unknown Airline';
  }
  
  // Mock data as fallback if centralized database doesn't have the requested data
  List<Map<String, dynamic>> _getMockArrivals(String airportIcao) {
    return [
      {
        'flight': {
          'iata': 'LO282',
          'icao': 'LOT282',
        },
        'departure': {
          'airport': {
            'iata': 'WAW',
          },
        },
        'arrival': {
          'airport': {
            'iata': airportIcao,
          },
          'scheduledTime': {
            'local': '2024-03-15T16:15:00',
          },
          'actualTime': {
            'local': '2024-03-15T19:15:00',
          },
        },
        'status': 'Delayed',
        'airline': {
          'name': 'LOT Polish Airlines',
        },
        'delay': 180,
      },
      {
        'flight': {
          'iata': 'LO379',
          'icao': 'LOT379',
        },
        'departure': {
          'airport': {
            'iata': 'WAW',
          },
        },
        'arrival': {
          'airport': {
            'iata': airportIcao,
          },
          'scheduledTime': {
            'local': '2024-04-20T10:30:00',
          },
          'actualTime': {
            'local': '2024-04-20T14:10:00',
          },
        },
        'status': 'Delayed',
        'airline': {
          'name': 'LOT Polish Airlines',
        },
        'delay': 220,
      }
    ];
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
      // First try to get data from the centralized database
      final compensationCheckUri = Uri.parse('$apiBaseUrl/compensation-check').replace(queryParameters: queryParams);
      final compResponse = await _makeRequest(compensationCheckUri);
      
      if (compResponse.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(compResponse.body);
        
        if (jsonResp.containsKey('flights') && jsonResp['flights'] is List && jsonResp['flights'].isNotEmpty) {
          final flight = (jsonResp['flights'] as List).first;
          
          return [
            {
              'flight': {
                'iata': flight['flight_number'],
                'icao': flight['flight_number'],
              },
              'departure': {
                'airport': {
                  'iata': flight['departure_airport'],
                },
                'scheduledTime': {
                  'local': flight['departure_date'],
                },
              },
              'arrival': {
                'airport': {
                  'iata': flight['arrival_airport'],
                },
                'scheduledTime': {
                  'local': flight['arrival_date'],
                },
              },
              'status': flight['delay_minutes'] > 0 ? 'Delayed' : 'On Time',
              'airline': {
                'name': _getAirlineName(flight['airline']),
              },
              'delay': flight['delay_minutes'],
            }
          ];
        }
      }
      
      // Fall back to default implementation if no data in centralized database
      final response = await _makeRequest(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        if (jsonResp.containsKey('flights')) {
          final flights = List<Map<String, dynamic>>.from(jsonResp['flights']);
          return flights;
        } else {
          return [];
        }
      } else {
        throw Exception('Backend API failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Return mock data as fallback
      return [
        {
          'flight': {
            'iata': flightNumber,
            'icao': flightNumber,
          },
          'departure': {
            'airport': {
              'iata': 'WAW',
            },
            'scheduledTime': {
              'local': date != null ? '${date}T14:30:00' : '2024-03-15T14:30:00',
            },
          },
          'arrival': {
            'airport': {
              'iata': 'LHR',
            },
            'scheduledTime': {
              'local': date != null ? '${date}T16:15:00' : '2024-03-15T16:15:00',
            },
          },
          'status': 'Delayed',
          'airline': {
            'name': flightNumber.startsWith('LO') ? 'LOT Polish Airlines' : 'Unknown Airline',
          },
          'delay': 180,
        }
      ];
    }
  }

  /// Check if a specific flight is eligible for EU261 compensation
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
    debugPrint('Checking compensation with centralized database at: $uri');
    
    try {
      final response = await _makeRequest(uri);
      debugPrint('Received response from centralized database with status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        debugPrint('Server response: ${jsonResp.toString()}');
        
        // Transform the centralized database response to the format expected by the app UI
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
        throw Exception('Backend API failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception in checkCompensationEligibility: $e');
      rethrow;
    }
  }

  /// Get EU-wide compensation eligible flights from the centralized database
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72, // Default to 72 hours for wider coverage
  }) async {
    // TEMPORARY FOR TESTING: Use local test data to test claim submission
    if (kDebugMode) {
      debugPrint('DEBUG MODE: Using local test flight data instead of API');
      try {
        // Load from assets bundle
        final jsonString = await rootBundle.loadString('assets/data/flight_compensation_data.json');
        final List<dynamic> jsonData = json.decode(jsonString);
        debugPrint('Found ${jsonData.length} flights in local test data');
        
        // Transform to the format expected by the UI
        final processedFlights = jsonData.map((flight) => {
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
            'isDelayedOver3Hours': true,
          }).toList();
        
        return List<Map<String, dynamic>>.from(processedFlights);
      } catch (e) {
        debugPrint('Error loading local test data: $e');
        // Continue to normal API logic if local data fails
      }
    }
    
    // Use the dedicated endpoint for EU compensation eligible flights
    final uri = Uri.parse('$apiBaseUrl/eu-compensation-eligible?hours=$hours');
    
    try {
      debugPrint('Fetching eligible flights from centralized database: $uri');
      // Use longer timeout for this endpoint since it processes more data
      final response = await _makeRequest(uri, customTimeout: 60); // 60-second timeout
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResp = json.decode(response.body);
        debugPrint('Response: ${jsonResp.toString().substring(0, min(200, jsonResp.toString().length))}...');
        
        // Process the flights from the centralized database
        if (jsonResp.containsKey('flights') && jsonResp['flights'] is List) {
          final rawFlights = jsonResp['flights'] as List;
          debugPrint('Received ${rawFlights.length} flights from centralized database');
          
          // Filter flights for those that are eligible for compensation
          final eligibleFlights = rawFlights.where((flight) => 
            flight['eligible_for_compensation'] == true
          ).toList();
          
          debugPrint('Found ${eligibleFlights.length} eligible flights in the centralized database');
          
          // Transform to the format expected by the UI
          final processedFlights = eligibleFlights.map((flight) => {
            'flightNumber': flight['flight_number'],
            'airline': flight['airline'] ?? 'Unknown',
            'departureAirport': flight['departure_airport'] ?? 'Unknown',
            'arrivalAirport': flight['arrival_airport'] ?? 'Unknown',
            'departureTime': flight['departure_date'],
            'arrivalTime': flight['arrival_date'],
            'status': 'Delayed',
            'delayMinutes': flight['delay_minutes'] ?? 0,
            'isEligibleForCompensation': true,
            'potentialCompensationAmount': flight['compensation_amount_eur'] ?? 0,
            'distance': flight['distance_km'] ?? 2000,
            'currency': 'EUR',
            'isDelayedOver3Hours': true,
          }).toList();
          
          // Even if no eligible flights, return an empty list instead of null
          return List<Map<String, dynamic>>.from(processedFlights);
        }
        
        // No eligible flights found
        return [];
      } else {
        debugPrint('Error response: ${response.body}');
        throw Exception('Backend API failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception in getEUCompensationEligibleFlights: $e');
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Connection timed out. The EU-wide search may take longer due to checking multiple airports.');
      }
      rethrow;
    }
  }
}
