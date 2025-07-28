import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart'; // Import for safe l10n extension
import '../models/claim.dart';
import 'claim_attachment_screen.dart';

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
  
  @override
  void initState() {
    super.initState();
    // Set default values
    _nameController.text = 'Piotr Styla';
    _emailController.text = 'p.styla@gmail.com';
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
        reason: widget.flightData['forceSubmit'] == true 
            ? 'Passenger submitted claim despite apparent ineligibility'
            : widget.flightData['reason'] ?? 'Compensation claim',
        compensationAmount: (widget.flightData['potentialCompensationAmount'] as num?)?.toDouble() ?? 600.0,
        status: 'pending',
        bookingReference: '', // Will be filled in confirmation flow
        attachmentUrls: [], // Will be added in confirmation flow
      );
      
      print('Claim object created successfully');
      print('Navigating to ClaimConfirmationScreen...');

      // Navigate to the attachments screen first (complete flow: form → attachments → confirmation)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClaimAttachmentScreen(
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
    
    final String compensation = widget.flightData['compensation_amount_eur'] != null 
        ? '€${widget.flightData['compensation_amount_eur']}' 
        : '€250';

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
