// Simple donation models without json_serializable for immediate testing

/// Payment method options for donations
enum PaymentMethod {
  card,
  paypal,
  applePay,
  googlePay,
}

/// Status of a donation
enum DonationStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}

/// Predefined donation amounts
enum DonationAmount {
  small(5.0, 'Small Support'),
  good(10.0, 'Good Support'),
  great(25.0, 'Great Support');

  const DonationAmount(this.amount, this.label);
  
  final double amount;
  final String label;
  
  /// Get hospice amount (50% of total)
  double get hospiceAmount => amount / 2;
  
  /// Get app development amount (50% of total)
  double get appAmount => amount / 2;
  
  /// Get formatted amount string
  String get formattedAmount => '€${amount.toStringAsFixed(0)}';
  
  /// Get formatted hospice amount string
  String get formattedHospiceAmount => '€${hospiceAmount.toStringAsFixed(1)}';
  
  /// Get formatted app amount string
  String get formattedAppAmount => '€${appAmount.toStringAsFixed(1)}';
}

/// Donation model representing a user's charitable contribution
class Donation {
  /// Unique identifier for the donation
  final String id;
  
  /// User ID who made the donation
  final String userId;
  
  /// Total donation amount in EUR
  final double amount;
  
  /// Amount going to hospice foundation (50%)
  final double hospiceAmount;
  
  /// Amount going to app development (50%)
  final double appAmount;
  
  /// Timestamp when donation was made
  final DateTime timestamp;
  
  /// Payment method used
  final PaymentMethod paymentMethod;
  
  /// Current status of the donation
  final DonationStatus status;
  
  /// URL to receipt/confirmation
  final String? receiptUrl;
  
  /// Payment processor transaction ID
  final String? transactionId;
  
  /// User's email for receipt
  final String? userEmail;
  
  /// Optional message from user
  final String? message;
  
  /// Whether user wants to be anonymous
  final bool isAnonymous;

  const Donation({
    required this.id,
    required this.userId,
    required this.amount,
    required this.hospiceAmount,
    required this.appAmount,
    required this.timestamp,
    required this.paymentMethod,
    required this.status,
    this.receiptUrl,
    this.transactionId,
    this.userEmail,
    this.message,
    this.isAnonymous = false,
  });

  /// Create donation from predefined amount
  factory Donation.fromAmount({
    required String id,
    required String userId,
    required DonationAmount donationAmount,
    required PaymentMethod paymentMethod,
    String? userEmail,
    String? message,
    bool isAnonymous = false,
  }) {
    return Donation(
      id: id,
      userId: userId,
      amount: donationAmount.amount,
      hospiceAmount: donationAmount.hospiceAmount,
      appAmount: donationAmount.appAmount,
      timestamp: DateTime.now(),
      paymentMethod: paymentMethod,
      status: DonationStatus.pending,
      userEmail: userEmail,
      message: message,
      isAnonymous: isAnonymous,
    );
  }

  /// Create a copy with updated fields
  Donation copyWith({
    String? id,
    String? userId,
    double? amount,
    double? hospiceAmount,
    double? appAmount,
    DateTime? timestamp,
    PaymentMethod? paymentMethod,
    DonationStatus? status,
    String? receiptUrl,
    String? transactionId,
    String? userEmail,
    String? message,
    bool? isAnonymous,
  }) {
    return Donation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      hospiceAmount: hospiceAmount ?? this.hospiceAmount,
      appAmount: appAmount ?? this.appAmount,
      timestamp: timestamp ?? this.timestamp,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      transactionId: transactionId ?? this.transactionId,
      userEmail: userEmail ?? this.userEmail,
      message: message ?? this.message,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  /// Convert from JSON
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      hospiceAmount: (json['hospiceAmount'] as num).toDouble(),
      appAmount: (json['appAmount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentMethod'],
      ),
      status: DonationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      receiptUrl: json['receiptUrl'] as String?,
      transactionId: json['transactionId'] as String?,
      userEmail: json['userEmail'] as String?,
      message: json['message'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'hospiceAmount': hospiceAmount,
      'appAmount': appAmount,
      'timestamp': timestamp.toIso8601String(),
      'paymentMethod': paymentMethod.toString().split('.').last,
      'status': status.toString().split('.').last,
      'receiptUrl': receiptUrl,
      'transactionId': transactionId,
      'userEmail': userEmail,
      'message': message,
      'isAnonymous': isAnonymous,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Donation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Donation{id: $id, amount: $amount, status: $status, timestamp: $timestamp}';
  }
}

/// Community impact statistics
class CommunityImpact {
  /// Total amount raised for hospice
  final double totalHospiceAmount;
  
  /// Total amount for app development
  final double totalAppAmount;
  
  /// Number of supporters
  final int supporterCount;
  
  /// Number of patients helped (estimated)
  final int patientsHelped;
  
  /// Number of app improvements made
  final int appImprovements;
  
  /// Last updated timestamp
  final DateTime lastUpdated;

  const CommunityImpact({
    required this.totalHospiceAmount,
    required this.totalAppAmount,
    required this.supporterCount,
    required this.patientsHelped,
    required this.appImprovements,
    required this.lastUpdated,
  });

  /// Total amount raised
  double get totalAmount => totalHospiceAmount + totalAppAmount;
  
  /// Formatted total hospice amount
  String get formattedHospiceAmount => '€${totalHospiceAmount.toStringAsFixed(0)}';
  
  /// Formatted total app amount
  String get formattedAppAmount => '€${totalAppAmount.toStringAsFixed(0)}';
  
  /// Formatted total amount
  String get formattedTotalAmount => '€${totalAmount.toStringAsFixed(0)}';

  /// Convert from JSON
  factory CommunityImpact.fromJson(Map<String, dynamic> json) {
    return CommunityImpact(
      totalHospiceAmount: (json['totalHospiceAmount'] as num).toDouble(),
      totalAppAmount: (json['totalAppAmount'] as num).toDouble(),
      supporterCount: json['supporterCount'] as int,
      patientsHelped: json['patientsHelped'] as int,
      appImprovements: json['appImprovements'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalHospiceAmount': totalHospiceAmount,
      'totalAppAmount': totalAppAmount,
      'supporterCount': supporterCount,
      'patientsHelped': patientsHelped,
      'appImprovements': appImprovements,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CommunityImpact{total: $formattedTotalAmount, supporters: $supporterCount}';
  }
}
