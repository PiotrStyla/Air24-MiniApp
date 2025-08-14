import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import '../services/aviation_stack_service.dart';
import 'compensation_claim_form_screen.dart';

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
    final _aviationStackService = AviationStackService(baseUrl: 'https://api.aviationstack.com/v1');
  
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
      // Try to check compensation eligibility with API
      try {
        final result = await _aviationStackService.checkCompensationEligibility(
          flightNumber: _flightNumberController.text.trim(),
          date: _dateController.text.isEmpty ? null : _dateController.text.trim(),
        );
        
        setState(() {
          _compensationResult = result;
          _isLoading = false;
        });
      } catch (apiError) {
        debugPrint('API error, using fallback: $apiError');
        
        // Use fallback data if API fails
        // Using same method without fallback parameter
        final result = await _aviationStackService.checkCompensationEligibility(
          flightNumber: _flightNumberController.text.trim(),
          date: _dateController.text.isEmpty ? null : _dateController.text.trim(),
        );
        
        setState(() {
          _compensationResult = result;
          _isLoading = false;
        });
      }
      
    } catch (e) {
      setState(() {
        _errorMessage = _getUserFriendlyErrorMessage(e.toString());
        _isLoading = false;
      });
    }
  }

  /// Convert technical error messages to user-friendly localized messages
  String _getUserFriendlyErrorMessage(String technicalError) {
    final localizations = context.l10n;
    
    // Convert technical errors to user-friendly messages
    if (technicalError.contains('404') || technicalError.contains('not found')) {
      return localizations.flightNotFoundError;
    } else if (technicalError.contains('400') || technicalError.contains('bad request')) {
      return localizations.invalidFlightNumberError;
    } else if (technicalError.contains('timeout') || technicalError.contains('connection')) {
      return localizations.networkTimeoutError;
    } else if (technicalError.contains('network') || technicalError.contains('internet')) {
      return localizations.networkError;
    } else if (technicalError.contains('server') || technicalError.contains('500')) {
      return localizations.serverError;
    } else if (technicalError.contains('rate limit') || technicalError.contains('429')) {
      return localizations.rateLimitError;
    } else {
      // Generic fallback message for unknown errors
      return localizations.generalFlightCheckError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.flightCompensationCheckerTitle),
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
                              Text(
                                context.l10n.checkEligibilityForEu261,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _flightNumberController,
                                decoration: InputDecoration(
                                  labelText: context.l10n.flightNumberPlaceholder,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.l10n.pleaseEnterFlightNumber;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  labelText: context.l10n.dateOptionalPlaceholder,
                                  border: const OutlineInputBorder(),
                                  hintText: context.l10n.leaveDateEmptyForToday,
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
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text(context.l10n.checkCompensationEligibility),
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
                              Text(
                                context.l10n.error,
                                style: const TextStyle(
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
                    // Show compensation result
                    if (_compensationResult != null) ...[
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.flightInfoFormat(
                                  _compensationResult!['flight_number']?.toString() ?? _flightNumberController.text,
                                  _compensationResult!['airline']?.toString() ?? context.l10n.unknown,
                                ),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                context.l10n.status, 
                                (_compensationResult!['status'] ?? context.l10n.unknown).toString()
                              ),
                              _buildInfoRow(
                                context.l10n.from, 
                                _compensationResult!['departure_airport'] ?? (_compensationResult!['route']?.toString().split(' - ').first) ?? context.l10n.unknown
                              ),
                              _buildInfoRow(
                                context.l10n.to, 
                                _compensationResult!['arrival_airport'] ?? (_compensationResult!['route']?.toString().split(' - ').last) ?? context.l10n.unknown
                              ),
                              _buildInfoRow(
                                context.l10n.delay, 
                                context.l10n.minutesFormat(_compensationResult!['delay_minutes'] ?? 0)
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              _buildEligibilitySection(),
                            ],
                          ),
                        ),
                      ),
                    ],
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
    final isEligible = _compensationResult!['is_eligible'] ?? false;
    final compensationAmount = _compensationResult!['compensation_amount_eur'] ?? 0;
    final currency = _compensationResult!['currency'] ?? 'EUR';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEligible) ...[
          // Eligible flight - show positive result
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.flightEligibleForCompensation,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                Text(
                  context.l10n.potentialCompensation,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                Text(
                  context.l10n.contactAirlineForClaim,
                ),
              ],
            ),
          ),
        ] else ...[
          // Apparently ineligible flight - show empowering messaging
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.flightMightNotBeEligible,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Airline data disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.knowYourRights,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.airlineDataDisclaimer,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.eu261Rights,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.dontLetAirlinesWin,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Submit Claim Anyway button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _submitClaimAnyway();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                context.l10n.submitClaimAnyway,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Navigate to claim form when user wants to submit claim anyway
  void _submitClaimAnyway() {
    // Navigate to the compensation claim form with the current flight data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompensationClaimFormScreen(
          flightData: {
            'flightNumber': _flightNumberController.text.trim(),
            'flightDate': _dateController.text.isEmpty ? null : _dateController.text.trim(),
            'forceSubmit': true, // Flag to indicate this is a forced submission
            ..._compensationResult ?? {},
          },
        ),
      ),
    );
  }
}
