import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../models/flight.dart';
import '../services/claim_submission_service.dart';
import '../services/document_storage_service.dart';
import '../services/document_ocr_service.dart';
import '../utils/localization_util.dart';
import '../utils/localization_migration_helper.dart';
import '../models/user_profile.dart';
import '../models/compensation_claim_submission.dart';
import '../models/flight_document.dart';
import '../models/document_ocr_result.dart';
import '../viewmodels/document_scanner_viewmodel.dart';
import '../core/services/service_initializer.dart';
import 'document_upload_screen.dart';
import 'document_management_screen.dart';
import 'document_detail_screen.dart';
import 'document_scanner_screen.dart';

class CompensationClaimFormScreen extends StatefulWidget {
  final Map<String, dynamic> flightData;
  
  const CompensationClaimFormScreen({super.key, required this.flightData});

  @override
  State<CompensationClaimFormScreen> createState() => _CompensationClaimFormScreenState();
}

class _CompensationClaimFormScreenState extends State<CompensationClaimFormScreen> {
  // Make localizations available to all methods in the class
  late MigrationLocalizations localizations;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _airlineController;
  late TextEditingController _flightNumberController;
  late TextEditingController _departureDateController;
  late TextEditingController _departureAirportController;
  late TextEditingController _arrivalAirportController;
  late TextEditingController _passengerNameController;
  late TextEditingController _passengerEmailController;
  late TextEditingController _bookingReferenceController;
  late TextEditingController _additionalInfoController;

  bool _isLoading = false;
  bool _isFormValid = false;
  String _errorMessage = '';
  
  // Document management state
  List<FlightDocument> _attachedDocuments = [];
  bool _loadingDocuments = false;
  String? _documentError;
  
  // Track which fields were prefilled from profile
  final Map<String, bool> _prefilledFields = {};
  
  // Track completed checklist items
  final Map<String, bool> _checklistItems = {
    'documents': false,
    'scanned_documents': false,
  };
  
  // Helper to get localized strings using the centralized LocalizationUtil
  String _getLocalizedText(String key, {String? fallback, Map<String, String>? replacements}) {
    return LocalizationUtil.getText(key, replacements: replacements, fallback: fallback ?? key);
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize form validation
    _isFormValid = false;
    
    // Debug print flight data
    print('Flight Data: ${widget.flightData}');
    
    // Initialize controllers with flight data (with correct field mapping)
    // Handle airline (this can be a string or the name property from an airline object)
    _airlineController = TextEditingController(text: widget.flightData['airline'] ?? '');
    
    // Handle flight number (can be flightNumber, flight_number, or number)
    _flightNumberController = TextEditingController(text: 
      widget.flightData['flightNumber'] ?? 
      widget.flightData['flight_number'] ?? 
      widget.flightData['number'] ?? 
      '');
    
    // Handle departure date (with multiple possible formats)
    if (widget.flightData['departureTime'] != null) {
      // Convert timestamp to date string
      _departureDateController = TextEditingController(
        text: DateTime.fromMillisecondsSinceEpoch(widget.flightData['departureTime'] as int)
            .toIso8601String().substring(0, 10)
      );
    } else if (widget.flightData['departure_date'] != null) {
      // Use provided date string
      _departureDateController = TextEditingController(text: widget.flightData['departure_date']);
    } else {
      // Fallback to current date
      _departureDateController = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    }
    
    // Handle departure airport (with multiple possible field names)
    _departureAirportController = TextEditingController(text: 
      widget.flightData['departureAirport'] ?? 
      widget.flightData['departure_airport'] ?? 
      '');
    
    // Handle arrival airport (with multiple possible field names)
    _arrivalAirportController = TextEditingController(text: 
      widget.flightData['arrivalAirport'] ?? 
      widget.flightData['arrival_airport'] ?? 
      '');
    
    // Initialize empty controllers for other fields
    _passengerNameController = TextEditingController();
    _passengerEmailController = TextEditingController();
    _bookingReferenceController = TextEditingController();
    _additionalInfoController = TextEditingController();
    
    // Then load the user profile from Firebase
    _loadUserProfile();
    
    // Load any existing documents for this flight
    _loadFlightDocuments();
  }

