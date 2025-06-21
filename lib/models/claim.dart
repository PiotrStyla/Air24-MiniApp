import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {
  final String id;
  final String userId;
  final String flightNumber;
  final DateTime flightDate;
  final String departureAirport;
  final String arrivalAirport;
  final String reason;
  final double compensationAmount;
  final String status;
  final String bookingReference;

  Claim({
    required this.id,
    required this.userId,
    required this.flightNumber,
    required this.flightDate,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.reason,
    required this.compensationAmount,
    required this.status,
    required this.bookingReference,
  });

  factory Claim.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Claim(
      id: documentId,
      userId: data['userId'] as String,
      flightNumber: data['flightNumber'] as String,
      flightDate: (data['flightDate'] as Timestamp).toDate(),
      departureAirport: data['departureAirport'] as String,
      arrivalAirport: data['arrivalAirport'] as String,
      reason: data['reason'] as String,
      compensationAmount: (data['compensationAmount'] as num).toDouble(),
      status: data['status'] as String,
      bookingReference: data['bookingReference'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'flightDate': Timestamp.fromDate(flightDate),
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'reason': reason,
      'compensationAmount': compensationAmount,
      'status': status,
      'bookingReference': bookingReference,
    };
  }
}
