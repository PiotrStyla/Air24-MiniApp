import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Service for working with EU airport data
/// This service provides methods to check if airports are in the EU
/// and supports the enhanced EU261 eligibility checking
class EUAirportService {
  static final EUAirportService _instance = EUAirportService._internal();
  
  // Singleton pattern
  factory EUAirportService() => _instance;
  
  EUAirportService._internal();
  
  // Cache for airport data
  Map<String, dynamic>? _airportData;
  Map<String, bool> _euAirportCache = {};
  List<String> _euCountries = [];
  
  /// Initialize the service by loading airport data
  Future<void> initialize() async {
    if (_airportData != null) return; // Already initialized
    
    try {
      // Load the airport data from the assets
      final jsonString = await rootBundle.loadString('assets/data/eu_airports.json');
      _airportData = json.decode(jsonString);
      
      // Cache EU countries for quicker checks
      if (_airportData!.containsKey('eu_countries')) {
        _euCountries = List<String>.from(_airportData!['eu_countries']);
      }
      
      // Pre-populate the cache with known EU airports
      if (_airportData!.containsKey('airports')) {
        final airports = _airportData!['airports'] as List;
        for (final airport in airports) {
          if (airport is Map && airport.containsKey('iata') && airport.containsKey('is_eu')) {
            final iata = airport['iata'].toString();
            final isEu = airport['is_eu'] as bool;
            _euAirportCache[iata] = isEu;
          }
        }
      }
      
      debugPrint('EU Airport Service initialized with ${_euAirportCache.length} airports');
    } catch (e) {
      debugPrint('Error initializing EU Airport Service: $e');
      // Create empty data structures as fallback
      _airportData = {};
      _euCountries = [];
    }
  }
  
  /// Check if an airport is in the EU based on its IATA code
  /// Returns true if the airport is confirmed to be in an EU country
  Future<bool> isAirportInEU(String iataCode) async {
    // Make sure we're initialized
    await initialize();
    
    // First check the cache
    if (_euAirportCache.containsKey(iataCode)) {
      return _euAirportCache[iataCode]!;
    }
    
    // If not in cache, check the full list
    if (_airportData != null && _airportData!.containsKey('airports')) {
      final airports = _airportData!['airports'] as List;
      for (final airport in airports) {
        if (airport is Map && 
            airport.containsKey('iata') && 
            airport['iata'] == iataCode) {
          
          final isEu = airport['is_eu'] as bool;
          // Add to cache for future lookups
          _euAirportCache[iataCode] = isEu;
          return isEu;
        }
      }
    }
    
    // If we don't have the airport in our database, return false to be safe
    return false;
  }
  
  /// Get a batch of airports to check in a single API call
  /// Prioritizes major hubs when processingLimit is specified
  List<String> getAirportBatch({int? processingLimit, List<String>? skipAirports}) {
    if (_airportData == null || !_airportData!.containsKey('airports')) {
      return [];
    }
    
    final airports = _airportData!['airports'] as List;
    final result = <String>[];
    final skipList = skipAirports ?? [];
    
    // Sort by passenger volume if we have a processing limit
    if (processingLimit != null) {
      final sortedAirports = List.from(airports);
      sortedAirports.sort((a, b) {
        final rankA = a['passenger_volume_rank'] as int? ?? 999;
        final rankB = b['passenger_volume_rank'] as int? ?? 999;
        return rankA.compareTo(rankB);
      });
      
      // Take top N airports not in skip list
      for (final airport in sortedAirports) {
        if (result.length >= processingLimit) break;
        
        final iata = airport['iata'].toString();
        if (!skipList.contains(iata)) {
          result.add(iata);
        }
      }
    } else {
      // No limit, return all airports not in skip list
      for (final airport in airports) {
        final iata = airport['iata'].toString();
        if (!skipList.contains(iata)) {
          result.add(iata);
        }
      }
    }
    
    return result;
  }
  
  /// Check if a country is in the EU
  bool isCountryInEU(String country) {
    return _euCountries.contains(country);
  }
  
  /// Get all EU airports
  List<Map<String, dynamic>> getAllEUAirports() {
    if (_airportData == null || !_airportData!.containsKey('airports')) {
      return [];
    }
    
    final airports = _airportData!['airports'] as List;
    return airports.where((airport) => 
      airport is Map && airport['is_eu'] == true
    ).cast<Map<String, dynamic>>().toList();
  }
  
  /// Get only major hub airports in the EU (for prioritized processing)
  List<Map<String, dynamic>> getMajorEUHubs() {
    if (_airportData == null || !_airportData!.containsKey('airports')) {
      return [];
    }
    
    final airports = _airportData!['airports'] as List;
    return airports.where((airport) => 
      airport is Map && 
      airport['is_eu'] == true && 
      airport['is_major_hub'] == true
    ).cast<Map<String, dynamic>>().toList();
  }
}
