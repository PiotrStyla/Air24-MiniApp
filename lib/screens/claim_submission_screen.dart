import 'package:flutter/material.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _flightNumberController,
                decoration: const InputDecoration(labelText: 'Flight Number *'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickFlightDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Flight Date *'),
                  child: Text(_flightDate != null
                      ? DateFormat.yMMMd().format(_flightDate!)
                      : 'Select date'),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _departureAirportController,
                decoration: const InputDecoration(labelText: 'Departure Airport *'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _arrivalAirportController,
                decoration: const InputDecoration(labelText: 'Arrival Airport *'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason (delay, cancellation, etc.) *'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _compensationAmountController,
                decoration: const InputDecoration(labelText: 'Compensation Amount (optional)'),
                keyboardType: TextInputType.number,
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
            ],
          ),
        ),
      ),
    );
  }
}
