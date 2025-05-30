import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service for predicting flight delays based on historical data
class FlightPredictionService {
  final FirebaseFirestore _firestore;
  final String _apiBaseUrl = 'https://api.flightpredictions.com'; // Replace with actual API URL
  
  FlightPredictionService({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Get delay prediction for a specific flight route
  Future<Map<String, dynamic>> getDelayPrediction({
    required String airline,
    required String flightNumber,
    required String departureAirport,
    required String arrivalAirport,
    required DateTime flightDate,
  }) async {
    try {
      // First try to get from cache
      final cacheResult = await _getFromCache(
        airline: airline,
        flightNumber: flightNumber,
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
        flightDate: flightDate,
      );
      
      if (cacheResult != null) {
        debugPrint('Using cached flight prediction data');
        return cacheResult;
      }
      
      // If not in cache, fetch from historical data
      return await _fetchPredictionFromHistoricalData(
        airline: airline,
        flightNumber: flightNumber,
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
        flightDate: flightDate,
      );
    } catch (e) {
      debugPrint('Error getting flight delay prediction: $e');
      return {
        'hasDelayRisk': false,
        'delayRiskPercentage': 0,
        'averageDelay': 0,
        'historicalData': [],
        'compensationEligible': false,
        'error': e.toString(),
      };
    }
  }
  
  /// Get prediction from cache if available and not expired
  Future<Map<String, dynamic>?> _getFromCache({
    required String airline,
    required String flightNumber,
    required String departureAirport,
    required String arrivalAirport,
    required DateTime flightDate,
  }) async {
    try {
      final cacheKey = _generateCacheKey(
        airline: airline,
        flightNumber: flightNumber,
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
      );
      
      final doc = await _firestore
          .collection('prediction_cache')
          .doc(cacheKey)
          .get();
      
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      final cacheTimestamp = data['timestamp'] as Timestamp;
      final now = DateTime.now();
      
      // Cache expires after 24 hours
      if (now.difference(cacheTimestamp.toDate()).inHours > 24) {
        return null;
      }
      
      return data['prediction'] as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error fetching from cache: $e');
      return null;
    }
  }
  
  /// Generate cache key for predictions
  String _generateCacheKey({
    required String airline,
    required String flightNumber,
    required String departureAirport,
    required String arrivalAirport,
  }) {
    return '$airline-$flightNumber-$departureAirport-$arrivalAirport'.toLowerCase();
  }
  
  /// Fetch prediction from historical flight data
  Future<Map<String, dynamic>> _fetchPredictionFromHistoricalData({
    required String airline,
    required String flightNumber,
    required String departureAirport,
    required String arrivalAirport,
    required DateTime flightDate,
  }) async {
    try {
      // In a real application, this would call a prediction API
      // For now, we'll simulate this with a mix of historical data and firestore
      
      // 1. Get historical data for this route
      final routeKey = _generateCacheKey(
        airline: airline,
        flightNumber: flightNumber,
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
      );
      
      final historicalData = await _getHistoricalRouteData(routeKey);
      
      // 2. Calculate metrics
      final dayOfWeek = flightDate.weekday;  // 1 = Monday, 7 = Sunday
      final month = flightDate.month;
      
      // Extract relevant metrics
      int totalFlightsOnSimilarDay = 0;
      int totalDelayedFlights = 0;
      int cumulativeDelayMinutes = 0;
      
      for (final flight in historicalData) {
        final flightDayOfWeek = flight['dayOfWeek'] as int;
        final flightMonth = flight['month'] as int;
        
        // Count flights on the same day of week in same month
        if (flightDayOfWeek == dayOfWeek && flightMonth == month) {
          totalFlightsOnSimilarDay++;
          
          final delayMinutes = flight['delayMinutes'] as int? ?? 0;
          if (delayMinutes > 15) {  // Consider as delayed if more than 15 mins
            totalDelayedFlights++;
            cumulativeDelayMinutes += delayMinutes;
          }
        }
      }
      
      // Calculate risk and average delay
      double delayRiskPercentage = 0;
      double averageDelay = 0;
      
      if (totalFlightsOnSimilarDay > 0) {
        delayRiskPercentage = (totalDelayedFlights / totalFlightsOnSimilarDay) * 100;
        
        if (totalDelayedFlights > 0) {
          averageDelay = cumulativeDelayMinutes / totalDelayedFlights;
        }
      }
      
      // Determine if delay is substantial enough for possible compensation
      final compensationEligible = averageDelay >= 180;  // 3 hours or more
      
      // Create prediction result
      final prediction = {
        'hasDelayRisk': delayRiskPercentage > 25,  // Consider risky if >25% chance
        'delayRiskPercentage': delayRiskPercentage.round(),
        'averageDelay': averageDelay.round(),
        'historicalDataPoints': totalFlightsOnSimilarDay,
        'compensationEligible': compensationEligible,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // Save to cache
      await _saveToCache(routeKey, prediction);
      
      return prediction;
    } catch (e) {
      debugPrint('Error fetching prediction data: $e');
      return {
        'hasDelayRisk': false,
        'delayRiskPercentage': 0,
        'averageDelay': 0,
        'historicalDataPoints': 0,
        'compensationEligible': false,
        'error': e.toString(),
      };
    }
  }
  
  /// Get historical data for a specific route
  Future<List<Map<String, dynamic>>> _getHistoricalRouteData(String routeKey) async {
    try {
      // In a production app, this would use a real flight history API
      // For now, we'll check if we have data in Firestore, otherwise generate mock data
      
      final doc = await _firestore
          .collection('flight_history')
          .doc(routeKey)
          .get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['history'] ?? []);
      }
      
      // If no history exists, fetch from API or generate sample data
      final historical = await _fetchHistoricalDataFromApi(routeKey);
      
      // Save historical data to Firestore for future use
      await _firestore
          .collection('flight_history')
          .doc(routeKey)
          .set({
            'history': historical,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
      
      return historical;
    } catch (e) {
      debugPrint('Error fetching historical route data: $e');
      return [];
    }
  }
  
  /// Fetch historical data from external API
  Future<List<Map<String, dynamic>>> _fetchHistoricalDataFromApi(String routeKey) async {
    try {
      // In a real app, this would call an actual API
      // For demonstration, we'll generate data based on the route key
      // This ensures consistent but varied data for different routes
      
      // Use route key to generate a predictable but varied seed
      final seed = routeKey.codeUnits.fold<int>(0, (prev, element) => prev + element);
      
      // Generate 100 historical flight entries
      final List<Map<String, dynamic>> historicalData = [];
      
      for (int i = 0; i < 100; i++) {
        final dayOfWeek = 1 + ((seed + i) % 7);  // 1-7 for Monday-Sunday
        final month = 1 + ((seed + i) % 12);  // 1-12 for Jan-Dec
        
        // Create varied delay patterns based on day/month/seed
        int delayMinutes = 0;
        
        // More delays on weekends and holiday months (July, December)
        if (dayOfWeek >= 6 || month == 7 || month == 12) {
          delayMinutes = (seed + i * 7) % 240;  // 0-239 minutes
        } else {
          delayMinutes = (seed + i * 3) % 120;  // 0-119 minutes
        }
        
        // Add some canceled flights (negative delay)
        if (i % 20 == 0) {  // 5% cancellation rate
          delayMinutes = -1;  // Use -1 to indicate cancellation
        }
        
        historicalData.add({
          'flightDate': DateTime.now().subtract(Duration(days: 1 + i)).toIso8601String(),
          'dayOfWeek': dayOfWeek,
          'month': month,
          'delayMinutes': delayMinutes,
          'canceled': delayMinutes < 0,
        });
      }
      
      return historicalData;
    } catch (e) {
      debugPrint('Error fetching from API: $e');
      return [];
    }
  }
  
  /// Save prediction to cache
  Future<void> _saveToCache(String cacheKey, Map<String, dynamic> prediction) async {
    try {
      await _firestore
          .collection('prediction_cache')
          .doc(cacheKey)
          .set({
            'prediction': prediction,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('Error saving prediction to cache: $e');
    }
  }
}
