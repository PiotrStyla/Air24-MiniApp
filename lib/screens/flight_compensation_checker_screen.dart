import 'package:flutter/material.dart';
import '../services/aerodatabox_service.dart';

class FlightCompensationCheckerScreen extends StatefulWidget {
  const FlightCompensationCheckerScreen({Key? key}) : super(key: key);

  @override
  State<FlightCompensationCheckerScreen> createState() => _FlightCompensationCheckerScreenState();
}

class _FlightCompensationCheckerScreenState extends State<FlightCompensationCheckerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _flightNumberController = TextEditingController();
  final _dateController = TextEditingController();
  // Initialize service with real API data only
  final _aerodataboxService = AeroDataBoxService();
  
  bool _isLoading = false;
  Map<String, dynamic>? _compensationResult;
  String? _errorMessage;

  @override
  void dispose() {
    _flightNumberController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _checkCompensation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _compensationResult = null;
      _errorMessage = null;
    });

    try {
      final result = await _aerodataboxService.checkCompensationEligibility(
        flightNumber: _flightNumberController.text.trim(),
        date: _dateController.text.isEmpty ? null : _dateController.text.trim(),
      );
      
      setState(() {
        _compensationResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Compensation Checker'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout
          final maxWidth = constraints.maxWidth;
          final isWideScreen = maxWidth > 600;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(isWideScreen ? 32.0 : 16.0),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: isWideScreen ? 600 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check if your flight is eligible for EU261 compensation',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _flightNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Flight Number (e.g., BA123)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a flight number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  labelText: 'Date (YYYY-MM-DD, optional)',
                                  border: OutlineInputBorder(),
                                  hintText: 'Leave empty for today',
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    _dateController.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                  }
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _checkCompensation,
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Check Compensation Eligibility'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage != null)
                      Card(
                        color: Colors.red[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(_errorMessage!),
                            ],
                          ),
                        ),
                      ),
                    if (_compensationResult != null)
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flight ${_compensationResult!['flightNumber']} - ${_compensationResult!['airline']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Status', _compensationResult!['status'] ?? 'Unknown'),
                              _buildInfoRow('From', _compensationResult!['departureAirport'] ?? 'Unknown'),
                              _buildInfoRow('To', _compensationResult!['arrivalAirport'] ?? 'Unknown'),
                              _buildInfoRow('Delay', '${_compensationResult!['delayMinutes'] ?? 0} minutes'),
                              const Divider(),
                              const SizedBox(height: 8),
                              _buildEligibilitySection(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEligibilitySection() {
    final isEligible = _compensationResult!['isEligibleForCompensation'] ?? false;
    final compensationAmount = _compensationResult!['potentialCompensationAmount'] ?? 0;
    final currency = _compensationResult!['currency'] ?? 'EUR';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isEligible ? Icons.check_circle : Icons.cancel,
              color: isEligible ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isEligible
                    ? 'Your flight is eligible for compensation!'
                    : 'Your flight is not eligible for compensation.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isEligible ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isEligible)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Potential Compensation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$compensationAmount $currency',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Contact the airline to claim your compensation under EU Regulation 261/2004.',
                ),
              ],
            ),
          ),
        if (!isEligible)
          Text(
            'Reason: ${_getIneligibilityReason()}',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  String _getIneligibilityReason() {
    final isDelayedOver3Hours = _compensationResult!['isDelayedOver3Hours'] ?? false;
    final isUnderEuJurisdiction = _compensationResult!['isUnderEuJurisdiction'] ?? false;
    
    if (!isDelayedOver3Hours) {
      return 'Flight delay is less than 3 hours';
    } else if (!isUnderEuJurisdiction) {
      return 'Flight is not under EU jurisdiction';
    } else {
      return 'Unknown reason';
    }
  }
}
