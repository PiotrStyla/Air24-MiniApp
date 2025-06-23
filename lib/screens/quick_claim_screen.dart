import 'package:flutter/material.dart';
import 'faq_screen.dart';
import '../services/auth_service.dart';
import 'package:uuid/uuid.dart';
import '../models/claim.dart';
import '../services/claim_tracking_service.dart';
import '../core/services/service_initializer.dart';
import 'package:intl/intl.dart';
import '../utils/translation_helper.dart';

class QuickClaimScreen extends StatefulWidget {
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime flightDate;
  final String? reason;
  final double? compensationAmount;

  const QuickClaimScreen({
    Key? key,
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.flightDate,
    this.reason,
    this.compensationAmount,
  }) : super(key: key);

  @override
  State<QuickClaimScreen> createState() => _QuickClaimScreenState();
}

class _QuickClaimScreenState extends State<QuickClaimScreen> {
  bool _isSubmitting = false;
  String? _errorMessage;
  late TextEditingController _flightNumberController;
  late TextEditingController _departureAirportController;
  late TextEditingController _arrivalAirportController;
  late TextEditingController _reasonController;
  late TextEditingController _compensationAmountController;
  late DateTime _flightDate;

  @override
  void initState() {
    super.initState();
    _flightNumberController = TextEditingController(text: widget.flightNumber);
    _departureAirportController = TextEditingController(text: widget.departureAirport);
    _arrivalAirportController = TextEditingController(text: widget.arrivalAirport);
    _reasonController = TextEditingController(text: widget.reason ?? '');
    _compensationAmountController = TextEditingController(text: widget.compensationAmount?.toString() ?? '');
    _flightDate = widget.flightDate;
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _reasonController.dispose();
    _compensationAmountController.dispose();
    super.dispose();
  }

