import 'package:flutter/material.dart';
import 'dart:io';
import 'faq_screen.dart';
import '../services/airline_procedure_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';
import '../core/accessibility/accessibility_service.dart';
import '../core/accessibility/accessible_widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import '../models/claim.dart';
import '../models/document_ocr_result.dart';
import '../services/firestore_service.dart';
import '../services/claim_validation_service.dart';
import '../services/opensky_api_service.dart';
import '../core/services/service_initializer.dart';
import '../viewmodels/document_scanner_viewmodel.dart';
import 'document_scanner_screen.dart';

/// Intent for keyboard deletion of documents
class DeleteIntent extends Intent {}

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
  final _bookingReferenceController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  DateTime? _flightDate;

  // Document attachment support
  final List<File> _attachedDocuments = [];
  bool _isDocumentProcessing = false;
  late final DocumentScannerViewModel _documentScannerViewModel;
  
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
    _documentScannerViewModel = ServiceInitializer.get<DocumentScannerViewModel>();
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
    _bookingReferenceController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }
  
  /// Add a document to the claim
  Future<void> _addDocument() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _attachedDocuments.add(File(image.path));
      });
    }
  }
  
  /// Scan a document using the document scanner
  Future<void> _scanDocument() async {
    setState(() {
      _isDocumentProcessing = true;
    });
    
    try {
      // Navigate to the document scanner screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentScannerScreen(),
        ),
      );
      
      // Handle the scanned document if available
      if (result != null && result is DocumentOcrResult) {
        // Add the scanned document to the list
        if (result.imagePath.isNotEmpty) {
          setState(() {
            _attachedDocuments.add(File(result.imagePath));
          });
        }
        
        // Pre-fill form fields if OCR extracted useful information
        final fields = result.extractedFields;
        
        // Flight Number
        if (fields.containsKey('flightNumber') && _flightNumberController.text.isEmpty) {
          _flightNumberController.text = fields['flightNumber']!;
        }
        
        // Departure Airport
        if (fields.containsKey('departureAirport') && _departureAirportController.text.isEmpty) {
          _departureAirportController.text = fields['departureAirport']!;
        }
        
        // Arrival Airport
        if (fields.containsKey('arrivalAirport') && _arrivalAirportController.text.isEmpty) {
          _arrivalAirportController.text = fields['arrivalAirport']!;
        }
        
        // Flight Date
        if (fields.containsKey('flightDate') && _flightDate == null) {
          try {
            setState(() {
              _flightDate = DateTime.parse(fields['flightDate']!);
            });
          } catch (e) {
            // Ignore parsing errors
          }
        }
        
        // Booking Reference
        if (fields.containsKey('bookingReference') && _bookingReferenceController.text.isEmpty) {
          _bookingReferenceController.text = fields['bookingReference']!;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing document: $e')),
      );
    } finally {
      setState(() {
        _isDocumentProcessing = false;
      });
    }
  }
  
  /// Remove a document from the list
  void _removeDocument(int index) {
    setState(() {
      _attachedDocuments.removeAt(index);
    });
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
      
      // Check if user has attached documents (optional but recommended)
      if (_attachedDocuments.isEmpty) {
        final shouldContinue = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('No Documents Attached'),
            content: const Text(
              'It is recommended to attach supporting documents like boarding passes or tickets. Do you want to continue without documents?',
            ),
            actions: [
              TextButton(
                child: const Text('Attach Documents'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: const Text('Continue Anyway'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
        
        if (shouldContinue == false) {
          setState(() {
            _isSubmitting = false;
          });
          return;
        }
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
        bookingReference: _bookingReferenceController.text.trim(),
        additionalInfo: _additionalInfoController.text.trim(),
        documentPaths: _attachedDocuments.map((file) => file.path).toList(),
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
    // Get accessibility service
    final accessibilityService = Provider.of<AccessibilityService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: accessibilityService.semanticLabel(
            'Submit Claim', 
            'Submit Flight Compensation Claim Form'
          ),
          child: const Text('Submit Claim'),
        ),
        actions: [
          // Help button with enhanced semantics
          Semantics(
            button: true,
            label: accessibilityService.semanticLabel(
              'Help', 
              'View frequently asked questions about claim submission'
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FAQScreen(),
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
              // Flight Number with enhanced accessibility
              AccessibleTextField(
                key: const Key('flightNumberField'),
                controller: _flightNumberController,
                label: 'Flight Number',
                semanticLabel: 'Flight number, usually a 2-letter airline code followed by digits',
                hint: 'e.g. LH1234, BA965',
                helperText: 'Usually a 2-letter airline code and digits',
                required: true,
                icon: Icons.flight,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                textInputAction: TextInputAction.next,
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
              // Flight Date with enhanced accessibility
              Semantics(
                label: 'Flight date field, required',
                hint: 'Tap to select your flight date',
                button: true,
                textField: true,
                child: GestureDetector(
                  onTap: _pickFlightDate,
                  child: Focus(
                    onKey: (FocusNode node, RawKeyEvent event) {
                      // Handle keyboard navigation
                      if (event is RawKeyDownEvent && 
                          (event.logicalKey == LogicalKeyboardKey.enter || 
                           event.logicalKey == LogicalKeyboardKey.space)) {
                        _pickFlightDate();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flight Date *',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _flightDate != null
                                      ? DateFormat.yMMMd().format(_flightDate!)
                                      : 'Select date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _flightDate == null 
                                        ? Theme.of(context).hintColor 
                                        : Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              // Departure Airport with enhanced accessibility
              AccessibleTextField(
                key: const Key('departureAirportField'),
                controller: _departureAirportController,
                label: 'Departure Airport',
                semanticLabel: 'Departure airport, enter the 3-letter IATA code',
                hint: 'e.g. FRA, LHR, JFK',
                helperText: 'Enter the airport code where your flight departed',
                required: true,
                icon: Icons.flight_takeoff,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              
              // Arrival Airport with enhanced accessibility
              AccessibleTextField(
                key: const Key('arrivalAirportField'),
                controller: _arrivalAirportController,
                label: 'Arrival Airport',
                semanticLabel: 'Arrival airport, enter the 3-letter IATA code',
                hint: 'e.g. CDG, JFK, MAD',
                helperText: 'Enter the airport code where your flight arrived',
                required: true,
                icon: Icons.flight_land,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),
              // Reason with enhanced accessibility
              AccessibleTextField(
                controller: _reasonController,
                label: 'Reason',
                semanticLabel: 'Reason for compensation claim, such as delay or cancellation',
                hint: 'e.g. 3-hour delay, cancellation, denied boarding',
                helperText: 'Explain why you are eligible for compensation',
                required: true,
                icon: Icons.info_outline,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                textInputAction: TextInputAction.next,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              // Compensation Amount with enhanced accessibility
              AccessibleTextField(
                controller: _compensationAmountController,
                label: 'Compensation Amount',
                semanticLabel: 'Expected compensation amount in euros, optional field',
                hint: 'Enter amount in Euros',
                helperText: 'Typical EU compensation ranges from €250-€600',
                required: false,
                icon: Icons.euro,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
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
                  key: const Key('submitClaimButton'),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit'),
              ),
              const SizedBox(height: 16),
              
              // Booking Reference and Additional Info
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Reference',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bookingReferenceController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your booking reference',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Additional Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _additionalInfoController,
                      decoration: const InputDecoration(
                        hintText: 'Any other details about your claim',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              
              // Supporting Documents Section with accessibility enhancements
              AccessibleCard(
                title: 'Supporting Documents',
                semanticLabel: 'Supporting documents section. You can attach boarding passes, tickets and other documents here',
                backgroundColor: Colors.amber.shade50,
                borderColor: Colors.amber.shade200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Descriptive text with proper semantics
                    Semantics(
                      label: 'Description of supporting documents purpose',
                      child: const Text(
                        'Attach boarding passes, tickets, and other documents to strengthen your claim.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Document list with accessibility
                    Semantics(
                      label: accessibilityService.semanticLabel(
                        'Document list', 
                        _attachedDocuments.isEmpty 
                            ? 'No documents attached yet' 
                            : '${_attachedDocuments.length} documents attached'
                      ),
                      child: _attachedDocuments.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text('No documents attached yet', 
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _attachedDocuments.length,
                            itemBuilder: (context, index) {
                              final document = _attachedDocuments[index];
                              final fileName = document.path.split('/').last;
                              
                              return Semantics(
                                label: 'Document ${index + 1}, ${fileName}',
                                button: true,
                                child: FocusableActionDetector(
                                  actions: {
                                    DeleteIntent: CallbackAction<DeleteIntent>(
                                      onInvoke: (intent) {
                                        _removeDocument(index);
                                        return null;
                                      },
                                    ),
                                  },
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.file(
                                        document,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        semanticLabel: 'Preview of document ${index + 1}',
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.description, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    title: Text('Document ${index + 1}'),
                                    subtitle: Text(fileName),
                                    trailing: Semantics(
                                      button: true,
                                      label: 'Delete document ${index + 1}',
                                      hint: 'Double tap to remove this document',
                                      child: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeDocument(index),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Document action buttons with enhanced accessibility
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AccessibleButton(
                          label: 'Scan Document',
                          semanticLabel: 'Scan a document using your camera',
                          onPressed: _scanDocument,
                          icon: Icons.document_scanner,
                          enabled: !_isDocumentProcessing,
                          isLoading: _isDocumentProcessing,
                          color: Colors.amber.shade600,
                        ),
                        const SizedBox(width: 16),
                        AccessibleButton(
                          label: 'Upload File',
                          semanticLabel: 'Select a document from your device to upload',
                          onPressed: _addDocument,
                          icon: Icons.upload_file,
                          filled: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Submission Checklist with enhanced accessibility
              AccessibleCard(
                title: 'Submission Checklist',
                semanticLabel: 'Submission checklist to verify your claim is ready',
                backgroundColor: Colors.blue.shade50,
                borderColor: Colors.blue.shade200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Document checklist item with enhanced semantics
                    Semantics(
                      toggled: _attachedDocuments.isNotEmpty,
                      label: accessibilityService.semanticLabel(
                        'Supporting Documents', 
                        'Supporting documents checkbox, ${_attachedDocuments.isNotEmpty ? "completed" : "needs attention"}'
                      ),
                      hint: _attachedDocuments.isEmpty ? 'Tap to add documents' : null,
                      child: FocusableActionDetector(
                        actions: {
                          ActivateIntent: CallbackAction<ActivateIntent>(
                            onInvoke: (intent) {
                              if (_attachedDocuments.isEmpty) {
                                _scanDocument();
                              }
                              return null;
                            },
                          ),
                        },
                        child: CheckboxListTile(
                          title: const Text('Supporting Documents'),
                          subtitle: const Text('Boarding passes, tickets, correspondence'),
                          value: _attachedDocuments.isNotEmpty,
                          onChanged: (value) {
                            if (value == true && _attachedDocuments.isEmpty) {
                              _scanDocument();
                            }
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    
                    // Required fields checklist item with enhanced semantics
                    Semantics(
                      toggled: _formKey.currentState?.validate() ?? false,
                      label: accessibilityService.semanticLabel(
                        'Required Fields', 
                        'Required form fields status, ${(_formKey.currentState?.validate() ?? false) ? "completed" : "needs attention"}'
                      ),
                      child: CheckboxListTile(
                        title: const Text('Required Fields Completed'),
                        subtitle: const Text('Flight details, reason for claim'),
                        value: _formKey.currentState?.validate() ?? false,
                        onChanged: null,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Error message with screen reader announcement
              if (_errorMessage != null)
                Semantics(
                  liveRegion: true, // Announce to screen readers when content changes
                  label: 'Error: $_errorMessage',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Submit button with enhanced accessibility
              AccessibleButton(
                label: 'Submit Claim',
                semanticLabel: 'Submit your compensation claim',
                onPressed: _submitClaim,
                enabled: !_isSubmitting,
                isLoading: _isSubmitting,
                icon: Icons.send,
                filled: true,
                color: Theme.of(context).primaryColor,
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
