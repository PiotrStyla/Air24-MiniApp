import 'package:flutter/material.dart';
import '../services/claim_validation_service.dart';

/// A comprehensive checklist widget for EU261 flight compensation claims
/// This helps users ensure they have all required information before submitting
class ClaimChecklistWidget extends StatefulWidget {
  /// The flight data for the claim
  final Map<String, dynamic> flightData;
  
  /// Callback when all items are checked
  final Function(bool) onChecklistComplete;

  const ClaimChecklistWidget({
    Key? key,
    required this.flightData,
    required this.onChecklistComplete,
  }) : super(key: key);

  @override
  _ClaimChecklistWidgetState createState() => _ClaimChecklistWidgetState();
}

class _ClaimChecklistWidgetState extends State<ClaimChecklistWidget> {
  // Checklist items state
  final Map<String, bool> _checklistItems = {
    'flightDetails': false,
    'delayOrCancellation': false,
    'euEligibility': false,
    'documents': false,
    'personalDetails': false,
    'deadline': false,
    'noPriorCompensation': false,
    'noExtraordinaryCircumstances': false,
  };

  // Items that can be auto-verified based on flight data
  final Map<String, bool> _autoVerifiedItems = {};

  // initState moved above to include validation scheduling
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Don't trigger validation here - will be done in initState only
  }
  
  @override
  void initState() {
    super.initState();
    _autoVerifyItems();
    
    // Schedule validation for after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateWithService();
    });
  }

  /// Auto-verify checklist items based on flight data
  void _autoVerifyItems() {
    final flight = widget.flightData;
    
    // Basic initial checks while we wait for the validation service
    // These will be updated by the validation service in _validateWithService()
    
    // Check if flight details are complete
    if (flight['flight_number'] != null && flight['departure_airport'] != null && 
        flight['arrival_airport'] != null && flight['departure_date'] != null) {
      _autoVerifiedItems['flightDetails'] = true;
      _checklistItems['flightDetails'] = true;
    }
    
    // Check if delay/cancellation is verified
    if (flight['delay_minutes'] != null && flight['delay_minutes'] >= 180) {
      _autoVerifiedItems['delayOrCancellation'] = true;
      _checklistItems['delayOrCancellation'] = true;
    } else if (flight['status'] != null && 
               flight['status'].toString().toLowerCase().contains('cancel')) {
      _autoVerifiedItems['delayOrCancellation'] = true;
      _checklistItems['delayOrCancellation'] = true;
    }
    
    // Check if EU eligibility is verified
    if (flight['eligible_for_compensation'] == true) {
      _autoVerifiedItems['euEligibility'] = true;
      _checklistItems['euEligibility'] = true;
    }
    
    // Update completion status
    _updateCompletionStatus();
  }
  
  /// Use the validation service to verify items where possible
  Future<void> _validateWithService() async {
    try {
      // Get validation results from the service
      final validationResults = await ClaimValidationService.validateChecklist(widget.flightData);
      
      // Update auto-verified items based on validation results
      setState(() {
        validationResults.forEach((key, isValid) {
          if (isValid) {
            _autoVerifiedItems[key] = true;
            _checklistItems[key] = true;
          }
        });
        
        // Update completion status
        _updateCompletionStatus();
      });
    } catch (e) {
      debugPrint('Error validating checklist: $e');
      // Fall back to basic validation if the service fails
    }
  }

  /// Update the completion status and notify parent
  void _updateCompletionStatus() {
    final allChecked = !_checklistItems.values.contains(false);
    widget.onChecklistComplete(allChecked);
  }

  /// Toggle a checklist item
  void _toggleItem(String key) {
    // Don't allow toggling auto-verified items
    if (_autoVerifiedItems.containsKey(key) && _autoVerifiedItems[key] == true) {
      return;
    }
    
    setState(() {
      _checklistItems[key] = !_checklistItems[key]!;
      _updateCompletionStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                'Claim Eligibility Checklist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Please confirm all items below before submitting:',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          
          // Flight Details
          _buildChecklistItem(
            'flightDetails',
            'Flight details are correct',
            'Verify flight number, date, departure and arrival airports',
          ),
          
          // Delay or Cancellation
          _buildChecklistItem(
            'delayOrCancellation',
            'Flight was delayed 3+ hours or cancelled',
            'EU261 requires a delay of at least 3 hours or a cancellation',
          ),
          
          // EU Eligibility
          _buildChecklistItem(
            'euEligibility',
            'Flight is eligible under EU261',
            'Departed from EU airport or was operated by an EU carrier flying to the EU',
          ),
          
          // Supporting Documents
          _buildChecklistItem(
            'documents',
            'I have supporting documents ready',
            'Boarding pass, booking confirmation, delay/cancellation communication',
            autoVerified: false,
          ),
          
          // Personal Details
          _buildChecklistItem(
            'personalDetails',
            'My personal details are complete',
            'Full name, contact information, and payment details',
          ),
          
          // Claim Deadline
          _buildChecklistItem(
            'deadline',
            'Claim is within allowed time window',
            'Usually up to 2-3 years after the flight, depending on the country',
            autoVerified: false,
          ),
          
          // No Prior Compensation
          _buildChecklistItem(
            'noPriorCompensation',
            'I have not received prior compensation',
            'For the same flight from the airline or another service',
            autoVerified: false,
          ),
          
          // No Extraordinary Circumstances
          _buildChecklistItem(
            'noExtraordinaryCircumstances',
            'No extraordinary circumstances apply',
            'Weather events, political unrest, security risks, or strikes',
            autoVerified: false,
          ),
        ],
      ),
    );
  }

  /// Build a single checklist item with description tooltip
  Widget _buildChecklistItem(
    String key,
    String title,
    String description, {
    bool autoVerified = true,
  }) {
    final isAutoVerified = _autoVerifiedItems.containsKey(key) && 
                          _autoVerifiedItems[key] == true && 
                          autoVerified;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Checkbox or auto-verified icon
          if (isAutoVerified)
            Icon(Icons.verified, color: Colors.green.shade700)
          else
            Checkbox(
              value: _checklistItems[key],
              onChanged: (_) => _toggleItem(key),
              activeColor: Colors.green,
            ),
          
          // Clickable label with tooltip
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleItem(key),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: _checklistItems[key]! ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    message: description,
                    child: const Icon(Icons.info_outline, size: 16),
                  ),
                  
                  // Auto-verified label if applicable
                  if (isAutoVerified)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        '(Auto-verified)',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
