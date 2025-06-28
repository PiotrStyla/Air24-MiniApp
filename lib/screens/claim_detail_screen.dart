import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';

import '../models/claim.dart';
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
  Claim? _claim;
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
        title: Text(AppLocalizations.of(context)!.claimDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.refresh,
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
              AppLocalizations.of(context)!.errorLoadingClaim,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? AppLocalizations.of(context)!.unknownError,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadClaimDetails,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
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
              AppLocalizations.of(context)!.claimNotFound,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.claimNotFoundDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.backToDashboard),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildClaimStatusSection(BuildContext context) {
    final claim = _claim!;
    
    // Helper function to get color for status
    Color getStatusColor(String status) {
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
          return Colors.green.shade800;
        case 'appealing':
          return Colors.amber;
        default:
          return Colors.grey;
      }
    }
    
    // Helper function to get icon for status
    IconData getStatusIcon(String status) {
      switch (status) {
        case 'submitted':
          return Icons.send;
        case 'reviewing':
          return Icons.search;
        case 'action_required':
          return Icons.warning_amber;
        case 'processing':
          return Icons.loop;
        case 'approved':
          return Icons.check_circle;
        case 'rejected':
          return Icons.cancel;
        case 'paid':
          return Icons.paid;
        case 'appealing':
          return Icons.gavel;
        default:
          return Icons.help_outline;
      }
    }
    
    // Helper function to get display name for status
    String getStatusDisplayName(String status) {
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
    
    // Get next steps based on status
    List<String> getNextSteps(String status) {
      switch (status) {
        case 'submitted':
          return ['Your claim is being processed', 'We will notify you of updates'];
        case 'reviewing':
          return ['Our team is reviewing your claim', 'This usually takes 3-5 business days'];
        case 'action_required':
          return ['Please provide the requested information', 'Your claim is on hold until then'];
        case 'processing':
          return ['Your claim has been approved', 'Payment processing in progress'];
        case 'approved':
          return ['Your compensation has been approved', 'Payment will be issued soon'];
        case 'rejected':
          return ['Your claim has been rejected', 'You can appeal this decision'];
        case 'paid':
          return ['Your compensation has been paid', 'Thank you for using our service'];
        case 'appealing':
          return ['Your appeal is being reviewed', 'We will contact you with the result'];
        default:
          return ['Status unknown', 'Please contact support'];
      }
    }
    
    final statusColor = getStatusColor(claim.status);
    final statusIcon = getStatusIcon(claim.status);
    final statusName = getStatusDisplayName(claim.status);
    final nextSteps = getNextSteps(claim.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status icon and name
              Row(
                children: [
                  Icon(statusIcon, color: statusColor),
                  const SizedBox(width: 8),
                  Text(
                    statusName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          // Display next steps
          ...nextSteps.map((step) => Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_right,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    step,
                    style: TextStyle(
                      color: statusColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
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
          _buildClaimStatusSection(context),
          
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
                  _buildInfoRow('Departure:', claim.departureAirport),
                  _buildInfoRow('Arrival:', claim.arrivalAirport),
                  _buildInfoRow('Flight Date:', dateFormatter.format(claim.flightDate)),
                  _buildInfoRow('Reason:', claim.reason),
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
          if (claim.status == 'action_required')
            ElevatedButton.icon(
              onPressed: () => _showActionRequiredDialog(),
              icon: const Icon(Icons.priority_high),
              label: const Text('Take Required Action'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            
          if (claim.status == 'rejected')
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
