import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/donation.dart';
import '../services/auth_service_firebase.dart';
import '../core/services/service_initializer.dart';

/// Service for handling donation operations
class DonationService {
  static const String _baseUrl = 'https://your-backend-url.com/api';
  static const Duration _requestTimeout = Duration(seconds: 30);
  
  final FirebaseAuthService _authService;
  final http.Client _httpClient;

  DonationService({
    FirebaseAuthService? authService,
    http.Client? httpClient,
  }) : _authService = authService ?? ServiceInitializer.get<FirebaseAuthService>(),
       _httpClient = httpClient ?? http.Client();

  /// Create a new donation
  Future<Donation> createDonation({
    required DonationAmount amount,
    required PaymentMethod paymentMethod,
    String? userEmail,
    String? message,
    bool isAnonymous = false,
  }) async {
    try {
      debugPrint('🚀 DonationService: Creating donation for ${amount.formattedAmount}');

      final userId = _authService.currentUser?.uid ?? 'anonymous';
      final donationId = _generateDonationId();

      // In development mode, create a mock donation
      if (kDebugMode) {
        debugPrint('🔧 DonationService: Creating mock donation for development');
        
        final donation = Donation.fromAmount(
          id: donationId,
          userId: userId,
          donationAmount: amount,
          paymentMethod: paymentMethod,
          userEmail: userEmail ?? _authService.currentUser?.email,
          message: message,
          isAnonymous: isAnonymous,
        );

        debugPrint('✅ DonationService: Mock donation created: ${donation.id}');
        return donation;
      }

      // Production: Make API call to backend
      final requestBody = {
        'id': donationId,
        'userId': userId,
        'amount': amount.amount,
        'hospiceAmount': amount.hospiceAmount,
        'appAmount': amount.appAmount,
        'paymentMethod': paymentMethod.name,
        'userEmail': userEmail ?? _authService.currentUser?.email,
        'message': message,
        'isAnonymous': isAnonymous,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/donations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode(requestBody),
      ).timeout(_requestTimeout);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final donation = Donation.fromJson(responseData);
        
        debugPrint('✅ DonationService: Donation created successfully: ${donation.id}');
        return donation;
      } else {
        throw Exception('Failed to create donation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DonationService: Failed to create donation: $e');
      rethrow;
    }
  }

  /// Process payment for a donation
  Future<bool> processPayment({
    required String donationId,
    Map<String, dynamic>? paymentDetails,
  }) async {
    try {
      debugPrint('🚀 DonationService: Processing payment for donation: $donationId');

      // In development mode, simulate payment processing
      if (kDebugMode) {
        debugPrint('🔧 DonationService: Simulating payment processing for development');
        
        // Simulate processing delay
        await Future.delayed(const Duration(seconds: 2));
        
        // Simulate 95% success rate
        final success = Random().nextDouble() > 0.05;
        
        if (success) {
          debugPrint('✅ DonationService: Mock payment processed successfully');
        } else {
          debugPrint('❌ DonationService: Mock payment failed');
        }
        
        return success;
      }

      // Production: Make API call to payment processor
      final requestBody = {
        'donationId': donationId,
        'paymentDetails': paymentDetails ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      };

      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/donations/$donationId/process-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode(requestBody),
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final success = responseData['success'] as bool;
        
        debugPrint('✅ DonationService: Payment processing result: $success');
        return success;
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DonationService: Failed to process payment: $e');
      rethrow;
    }
  }

