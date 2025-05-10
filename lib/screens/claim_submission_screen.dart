import 'package:flutter/material.dart';
import 'faq_screen.dart';
import '../services/airline_procedure_service.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import '../models/claim.dart';
import '../services/firestore_service.dart';
import '../services/claim_validation_service.dart';
import '../services/opensky_api_service.dart';

class ClaimSubmissionScreen extends StatefulWidget {
  final String? prefillFlightNumber;
  final String? prefillDepartureAirport;
  final String? prefillArrivalAirport;
  final DateTime? prefillFlightDate;
  final String? prefillReason;

  const ClaimSubmissionScreen({
    Key? key,
    this.prefillFlightNumber,
    this.prefillDepartureAirport,
    this.prefillArrivalAirport,
    this.prefillFlightDate,
    this.prefillReason,
  }) : super(key: key);

  @override
  State<ClaimSubmissionScreen> createState() => _ClaimSubmissionScreenState();
}

class _ClaimSubmissionScreenState extends State<ClaimSubmissionScreen> {
  // TODO: Replace with secure storage or environment variables in production!
  static const String _openSkyUsername = 'Piotr Styła';
  static const String _openSkyPassword = 'HippiH-01HippiH-01';

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _flightNumberController;
  late final TextEditingController _departureAirportController;
  late final TextEditingController _arrivalAirportController;
  final _reasonController = TextEditingController();
  final _compensationAmountController = TextEditingController();
  DateTime? _flightDate;

  AirlineClaimProcedure? _airlineProcedure;
  String? _airlineProcedureError;

  double? _suggestedCompensation;

  static double? _estimateDistanceKm(String dep, String arr) {
    // Simple hardcoded sample for demo; in production, use a real airport DB
    final airportCoords = {
      'FRA': [50.0379, 8.5622], // Frankfurt
      'LHR': [51.4700, -0.4543], // London Heathrow
      'CDG': [49.0097, 2.5479], // Paris CDG
      'JFK': [40.6413, -73.7781], // New York JFK
      'WAW': [52.1657, 20.9671], // Warsaw
      'AMS': [52.3105, 4.7683], // Amsterdam
      'IST': [41.2753, 28.7519], // Istanbul
      // Add more as needed
    };
    final depC = airportCoords[dep.toUpperCase()];
    final arrC = airportCoords[arr.toUpperCase()];
    if (depC == null || arrC == null) return null;
    double toRad(double deg) => deg * 3.1415926535 / 180.0;
    final lat1 = toRad(depC[0]), lon1 = toRad(depC[1]);
    final lat2 = toRad(arrC[0]), lon2 = toRad(arrC[1]);
    const R = 6371.0;
    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;
    final a = (sin(dLat/2) * sin(dLat/2)) + cos(lat1) * cos(lat2) * (sin(dLon/2) * sin(dLon/2));
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    return R * c;
  }

  void _suggestCompensation() {
    final reason = _reasonController.text.toLowerCase();
    final dep = _departureAirportController.text.trim();
    final arr = _arrivalAirportController.text.trim();
    if (reason.contains('delay') || reason.contains('cancel')) {
      final dist = _estimateDistanceKm(dep, arr);
      if (dist != null) {
        if (dist < 1500) {
          _suggestedCompensation = 250;
        } else if (dist < 3500) {
          _suggestedCompensation = 400;
        } else {
          _suggestedCompensation = 600;
        }
      } else {
        _suggestedCompensation = null;
      }
    } else {
      _suggestedCompensation = null;
    }
  }


  @override
  void didUpdateWidget(covariant ClaimSubmissionScreen oldWidget) {
    print('didUpdateWidget prefill: flightNumber=${widget.prefillFlightNumber}, depIcao=${widget.prefillDepartureAirport}, arrIcao=${widget.prefillArrivalAirport}, schedDate=${widget.prefillFlightDate}, reason=${widget.prefillReason}');
    super.didUpdateWidget(oldWidget);
    // Update controllers if the prefill values change
    if (widget.prefillFlightNumber != null && widget.prefillFlightNumber != oldWidget.prefillFlightNumber) {
      _flightNumberController.text = widget.prefillFlightNumber!;
    }
    if (widget.prefillDepartureAirport != null && widget.prefillDepartureAirport != oldWidget.prefillDepartureAirport) {
      _departureAirportController.text = widget.prefillDepartureAirport!;
    }
    if (widget.prefillArrivalAirport != null && widget.prefillArrivalAirport != oldWidget.prefillArrivalAirport) {
      _arrivalAirportController.text = widget.prefillArrivalAirport!;
    }
    if (widget.prefillFlightDate != null && widget.prefillFlightDate != oldWidget.prefillFlightDate) {
      setState(() {
        _flightDate = widget.prefillFlightDate;
      });
    }
    if (widget.prefillReason != null && widget.prefillReason != oldWidget.prefillReason) {
      _reasonController.text = widget.prefillReason!;
    }
  }

