import 'dart:convert';
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
  static Future<List<AirlineClaimProcedure>> loadProcedures() async {
    final String jsonString = await rootBundle.loadString('lib/data/airline_claim_procedures.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => AirlineClaimProcedure.fromJson(e)).toList();
  }

  static Future<AirlineClaimProcedure?> getProcedureByIata(String iata) async {
    final procedures = await loadProcedures();
    try {
      return procedures.firstWhere(
        (e) => e.iata.toUpperCase() == iata.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