  /// Get donation by ID
  Future<Donation?> getDonation(String donationId) async {
    try {
      debugPrint('🔍 DonationService: Getting donation: $donationId');

      // In development mode, return mock donation with completed status
      if (kDebugMode) {
        debugPrint('🔧 DonationService: Returning mock donation for development');
        
        return Donation(
          id: donationId,
          userId: _authService.currentUser?.uid ?? 'anonymous',
          amount: 10.0,
          hospiceAmount: 5.0,
          appAmount: 5.0,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          paymentMethod: PaymentMethod.card,
          status: DonationStatus.completed,
          userEmail: _authService.currentUser?.email,
          transactionId: 'txn_${donationId}_mock',
        );
      }

      // Production: Make API call to backend
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/donations/$donationId'),
        headers: {
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final donation = Donation.fromJson(responseData);
        
        debugPrint('✅ DonationService: Donation retrieved: ${donation.id}');
        return donation;
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ DonationService: Donation not found: $donationId');
        return null;
      } else {
        throw Exception('Failed to get donation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DonationService: Failed to get donation: $e');
      rethrow;
    }
  }

  /// Get user's donation history
  Future<List<Donation>> getUserDonations() async {
    try {
      debugPrint('📋 DonationService: Getting user donations');

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ DonationService: No authenticated user');
        return [];
      }

      // In development mode, return mock donations
      if (kDebugMode) {
        debugPrint('🔧 DonationService: Returning mock user donations for development');
        
        return [
          Donation(
            id: 'donation_1',
            userId: userId,
            amount: 10.0,
            hospiceAmount: 5.0,
            appAmount: 5.0,
            timestamp: DateTime.now().subtract(const Duration(days: 7)),
            paymentMethod: PaymentMethod.card,
            status: DonationStatus.completed,
            userEmail: _authService.currentUser?.email,
            transactionId: 'txn_1_mock',
          ),
          Donation(
            id: 'donation_2',
            userId: userId,
            amount: 25.0,
            hospiceAmount: 12.5,
            appAmount: 12.5,
            timestamp: DateTime.now().subtract(const Duration(days: 30)),
            paymentMethod: PaymentMethod.paypal,
            status: DonationStatus.completed,
            userEmail: _authService.currentUser?.email,
            transactionId: 'txn_2_mock',
          ),
        ];
      }

      // Production: Make API call to backend
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/users/$userId/donations'),
        headers: {
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as List;
        final donations = responseData.map((json) => Donation.fromJson(json)).toList();
        
        debugPrint('✅ DonationService: Retrieved ${donations.length} user donations');
        return donations;
      } else {
        throw Exception('Failed to get user donations: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DonationService: Failed to get user donations: $e');
      rethrow;
    }
  }

  /// Get community impact statistics
  Future<CommunityImpact> getCommunityImpact() async {
    try {
      debugPrint('🌍 DonationService: Getting community impact');

      // In development mode, return mock impact data
      if (kDebugMode) {
        debugPrint('🔧 DonationService: Returning mock community impact for development');
        
        return CommunityImpact(
          totalHospiceAmount: 2450.0,
          totalAppAmount: 2450.0,
          supporterCount: 89,
          patientsHelped: 156,
          appImprovements: 12,
          lastUpdated: DateTime.now(),
        );
      }

      // Production: Make API call to backend
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/community-impact'),
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final impact = CommunityImpact.fromJson(responseData);
        
        debugPrint('✅ DonationService: Community impact retrieved: ${impact.formattedTotalAmount}');
        return impact;
      } else {
        throw Exception('Failed to get community impact: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DonationService: Failed to get community impact: $e');
      rethrow;
    }
  }

  /// Send donation receipt
  Future<bool> sendReceipt(String donationId) async {
    try {
      debugPrint('📧 DonationService: Sending receipt for donation: $donationId');

      // In development mode, simulate receipt sending
      if (kDebugMode) {
        debugPrint('🔧 DonationService: Simulating receipt sending for development');
        await Future.delayed(const Duration(seconds: 1));
        debugPrint('✅ DonationService: Mock receipt sent successfully');
        return true;
      }

      // Production: Make API call to backend
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/donations/$donationId/send-receipt'),
        headers: {
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        debugPrint('✅ DonationService: Receipt sent successfully');
        return true;
      } else {
        throw Exception('Failed to send receipt: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ DonationService: Failed to send receipt: $e');
      rethrow;
    }
  }

  /// Generate unique donation ID
  String _generateDonationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'donation_${timestamp}_$random';
  }

  /// Get authentication token
  Future<String?> _getAuthToken() async {
    try {
      // In development mode, return mock token
      if (kDebugMode) {
        return 'mock_auth_token';
      }

      // Production: Get actual auth token
      final user = _authService.currentUser;
      if (user != null) {
        // Return Firebase ID token or similar
        return 'firebase_token_${user.uid}';
      }
      return null;
    } catch (e) {
      debugPrint('⚠️ DonationService: Failed to get auth token: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
