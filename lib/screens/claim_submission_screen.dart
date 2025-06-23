import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/claim.dart';
import 'claim_attachment_screen.dart';

class ClaimSubmissionScreen extends StatefulWidget {
  final Claim? initialClaim;

  const ClaimSubmissionScreen({super.key, this.initialClaim});

  @override
  State<ClaimSubmissionScreen> createState() => _ClaimSubmissionScreenState();
}

class _ClaimSubmissionScreenState extends State<ClaimSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _airlineNameController;
  late final TextEditingController _flightNumberController;
  late final TextEditingController _departureAirportController;
  late final TextEditingController _arrivalAirportController;
    late final TextEditingController _reasonController;
  late final TextEditingController _dateController;
  DateTime? _selectedDate;



  @override
  void initState() {
    super.initState();
    final claim = widget.initialClaim;
    _airlineNameController = TextEditingController(text: claim?.airlineName ?? '');
    _flightNumberController = TextEditingController(text: claim?.flightNumber ?? '');
    _departureAirportController = TextEditingController(text: claim?.departureAirport ?? '');
    _arrivalAirportController = TextEditingController(text: claim?.arrivalAirport ?? '');
    _reasonController = TextEditingController(text: claim?.reason ?? '');
    _selectedDate = claim?.flightDate;
    _dateController = TextEditingController(
      text: _selectedDate == null ? '' : DateFormat.yMd().format(_selectedDate!)
    );
  }

  @override
  void dispose() {
    _airlineNameController.dispose();
    _flightNumberController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(_selectedDate!); 
      });
    }
  }

  void _submitClaim() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a flight date.')),
        );
        return;
      }

      // Use copyWith on the initial claim if it exists, otherwise create a new one.
      // This preserves fields that aren't on this form, like passenger details.
      final newClaim = (widget.initialClaim ?? Claim(
              id: '', // Will be generated
              userId: '', // Will be set from auth
              flightNumber: '',
              airlineName: '',
              flightDate: _selectedDate!,
              departureAirport: '',
              arrivalAirport: '',
              reason: '',
              compensationAmount: 0,
              status: 'Draft',
              bookingReference: '',
            )).copyWith(
              flightNumber: _flightNumberController.text,
              airlineName: _airlineNameController.text,
              flightDate: _selectedDate!,
              departureAirport: _departureAirportController.text,
              arrivalAirport: _arrivalAirportController.text,
              reason: _reasonController.text,
            );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClaimAttachmentScreen(claim: newClaim),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit New Claim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _airlineNameController,
                decoration: const InputDecoration(labelText: 'Airline'),
                readOnly: true, // This field is pre-filled and not editable
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _flightNumberController,
                decoration: const InputDecoration(labelText: 'Flight Number'),
                validator: (value) => value!.isEmpty ? 'Please enter a flight number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departureAirportController,
                decoration: const InputDecoration(labelText: 'Departure Airport (IATA)'),
                validator: (value) => value!.isEmpty ? 'Please enter a departure airport' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arrivalAirportController,
                decoration: const InputDecoration(labelText: 'Arrival Airport (IATA)'),
                validator: (value) => value!.isEmpty ? 'Please enter an arrival airport' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason for Claim (e.g., Delay > 3h)'),
                validator: (value) => value!.isEmpty ? 'Please enter a reason' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Flight Date',
                  hintText: 'Select the date of your flight',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a flight date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _submitClaim(),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Continue to Attachments'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
