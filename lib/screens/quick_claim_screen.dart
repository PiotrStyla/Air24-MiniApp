import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart'; // Import for safe l10n extension
import '../models/claim.dart';
import '../models/flight.dart';
import '../services/auth_service_firebase.dart';
import '../core/services/service_initializer.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'claim_attachment_screen.dart';
import 'faq_screen.dart';

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

  void _prepareClaimForVerification() {
    if (_formKey.currentState!.validate()) {
      final authService = ServiceInitializer.get<FirebaseAuthService>();
      final user = authService.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = context.l10n.errorMustBeLoggedIn;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.dialogTitleError),
            content: Text(_errorMessage!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.dialogButtonOK),
              ),
            ],
          ),
        );
        return;
      }

      // Prepare claim object
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

      // Navigate to the attachment screen first (standard claim flow)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClaimAttachmentScreen(claim: claim),
        ),
      );
    }
  }

  // This method is no longer used as we now redirect to the standard claim flow

  final _formKey = GlobalKey<FormState>();
  
  // This method is no longer used as we now redirect to the standard claim flow

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.quickClaimTitle),
        actions: [
          Tooltip(
            message: context.l10n.tooltipFaqHelp,
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
                        context.l10n.quickClaimInfoBanner,
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
                        labelText: '${context.l10n.flightNumber} *',
                        helperText: context.l10n.flightNumberHintQuickClaim,
                      ),
                      validator: (value) => value == null || value.isEmpty ? context.l10n.validatorFlightNumberRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tooltipFlightNumberQuickClaim,
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
                      decoration: InputDecoration(labelText: '${context.l10n.flightDate} *'),
                      child: Text(DateFormat.yMMMd().format(_flightDate)),
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tooltipFlightDateQuickClaim,
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
                        labelText: '${context.l10n.departureAirport} *',
                        helperText: context.l10n.departureAirportHintQuickClaim,
                      ),
                      validator: (value) => value == null || value.isEmpty ? context.l10n.validatorDepartureAirportRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tooltipDepartureAirportQuickClaim,
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
                        labelText: '${context.l10n.arrivalAirport} *',
                        helperText: context.l10n.arrivalAirportHintQuickClaim,
                      ),
                      validator: (value) => value == null || value.isEmpty ? context.l10n.validatorArrivalAirportRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tooltipArrivalAirportQuickClaim,
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
                        labelText: context.l10n.reasonForClaimLabel,
                        hintText: context.l10n.hintTextReasonQuickClaim,
                        helperText: context.l10n.reasonForClaimHint,
                      ),
                      validator: (value) => value == null || value.isEmpty ? context.l10n.validatorReasonRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tooltipReasonQuickClaim,
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
                        labelText: context.l10n.compensationAmountOptionalLabel,
                        helperText: context.l10n.compensationAmountHint,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tooltipCompensationAmountQuickClaim,
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
                  onPressed: _isSubmitting ? null : _prepareClaimForVerification,
                  child: Text(context.l10n.continueToReview),
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
                      context.l10n.tipsAndRemindersTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    SizedBox(height: 6),
                    Text(context.l10n.tipSecureData),
                    Text(context.l10n.tipCheckEligibility),
                    Text(context.l10n.tipDoubleCheckDetails),
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
