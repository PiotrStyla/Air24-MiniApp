import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:f35_flight_compensation/models/claim.dart';
import 'package:f35_flight_compensation/screens/claim_submission_screen.dart';

import '../core/app_localizations_patch.dart';
import '../viewmodels/claim_dashboard_viewmodel.dart';
import '../core/services/service_initializer.dart';
import 'claim_detail_screen.dart';


/// Dashboard screen to track user's compensation claims
class ClaimDashboardScreen extends StatefulWidget {
  const ClaimDashboardScreen({super.key});

  @override
  State<ClaimDashboardScreen> createState() => _ClaimDashboardScreenState();
}

class _ClaimDashboardScreenState extends State<ClaimDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ClaimDashboardViewModel _viewModel;
  final _currencyFormat = NumberFormat.currency(symbol: '€');
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _viewModel = ServiceInitializer.get<ClaimDashboardViewModel>();
    _initializeViewModel();
  }
  
  Future<void> _initializeViewModel() async {
    await _viewModel.initialize();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ClaimDashboardViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.claimsDashboard),
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: context.l10n.active),
                  Tab(text: context.l10n.actionRequired),
                  Tab(text: context.l10n.completed),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: viewModel.isLoading 
                    ? null 
                    : () => viewModel.refreshDashboard(),
                  tooltip: context.l10n.refreshDashboard,
                ),
              ],
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildDashboardContent(viewModel),
          );
        },
      ),
    );
  }
  
  Widget _buildDashboardContent(ClaimDashboardViewModel viewModel) {
    if (viewModel.errorMessage.isNotEmpty) {
      return _buildErrorView(viewModel);
    }
    
    if (viewModel.claims.isEmpty) {
      return _buildEmptyClaimsView();
    }
    
    return Column(
      children: [
        // Analytics card
        _buildAnalyticsCard(viewModel.stats),
        
        // Claims lists in tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildClaimsList(viewModel.activeClaims),
              _buildClaimsList(viewModel.requiresActionClaims),
              _buildClaimsList(viewModel.completedClaims),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnalyticsCard(DashboardStats stats) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with semantic heading
            Semantics(
              header: true,
              child: Text(
                context.l10n.claimsSummary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Main metrics row using LayoutBuilder for responsiveness
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 500;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: isWide 
                      ? MainAxisAlignment.spaceEvenly 
                      : MainAxisAlignment.start,
                  children: [
                    // First row of analytics
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAnalyticItem(
                          context.l10n.totalClaims, 
                          '${stats.totalClaims}',
                          Icons.summarize,
                        ),
                        _buildAnalyticItem(
                          context.l10n.active, 
                          '${stats.activeClaims}',
                          Icons.pending_actions,
                          color: Colors.amber,
                        ),
                        _buildAnalyticItem(
                          context.l10n.completed, 
                          '${stats.completedClaims}',
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
                    // Second row of analytics - financial data
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAnalyticItem(
                          context.l10n.totalCompensation, 
                          _currencyFormat.format(stats.totalCompensation),
                          Icons.euro,
                          isWide: true,
                        ),
                        _buildAnalyticItem(
                          context.l10n.pendingAmount, 
                          _currencyFormat.format(stats.pendingCompensation),
                          Icons.account_balance_wallet,
                          isWide: true,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalyticItem(
    String label, 
    String value, 
    IconData icon, {
    Color? color,
    bool isWide = false,
  }) {
    return SizedBox(
      width: isWide ? 160 : 100,
      child: Column(
        children: [
          Icon(icon, color: color ?? Colors.blue, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color ?? Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildClaimsList(List<Claim> claims) {
    if (claims.isEmpty) {
      return Center(
        child: Semantics(
          label: context.l10n.noClaimsYetTitle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                context.l10n.noClaimsYetTitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        return _viewModel.refreshDashboard();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: claims.length,
        itemBuilder: (context, index) {
          final claim = claims[index];
          
          // Format the date in a readable format
          final flightDate = DateFormat.yMMMd().format(claim.flightDate);
          
          // Get compensation amount as string
          final compensationText = claim.compensationAmount > 0
              ? _currencyFormat.format(claim.compensationAmount)
              : context.l10n.pending;
          
          return Semantics(
            button: true,
            enabled: true,
            onTapHint: context.l10n.viewClaimDetails,
            value: context.l10n.claimForFlight(claim.flightNumber, claim.status.toString()),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () => _navigateToClaimDetail(claim.id),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flight info row
                      Row(
                        children: [
                          _getStatusIcon(claim.status),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.l10n.flightRouteDetailsWithNumber(
                                claim.flightNumber,
                                claim.departureAirport,
                                claim.arrivalAirport,
                                claim.flightNumber, // number
                                claim.airlineName, // airline (using airlineName instead of airline)
                                claim.departureAirport, // departureAirport
                                claim.arrivalAirport, // arrivalAirport
                                claim.flightDate.toString(), // date converted to string
                                ''), // time (using empty string as flightTime is missing)
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(claim.status).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(claim.status),
                              style: TextStyle(
                                color: _getStatusColor(claim.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Details row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.flightDate
                              .replaceAll('{date}', flightDate),
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          Text(
                            compensationText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: claim.status == 'paid' ? Colors.green : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      if (claim.status == 'action_required')
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: OutlinedButton.icon(
                            onPressed: () => _navigateToClaimDetail(claim.id),
                            icon: const Icon(Icons.warning, size: 16),
                            label: Text(context.l10n.actionRequired),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildErrorView(ClaimDashboardViewModel viewModel) {
    // Check if the error is related to authentication
    final bool isAuthError = viewModel.errorMessage.toLowerCase().contains('not logged in') || 
                              viewModel.errorMessage.toLowerCase().contains('authentication');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isAuthError ? Icons.account_circle : Icons.error_outline, 
              size: 64, 
              color: isAuthError ? Colors.blue : Colors.red
            ),
            const SizedBox(height: 16),
            Text(
              isAuthError 
                ? context.l10n.authenticationRequired 
                : context.l10n.errorLoadingClaims,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              isAuthError 
                ? context.l10n.loginToViewClaimsDashboard
                : viewModel.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isAuthError ? Colors.black87 : Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            if (isAuthError)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed('/auth');
                },
                icon: const Icon(Icons.login),
                label: Text(context.l10n.logIn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => viewModel.refreshDashboard(),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.retry),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyClaimsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noClaimsYet,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              context.l10n.startCompensationClaimInstructions,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ClaimSubmissionScreen(),
                ),
              ).then((_) {
                // Refresh dashboard when returning from submission screen
                _viewModel.refreshDashboard();
              });
            },
            icon: const Icon(Icons.add),
            label: Text(context.l10n.createClaim),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  void _navigateToClaimDetail(String claimId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClaimDetailScreen(claimId: claimId),
      ),
    ).then((_) {
      // Refresh dashboard when returning from detail screen
      _viewModel.refreshDashboard();
    });
  }
  
  Widget _getStatusIcon(String? status) {
    IconData iconData;
    Color color = _getStatusColor(status);
    
    switch (status) {
      case 'submitted':
        iconData = Icons.upload_file;
        break;
      case 'reviewing':
        iconData = Icons.search;
        break;
      case 'action_required':
        iconData = Icons.warning;
        break;
      case 'processing':
        iconData = Icons.hourglass_bottom;
        break;
      case 'approved':
        iconData = Icons.thumb_up;
        break;
      case 'rejected':
        iconData = Icons.thumb_down;
        break;
      case 'paid':
        iconData = Icons.payments;
        break;
      case 'appealing':
        iconData = Icons.gavel;
        break;
      default:
        iconData = Icons.help_outline;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }
  
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'submitted':
        return Colors.blue;
      case 'reviewing':
        return Colors.orange;
      case 'action_required':
        return Colors.red;
      case 'processing':
        return Colors.purple;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'paid':
        return Colors.green;
      case 'appealing':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
  
  String _getStatusText(String? status) {
    switch (status) {
      case 'submitted':
        return context.l10n.submitted;
      case 'reviewing':
        return context.l10n.inReview;
      case 'action_required':
        return context.l10n.actionRequired;
      case 'processing':
        return context.l10n.processing;
      case 'approved':
        return context.l10n.approved;
      case 'rejected':
        return context.l10n.rejected;
      case 'paid':
        return context.l10n.paid;
      case 'appealing':
        return context.l10n.underAppeal;
      default:
        return context.l10n.unknown;
    }
  }
}
