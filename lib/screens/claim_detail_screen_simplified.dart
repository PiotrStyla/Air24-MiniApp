import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/claim_status.dart';
import '../core/services/service_initializer.dart';
import '../viewmodels/claim_dashboard_viewmodel.dart';
import '../core/error/error_handler.dart';

/// A simplified version of the claim detail screen to address compilation issues
class ClaimDetailScreen extends StatefulWidget {
  final String claimId;
  
  const ClaimDetailScreen({Key? key, required this.claimId}) : super(key: key);

  @override
  State<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends State<ClaimDetailScreen> {
  late final ClaimDashboardViewModel _viewModel;
  ClaimSummary? _claim;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _viewModel = ServiceInitializer.get<ClaimDashboardViewModel>();
    _loadClaimDetails();
  }
  
  Future<void> _loadClaimDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final claim = await _viewModel.getClaimDetails(widget.claimId);
      
      setState(() {
        _claim = claim;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading claim details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _isLoading ? null : _loadClaimDetails,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _claim == null
                  ? _buildClaimNotFoundView()
                  : _buildClaimDetailsView(),
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading claim',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadClaimDetails,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildClaimNotFoundView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Claim Not Found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'The requested claim could not be found. It may have been deleted.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildClaimDetailsView() {
    final claim = _claim!;
    final dateFormatter = DateFormat('MMM d, yyyy');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: claim.status.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: claim.status.color.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status header
                Row(
                  children: [
                    Icon(claim.status.icon, color: claim.status.color),
                    const SizedBox(width: 8),
                    Text(
                      claim.status.displayName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: claim.status.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...claim.status.nextSteps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline, 
                        size: 16, 
                        color: claim.status.color.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Flight details card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flight Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildInfoRow('Flight Number:', claim.flightNumber),
                  _buildInfoRow('Airline:', claim.airline),
                  _buildInfoRow('Flight Date:', dateFormatter.format(claim.flightDate)),
                  _buildInfoRow('Submitted On:', dateFormatter.format(claim.submissionDate)),
                  _buildInfoRow('Last Updated:', dateFormatter.format(claim.lastUpdated)),
                  if (claim.compensationAmount != null)
                    _buildInfoRow(
                      'Compensation Amount:', 
                      '€${claim.compensationAmount!.toStringAsFixed(2)}',
                      valueColor: Colors.green,
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Actions buttons
          if (claim.status == ClaimStatus.requiresAction)
            ElevatedButton.icon(
              onPressed: () => _showActionRequiredDialog(),
              icon: const Icon(Icons.priority_high),
              label: const Text('Take Required Action'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            
          if (claim.status == ClaimStatus.rejected)
            ElevatedButton.icon(
              onPressed: () => _showAppealDialog(),
              icon: const Icon(Icons.gavel),
              label: const Text('Submit Appeal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showActionRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Action Required'),
        content: const Text(
          'Additional information is needed for this claim. Please provide the requested information to proceed.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Provide Information'),
          ),
        ],
      ),
    );
  }
  
  void _showAppealDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Appeal'),
        content: const Text(
          'You can appeal this decision by providing additional information or documentation to support your claim.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start Appeal'),
          ),
        ],
      ),
    );
  }
}
