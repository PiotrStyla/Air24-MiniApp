import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/claim.dart';
import 'opensky_api_service.dart';
import 'package:flutter/material.dart';

class ClaimValidationResult {
  final bool isValid;
  final List<String> errors;
  final Map<String, bool> checklistStatus;
  
  ClaimValidationResult({
    required this.isValid, 
    required this.errors, 
    this.checklistStatus = const {},
  });
}

class ClaimValidationService {
  // Deadline for EU261 claims in days (varies by country, using 2 years as default)
  static const int EU261_CLAIM_DEADLINE_DAYS = 730; // 2 years
  static List<String>? _iataCodes;

  /// Loads IATA codes from the local JSON file (singleton)
  static Future<List<String>> _loadIataCodes() async {
    if (_iataCodes != null) return _iataCodes!;
    final String jsonString = await rootBundle.loadString('lib/data/iata_codes.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _iataCodes = jsonList.map((e) => e['code'] as String).toList();
    return _iataCodes!;
  }

  /// Checks if the IATA code is valid
  static Future<bool> isValidIata(String code) async {
    final codes = await _loadIataCodes();
    return codes.contains(code.toUpperCase());
  }

  /// Checks if the claim is a duplicate (same user, flight number, date)
  static Future<bool> isDuplicateClaim(Claim claim, List<Claim> userClaims) async {
    return userClaims.any((c) =>
      c.flightNumber.toUpperCase() == claim.flightNumber.toUpperCase() &&
      c.flightDate == claim.flightDate
    );
  }

  /// Check if flight is still within the claim deadline period
  static bool isWithinClaimDeadline(DateTime flightDate) {
    final deadline = DateTime.now().subtract(Duration(days: EU261_CLAIM_DEADLINE_DAYS));
    return flightDate.isAfter(deadline);
  }

  /// Check if there are likely extraordinary circumstances for this flight
  /// This is a simplified check - in a real app, this would be more comprehensive
  static Future<bool> checkExtraordinaryCircumstances(String flightDate, String departureAirport) async {
    // In a real implementation, this would check against a database of:
    // - Major weather events
    // - Political unrest
    // - Security incidents
    // - Air traffic control strikes
    // - Other force majeure events
    // For this demo, we'll just return false (no extraordinary circumstances)
    return false;
  }

  /// Validate a single checklist item based on flight data
  static Future<bool> validateChecklistItem(String itemKey, Map<String, dynamic> flightData) async {
    switch(itemKey) {
      case 'flightDetails':
        return flightData['flight_number'] != null && 
               flightData['departure_airport'] != null && 
               flightData['arrival_airport'] != null;

      case 'delayOrCancellation':
        bool isDelayed = flightData['delay_minutes'] != null && flightData['delay_minutes'] >= 180;
        bool isCancelled = flightData['status'] != null && 
                          flightData['status'].toString().toLowerCase().contains('cancel');
        return isDelayed || isCancelled;

      case 'euEligibility':
        return flightData['eligible_for_compensation'] == true;

      case 'deadline':
        if (flightData['departure_date'] != null) {
          try {
            DateTime departureDate = DateTime.parse(flightData['departure_date'].toString());
            return isWithinClaimDeadline(departureDate);
          } catch (e) {
            debugPrint('Error parsing departure date: $e');
          }
        }
        return false;

      case 'noExtraordinaryCircumstances':
        if (flightData['departure_date'] != null && flightData['departure_airport'] != null) {
          return !await checkExtraordinaryCircumstances(
            flightData['departure_date'].toString(),
            flightData['departure_airport'].toString(),
          );
        }
        return false;

      default:
        return false;
    }
  }

  /// Validate entire checklist based on flight data
  static Future<Map<String, bool>> validateChecklist(Map<String, dynamic> flightData) async {
    Map<String, bool> results = {};
    
    // Standard items we can validate automatically
    final items = [
      'flightDetails',
      'delayOrCancellation',
      'euEligibility',
      'deadline',
      'noExtraordinaryCircumstances',
    ];
    
    for (String item in items) {
      results[item] = await validateChecklistItem(item, flightData);
    }
    
    return results;
  }

  /// Validates claim for IATA, date, and duplicate
  /// Optionally verifies flight existence using OpenSky API. ICAO codes required.
  static Future<bool> verifyFlightWithOpenSky({
    required String flightNumber,
    required String departureIcao,
    required DateTime flightDate,
    String? username,
    String? password,
  }) async {
    return await OpenSkyApiService.verifyFlight(
      flightNumber: flightNumber,
      departureIcao: departureIcao,
      flightDate: flightDate,
      username: username,
      password: password,
    );
  }

  /// Validates claim for IATA, date, duplicate, and optionally flight existence
  static Future<ClaimValidationResult> validateClaim(
    Claim claim,
    List<Claim> userClaims, {
    bool verifyWithOpenSky = false,
    String? openSkyUsername,
    String? openSkyPassword,
  }) async {
    List<String> errors = [];
    if (!await isValidIata(claim.departureAirport)) {
      errors.add('Invalid departure airport IATA code.');
    }
    if (!await isValidIata(claim.arrivalAirport)) {
      errors.add('Invalid arrival airport IATA code.');
    }
    if (claim.flightDate.isAfter(DateTime.now())) {
      errors.add('Flight date cannot be in the future.');
    }
    if (await isDuplicateClaim(claim, userClaims)) {
      errors.add('Duplicate claim for this flight already exists.');
    }
    if (verifyWithOpenSky && errors.isEmpty) {
      final found = await verifyFlightWithOpenSky(
        flightNumber: claim.flightNumber,
        departureIcao: claim.departureAirport,
        flightDate: claim.flightDate,
        username: openSkyUsername,
        password: openSkyPassword,
      );
      if (!found) {
        errors.add('Flight not found in OpenSky for the selected date and airport.');
      }
    }
    return ClaimValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}