  Future<void> _submitClaim() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      final authService = ServiceInitializer.get<AuthService>();
      final user = authService.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = TranslationHelper.getString(context, 'errorMustBeLoggedIn', fallback: 'You must be logged in to submit a claim.');
          _isSubmitting = false;
        });
        return;
      }
      final claim = Claim(
        bookingReference: '', // Placeholder for quick claim
        id: const Uuid().v4(),
        userId: user.uid,
        airlineName: 'Not specified',
        flightNumber: _flightNumberController.text.trim(),
        flightDate: _flightDate,
        departureAirport: _departureAirportController.text.trim(),
        arrivalAirport: _arrivalAirportController.text.trim(),
        reason: _reasonController.text.trim(),
        compensationAmount: double.tryParse(_compensationAmountController.text) ?? 0.0,
        status: 'pending',
      );
      final claimTrackingService = ServiceInitializer.get<ClaimTrackingService>();
      await claimTrackingService.saveClaim(claim);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(TranslationHelper.getString(context, 'dialogTitleSuccess', fallback: 'Success')),
            content: Text(TranslationHelper.getString(context, 'dialogContentClaimSubmitted', fallback: 'Your claim has been submitted!')),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text(TranslationHelper.getString(context, 'dialogButtonOK', fallback: 'OK')),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = TranslationHelper.getString(context, 'errorFailedToSubmitClaim', fallback: 'Failed to submit claim. Please try again.');
        _isSubmitting = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(TranslationHelper.getString(context, 'dialogTitleError', fallback: 'Error')),
          content: Text(_errorMessage!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(TranslationHelper.getString(context, 'dialogButtonOK', fallback: 'OK')),
            ),
          ],
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationHelper.getString(context, 'quickClaimTitle', fallback: 'Quick Claim')),
        actions: [
          Tooltip(
            message: TranslationHelper.getString(context, 'tooltipFaqHelp', fallback: 'FAQ & Help'),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        TranslationHelper.getString(context, 'quickClaimInfoBanner', fallback: 'Review and edit your flight claim details below. All required fields must be filled. Tap the info icons for help.'),
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _flightNumberController,
                      decoration: InputDecoration(
                        labelText: '${TranslationHelper.getString(context, 'flightNumber', fallback: 'Flight Number')} *',
                        helperText: TranslationHelper.getString(context, 'flightNumberHintQuickClaim', fallback: 'Usually a 2-letter airline code and digits, e.g. LH1234'),
                      ),
                      validator: (value) => value == null || value.isEmpty ? TranslationHelper.getString(context, 'validatorFlightNumberRequired', fallback: 'Flight number is required') : null,
                    ),
                  ),
                  Tooltip(
                    message: TranslationHelper.getString(context, 'tooltipFlightNumberQuickClaim', fallback: 'Enter your flight number as shown on your ticket or boarding pass.'),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: '${TranslationHelper.getString(context, 'flightDate', fallback: 'Flight Date')} *'),
                      child: Text(DateFormat.yMMMd().format(_flightDate)),
                    ),
                  ),
                  Tooltip(
                    message: TranslationHelper.getString(context, 'tooltipFlightDateQuickClaim', fallback: 'The date your flight departed or was scheduled to depart.'),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _departureAirportController,
                      decoration: InputDecoration(
                        labelText: '${TranslationHelper.getString(context, 'departureAirport', fallback: 'Departure Airport')} *',
                        helperText: TranslationHelper.getString(context, 'departureAirportHintQuickClaim', fallback: 'e.g. FRA for Frankfurt, LHR for London Heathrow'),
                      ),
                      validator: (value) => value == null || value.isEmpty ? TranslationHelper.getString(context, 'validatorDepartureAirportRequired', fallback: 'Departure airport is required') : null,
                    ),
                  ),
                  Tooltip(
                    message: TranslationHelper.getString(context, 'tooltipDepartureAirportQuickClaim', fallback: 'Enter the IATA code of the airport where your flight started.'),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _arrivalAirportController,
                      decoration: InputDecoration(
                        labelText: '${TranslationHelper.getString(context, 'arrivalAirport', fallback: 'Arrival Airport')} *',
                        helperText: TranslationHelper.getString(context, 'arrivalAirportHintQuickClaim', fallback: 'e.g. JFK for New York, CDG for Paris'),
                      ),
                      validator: (value) => value == null || value.isEmpty ? TranslationHelper.getString(context, 'validatorArrivalAirportRequired', fallback: 'Arrival airport is required') : null,
                    ),
                  ),
                  Tooltip(
                    message: TranslationHelper.getString(context, 'tooltipArrivalAirportQuickClaim', fallback: 'Enter the IATA code of the airport where your flight landed.'),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: TranslationHelper.getString(context, 'reasonForClaimLabel', fallback: 'Reason *'),
                        hintText: TranslationHelper.getString(context, 'hintTextReasonQuickClaim', fallback: 'Reason (delay, cancellation, etc.)'),
                        helperText: TranslationHelper.getString(context, 'reasonForClaimHint', fallback: 'State why you are claiming: delay, cancellation, denied boarding, etc.'),
                      ),
                      validator: (value) => value == null || value.isEmpty ? TranslationHelper.getString(context, 'validatorReasonRequired', fallback: 'Reason is required') : null,
                    ),
                  ),
                  Tooltip(
                    message: TranslationHelper.getString(context, 'tooltipReasonQuickClaim', fallback: 'Describe the issue: e.g. delayed more than 3 hours, cancelled, overbooked.'),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _compensationAmountController,
                      decoration: InputDecoration(
                        labelText: TranslationHelper.getString(context, 'compensationAmountOptionalLabel', fallback: 'Compensation Amount (optional)'),
                        helperText: TranslationHelper.getString(context, 'compensationAmountHint', fallback: 'If you know the amount you are eligible for, enter it here.'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Tooltip(
                    message: TranslationHelper.getString(context, 'tooltipCompensationAmountQuickClaim', fallback: 'Leave blank if unsure. Typical EU compensation: €250-€600 depending on distance.'),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _submitClaim();
                          }
                        },
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(TranslationHelper.getString(context, 'submitClaim', fallback: 'Submit Claim')),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TranslationHelper.getString(context, 'tipsAndRemindersTitle', fallback: 'Tips & Reminders'),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    SizedBox(height: 6),
                    Text(TranslationHelper.getString(context, 'tipSecureData', fallback: '• Your data is securely processed and only used for compensation claims.')),
                    Text(TranslationHelper.getString(context, 'tipCheckEligibility', fallback: '• Make sure your flight is eligible for compensation (e.g., delay >3h, cancellation, denied boarding).')),
                    Text(TranslationHelper.getString(context, 'tipDoubleCheckDetails', fallback: '• Double-check all details before submitting to avoid delays.')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
