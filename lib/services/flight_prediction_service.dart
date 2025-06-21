import 'dart:convert';

import 'dart:math';
import 'package:flutter/foundation.dart';

/// Service for predicting flight delays based on historical data
class FlightPredictionService {
  final Map<String, Map<String, dynamic>> _predictionCache = {};

  FlightPredictionService();

  /// Get delay prediction for a specific flight route
  Future<Map<String, dynamic>> getDelayPrediction({
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

      final cacheResult = _getFromCache(cacheKey);
      if (cacheResult != null) {
        debugPrint('Using cached flight prediction data');
        return cacheResult;
      }

      // If not in cache, fetch from historical data
      return _fetchPredictionFromHistoricalData(
        cacheKey: cacheKey,
        flightDate: flightDate,
      );
    } catch (e) {
      debugPrint('Error getting flight delay prediction: $e');
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

  /// Get prediction from cache if available and not expired
  Map<String, dynamic>? _getFromCache(String cacheKey) {
    if (_predictionCache.containsKey(cacheKey)) {
      final cachedData = _predictionCache[cacheKey]!;
      final cacheTimestamp = DateTime.parse(cachedData['timestamp'] as String);
      if (DateTime.now().difference(cacheTimestamp).inHours <= 24) {
        return cachedData['prediction'] as Map<String, dynamic>;
      }
    }
    return null;
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
  Map<String, dynamic> _fetchPredictionFromHistoricalData({
    required String cacheKey,
    required DateTime flightDate,
  }) {
    try {
      final historicalData = _getMockHistoricalData(cacheKey);

      final dayOfWeek = flightDate.weekday; // 1 = Monday, 7 = Sunday
      final month = flightDate.month;

      int totalFlightsOnSimilarDay = 0;
      int totalDelayedFlights = 0;
      int cumulativeDelayMinutes = 0;

      for (final flight in historicalData) {
        final flightDayOfWeek = flight['dayOfWeek'] as int;
        final flightMonth = flight['month'] as int;

        if (flightDayOfWeek == dayOfWeek && flightMonth == month) {
          totalFlightsOnSimilarDay++;
          final delayMinutes = flight['delayMinutes'] as int? ?? 0;
          if (delayMinutes > 15) {
            totalDelayedFlights++;
            cumulativeDelayMinutes += delayMinutes;
          }
        }
      }

      double delayRiskPercentage = 0;
      double averageDelay = 0;

      if (totalFlightsOnSimilarDay > 0) {
        delayRiskPercentage = (totalDelayedFlights / totalFlightsOnSimilarDay) * 100;
        if (totalDelayedFlights > 0) {
          averageDelay = cumulativeDelayMinutes / totalDelayedFlights;
        }
      }

      final compensationEligible = averageDelay >= 180; // 3 hours or more

      final prediction = {
        'hasDelayRisk': delayRiskPercentage > 25,
        'delayRiskPercentage': delayRiskPercentage.round(),
        'averageDelay': averageDelay.round(),
        'historicalDataPoints': totalFlightsOnSimilarDay,
        'compensationEligible': compensationEligible,
      };

      _saveToCache(cacheKey, prediction);

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

  /// Generate mock historical data for a route
  List<Map<String, dynamic>> _getMockHistoricalData(String routeKey) {
    final random = Random(routeKey.hashCode);
    return List.generate(50, (index) {
      final month = random.nextInt(12) + 1;
      final dayOfWeek = random.nextInt(7) + 1;
      final delay = (random.nextDouble() < 0.2) ? random.nextInt(240) : 0;

      return {
        'month': month,
        'dayOfWeek': dayOfWeek,
        'delayMinutes': delay,
      };
    });
  }

  /// Save prediction to in-memory cache
  void _saveToCache(String cacheKey, Map<String, dynamic> prediction) {
    _predictionCache[cacheKey] = {
      'prediction': prediction,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
