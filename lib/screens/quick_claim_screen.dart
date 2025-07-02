import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n2/app_localizations.dart';
import '../models/claim.dart';
import '../core/services/service_initializer.dart';
import '../services/claim_tracking_service.dart';
import '../services/auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'claim_attachment_screen.dart';
import 'faq_screen.dart';
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

  void _prepareClaimForVerification() {
    if (_formKey.currentState!.validate()) {
      final authService = ServiceInitializer.get<AuthService>();
      final user = authService.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.errorMustBeLoggedIn;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.dialogTitleError),
            content: Text(_errorMessage!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.dialogButtonOK),
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
        title: Text(AppLocalizations.of(context)!.quickClaimTitle),
        actions: [
          Tooltip(
            message: AppLocalizations.of(context)!.tooltipFaqHelp,
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
                        AppLocalizations.of(context)!.quickClaimInfoBanner,
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
                        labelText: '${AppLocalizations.of(context)!.flightNumber} *',
                        helperText: AppLocalizations.of(context)!.flightNumberHintQuickClaim,
                      ),
                      validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.validatorFlightNumberRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.tooltipFlightNumberQuickClaim,
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
                      decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.flightDate} *'),
                      child: Text(DateFormat.yMMMd().format(_flightDate)),
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.tooltipFlightDateQuickClaim,
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
                        labelText: '${AppLocalizations.of(context)!.departureAirport} *',
                        helperText: AppLocalizations.of(context)!.departureAirportHintQuickClaim,
                      ),
                      validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.validatorDepartureAirportRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.tooltipDepartureAirportQuickClaim,
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
                        labelText: '${AppLocalizations.of(context)!.arrivalAirport} *',
                        helperText: AppLocalizations.of(context)!.arrivalAirportHintQuickClaim,
                      ),
                      validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.validatorArrivalAirportRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.tooltipArrivalAirportQuickClaim,
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
                        labelText: AppLocalizations.of(context)!.reasonForClaimLabel,
                        hintText: AppLocalizations.of(context)!.hintTextReasonQuickClaim,
                        helperText: AppLocalizations.of(context)!.reasonForClaimHint,
                      ),
                      validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.validatorReasonRequired : null,
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.tooltipReasonQuickClaim,
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
                        labelText: AppLocalizations.of(context)!.compensationAmountOptionalLabel,
                        helperText: AppLocalizations.of(context)!.compensationAmountHint,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.tooltipCompensationAmountQuickClaim,
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
                  child: Text(AppLocalizations.of(context)!.continueToReview),
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
                      AppLocalizations.of(context)!.tipsAndRemindersTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    SizedBox(height: 6),
                    Text(AppLocalizations.of(context)!.tipSecureData),
                    Text(AppLocalizations.of(context)!.tipCheckEligibility),
                    Text(AppLocalizations.of(context)!.tipDoubleCheckDetails),
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
