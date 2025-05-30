import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class for EU261 flight compensation claims
class CompensationClaim {
  final String id;
  final String userId;
  final String flightNumber;
  final String airline;
  final String departureAirport;
  final String arrivalAirport;
  final String departureDate;
  final String disruption; // Delay or cancellation
  final int compensationAmount;
  final String passengerName;
  final String passengerEmail;
  final String? passengerPhone;
  final String? bookingReference;
  final String? additionalInfo;
  final List<String> documentUrls;
  final String status; // "submitted", "in_review", "approved", "denied"
  final DateTime submittedAt;
  final DateTime? lastUpdatedAt;
  final Map<String, dynamic>? originalFlightData;

  CompensationClaim({
    required this.id,
    required this.userId,
    required this.flightNumber,
    required this.airline,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureDate,
    required this.disruption,
    required this.compensationAmount,
    required this.passengerName,
    required this.passengerEmail,
    this.passengerPhone,
    this.bookingReference,
    this.additionalInfo,
    required this.documentUrls,
    required this.status,
    required this.submittedAt,
    this.lastUpdatedAt,
    this.originalFlightData,
  });

  /// Create a new claim with a generated ID
  factory CompensationClaim.create({
    required String userId,
    required String flightNumber,
    required String airline,
    required String departureAirport,
    required String arrivalAirport,
    required String departureDate,
    required String disruption,
    required int compensationAmount,
    required String passengerName,
    required String passengerEmail,
    String? passengerPhone,
    String? bookingReference,
    String? additionalInfo,
    List<String> documentUrls = const [],
    Map<String, dynamic>? originalFlightData,
  }) {
    return CompensationClaim(
      id: FirebaseFirestore.instance.collection('claims').doc().id,
      userId: userId,
      flightNumber: flightNumber,
      airline: airline,
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      departureDate: departureDate,
      disruption: disruption,
      compensationAmount: compensationAmount,
      passengerName: passengerName,
      passengerEmail: passengerEmail,
      passengerPhone: passengerPhone,
      bookingReference: bookingReference,
      additionalInfo: additionalInfo,
      documentUrls: documentUrls,
      status: 'submitted',
      submittedAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
      originalFlightData: originalFlightData,
    );
  }

  /// Convert claim to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'flightNumber': flightNumber,
      'airline': airline,
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'departureDate': departureDate,
      'disruption': disruption,
      'compensationAmount': compensationAmount,
      'passengerName': passengerName,
      'passengerEmail': passengerEmail,
      'passengerPhone': passengerPhone,
      'bookingReference': bookingReference,
      'additionalInfo': additionalInfo,
      'documentUrls': documentUrls,
      'status': status,
      'submittedAt': FieldValue.serverTimestamp(),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
      'originalFlightData': originalFlightData,
    };
  }

  /// Create a claim from Firestore document
  factory CompensationClaim.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return CompensationClaim(
      id: doc.id,
      userId: data['userId'] ?? '',
      flightNumber: data['flightNumber'] ?? '',
      airline: data['airline'] ?? '',
      departureAirport: data['departureAirport'] ?? '',
      arrivalAirport: data['arrivalAirport'] ?? '',
      departureDate: data['departureDate'] ?? '',
      disruption: data['disruption'] ?? '',
      compensationAmount: data['compensationAmount'] ?? 0,
      passengerName: data['passengerName'] ?? '',
      passengerEmail: data['passengerEmail'] ?? '',
      passengerPhone: data['passengerPhone'],
      bookingReference: data['bookingReference'],
      additionalInfo: data['additionalInfo'],
      documentUrls: List<String>.from(data['documentUrls'] ?? []),
      status: data['status'] ?? 'submitted',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdatedAt: (data['lastUpdatedAt'] as Timestamp?)?.toDate(),
      originalFlightData: data['originalFlightData'],
    );
  }

  /// Create a copy of this claim with modified fields
  CompensationClaim copyWith({
    String? id,
    String? userId,
    String? flightNumber,
    String? airline,
    String? departureAirport,
    String? arrivalAirport,
    String? departureDate,
    String? disruption,
    int? compensationAmount,
    String? passengerName,
    String? passengerEmail,
    String? passengerPhone,
    String? bookingReference,
    String? additionalInfo,
    List<String>? documentUrls,
    String? status,
    DateTime? submittedAt,
    DateTime? lastUpdatedAt,
    Map<String, dynamic>? originalFlightData,
  }) {
    return CompensationClaim(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      departureDate: departureDate ?? this.departureDate,
      disruption: disruption ?? this.disruption,
      compensationAmount: compensationAmount ?? this.compensationAmount,
      passengerName: passengerName ?? this.passengerName,
      passengerEmail: passengerEmail ?? this.passengerEmail,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      bookingReference: bookingReference ?? this.bookingReference,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      documentUrls: documentUrls ?? this.documentUrls,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      originalFlightData: originalFlightData ?? this.originalFlightData,
    );
  }
}
