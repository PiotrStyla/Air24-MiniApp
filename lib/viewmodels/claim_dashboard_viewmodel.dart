import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/claim.dart';
import '../models/claim_status.dart';

import '../services/claim_tracking_service.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import '../core/services/service_initializer.dart';

/// Dashboard statistics model
class DashboardStats {
  final int totalClaims;
  final int activeClaims;
  final int completedClaims;
  final double totalCompensation;
  final double pendingCompensation;
  
  DashboardStats({
    this.totalClaims = 0,
    this.activeClaims = 0,
    this.completedClaims = 0,
    this.totalCompensation = 0.0,
    this.pendingCompensation = 0.0,
  });
}

/// ViewModel for the claims dashboard - follows MVVM architecture
class ClaimDashboardViewModel extends ChangeNotifier {
  
  final ClaimTrackingService _trackingService;
  final FirebaseAuthService _authService;
  
  // Dashboard state
  List<Claim> _claims = [];
  DashboardStats _stats = DashboardStats();
  Map<String, dynamic>? _analytics;
  bool _isLoading = false;
  String _errorMessage = '';
  
  // Getters
  List<Claim> get claims => _claims;
  DashboardStats get stats => _stats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  // Filtered claims getters
  List<Claim> get activeClaims => _claims.where((claim) => 
    claim.status != 'paid' && 
    claim.status != 'rejected').toList();
    
  List<Claim> get requiresActionClaims => _claims.where((claim) => 
    claim.status == 'action_required').toList();
    
  List<Claim> get completedClaims => _claims.where((claim) => 
    claim.status == 'paid' || 
    claim.status == 'rejected').toList();
  
  // Stream subscription
  StreamSubscription<List<Claim>>? _claimsSubscription;
  
  ClaimDashboardViewModel({
    required ClaimTrackingService trackingService,
    required FirebaseAuthService authService,
  })  : _trackingService = trackingService,
        _authService = authService;
  
  /// Initialize the dashboard by loading claims and analytics
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // Load claims directly - in a real app this would be a stream
      await _loadClaims();
      
      // Calculate analytics from claims
      _calculateDashboardStats();
      
    } catch (e) {
      _errorMessage = 'Error initializing dashboard: $e';
      debugPrint(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// Load claims from Firestore
  Future<void> _loadClaims() async {
    try {
      final currentUser = _authService.currentUser?.uid;
      if (currentUser != null) {
        _claims = await _trackingService.getClaimsForUser(currentUser);
        notifyListeners();
      } else {
        _errorMessage = 'User not logged in';
        debugPrint(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error loading claims: $e';
      debugPrint(_errorMessage);
    }
  }
  
  /// Load claim analytics
  Future<void> _loadAnalytics() async {
    try {
      // Either use the tracking service or calculate from existing claims
      if (_claims.isNotEmpty) {
        _calculateDashboardStats();
      } else {
        debugPrint('No claims available for analytics');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading analytics: $e');
    }
  }
  
  /// Calculate dashboard statistics from claims data
  void _calculateDashboardStats() {
    try {
      // Count by status
      final activeClaims = _claims.where((claim) => 
        claim.status != 'paid' && 
        claim.status != 'rejected').toList();
        
      final completedClaims = _claims.where((claim) => 
        claim.status == 'paid' || 
        claim.status == 'rejected').toList();
      
      // Calculate compensation amounts
      double totalCompensation = 0.0;
      double pendingCompensation = 0.0;
      
      for (final claim in _claims) {
        // For paid claims, add to total compensation
        if (claim.status == 'paid' && claim.compensationAmount != null) {
          totalCompensation += claim.compensationAmount;
        }
        
        // For pending claims, add to pending compensation
        if (claim.status != 'rejected' && claim.status != 'paid' && claim.compensationAmount != null) {
          // Use the actual compensation amount as an estimate for pending claims
          pendingCompensation += claim.compensationAmount;
        }
      }
      
      // Update stats
      _stats = DashboardStats(
        totalClaims: _claims.length,
        activeClaims: activeClaims.length,
        completedClaims: completedClaims.length,
        totalCompensation: totalCompensation,
        pendingCompensation: pendingCompensation,
      );
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating statistics: $e');
    }
  }
  
  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    _setLoading(true);
    
    try {
      // Reload user claims
      await _loadClaims();
      
      // Recalculate statistics
      _calculateDashboardStats();
      
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error refreshing dashboard: $e';
      debugPrint(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// Get detailed information for a specific claim
  Future<Claim?> getClaimDetails(String claimId) async {
    try {
      // Find the claim in the existing list
      return _claims.firstWhere((claim) => claim.id == claimId);
    } catch (e) {
      debugPrint('Error fetching claim details: $e');
      return null;
    }
  }
  
  /// Submit action for a claim that requires user input
  Future<bool> submitRequiredAction(String claimId, Map<String, dynamic> actionData) async {
    try {
      // Update claim status to processing - placeholder implementation
      var claimIndex = _claims.indexWhere((claim) => claim.id == claimId);
      if (claimIndex >= 0) {
        // This is a placeholder, in a real app we would call the actual service
        // _claims[claimIndex].status = 'processing';
        // notifyListeners();
        await refreshDashboard();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error submitting action: $e');
      return false;
    }
  }
  
  /// Submit appeal for a rejected claim
  Future<bool> submitAppeal(String claimId, String appealReason, List<String> documentIds) async {
    try {
      // Update claim status to appealing - placeholder implementation
      var claimIndex = _claims.indexWhere((claim) => claim.id == claimId);
      if (claimIndex >= 0) {
        // This is a placeholder, in a real app we would call the actual service
        // _claims[claimIndex].status = 'appealing';
        // notifyListeners();
        await refreshDashboard();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error submitting appeal: $e');
      return false;
    }
  }
  
  /// Get claim history
  Future<List<Map<String, dynamic>>> getClaimHistory(String claimId) async {
    try {
      // Placeholder implementation - return empty history
      // In a real app, this would call the tracking service
      return [
        {
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'status': 'submitted',
          'description': 'Claim submitted successfully',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'status': 'reviewing',
          'description': 'Claim is under review',
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'status': 'processing',
          'description': 'Claim approved, processing payment',
        },
      ];
    } catch (e) {
      debugPrint('Error fetching claim history: $e');
      return [];
    }
  }
  
  /// Delete a claim and refresh dashboard state
  Future<bool> deleteClaim(String claimId) async {
    try {
      await _trackingService.deleteClaim(claimId);
      _claims.removeWhere((c) => c.id == claimId);
      _calculateDashboardStats();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting claim: $e';
      debugPrint(_errorMessage);
      return false;
    }
  }
  
  /// Helper to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Clear any error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
  
  @override
  void dispose() {
    _claimsSubscription?.cancel();
    super.dispose();
  }
}
