import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/claim_submission_viewmodel.dart';
import '../models/flight.dart';

class ClaimSubmissionScreen extends StatelessWidget {
  const ClaimSubmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClaimSubmissionViewModel(),
      child: const _ClaimSubmissionForm(),
    );
  }
}

class _ClaimSubmissionForm extends StatefulWidget {
  const _ClaimSubmissionForm();

  @override
  State<_ClaimSubmissionForm> createState() => _ClaimSubmissionFormState();
}

class _ClaimSubmissionFormState extends State<_ClaimSubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  final _flightNumberController = TextEditingController();
  final _departureAirportController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  final _reasonController = TextEditingController(); // For simplicity
  DateTime? _selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _flightNumberController.text = arguments['prefillFlightNumber'] ?? '';
      _departureAirportController.text = arguments['prefillDepartureAirport'] ?? '';
      _arrivalAirportController.text = arguments['prefillArrivalAirport'] ?? '';
      _selectedDate = arguments['prefillFlightDate'];
    }
  }

  @override
  void dispose() {
    _flightNumberController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _reasonController.dispose();
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
      });
    }
  }

  void _submitClaim(ClaimSubmissionViewModel viewModel) {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a flight date.')),
        );
        return;
      }

      final flight = Flight(
        flightNumber: _flightNumberController.text,
        flightDate: _selectedDate!,
        departureAirport: _departureAirportController.text,
        arrivalAirport: _arrivalAirportController.text,

      );

      viewModel.submitClaim(flight, _reasonController.text).then((_) {
        if (viewModel.errorMessage.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Claim submitted successfully!')),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Submission Failed: ${viewModel.errorMessage}')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClaimSubmissionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit New Claim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No date chosen!'
                        : 'Flight Date: ${DateFormat.yMd().format(_selectedDate!)}'),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : () => _submitClaim(viewModel),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Claim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
