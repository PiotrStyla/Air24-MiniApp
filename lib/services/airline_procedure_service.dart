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
    return AirlineClaimProcedure(
      iata: json['iata'],
      name: json['name'],
      claimEmail: json['claim_email'],
      claimFormUrl: json['claim_form_url'],
      instructions: json['instructions'],
      phone: json['phone'],
      postalAddress: json['postal_address'],
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
    final String jsonString = await rootBundle.loadString('lib/data/airline_claim_procedures.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => AirlineClaimProcedure.fromJson(e)).toList();
  }

  static Future<AirlineClaimProcedure?> getProcedureByIata(String iata) async {
    final procedures = await loadProcedures();
    // Use firstWhereOrNull for safety, especially in tests where the list might be empty.
    return procedures.firstWhereOrNull((p) => p.iata.toUpperCase() == iata.toUpperCase());
  }
}