  /// Load the user profile from AuthService and prefill form fields
  Future<void> _loadUserProfile() async {
    try {
      final authService = ServiceInitializer.get<AuthService>();
      final user = authService.currentUser;

      if (user != null && mounted) {
        setState(() {
          // Prefill name if available
          if (user.displayName != null && user.displayName!.isNotEmpty) {
            _setAndTrackPrefill('passengerName', _passengerNameController, user.displayName!);
          }

          // Prefill email if available
          if (user.email != null && user.email!.isNotEmpty) {
            _setAndTrackPrefill('passengerEmail', _passengerEmailController, user.email!);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading profile: $e';
        });
      }
    }
  }
  
  /// Load documents related to this flight number
  Future<void> _loadFlightDocuments() async {
    if (_flightNumberController.text.isEmpty) return;
    
    setState(() {
      _loadingDocuments = true;
      _documentError = null;
    });
    
    try {
      final documentService = Provider.of<DocumentStorageService>(context, listen: false);
      final documents = await documentService.getFlightDocuments(_flightNumberController.text);
      
      if (mounted) {
        setState(() {
          _attachedDocuments = documents;
          _loadingDocuments = false;
          _checklistItems['documents'] = documents.isNotEmpty;
          _validateForm();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _documentError = 'Error loading documents: $e';
          _loadingDocuments = false;
          _checklistItems['documents'] = false;
          _validateForm();
        });
      }
    }
  }
  
  // Helper to set controller text and track that it was prefilled
  void _setAndTrackPrefill(String controllerName, TextEditingController controller, String value) {
    controller.text = value;
    _prefilledFields[controllerName] = true;
  }
  
  // Format delay minutes into readable format
  String _formatDelay(dynamic minutes) {
    int delayMinutes;
    if (minutes is int) {
      delayMinutes = minutes;
    } else if (minutes is String) {
      delayMinutes = int.tryParse(minutes) ?? 0;
    } else {
      delayMinutes = 0;
    }
    
    if (delayMinutes < 60) {
      return '$delayMinutes minutes';
    } else {
      final hours = delayMinutes ~/ 60;
      final remainingMinutes = delayMinutes % 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ${remainingMinutes > 0 ? '$remainingMinutes minutes' : ''}'.trim();
    }
  }
  
  /// Format document type enum to readable string
  String _formatDocumentType(FlightDocumentType type) {
    // Use localization for document types instead of formatting the enum
    switch (type) {
      case FlightDocumentType.boardingPass:
        return localizations.boardingPass;
      case FlightDocumentType.ticket:
        return localizations.ticket;
      case FlightDocumentType.bookingConfirmation:
        return 'Booking Confirmation'; // TODO: Add localization
      case FlightDocumentType.eTicket:
        return 'eTicket'; // TODO: Add localization
      case FlightDocumentType.luggageTag:
        return localizations.luggageTag;
      case FlightDocumentType.delayConfirmation:
        return localizations.delayConfirmation;
      case FlightDocumentType.hotelReceipt:
        return localizations.hotelReceipt;
      case FlightDocumentType.mealReceipt:
        return localizations.mealReceipt;
      case FlightDocumentType.transportReceipt:
        return localizations.transportReceipt;
      case FlightDocumentType.other:
        return localizations.otherDocument;
    }
  }
  
  /// Builds a section header with consistent styling
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Show dialog with document upload/scan options
  /// Validate form fields and checklist items
  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final hasDocuments = _checklistItems['documents'] == true || _checklistItems['scanned_documents'] == true;
    setState(() {
      _isFormValid = isValid && hasDocuments;
    });
  }

  /// Submit the compensation claim form
  Future<void> _submitForm() async {
    _validateForm();
    if (!_isFormValid) {
      // Use centralized LocalizationUtil instead of AppLocalizations
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(!_isFormValid && !_formKey.currentState!.validate()
              ? localizations.pleaseCompleteAllFields
              : localizations.pleaseAttachDocuments),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    // ... rest of the code remains the same ...

  @override
  Widget build(BuildContext context) {
    // Initialize the class-level localizations field
    localizations = MigrationLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.compensationClaimForm),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... rest of the code remains the same ...

              // Submission Checklist
              const SizedBox(height: 24),
              _buildSectionHeader(localizations.submissionChecklist),
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _formKey.currentState?.validate() == true 
                              ? Icons.check_circle 
                              : Icons.radio_button_unchecked,
                            color: _formKey.currentState?.validate() == true 
                              ? Colors.green 
                              : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              localizations.allFieldsCompleted, 
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            _checklistItems['documents'] == true || _checklistItems['scanned_documents'] == true 
                              ? Icons.check_circle 
                              : Icons.radio_button_unchecked,
                            color: _checklistItems['documents'] == true || _checklistItems['scanned_documents'] == true 
                              ? Colors.green 
                              : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              localizations.supportingDocuments, 
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (_checklistItems['documents'] == true)
                            Chip(
                              label: Text(localizations.uploaded),
                              backgroundColor: Colors.green.shade100,
                              labelStyle: TextStyle(color: Colors.green.shade800),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (_checklistItems['scanned_documents'] == true) ...[  
                            if (_checklistItems['documents'] == true)
                              const SizedBox(width: 4),
                            Chip(
                              label: Text(localizations.scanned),
                              backgroundColor: Colors.blue.shade100,
                              labelStyle: TextStyle(color: Colors.blue.shade800),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.scanningDocumentsNote,
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Submit Button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(localizations.submitClaim, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
