import 'package:flutter/material.dart';
import 'faq_screen.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/claim.dart';
import '../services/firestore_service.dart';

class ClaimSubmissionScreen extends StatefulWidget {
  final String? prefillFlightNumber;
  final String? prefillDepartureAirport;
  final String? prefillArrivalAirport;
  final DateTime? prefillFlightDate;

  const ClaimSubmissionScreen({
    Key? key,
    this.prefillFlightNumber,
    this.prefillDepartureAirport,
    this.prefillArrivalAirport,
    this.prefillFlightDate,
  }) : super(key: key);

  @override
  State<ClaimSubmissionScreen> createState() => _ClaimSubmissionScreenState();
}

class _ClaimSubmissionScreenState extends State<ClaimSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _flightNumberController;
  late final TextEditingController _departureAirportController;
  late final TextEditingController _arrivalAirportController;
  final _reasonController = TextEditingController();
  final _compensationAmountController = TextEditingController();
  DateTime? _flightDate;

  @override
  void initState() {
    super.initState();
    _flightNumberController = TextEditingController(text: widget.prefillFlightNumber ?? '');
    _departureAirportController = TextEditingController(text: widget.prefillDepartureAirport ?? '');
    _arrivalAirportController = TextEditingController(text: widget.prefillArrivalAirport ?? '');
    _flightDate = widget.prefillFlightDate;
  }
  bool _isSubmitting = false;
  String? _errorMessage;

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
    if (!_formKey.currentState!.validate() || _flightDate == null) {
      setState(() {
        _errorMessage = 'Please fill all required fields.';
      });
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'You must be logged in to submit a claim.';
          _isSubmitting = false;
        });
        return;
      }
      final claim = Claim(
        id: const Uuid().v4(),
        userId: user.uid,
        flightNumber: _flightNumberController.text.trim(),
        flightDate: _flightDate!,
        departureAirport: _departureAirportController.text.trim(),
        arrivalAirport: _arrivalAirportController.text.trim(),
        reason: _reasonController.text.trim(),
        compensationAmount: _compensationAmountController.text.isNotEmpty
            ? double.tryParse(_compensationAmountController.text)
            : null,
        status: 'pending',
      );
      await FirestoreService().setClaim(claim);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to submit claim. Please try again.';
        _isSubmitting = false;
      });
    }
  }

  Future<void> _pickFlightDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _flightDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Claim'),
        actions: [
          Tooltip(
            message: 'FAQ & Help',
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
                        'Please fill in your claim details below. All required fields must be completed. Tap the info icons for help.',
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
                      decoration: const InputDecoration(
                        labelText: 'Flight Number *',
                        helperText: 'Usually a 2-letter airline code and digits, e.g. LH1234',
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  Tooltip(
                    message: 'Enter your flight number as shown on your ticket or boarding pass.',
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
                    child: InkWell(
                      onTap: _pickFlightDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Flight Date *'),
                        child: Text(_flightDate != null
                            ? DateFormat.yMMMd().format(_flightDate!)
                            : 'Select date'),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'The date your flight departed or was scheduled to depart.',
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
                      decoration: const InputDecoration(
                        labelText: 'Departure Airport *',
                        helperText: 'e.g. FRA for Frankfurt, LHR for London Heathrow',
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  Tooltip(
                    message: 'Enter the IATA code of the airport where your flight started.',
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
                      decoration: const InputDecoration(
                        labelText: 'Arrival Airport *',
                        helperText: 'e.g. JFK for New York, CDG for Paris',
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  Tooltip(
                    message: 'Enter the IATA code of the airport where your flight landed.',
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
                      decoration: const InputDecoration(
                        labelText: 'Reason *',
                        hintText: 'Reason (delay, cancellation, etc.)',
                        helperText: 'State why you are claiming: delay, cancellation, denied boarding, etc.',
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  Tooltip(
                    message: 'Describe the issue: e.g. delayed more than 3 hours, cancelled, overbooked.',
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
                      decoration: const InputDecoration(
                        labelText: 'Compensation Amount (optional)',
                        helperText: 'If you know the amount you are eligible for, enter it here.',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Tooltip(
                    message: 'Leave blank if unsure. Typical EU compensation: €250-€600 depending on distance.',
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
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitClaim,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit'),
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
                  children: const [
                    Text(
                      'Tips & Reminders',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    SizedBox(height: 6),
                    Text('• Your data is securely processed and only used for compensation claims.'),
                    Text('• Make sure your flight is eligible for compensation (e.g., delay >3h, cancellation, denied boarding).'),
                    Text('• Double-check all details before submitting to avoid delays.'),
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
