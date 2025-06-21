

/// Model class for tracking compensation claim submissions
class CompensationClaimSubmission {
  final String id;
  final String userId;
  final String flightNumber;
  final String airline;
  final String departureAirport;
  final String arrivalAirport;
  final String departureDate;
  final String passengerName;
  final String passengerEmail;
  final String? bookingReference;
  final String? additionalInfo;
  final int delayMinutes;
  final double compensationAmount;
  final String status;
  final bool hasAllDocuments;
  final List<String> completedChecklistItems;
  final List<String> documentIds; // IDs of attached flight documents
  final DateTime createdAt;
  final DateTime? updatedAt;

  CompensationClaimSubmission({
    required this.id,
    required this.userId,
    required this.flightNumber,
    required this.airline,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureDate,
    required this.passengerName,
    required this.passengerEmail,
    this.bookingReference,
    this.additionalInfo,
    required this.delayMinutes,
    required this.compensationAmount,
    required this.status,
    required this.hasAllDocuments,
    required this.completedChecklistItems,
    this.documentIds = const [], // Default to empty list if not provided
    required this.createdAt,
    this.updatedAt,
  });

  /// Create from form data and flight data
  static CompensationClaimSubmission fromFormData({
    required String userId,
    required Map<String, dynamic> formData,
    required Map<String, dynamic> flightData,
    required List<String> completedChecklistItems,
    required bool hasAllDocuments,
    List<String> documentIds = const [],
  }) {
    // Extract delay minutes from form or flight data
    int delayMinutes = 0;
    if (flightData['delay_minutes'] != null) {
      delayMinutes = flightData['delay_minutes'] is int
          ? flightData['delay_minutes']
          : int.tryParse(flightData['delay_minutes'].toString()) ?? 0;
    }

    // Extract compensation amount from form or flight data
    double compensationAmount = 0.0;
    if (flightData['compensation_amount_eur'] != null) {
      compensationAmount = flightData['compensation_amount_eur'] is double
          ? flightData['compensation_amount_eur']
          : double.tryParse(
                  flightData['compensation_amount_eur'].toString().replaceAll('€', '')) ??
              0.0;
    }

    return CompensationClaimSubmission(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      flightNumber: formData['flightNumber'] ?? flightData['flight_number'] ?? '',
      airline: formData['airline'] ?? flightData['airline'] ?? '',
      departureAirport:
          formData['departureAirport'] ?? flightData['departure_airport'] ?? '',
      arrivalAirport: formData['arrivalAirport'] ?? flightData['arrival_airport'] ?? '',
      departureDate: formData['departureDate'] ?? flightData['departure_date'] ?? '',
      passengerName: formData['passengerName'] ?? '',
      passengerEmail: formData['passengerEmail'] ?? '',
      bookingReference: formData['bookingReference'],
      additionalInfo: formData['additionalInfo'],
      delayMinutes: delayMinutes,
      compensationAmount: compensationAmount,
      status: 'Submitted', // Initial status
      hasAllDocuments: hasAllDocuments,
      completedChecklistItems: completedChecklistItems,
      documentIds: documentIds, // Include attached document IDs
      createdAt: DateTime.now(),
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'airline': airline,
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'departureDate': departureDate,
      'passengerName': passengerName,
      'passengerEmail': passengerEmail,
      'bookingReference': bookingReference,
      'additionalInfo': additionalInfo,
      'delayMinutes': delayMinutes,
      'compensationAmount': compensationAmount,
      'status': status,
      'hasAllDocuments': hasAllDocuments,
      'completedChecklistItems': completedChecklistItems,
      'documentIds': documentIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from a map structure
  factory CompensationClaimSubmission.fromMap(Map<String, dynamic> data, String id) {
    return CompensationClaimSubmission(
      id: id,
      userId: data['userId'] ?? '',
      flightNumber: data['flightNumber'] ?? '',
      airline: data['airline'] ?? '',
      departureAirport: data['departureAirport'] ?? '',
      arrivalAirport: data['arrivalAirport'] ?? '',
      departureDate: data['departureDate'] ?? '',
      passengerName: data['passengerName'] ?? '',
      passengerEmail: data['passengerEmail'] ?? '',
      bookingReference: data['bookingReference'],
      additionalInfo: data['additionalInfo'],
      delayMinutes: data['delayMinutes'] ?? 0,
      compensationAmount: (data['compensationAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'Submitted',
      hasAllDocuments: data['hasAllDocuments'] ?? false,
      completedChecklistItems: List<String>.from(data['completedChecklistItems'] ?? []),
      documentIds: List<String>.from(data['documentIds'] ?? []),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  /// Create a copy with updated fields
  CompensationClaimSubmission copyWith({
    String? id,
    String? userId,
    String? flightNumber,
    String? airline,
    String? departureAirport,
    String? arrivalAirport,
    String? departureDate,
    String? passengerName,
    String? passengerEmail,
    String? bookingReference,
    String? additionalInfo,
    int? delayMinutes,
    double? compensationAmount,
    String? status,
    bool? hasAllDocuments,
    List<String>? completedChecklistItems,
    List<String>? documentIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompensationClaimSubmission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      departureDate: departureDate ?? this.departureDate,
      passengerName: passengerName ?? this.passengerName,
      passengerEmail: passengerEmail ?? this.passengerEmail,
      bookingReference: bookingReference ?? this.bookingReference,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      compensationAmount: compensationAmount ?? this.compensationAmount,
      status: status ?? this.status,
      hasAllDocuments: hasAllDocuments ?? this.hasAllDocuments,
      completedChecklistItems: completedChecklistItems ?? this.completedChecklistItems,
      documentIds: documentIds ?? this.documentIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt ?? DateTime.now(),
    );
  }
}
