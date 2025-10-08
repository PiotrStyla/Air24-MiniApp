import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:f35_flight_compensation/models/claim.dart';
import 'package:f35_flight_compensation/screens/claim_submission_screen.dart';
import 'package:f35_flight_compensation/services/enhanced_claims_service.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';

import '../core/app_localizations_patch.dart';
import 'claim_detail_screen.dart';
import '../widgets/claims_shimmer_loading.dart'; // Day 11 - Beautiful loading

/// Enhanced Claims Dashboard with notifications and email integration
class EnhancedClaimDashboardScreen extends StatefulWidget {
  const EnhancedClaimDashboardScreen({super.key});

  @override
  State<EnhancedClaimDashboardScreen> createState() => _EnhancedClaimDashboardScreenState();
}

class _EnhancedClaimDashboardScreenState extends State<EnhancedClaimDashboardScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EnhancedClaimsService _claimsService;
  final _currencyFormat = NumberFormat.currency(symbol: '€');
  
  // Real-time event stream
  List<ClaimEvent> _recentEvents = [];
  StreamSubscription<ClaimEvent>? _eventsSubscription;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Added Events tab
    _initializeService();
  }
  
  Future<void> _initializeService() async {
    try {
      // Get the enhanced claims service directly from DI
      _claimsService = ServiceInitializer.get<EnhancedClaimsService>();
      
      // Listen to claim events
      _eventsSubscription = _claimsService.claimEventsStream.listen((event) {
        if (!mounted) return;
        setState(() {
          _recentEvents.insert(0, event);
          // Keep only last 20 events
          if (_recentEvents.length > 20) {
            _recentEvents = _recentEvents.take(20).toList();
          }
        });
      });
      
      setState(() {});
    } catch (e) {
      debugPrint('❌ Failed to initialize Enhanced Claims Service: $e');
    }
  }
  
  @override
  void dispose() {
    _eventsSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _claimsService,
      child: Consumer<EnhancedClaimsService>(
        builder: (context, claimsService, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.claimsDashboard),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.pending_actions),
                    text: context.l10n.active,
                  ),
                  Tab(
                    icon: const Icon(Icons.warning_amber),
                    text: context.l10n.actionRequired,
                  ),
                  Tab(
                    icon: const Icon(Icons.check_circle),
                    text: context.l10n.completed,
                  ),
                  Tab(
                    icon: const Icon(Icons.notifications_active),
                    text: context.l10n.events,
                  ),
                ],
              ),
              actions: [
                // Email status indicator
                _buildEmailStatusIndicator(claimsService),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _refreshDashboard(),
                  tooltip: context.l10n.refreshDashboard,
                ),
              ],
            ),
            body: StreamBuilder<List<Claim>>(
              stream: claimsService.claimsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      const AnalyticsCardShimmer(),
                      Expanded(child: ClaimsShimmerLoading(itemCount: 5)),
                    ],
                  );
                }
                
                if (snapshot.hasError) {
                  return _buildErrorView(snapshot.error.toString());
                }
                
                final claims = snapshot.data ?? [];
                
                if (claims.isEmpty) {
                  return _buildEmptyClaimsView();
                }
                
                return Column(
                  children: [
                    // Analytics card
                    _buildAnalyticsCard(claims, claimsService),
                    
                    // Claims lists in tabs
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildClaimsList(_getActiveClaims(claims), claimsService),
                          _buildClaimsList(_getActionRequiredClaims(claims), claimsService),
                          _buildClaimsList(_getCompletedClaims(claims), claimsService),
                          _buildEventsTab(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _navigateToClaimSubmission(),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.newClaim),
            ),
          );
        },
      ),
    );
  }
  
  /// Build email status indicator
  Widget _buildEmailStatusIndicator(EnhancedClaimsService claimsService) {
    final emailStatuses = claimsService.emailStatuses;
    final sendingCount = emailStatuses.values.where((s) => s == ClaimEmailStatus.sending).length;
    final failedCount = emailStatuses.values.where((s) => s == ClaimEmailStatus.failed).length;
    
    if (sendingCount > 0) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            const Icon(Icons.email, color: Colors.orange),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  sendingCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    if (failedCount > 0) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            const Icon(Icons.email_outlined, color: Colors.red),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  failedCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  /// Build analytics card
  Widget _buildAnalyticsCard(List<Claim> claims, EnhancedClaimsService claimsService) {
    final totalClaims = claims.length;
    final activeClaims = _getActiveClaims(claims).length;
    final completedClaims = _getCompletedClaims(claims).length;
    final totalCompensation = claims.fold<double>(0, (sum, claim) => sum + claim.compensationAmount);
    final paidCompensation = claims
        .where((c) => c.status.toLowerCase() == 'paid')
        .fold<double>(0, (sum, claim) => sum + claim.compensationAmount);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  context.l10n.claimsSummary,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context.l10n.totalClaims,
                    totalClaims.toString(),
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context.l10n.active,
                    activeClaims.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context.l10n.completed,
                    completedClaims.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context.l10n.totalCompensation,
                    _currencyFormat.format(totalCompensation),
                    Icons.euro,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context.l10n.receivedAmount,
                    _currencyFormat.format(paidCompensation),
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build stat card
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build claims list
  Widget _buildClaimsList(List<Claim> claims, EnhancedClaimsService claimsService) {
    if (claims.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.noClaimsYetTitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: claims.length,
      itemBuilder: (context, index) {
        final claim = claims[index];
        return _buildClaimCard(claim, claimsService);
      },
    );
  }
  
  /// Build claim card
  Widget _buildClaimCard(Claim claim, EnhancedClaimsService claimsService) {
    final emailStatus = claimsService.getEmailStatus(claim.id);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToClaimDetail(claim),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flight ${claim.flightNumber}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          claim.airlineName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusChip(claim.status),
                      const SizedBox(height: 4),
                      _buildEmailStatusChip(emailStatus),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Flight details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${claim.departureAirport} → ${claim.arrivalAirport}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy').format(claim.flightDate),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _currencyFormat.format(claim.compensationAmount),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                children: [
                  if (claim.status.toLowerCase() == 'draft')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendCompensationEmail(claim, claimsService),
                        icon: const Icon(Icons.send, size: 16),
                        label: Text(context.l10n.sendEmail),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (claim.status.toLowerCase() != 'draft') ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _resendEmail(claim, claimsService),
                        icon: const Icon(Icons.refresh, size: 16),
                        label: Text(context.l10n.resend),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToClaimDetail(claim),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: Text(context.l10n.viewClaimDetails),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build status chip
  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'draft':
        color = Colors.grey;
        icon = Icons.edit;
        break;
      case 'submitted':
        color = Colors.blue;
        icon = Icons.send;
        break;
      case 'under_review':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'approved':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case 'paid':
        color = Colors.purple;
        icon = Icons.account_balance_wallet;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build email status chip
  Widget _buildEmailStatusChip(ClaimEmailStatus emailStatus) {
    Color color;
    IconData icon;
    String text;
    
    switch (emailStatus) {
      case ClaimEmailStatus.notSent:
        color = Colors.grey;
        icon = Icons.email_outlined;
        text = context.l10n.emailStatusNotSent.toUpperCase();
        break;
      case ClaimEmailStatus.sending:
        color = Colors.orange;
        icon = Icons.send;
        text = context.l10n.emailStatusSending.toUpperCase();
        break;
      case ClaimEmailStatus.sent:
        color = Colors.green;
        icon = Icons.check_circle;
        text = context.l10n.emailStatusSent.toUpperCase();
        break;
      case ClaimEmailStatus.failed:
        color = Colors.red;
        icon = Icons.error;
        text = context.l10n.emailStatusFailed.toUpperCase();
        break;
      case ClaimEmailStatus.bounced:
        color = Colors.red;
        icon = Icons.error_outline;
        text = context.l10n.emailStatusBounced.toUpperCase();
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build events tab
  Widget _buildEventsTab() {
    if (_recentEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.noRecentEvents,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentEvents.length,
      itemBuilder: (context, index) {
        final event = _recentEvents[index];
        return _buildEventCard(event);
      },
    );
  }
  
  /// Build event card
  Widget _buildEventCard(ClaimEvent event) {
    IconData icon;
    Color color;
    
    switch (event.type) {
      case ClaimEventType.created:
        icon = Icons.add_circle;
        color = Colors.blue;
        break;
      case ClaimEventType.statusChanged:
        icon = Icons.update;
        color = Colors.orange;
        break;
      case ClaimEventType.emailSent:
        icon = Icons.email;
        color = Colors.green;
        break;
      case ClaimEventType.documentRequired:
        icon = Icons.description;
        color = Colors.purple;
        break;
      case ClaimEventType.deadlineReminder:
        icon = Icons.schedule;
        color = Colors.red;
        break;
      case ClaimEventType.deleted:
        icon = Icons.delete_outline;
        color = Colors.red;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(event.message),
        subtitle: Text(
          DateFormat('MMM dd, yyyy HH:mm').format(event.timestamp),
        ),
        trailing: Text(
          event.claimId,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
  
  /// Build error view
  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            context.l10n.errorLoadingClaims,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshDashboard,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
  
  /// Build empty claims view
  Widget _buildEmptyClaimsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            context.l10n.noClaimsYet,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.startCompensationClaimInstructions,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _navigateToClaimSubmission,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.createClaim),
          ),
        ],
      ),
    );
  }
  
  /// Get active claims
  List<Claim> _getActiveClaims(List<Claim> claims) {
    return claims.where((claim) => 
      !['paid', 'rejected'].contains(claim.status.toLowerCase())
    ).toList();
  }
  
  /// Get action required claims
  List<Claim> _getActionRequiredClaims(List<Claim> claims) {
    return claims.where((claim) => 
      ['draft', 'requires_documents'].contains(claim.status.toLowerCase())
    ).toList();
  }
  
  /// Get completed claims
  List<Claim> _getCompletedClaims(List<Claim> claims) {
    return claims.where((claim) => 
      ['paid', 'rejected'].contains(claim.status.toLowerCase())
    ).toList();
  }
  
  /// Send compensation email
  Future<void> _sendCompensationEmail(Claim claim, EnhancedClaimsService claimsService) async {
    try {
      final success = await claimsService.sendCompensationEmail(claim);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success 
                ? context.l10n.compensationEmailSuccess 
                : context.l10n.compensationEmailFailed
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorSendingEmail(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  /// Resend email
  Future<void> _resendEmail(Claim claim, EnhancedClaimsService claimsService) async {
    await _sendCompensationEmail(claim, claimsService);
  }
  
  /// Navigate to claim submission
  void _navigateToClaimSubmission() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ClaimSubmissionScreen(),
      ),
    );
  }
  
  /// Navigate to claim detail
  void _navigateToClaimDetail(Claim claim) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClaimDetailScreen(
          claimId: claim.id,
          initialClaim: claim,
        ),
      ),
    );
  }
  
  /// Refresh dashboard
  void _refreshDashboard() {
    // Trigger refresh through the service
    setState(() {});
  }
}
