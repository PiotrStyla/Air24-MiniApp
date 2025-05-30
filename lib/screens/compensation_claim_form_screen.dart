import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/firestore_service.dart';
import '../services/document_storage_service.dart';
import '../services/document_ocr_service.dart';
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

  /// Load the user profile from Firebase and prefill form fields
  Future<void> _loadUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      final userProfile = await firestoreService.getUserProfile(user.uid);
      
      if (userProfile != null && mounted) {
        setState(() {
          // Prefill name if available
          if (userProfile.fullName.isNotEmpty) {
            _setAndTrackPrefill('passengerName', _passengerNameController, userProfile.fullName);
          }
          
          // Prefill email if available
          if (userProfile.email.isNotEmpty) {
            _setAndTrackPrefill('passengerEmail', _passengerEmailController, userProfile.email);
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
    final text = type.toString().split('.').last
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();
    return text.isNotEmpty
        ? text[0].toUpperCase() + text.substring(1)
        : text;
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
  void _showDocumentOptionsDialog() {
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.addDocument),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scan document option
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.document_scanner, color: Colors.blue),
              ),
              title: Text(localizations.scanDocument),
              subtitle: Text(localizations.scanDocumentHint),
              onTap: () {
                Navigator.of(ctx).pop();
                _navigateToDocumentScanner();
              },
            ),
            const Divider(),
            // Upload document options
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade50,
                child: const Icon(Icons.upload_file, color: Colors.green),
              ),
              title: Text(localizations.uploadDocument),
              subtitle: Text(localizations.uploadDocumentHint),
              onTap: () {
                Navigator.of(ctx).pop();
                _navigateToDocumentUpload();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(localizations.cancel),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
  
  /// Navigate to document scanner
  void _navigateToDocumentScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DocumentScannerScreen(),
      ),
    );
    
    // Check if we have scanned documents after returning
    final scannerViewModel = ServiceInitializer.get<DocumentScannerViewModel>();
    await scannerViewModel.loadSavedDocuments();
    
    setState(() {
      _checklistItems['scanned_documents'] = scannerViewModel.savedDocuments.isNotEmpty;
    });
    
    // If we have a recently scanned document, offer to fill the form
    if (scannerViewModel.savedDocuments.isNotEmpty) {
      final latestDocument = scannerViewModel.savedDocuments.first;
      _offerToFillFormFromDocument(latestDocument);
    }
  }
  
  /// Navigate to document upload
  void _navigateToDocumentUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentUploadScreen(
          flightNumber: _flightNumberController.text,
        ),
      ),
    ).then((_) => _loadFlightDocuments());
  }
  
  /// Offer to fill form from OCR document
  void _offerToFillFormFromDocument(DocumentOcrResult document) {
    final extractedFields = document.extractedFields;
    if (extractedFields.isEmpty) return;
    
    // Only show dialog if we have useful fields
    bool hasUsefulFields = false;
    for (final field in ['passenger_name', 'flight_number', 'departure_airport', 
                         'arrival_airport', 'booking_reference']) {
      if (extractedFields.containsKey(field) && extractedFields[field]!.isNotEmpty) {
        hasUsefulFields = true;
        break;
      }
    }
    
    if (!hasUsefulFields) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Use Scanned Information?'),
        content: const Text(
          'We found useful information in your scanned document. Would you like to fill the form with this data?'
        ),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Yes, Fill Form'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _fillFormFromScannedDocument(extractedFields);
            },
          ),
        ],
      ),
    );
  }
  
  /// Fill form fields from scanned document
  void _fillFormFromScannedDocument(Map<String, String> extractedFields) {
    setState(() {
      // Fill passenger name
      if (extractedFields.containsKey('passenger_name') && 
          extractedFields['passenger_name']!.isNotEmpty) {
        _passengerNameController.text = extractedFields['passenger_name']!;
      } else if (extractedFields.containsKey('full_name') && 
                extractedFields['full_name']!.isNotEmpty) {
        _passengerNameController.text = extractedFields['full_name']!;
      }
      
      // Fill flight number
      if (extractedFields.containsKey('flight_number') && 
          extractedFields['flight_number']!.isNotEmpty) {
        _flightNumberController.text = extractedFields['flight_number']!;
      }
      
      // Fill departure airport
      if (extractedFields.containsKey('departure_airport') && 
          extractedFields['departure_airport']!.isNotEmpty) {
        _departureAirportController.text = extractedFields['departure_airport']!;
      }
      
      // Fill arrival airport
      if (extractedFields.containsKey('arrival_airport') && 
          extractedFields['arrival_airport']!.isNotEmpty) {
        _arrivalAirportController.text = extractedFields['arrival_airport']!;
      }
      
      // Fill booking reference
      if (extractedFields.containsKey('booking_reference') && 
          extractedFields['booking_reference']!.isNotEmpty) {
        _bookingReferenceController.text = extractedFields['booking_reference']!;
      }
      
      // Fill departure date
      if (extractedFields.containsKey('departure_date') && 
          extractedFields['departure_date']!.isNotEmpty) {
        try {
          // Try to parse the date in various formats
          final dateStr = extractedFields['departure_date']!;
          DateTime? parsedDate;
          
          // Try common date formats
          final formats = [
            'yyyy-MM-dd', 'dd/MM/yyyy', 'MM/dd/yyyy', 'd MMM yyyy',
            'dd-MM-yyyy', 'MM-dd-yyyy', 'yyyy/MM/dd'
          ];
          
          for (final format in formats) {
            try {
              parsedDate = DateFormat(format).parse(dateStr);
              break;
            } catch (_) {
              // Try next format
            }
          }
          
          if (parsedDate != null) {
            _departureDateController.text = DateFormat('yyyy-MM-dd').format(parsedDate);
          }
        } catch (e) {
          // If date parsing fails, keep existing date
          debugPrint('Failed to parse date: $e');
        }
      }
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form filled with scanned document data'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
  
  /// Build document section UI for displaying and managing documents
  Widget _buildDocumentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (context) {
            final localizations = AppLocalizations.of(context)!;
            return Text(
              localizations.supportingDocuments,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            );
          }),
          const SizedBox(height: 12),
          Builder(builder: (context) {
            final localizations = AppLocalizations.of(context)!;
            return Text(
              localizations.supportingDocumentsHint,
              style: const TextStyle(fontSize: 14),
            );
          }),
          const SizedBox(height: 16),
          
          if (_loadingDocuments)
            const Center(child: CircularProgressIndicator())
          else if (_documentError != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(_documentError!, style: TextStyle(color: Colors.red.shade800)),
            )
          else if (_attachedDocuments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Builder(builder: (context) {
                  final localizations = AppLocalizations.of(context)!;
                  return Text(localizations.noDocumentsYet);
                }),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attachedDocuments.length,
              itemBuilder: (context, index) {
                final document = _attachedDocuments[index];
                IconData iconData;
                
                switch (document.documentType) {
                  case FlightDocumentType.boardingPass:
                    iconData = Icons.airplane_ticket;
                    break;
                  case FlightDocumentType.ticket:
                    iconData = Icons.confirmation_number;
                    break;
                  case FlightDocumentType.luggageTag:
                    iconData = Icons.luggage;
                    break;
                  default:
                    iconData = Icons.description;
                }
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(iconData, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(document.documentName),
                  subtitle: Text(_formatDocumentType(document.documentType)),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: () {
                      // Remove document from the list (doesn't delete it)
                      setState(() {
                        _attachedDocuments.removeAt(index);
                        if (_attachedDocuments.isEmpty) {
                          _checklistItems['documents'] = false;
                        }
                      });
                    },
                  ),
                  onTap: () {
                    // Open document detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentDetailScreen(document: document),
                      ),
                    );
                  },
                );
              },
            ),
          
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                final localizations = AppLocalizations.of(context)!;
                return ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(localizations.addDocument),
                  onPressed: () {
                    if (_flightNumberController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations.enterFlightNumberFirst)),
                      );
                      return;
                    }
                    
                    _showDocumentOptionsDialog();
                  },
                );
              }),
              if (_attachedDocuments.isNotEmpty) ...[  
                const SizedBox(width: 16),
                Builder(builder: (context) {
                  final localizations = AppLocalizations.of(context)!;
                  return OutlinedButton.icon(
                    icon: const Icon(Icons.folder_open),
                    label: Text(localizations.viewAll),
                    onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentManagementScreen(
                          flightNumber: _flightNumberController.text,
                        ),
                      ),
                    ).then((_) => _loadFlightDocuments());
                    },
                  );
                }),
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  // Build a form field with prefill indicator if it was prefilled from profile
  Widget _buildPrefilledFormField({
    required TextEditingController controller,
    required String controllerName,
    required String labelText,
    required String hintText,
    bool required = false,
  }) {
    final isPrefilled = _prefilledFields[controllerName] == true;
    
    // Use Builder to access localizations from the context
    return Builder(builder: (context) {
      final localizations = AppLocalizations.of(context)!;
      
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          // Add a prefill indicator icon for prefilled fields
          suffixIcon: isPrefilled ? Tooltip(
            message: localizations.prefilledFromProfile,
            child: Icon(Icons.account_circle, color: Colors.green, size: 20),
          ) : null,
          // Add a subtle background color for prefilled fields
          fillColor: isPrefilled ? Colors.green.shade50 : null,
          filled: isPrefilled,
        ),
        validator: required ? (v) => v == null || v.isEmpty ? localizations.thisFieldIsRequired : null : null,
      );
    });
  }
  
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
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.completeAllFields),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = localizations.loginRequiredForClaim;
          _isLoading = false;
        });
        return;
      }
      
      // Get form data
      final formData = {
        'flightNumber': _flightNumberController.text,
        'airline': _airlineController.text,
        'departureAirport': _departureAirportController.text,
        'arrivalAirport': _arrivalAirportController.text,
        'departureDate': _departureDateController.text,
        'passengerName': _passengerNameController.text,
        'passengerEmail': _passengerEmailController.text,
        'bookingReference': _bookingReferenceController.text,
        'additionalInfo': _additionalInfoController.text,
      };
      
      // Get document IDs to include with submission
      final List<String> documentIds = _attachedDocuments.map((doc) => doc.id).toList();
      
      // Create claim submission
      final claimSubmission = CompensationClaimSubmission.fromFormData(
        userId: user.uid,
        formData: formData,
        flightData: widget.flightData,
        completedChecklistItems: _checklistItems.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        documentIds: documentIds,
        hasAllDocuments: _checklistItems['documents'] ?? false,
      );
      
      // Save to Firestore
      final firestoreService = FirestoreService();
      await firestoreService.submitCompensationClaim(claimSubmission);
      
      // Show success message
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.claimSubmittedSuccessfully)),
        );
        
        // Navigate back to previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          // Format error message based on error type
          if (e.toString().contains('network') || e.toString().contains('connection')) {
            _errorMessage = localizations.networkError;
          } else {
            _errorMessage = localizations.formSubmissionError(e.toString());
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose of all controllers to prevent memory leaks
    _airlineController.dispose();
    _flightNumberController.dispose();
    _departureDateController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _passengerNameController.dispose();
    _passengerEmailController.dispose();
    _bookingReferenceController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
              _buildSectionHeader(localizations.flightDetails),
              
              // Flight Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _airlineController,
                        decoration: InputDecoration(
                          labelText: localizations.airline,
                        ),
                        readOnly: true,
                        validator: (value) {
                          final localizations = AppLocalizations.of(context)!;
                          if (value == null || value.isEmpty) {
                            return localizations.thisFieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _flightNumberController,
                        decoration: InputDecoration(
                          labelText: localizations.flightNumber,
                        ),
                        readOnly: true,
                        validator: (value) {
                          final localizations = AppLocalizations.of(context)!;
                          if (value == null || value.isEmpty) {
                            return localizations.thisFieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _departureDateController,
                        decoration: InputDecoration(
                          labelText: localizations.flightDate,
                        ),
                        readOnly: true,
                        validator: (value) {
                          final localizations = AppLocalizations.of(context)!;
                          if (value == null || value.isEmpty) {
                            return localizations.thisFieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _departureAirportController,
                        decoration: InputDecoration(
                          labelText: localizations.departureAirport,
                        ),
                        readOnly: true,
                        validator: (value) {
                          final localizations = AppLocalizations.of(context)!;
                          if (value == null || value.isEmpty) {
                            return localizations.pleaseEnterDepartureAirport;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _arrivalAirportController,
                        decoration: InputDecoration(
                          labelText: localizations.arrivalAirport,
                        ),
                        readOnly: true,
                        validator: (value) {
                          final localizations = AppLocalizations.of(context)!;
                          if (value == null || value.isEmpty) {
                            return localizations.thisFieldIsRequired;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader(localizations.passengerDetails),
              
              // Passenger Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrefilledFormField(
                        controller: _passengerNameController,
                        controllerName: 'passengerName',
                        labelText: localizations.passengerName,
                        hintText: localizations.passengerName,
                        required: true,
                      ),
                      const SizedBox(height: 8),
                      _buildPrefilledFormField(
                        controller: _passengerEmailController,
                        controllerName: 'passengerEmail',
                        labelText: localizations.email,
                        hintText: localizations.email,
                        required: true,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _bookingReferenceController,
                        decoration: InputDecoration(
                          labelText: localizations.bookingReference,
                          helperText: localizations.optional,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _additionalInfoController,
                        decoration: InputDecoration(
                          labelText: localizations.additionalInformation,
                          helperText: localizations.optional,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Document Section
              const SizedBox(height: 24),
              _buildSectionHeader(localizations.supportingDocuments),
              _buildDocumentSection(),
              
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
                      const SizedBox(height: 12),
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
                              localizations.requiredFieldsCompleted, 
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
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
