import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/claim_dashboard_viewmodel.dart';
import '../models/claim.dart';
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
              title: const Text('Claims Dashboard'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Action Required'),
                  Tab(text: 'Completed'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: viewModel.isLoading 
                    ? null 
                    : () => viewModel.refreshDashboard(),
                  tooltip: 'Refresh Dashboard',
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
              child: const Text(
                'Claims Summary',
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
                          'Total Claims', 
                          '${stats.totalClaims}',
                          Icons.summarize,
                        ),
                        _buildAnalyticItem(
                          'Active', 
                          '${stats.activeClaims}',
                          Icons.pending_actions,
                          color: Colors.amber,
                        ),
                        _buildAnalyticItem(
                          'Completed', 
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
                          'Total Compensation', 
                          _currencyFormat.format(stats.totalCompensation),
                          Icons.euro,
                          isWide: true,
                        ),
                        _buildAnalyticItem(
                          'Pending Amount', 
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
          label: 'No claims in this category',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No claims in this category',
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
          final compensationText = claim.compensationAmount != null
              ? _currencyFormat.format(claim.compensationAmount)
              : 'Pending';
          
          return Semantics(
            button: true,
            enabled: true,
            onTapHint: 'View claim details',
            value: 'Claim for flight ${claim.flightNumber} with status ${claim.status}',
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
                              'Flight ${claim.flightNumber} · ${claim.departureAirport} to ${claim.arrivalAirport}',
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
                            'Flight Date: $flightDate',
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
                            label: const Text('Action Required'),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error loading claims',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.refreshDashboard(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
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
          const Text(
            AppLocalizations.of(context)!.noClaimsYetTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              AppLocalizations.of(context)!.noClaimsYetSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},  // Use empty callback to avoid navigation issues
            icon: const Icon(Icons.add),
            label: const Text('Create a Claim'),
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
        return 'Submitted';
      case 'reviewing':
        return 'Under Review';
      case 'action_required':
        return 'Action Required';
      case 'processing':
        return 'Processing';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'paid':
        return 'Paid';
      case 'appealing':
        return 'Under Appeal';
      default:
        return 'Unknown';
    }
  }
}
