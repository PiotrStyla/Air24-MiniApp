class UserProfile {
  final String uid;               // Firebase UID
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? passportNumber;
  final String? nationality;
  final DateTime? dateOfBirth;
  final String? addressLine;
  final String? city;
  final String? postalCode;
  final String? country;
  final bool consentToShareData;
  final bool consentToNotifications;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.passportNumber,
    this.nationality,
    this.dateOfBirth,
    this.addressLine,
    this.city,
    this.postalCode,
    this.country,
    required this.consentToShareData,
    required this.consentToNotifications,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      passportNumber: map['passportNumber'],
      nationality: map['nationality'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.tryParse(map['dateOfBirth'])
          : null,
      addressLine: map['addressLine'],
      city: map['city'],
      postalCode: map['postalCode'],
      country: map['country'],
      consentToShareData: map['consentToShareData'] ?? false,
      consentToNotifications: map['consentToNotifications'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'passportNumber': passportNumber,
      'nationality': nationality,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'addressLine': addressLine,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'consentToShareData': consentToShareData,
      'consentToNotifications': consentToNotifications,
    };
  }
}