  @override
  void initState() {
    print('initState prefill: flightNumber=${widget.prefillFlightNumber}, depIcao=${widget.prefillDepartureAirport}, arrIcao=${widget.prefillArrivalAirport}, schedDate=${widget.prefillFlightDate}, reason=${widget.prefillReason}');
    super.initState();
    _flightNumberController = TextEditingController();
    _departureAirportController = TextEditingController();
    _arrivalAirportController = TextEditingController();
    // Set prefill values after controllers are created
    if (widget.prefillFlightNumber != null && widget.prefillFlightNumber!.isNotEmpty) {
      _flightNumberController.text = widget.prefillFlightNumber!;
    }
    if (widget.prefillDepartureAirport != null && widget.prefillDepartureAirport!.isNotEmpty) {
      _departureAirportController.text = widget.prefillDepartureAirport!;
    }
    if (widget.prefillArrivalAirport != null && widget.prefillArrivalAirport!.isNotEmpty) {
      _arrivalAirportController.text = widget.prefillArrivalAirport!;
    }
    _flightDate = widget.prefillFlightDate;
    if (widget.prefillReason != null && widget.prefillReason!.isNotEmpty) {
      _reasonController.text = widget.prefillReason!;
    }
    _flightNumberController.addListener(_onFlightNumberChanged);
    _reasonController.addListener(_onClaimFieldsChanged);
    _departureAirportController.addListener(_onClaimFieldsChanged);
    _arrivalAirportController.addListener(_onClaimFieldsChanged);
    if (_flightNumberController.text.isNotEmpty) {
      _onFlightNumberChanged();
    }
    _suggestCompensation();
  }

