import 'package:flutter/foundation.dart';
import '../models/donation.dart';
import '../services/donation_service.dart';
import '../core/services/service_initializer.dart';

/// View model for handling donation-related operations
class DonationViewModel extends ChangeNotifier {
  final DonationService _donationService;
  
  // State
  bool _isLoading = false;
  String? _errorMessage;
  Donation? _currentDonation;
  CommunityImpact? _communityImpact;
  List<Donation> _userDonations = [];

  DonationViewModel() : _donationService = ServiceInitializer.get<DonationService>() {
    _loadCommunityImpact();
    _loadUserDonations();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Donation? get currentDonation => _currentDonation;
  CommunityImpact? get communityImpact => _communityImpact;
  List<Donation> get userDonations => _userDonations;
  
  bool get hasError => _errorMessage != null;
  
  /// Total amount donated by current user
  double get totalUserDonations {
    return _userDonations.fold(0.0, (sum, donation) => 
      donation.status == DonationStatus.completed ? sum + donation.amount : sum);
  }
  
  /// Number of completed donations by current user
  int get completedDonationsCount {
    return _userDonations.where((d) => d.status == DonationStatus.completed).length;
  }

  /// Create a new donation
  Future<bool> createDonation({
    required DonationAmount amount,
    required PaymentMethod paymentMethod,
    String? userEmail,
    String? message,
    bool isAnonymous = false,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      debugPrint('🚀 DonationViewModel: Creating donation for ${amount.formattedAmount}');

      final donation = await _donationService.createDonation(
        amount: amount,
        paymentMethod: paymentMethod,
        userEmail: userEmail,
        message: message,
        isAnonymous: isAnonymous,
      );

      _currentDonation = donation;
      debugPrint('✅ DonationViewModel: Donation created successfully: ${donation.id}');
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ DonationViewModel: Failed to create donation: $e');
      _setError('Failed to create donation: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Process payment for current donation
  Future<bool> processPayment({
    required String donationId,
    Map<String, dynamic>? paymentDetails,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      debugPrint('🚀 DonationViewModel: Processing payment for donation: $donationId');

      final success = await _donationService.processPayment(
        donationId: donationId,
        paymentDetails: paymentDetails,
      );

      if (success && _currentDonation != null) {
        _currentDonation = _currentDonation!.copyWith(
          status: DonationStatus.processing,
        );
        
        debugPrint('✅ DonationViewModel: Payment processing started');
      }

      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('❌ DonationViewModel: Failed to process payment: $e');
      _setError('Payment failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Check payment status
  Future<void> checkPaymentStatus(String donationId) async {
    try {
      debugPrint('🔍 DonationViewModel: Checking payment status for: $donationId');

      final donation = await _donationService.getDonation(donationId);
      if (donation != null) {
        _currentDonation = donation;
        
        // If donation is completed, refresh user donations and community impact
        if (donation.status == DonationStatus.completed) {
          _loadUserDonations();
          _loadCommunityImpact();
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ DonationViewModel: Failed to check payment status: $e');
      _setError('Failed to check payment status: ${e.toString()}');
    }
  }

  /// Load community impact statistics
  Future<void> _loadCommunityImpact() async {
    try {
      debugPrint('🌍 DonationViewModel: Loading community impact...');
      
      final impact = await _donationService.getCommunityImpact();
      _communityImpact = impact;
      
      debugPrint('✅ DonationViewModel: Community impact loaded: ${impact.formattedTotalAmount}');
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ DonationViewModel: Failed to load community impact: $e');
      // Don't show error for community impact - it's not critical
    }
  }

  /// Load user's donation history
  Future<void> _loadUserDonations() async {
    try {
      debugPrint('📋 DonationViewModel: Loading user donations...');
      
      final donations = await _donationService.getUserDonations();
      _userDonations = donations;
      
      debugPrint('✅ DonationViewModel: Loaded ${donations.length} user donations');
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ DonationViewModel: Failed to load user donations: $e');
      // Don't show error for user donations - it's not critical
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      _loadCommunityImpact(),
      _loadUserDonations(),
    ]);
  }

  /// Get donation by ID
  Future<Donation?> getDonation(String donationId) async {
    try {
      return await _donationService.getDonation(donationId);
    } catch (e) {
      debugPrint('❌ DonationViewModel: Failed to get donation: $e');
      return null;
    }
  }

  /// Send donation receipt
  Future<bool> sendReceipt(String donationId) async {
    try {
      _setLoading(true);
      _clearError();

      debugPrint('📧 DonationViewModel: Sending receipt for donation: $donationId');

      final success = await _donationService.sendReceipt(donationId);
      
      if (success) {
        debugPrint('✅ DonationViewModel: Receipt sent successfully');
      }

      return success;
    } catch (e) {
      debugPrint('❌ DonationViewModel: Failed to send receipt: $e');
      _setError('Failed to send receipt: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Clear current donation
  void clearCurrentDonation() {
    _currentDonation = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
