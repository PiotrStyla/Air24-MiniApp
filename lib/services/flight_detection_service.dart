import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import '../services/aerodatabox_service.dart';

class FlightDetectionService {
  static const double jumpThresholdKm = 150.0; // Minimum distance for a 'jump'
  static const int maxJumpDurationHours = 4;   // Max hours for a flight
  static const String airportDbAsset = 'assets/lib/data/iata_codes.json';

  Position? _lastPosition;
  DateTime? _lastTimestamp;

  /// Simulate a location jump for testing
  Future<void> simulateJump({
    required double fromLat,
    required double fromLon,
    required double toLat,
    required double toLon,
    required DateTime fromTime,
    required DateTime toTime,
    required void Function(DetectedFlight?) onFlightDetected,
    void Function(String errorMsg)? onError,
    void Function(int count)? onArrivalsFetched,
  }) async {
    _lastPosition = Position(
      latitude: fromLat,
      longitude: fromLon,
      timestamp: fromTime,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    _lastTimestamp = fromTime;
    // Simulate the jump by setting the new position and time
    final pos = Position(
      latitude: toLat,
      longitude: toLon,
      timestamp: toTime,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    final now = toTime;
    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude, _lastPosition!.longitude,
      pos.latitude, pos.longitude
    ) / 1000.0;
    final duration = now.difference(_lastTimestamp!).inHours;
    if (distance > jumpThresholdKm && duration < maxJumpDurationHours) {
      final depAirport = await _nearestAirport(_lastPosition!.latitude, _lastPosition!.longitude);
      final arrAirport = await _nearestAirport(pos.latitude, pos.longitude);
      if (depAirport == null) {
        if (onError != null) onError('Departure airport not found for simulated location.');
        return;
      }
      if (arrAirport == null) {
        if (onError != null) onError('Arrival airport not found for simulated location.');
        return;
      }
      String apiKey = '';
      try {
        apiKey = await rootBundle.loadString('assets/rapidapi_key.txt');
      } catch (e) {
        if (onError != null) onError('rapidapi_key.txt not found or unreadable: $e');
        return;
      }
      final aeroService = AeroDataBoxService();
      List<Map<String, dynamic>> arrivals = [];
      try {
        arrivals = await aeroService.getRecentArrivals(airportIcao: arrAirport.icao, minutesBeforeNow: 120);
      } catch (e) {
        if (onError != null) onError('AeroDataBox API error: $e');
        return;
      }
      if (onArrivalsFetched != null) onArrivalsFetched(arrivals.length);
      final nowUtc = now.toUtc();
      Map<String, dynamic>? bestMatch;
      Duration? bestTimeDiff;
      for (final flight in arrivals) {
        final movement = flight['movement'] ?? {};
        final scheduled = movement['scheduledTime'] ?? {};
        final depIcao = (movement['airport']?['icao'] ?? '').toString();
        final arrivalTimeStr = scheduled['utc'] ?? scheduled['local'];
        if (depIcao == depAirport.icao && arrivalTimeStr != null) {
          final arrivalTime = DateTime.tryParse(arrivalTimeStr);
          if (arrivalTime != null) {
            final diff = nowUtc.difference(arrivalTime).abs();
            if (bestTimeDiff == null || diff < bestTimeDiff) {
              bestTimeDiff = diff;
              bestMatch = flight;
            }
          }
        }
      }
      if (bestMatch != null) {
        onFlightDetected(DetectedFlight(
          flightData: bestMatch,
          departureAirport: depAirport,
          arrivalAirport: arrAirport,
        ));
      } else {
        onFlightDetected(null);
      }
    }
    _lastPosition = pos;
    _lastTimestamp = now;
  }

  /// Call this periodically or on location update
  Future<void> checkForFlightJump({
    required void Function(DetectedFlight?) onFlightDetected,
  }) async {
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final now = DateTime.now();
    if (_lastPosition != null && _lastTimestamp != null) {
      final distance = Geolocator.distanceBetween(
        _lastPosition!.latitude, _lastPosition!.longitude,
        pos.latitude, pos.longitude
      ) / 1000.0;
      final duration = now.difference(_lastTimestamp!).inHours;
      if (distance > jumpThresholdKm && duration < maxJumpDurationHours) {
        // Likely a flight!
        final depAirport = await _nearestAirport(_lastPosition!.latitude, _lastPosition!.longitude);
        final arrAirport = await _nearestAirport(pos.latitude, pos.longitude);
        if (depAirport != null && arrAirport != null) {
          // Fetch arrivals at arrival airport
          final apiKey = await File('rapidapi_key.txt').readAsString();
          final aeroService = AeroDataBoxService();
          final arrivals = await aeroService.getRecentArrivals(airportIcao: arrAirport.icao, minutesBeforeNow: 120);
          // Find best match: closest departure airport and arrival time
          final nowUtc = DateTime.now().toUtc();
          Map<String, dynamic>? bestMatch;
          Duration? bestTimeDiff;
          for (final flight in arrivals) {
            final movement = flight['movement'] ?? {};
            final scheduled = movement['scheduledTime'] ?? {};
            final depIcao = (movement['airport']?['icao'] ?? '').toString();
            final arrivalTimeStr = scheduled['utc'] ?? scheduled['local'];
            if (depIcao == depAirport.icao && arrivalTimeStr != null) {
              final arrivalTime = DateTime.tryParse(arrivalTimeStr);
              if (arrivalTime != null) {
                final diff = nowUtc.difference(arrivalTime).abs();
                if (bestTimeDiff == null || diff < bestTimeDiff) {
                  bestTimeDiff = diff;
                  bestMatch = flight;
                }
              }
            }
          }
          if (bestMatch != null) {
            onFlightDetected(DetectedFlight(
              flightData: bestMatch,
              departureAirport: depAirport,
              arrivalAirport: arrAirport,
            ));
          } else {
            onFlightDetected(null);
          }
        }
      }
    }
    _lastPosition = pos;
    _lastTimestamp = now;
  }

  Future<_AirportInfo?> _nearestAirport(double lat, double lon) async {
    print('[DEBUG] _nearestAirport called with lat=$lat, lon=$lon');
    String jsonStr;
    try {
      jsonStr = await rootBundle.loadString(airportDbAsset);
      print('[DEBUG] Loaded airport asset successfully');
    } catch (e) {
      print('[DEBUG] Failed to load airport asset: $e');
      return null;
    }
    final data = json.decode(jsonStr);
    print('[DEBUG] Parsed airport data: ${data.length} entries');
    _AirportInfo? nearest;
    double? minDist;
    for (final a in data) {
      final aLat = a['lat'];
      final aLon = a['lon'];
      if (aLat == null || aLon == null) continue;
      final dist = Geolocator.distanceBetween(lat, lon, aLat, aLon);
      print('[DEBUG] Checking airport ${a['icao'] ?? a['iata'] ?? a['name']} at ($aLat, $aLon), dist=$dist');
      if (minDist == null || dist < minDist) {
        minDist = dist;
        nearest = _AirportInfo(
          icao: a['icao'] ?? '',
          iata: a['iata'] ?? '',
          name: a['name'] ?? '',
          lat: aLat,
          lon: aLon,
        );
      }
    }
    if (nearest != null) {
      print('[DEBUG] Nearest airport: ${nearest.icao} (${nearest.name}) at distance $minDist');
    } else {
      print('[DEBUG] No airport found');
    }
    return nearest;
  }
}

class DetectedFlight {
  final Map<String, dynamic> flightData;
  final _AirportInfo departureAirport;
  final _AirportInfo arrivalAirport;
  DetectedFlight({required this.flightData, required this.departureAirport, required this.arrivalAirport});
}

class _AirportInfo {
  final String icao;
  final String iata;
  final String name;
  final double lat;
  final double lon;
  _AirportInfo({required this.icao, required this.iata, required this.name, required this.lat, required this.lon});
}
