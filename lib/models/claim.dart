import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {
  final String id;
  final String userId;
  final String flightNumber;
  final DateTime flightDate;
  final String departureAirport;
  final String arrivalAirport;
  final String reason; // delay, cancellation, etc.
  final double? compensationAmount;
  final String status; // pending, approved, rejected

  Claim({
    required this.id,
    required this.userId,
    required this.flightNumber,
    required this.flightDate,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.reason,
    this.compensationAmount,
    required this.status,
  });

  Claim copyWith({
    String? id,
    String? userId,
    String? flightNumber,
    DateTime? flightDate,
    String? departureAirport,
    String? arrivalAirport,
    String? reason,
    double? compensationAmount,
    String? status,
  }) {
    return Claim(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flightNumber: flightNumber ?? this.flightNumber,
      flightDate: flightDate ?? this.flightDate,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      reason: reason ?? this.reason,
      compensationAmount: compensationAmount ?? this.compensationAmount,
      status: status ?? this.status,
    );
  }


  factory Claim.fromMap(Map<String, dynamic> data, String documentId) {
    return Claim(
      id: documentId,
      userId: data['userId'] ?? '',
      flightNumber: data['flightNumber'] ?? '',
      flightDate: (data['flightDate'] as Timestamp).toDate(),
      departureAirport: data['departureAirport'] ?? '',
      arrivalAirport: data['arrivalAirport'] ?? '',
      reason: data['reason'] ?? '',
      compensationAmount: data['compensationAmount'] != null
          ? (data['compensationAmount'] as num).toDouble()
          : null,
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'flightDate': Timestamp.fromDate(flightDate),
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'reason': reason,
      'compensationAmount': compensationAmount,
      'status': status,
    };
  }
}
