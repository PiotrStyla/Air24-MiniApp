import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {
  final String id;
  final String claimId; // Human-readable ID for emails (e.g., "FC-2025-001")
  final String userId;
  final String flightNumber;
  final String airlineName;
  final DateTime flightDate;
  final String departureAirport;
  final String arrivalAirport;
  final String reason;
  final double compensationAmount;
  final String status;
  final String bookingReference;
  final List<String> attachmentUrls;

  Claim({
    required this.id,
    this.claimId = '', // Will be generated during submission
    required this.userId,
    required this.airlineName,
    required this.flightNumber,
    required this.flightDate,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.reason,
    required this.compensationAmount,
    required this.status,
    required this.bookingReference,
    this.attachmentUrls = const [],
  });

  factory Claim.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Claim(
      id: documentId,
      claimId: data['claimId'] as String? ?? documentId, // Fallback to document ID for old claims
      userId: data['userId'] as String,
      flightNumber: data['flightNumber'] as String,
      airlineName: data['airlineName'] as String? ?? '',
      flightDate: (data['flightDate'] as Timestamp).toDate(),
      departureAirport: data['departureAirport'] as String,
      arrivalAirport: data['arrivalAirport'] as String,
      reason: data['reason'] as String,
      compensationAmount: (data['compensationAmount'] as num).toDouble(),
      status: data['status'] as String,
      bookingReference: data['bookingReference'] as String,
      attachmentUrls: List<String>.from(data['attachmentUrls'] ?? []),
    );
  }

  Claim copyWith({
    String? id,
    String? claimId,
    String? userId,
    String? flightNumber,
    String? airlineName,
    DateTime? flightDate,
    String? departureAirport,
    String? arrivalAirport,
    String? reason,
    double? compensationAmount,
    String? status,
    String? bookingReference,
    List<String>? attachmentUrls,
  }) {
    return Claim(
      id: id ?? this.id,
      claimId: claimId ?? this.claimId,
      userId: userId ?? this.userId,
      flightNumber: flightNumber ?? this.flightNumber,
      airlineName: airlineName ?? this.airlineName,
      flightDate: flightDate ?? this.flightDate,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      reason: reason ?? this.reason,
      compensationAmount: compensationAmount ?? this.compensationAmount,
      status: status ?? this.status,
      bookingReference: bookingReference ?? this.bookingReference,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'claimId': claimId,
      'userId': userId,
      'flightNumber': flightNumber,
      'airlineName': airlineName,
      'flightDate': Timestamp.fromDate(flightDate),
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'reason': reason,
      'compensationAmount': compensationAmount,
      'status': status,
      'bookingReference': bookingReference,
      'attachmentUrls': attachmentUrls,
    };
  }
}