  Future<void> _suggestCorrectFlightDataIfNeeded() async {
    // Only trigger if flight number is entered but validation fails for date/airport
    if (_flightNumberController.text.trim().isEmpty || _flightDate == null) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final claim = Claim(
      id: '',
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
    final userClaims = await FirestoreService().getClaimsForUser(user.uid);
    final validation = await ClaimValidationService.validateClaim(
      claim,
      userClaims,
      verifyWithOpenSky: false,
    );
    // If only the flight number is valid, try to help the user
    if (validation.errors.any((e) => e.contains('Invalid departure airport') || e.contains('Invalid arrival airport'))) {
      // Try to find correct data by flight number
      final matches = await OpenSkyApiService.findFlightsByFlightNumber(
        flightNumber: _flightNumberController.text.trim(),
        flightDate: _flightDate!,
        username: _openSkyUsername,
        password: _openSkyPassword,
      );
      if (matches.isNotEmpty) {
        final f = matches.first;
        final suggestedDep = f['estDepartureAirport'] ?? '';
        final suggestedArr = f['estArrivalAirport'] ?? '';
        // Show dialog to user
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Did you mean this flight?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Flight: ${f['callsign'] ?? ''}'),
                  if (suggestedDep.isNotEmpty) Text('Departure: $suggestedDep'),
                  if (suggestedArr.isNotEmpty) Text('Arrival: $suggestedArr'),
                  if (f['firstSeen'] != null)
                    Text('Date: '
                        '${DateTime.fromMillisecondsSinceEpoch((f['firstSeen'] as int) * 1000).toLocal().toString().split(' ')[0]}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Autofill'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      if (suggestedDep.isNotEmpty) _departureAirportController.text = suggestedDep;
                      if (suggestedArr.isNotEmpty) _arrivalAirportController.text = suggestedArr;
                    });
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  void _onClaimFieldsChanged() {
    setState(() {
      _suggestCompensation();
    });
    _suggestCorrectFlightDataIfNeeded();
  }

  void _onFlightNumberChanged() async {
    final text = _flightNumberController.text.trim();
    if (text.length >= 2) {
      final iata = text.substring(0, 2).toUpperCase();
      try {
        final procedure = await AirlineProcedureService.getProcedureByIata(iata);
        setState(() {
          _airlineProcedure = procedure;
          _airlineProcedureError = null;
        });
      } catch (e) {
        setState(() {
          _airlineProcedure = null;
          _airlineProcedureError = 'Could not find airline procedure.';
        });
      }
    } else {
      setState(() {
        _airlineProcedure = null;
        _airlineProcedureError = null;
      });
    }
  }
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _flightNumberController.removeListener(_onFlightNumberChanged);
    _reasonController.removeListener(_onClaimFieldsChanged);
    _departureAirportController.removeListener(_onClaimFieldsChanged);
    _arrivalAirportController.removeListener(_onClaimFieldsChanged);
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
      // --- Automated validation ---
      final userClaims = await FirestoreService().getClaimsForUser(user.uid);
      if (_openSkyUsername.isEmpty || _openSkyPassword.isEmpty) {
        setState(() {
          _errorMessage = 'OpenSky credentials are required. Please set them in the code.';
          _isSubmitting = false;
        });
        return;
      }
      final validation = await ClaimValidationService.validateClaim(
        claim,
        userClaims,
        verifyWithOpenSky: true,
        openSkyUsername: _openSkyUsername,
        openSkyPassword: _openSkyPassword,
      );
      if (!validation.isValid) {
        setState(() {
          _errorMessage = validation.errors.join('\n');
          _isSubmitting = false;
        });
        return;
      }
      // --- End validation ---
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
              if (_airlineProcedure != null)
                Card(
                  color: Colors.green.shade50,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flight, color: Colors.green, size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_airlineProcedure!.name} (${_airlineProcedure!.iata})',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 18, thickness: 1),
                        if (_airlineProcedure!.claimEmail.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.teal),
                              const SizedBox(width: 6),
                              Expanded(
                                child: SelectableText(_airlineProcedure!.claimEmail, style: const TextStyle(fontSize: 15)),
                              ),
                              Tooltip(
                                message: 'Copy email address',
                                child: IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _airlineProcedure!.claimEmail));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied')));
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (_airlineProcedure!.claimFormUrl.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.link, color: Colors.blue),
                              const SizedBox(width: 6),
                              Expanded(
                                child: SelectableText(_airlineProcedure!.claimFormUrl, style: const TextStyle(fontSize: 15)),
                              ),
                              Tooltip(
                                message: 'Open web form',
                                child: IconButton(
                                  icon: const Icon(Icons.open_in_new, size: 20),
                                  onPressed: () async {
                                    final url = _airlineProcedure!.claimFormUrl;
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
                                    }
                                  },
                                ),
                              ),
                              Tooltip(
                                message: 'Copy web form URL',
                                child: IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _airlineProcedure!.claimFormUrl));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied')));
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (_airlineProcedure!.phone != null && _airlineProcedure!.phone!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.deepPurple),
                              const SizedBox(width: 6),
                              Expanded(
                                child: SelectableText(_airlineProcedure!.phone!, style: const TextStyle(fontSize: 15)),
                              ),
                              Tooltip(
                                message: 'Call phone number',
                                child: IconButton(
                                  icon: const Icon(Icons.call, size: 20),
                                  onPressed: () async {
                                    final tel = 'tel:${_airlineProcedure!.phone}';
                                    if (await canLaunchUrlString(tel)) {
                                      await launchUrlString(tel);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not call number')));
                                    }
                                  },
                                ),
                              ),
                              Tooltip(
                                message: 'Copy phone number',
                                child: IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _airlineProcedure!.phone ?? ''));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone copied')));
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (_airlineProcedure!.postalAddress != null && _airlineProcedure!.postalAddress!.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, color: Colors.orange),
                              const SizedBox(width: 6),
                              Expanded(
                                child: SelectableText(_airlineProcedure!.postalAddress!, style: const TextStyle(fontSize: 15)),
                              ),
                              Tooltip(
                                message: 'Copy postal address',
                                child: IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: _airlineProcedure!.postalAddress ?? ''));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Address copied')));
                                  },
                                ),
                              ),
                            ],
                          ),
                        if (_airlineProcedure!.instructions.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _airlineProcedure!.instructions,
                                    style: const TextStyle(color: Colors.green, fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (_airlineProcedure == null && _flightNumberController.text.length >= 2 && _airlineProcedureError == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No procedure info found for this airline code.', style: TextStyle(color: Colors.orange)),
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
              if (_suggestedCompensation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.euro, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Suggested compensation (EC261): €${_suggestedCompensation!.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
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
