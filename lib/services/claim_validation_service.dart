import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/claim.dart';
import 'opensky_api_service.dart';

class ClaimValidationResult {
  final bool isValid;
  final List<String> errors;
  ClaimValidationResult({required this.isValid, required this.errors});
}

class ClaimValidationService {
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
