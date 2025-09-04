import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;

class AirlineClaimProcedure {
  final String iata;
  final String name;
  final String claimEmail;
  final String claimFormUrl;
  final String instructions;
  final String? phone;
  final String? postalAddress;

  AirlineClaimProcedure({
    required this.iata,
    required this.name,
    required this.claimEmail,
    required this.claimFormUrl,
    required this.instructions,
    this.phone,
    this.postalAddress,
  });

  factory AirlineClaimProcedure.fromJson(Map<String, dynamic> json) {
    // Be tolerant to differing schemas and nulls
    final String iata = (json['iata'] ?? json['IATA'] ?? '').toString();
    final String name = (json['name'] ?? json['airline'] ?? json['Name'] ?? '').toString();
    final String claimEmail = (json['claim_email'] ?? json['email'] ?? '').toString();
    final String claimFormUrl = (json['claim_form_url'] ?? json['web_form'] ?? json['form_url'] ?? '').toString();
    final String instructions = (json['instructions'] ?? '').toString();
    final String? phone = json['phone']?.toString();
    final String? postalAddress = (json['postal_address'] ?? json['address'])?.toString();

    return AirlineClaimProcedure(
      iata: iata,
      name: name,
      claimEmail: claimEmail,
      claimFormUrl: claimFormUrl,
      instructions: instructions,
      phone: phone,
      postalAddress: postalAddress,
    );
  }
}

class AirlineProcedureService {
  static bool isInTestMode = false;

  static void setTestMode(bool isTesting) {
    isInTestMode = isTesting;
  }
  static Future<List<AirlineClaimProcedure>> loadProcedures() async {
    if (isInTestMode) {
      print('AirlineProcedureService: In test mode, returning mock procedures.');
      return Future.value([
        AirlineClaimProcedure(
          iata: 'BA',
          name: 'British Airways',
          claimEmail: 'claims@ba.com',
          claimFormUrl: 'https://ba.com/claims',
          instructions: 'Fill out the form at the provided URL.',
        )
      ]);
    }
    
    try {
      print('AirlineProcedureService: Attempting to load airline procedures from JSON file');
      final String jsonString = await rootBundle.loadString('lib/data/airline_claim_procedures.json');
      print('AirlineProcedureService: Successfully loaded JSON string, length: ${jsonString.length}');
      
      final List<dynamic> jsonList = json.decode(jsonString);
      print('AirlineProcedureService: Parsed JSON list with ${jsonList.length} items');
      
      // Debug: Print first few entries
      if (jsonList.isNotEmpty) {
        print('AirlineProcedureService: First item IATA: ${jsonList[0]['iata']}');
      }
      
      final procedures = jsonList.map((e) => AirlineClaimProcedure.fromJson(e)).toList();
      print('AirlineProcedureService: Created ${procedures.length} airline procedures');
      
      // Print all available IATA codes for debugging
      final iatas = procedures.map((p) => p.iata).toList();
      print('AirlineProcedureService: Available IATA codes: ${iatas.join(', ')}');
      
      return procedures;
    } catch (e, stackTrace) {
      print('AirlineProcedureService: Error loading procedures: $e');
      print('AirlineProcedureService: Stack trace: $stackTrace');
      
      // Return empty list on failure to avoid null errors
      return [];
    }
  }

  static Future<AirlineClaimProcedure?> getProcedureByIata(String iata) async {
    print('AirlineProcedureService: Looking for procedure with IATA code: "$iata"');
    
    if (iata.isEmpty) {
      print('AirlineProcedureService: IATA code is empty, cannot find matching airline');
      return null;
    }
    
    final procedures = await loadProcedures();
    
    if (procedures.isEmpty) {
      print('AirlineProcedureService: Procedures list is empty, check if JSON file was loaded correctly');
      return null;
    }
    
    print('AirlineProcedureService: Searching among ${procedures.length} procedures');
    
    // Case-insensitive search
    final normalized = iata.toUpperCase();
    final match = procedures.firstWhereOrNull((p) => p.iata.toUpperCase() == normalized);
    
    if (match != null) {
      print('AirlineProcedureService: Found match for "$iata": ${match.name} with email ${match.claimEmail}');
    } else {
      print('AirlineProcedureService: No match found for IATA code "$iata"');
      // Print a few examples of what we have for debugging
      if (procedures.length > 3) {
        print('AirlineProcedureService: Sample IATA codes in database: ${procedures.take(3).map((p) => p.iata).join(', ')}...');
      }
    }
    
    return match;
  }

  // Helper to normalize names for fuzzy matching
  static String _normalize(String value) {
    return value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  // Fallback: try to find airline by its human-readable name
  static Future<AirlineClaimProcedure?> getProcedureByName(String airlineName) async {
    print('AirlineProcedureService: Looking for procedure by airline NAME: "$airlineName"');

    if (airlineName.trim().isEmpty) {
      print('AirlineProcedureService: Airline name is empty, cannot find matching airline');
      return null;
    }

    final procedures = await loadProcedures();

    if (procedures.isEmpty) {
      print('AirlineProcedureService: Procedures list is empty, cannot match by name');
      return null;
    }

    final target = _normalize(airlineName);

    // 1) Exact normalized name match
    AirlineClaimProcedure? match =
        procedures.firstWhereOrNull((p) => _normalize(p.name) == target);

    // 2) Contains either way (handles prefixes/suffixes like "LOT Polish Airlines")
    match ??= procedures.firstWhereOrNull(
      (p) {
        final n = _normalize(p.name);
        return target.contains(n) || n.contains(target);
      },
    );

    if (match != null) {
      print('AirlineProcedureService: Found match by name: ${match.name} (${match.iata}) with email ${match.claimEmail}');
    } else {
      print('AirlineProcedureService: No match found by name for "$airlineName"');
    }

    return match;
  }
}
