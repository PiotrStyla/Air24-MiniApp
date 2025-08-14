import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart'; // Import for safe l10n extension
import '../models/claim.dart';
import 'claim_review_screen.dart';

class CompensationClaimFormScreen extends StatefulWidget {
  final Map<String, dynamic> flightData;
  
  const CompensationClaimFormScreen({Key? key, required this.flightData}) : super(key: key);

  @override
  _CompensationClaimFormScreenState createState() => _CompensationClaimFormScreenState();
}

class _CompensationClaimFormScreenState extends State<CompensationClaimFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Simple controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Set default values
    _nameController.text = 'Piotr Styla';
    _emailController.text = 'p.styla@gmail.com';
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-fill reason based on flight data (after context is available)
    if (_reasonController.text.isEmpty) {
      _autoFillReason();
    }
  }
  
  /// Auto-fill the reason for claim based on flight data and localize it
  void _autoFillReason() {
    print('🔍 Auto-filling reason for claim...');
    print('📊 Flight data: ${widget.flightData}');
    
    String reason = '';
    
    // Check flight status to determine reason
    final flightStatus = widget.flightData['status']?.toString().toLowerCase() ?? '';
    final delayMinutes = widget.flightData['delay_minutes'] as int? ?? 0;
    
    print('✈️ Flight status: "$flightStatus"');
    print('⏱️ Delay minutes: $delayMinutes');
    
    if (flightStatus.contains('cancelled') || flightStatus.contains('canceled')) {
      reason = context.l10n.flightCancellationReason;
      print('❌ Using cancellation reason: $reason');
    } else if (flightStatus.contains('delayed') || delayMinutes > 180) {
      reason = context.l10n.flightDelayReason;
      print('⏰ Using delay reason: $reason');
    } else if (flightStatus.contains('diverted')) {
      reason = context.l10n.flightDiversionReason;
      print('🔄 Using diversion reason: $reason');
    } else {
      // Default reason for EU261 compensation
      reason = context.l10n.eu261CompensationReason;
      print('🇪🇺 Using default EU261 reason: $reason');
    }
    
    _reasonController.text = reason;
    print('✅ Reason controller text set to: "${_reasonController.text}"');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  /// Submit the claim and navigate to the complete confirmation flow
  void _submitClaim() {
    print('_submitClaim method called');
    _navigateToConfirmation();
  }
  
  void _navigateToConfirmation() {
    try {
      print('Creating Claim object...');
      print('Flight data: ${widget.flightData}');
      
      // Create enhanced flight data with user's email
      final enhancedFlightData = {
        ...widget.flightData,
        'userEmail': _emailController.text.trim(),
        'userName': _nameController.text.trim(),
      };
      
      // Create a Claim object from the form data and flight information
      final claim = Claim(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}', // Simple user ID without Firebase
        flightNumber: widget.flightData['flightNumber'] ?? 'Unknown',
        airlineName: widget.flightData['airline'] ?? 'Unknown Airline',
        flightDate: DateTime.tryParse(widget.flightData['flightDate'] ?? '') ?? DateTime.now(),
        departureAirport: widget.flightData['departure'] ?? 'Unknown',
        arrivalAirport: widget.flightData['arrival'] ?? 'Unknown',
        reason: _reasonController.text.isNotEmpty 
            ? _reasonController.text 
            : widget.flightData['reason'] ?? 'Compensation claim',
        compensationAmount: (widget.flightData['potentialCompensationAmount'] as num?)?.toDouble() ?? 600.0,
        status: 'pending',
        bookingReference: '', // Will be filled in confirmation flow
        attachmentUrls: [], // Will be added in confirmation flow
      );
      
      print('Claim object created successfully');
      print('Navigating to ClaimConfirmationScreen...');

      // Navigate directly to review screen (streamlined flow: form → review with attachments → email preview → send)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClaimReviewScreen(
            claim: claim,
            userEmail: _emailController.text.trim(), // Pass the user's email from the form
          ),
        ),
      );
      
      print('Navigation call completed');
    } catch (e, stackTrace) {
      print('Error in _navigateToConfirmation: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting claim: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract basic flight info
    final String airline = widget.flightData['airline'] is String 
        ? widget.flightData['airline'] 
        : widget.flightData['airline_name'] ?? 'Unknown Airline';
    
    final String flightNumber = widget.flightData['flight_number']?.toString() ?? 
                              widget.flightData['flight']?.toString() ?? 
                              'Unknown';
    
    // Get compensation amount from flight data
    final double compensationAmount = (widget.flightData['potentialCompensationAmount'] as num?)?.toDouble() ?? 
                                     (widget.flightData['compensation_amount_eur'] as num?)?.toDouble() ?? 
                                     600.0;
    final String compensation = '€${compensationAmount.toInt()}';

    // Ensure auto-fill happens when form is displayed
    if (_reasonController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoFillReason();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.compensationClaimForm),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Info Section
              Text(
                '${context.l10n.flight}: $airline $flightNumber',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${context.l10n.potentialCompensation}: $compensation',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 24),
              
              // Passenger Section
              Text(
                context.l10n.passengerInformation,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.fullName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? context.l10n.required : null,
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: context.l10n.emailAddress,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? context.l10n.required : null,
              ),
              const SizedBox(height: 12),
              
              // Compensation Amount Section
              Text(
                'Compensation Amount',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                initialValue: '€600',
                decoration: InputDecoration(
                  labelText: 'Compensation Amount',
                  border: const OutlineInputBorder(),
                  helperText: 'Auto-filled based on flight distance and EU261 regulations',
                  prefixIcon: const Icon(Icons.euro),
                ),
                readOnly: true,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              
              // Reason for Claim Section
              Text(
                context.l10n.reasonForClaim,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: context.l10n.reasonForClaim,
                  border: const OutlineInputBorder(),
                  helperText: context.l10n.reasonForClaimHint,
                ),
                maxLines: 3,
                readOnly: true,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    print('Submit button pressed!');
                    try {
                      if (_formKey.currentState!.validate()) {
                        print('Form validation passed, calling _submitClaim');
                        _submitClaim();
                      } else {
                        print('Form validation failed');
                      }
                    } catch (e) {
                      print('Error in submit button: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: Text(context.l10n.submitClaim),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
