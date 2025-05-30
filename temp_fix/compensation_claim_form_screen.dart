import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../services/document_storage_service.dart';
import '../models/user_profile.dart';
import '../models/compensation_claim_submission.dart';
import '../models/flight_document.dart';
import 'document_upload_screen.dart';
import 'document_management_screen.dart';
import 'document_detail_screen.dart';

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
  };

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with flight data
    _airlineController = TextEditingController(text: widget.flightData['airline']);
    _flightNumberController = TextEditingController(text: widget.flightData['flightNumber']);
    _departureDateController = TextEditingController(
      text: DateTime.fromMillisecondsSinceEpoch(widget.flightData['departureTime'])
          .toIso8601String().substring(0, 10)
    );
    _departureAirportController = TextEditingController(text: widget.flightData['departureAirport']);
    _arrivalAirportController = TextEditingController(text: widget.flightData['arrivalAirport']);
    
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
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _documentError = 'Error loading documents: $e';
          _loadingDocuments = false;
          _checklistItems['documents'] = false;
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
          const Text(
            'Supporting Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Attach boarding passes, tickets, and other documents to strengthen your claim.',
            style: TextStyle(fontSize: 14),
          ),
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
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('No documents attached yet'),
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
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Document'),
                onPressed: () {
                  if (_flightNumberController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a flight number first')),
                    );
                    return;
                  }
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentUploadScreen(
                        flightNumber: _flightNumberController.text,
                      ),
                    ),
                  ).then((_) => _loadFlightDocuments());
                },
              ),
              if (_attachedDocuments.isNotEmpty) ...[  
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.folder_open),
                  label: const Text('View All'),
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
                ),
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
    
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        // Add a prefill indicator icon for prefilled fields
        suffixIcon: isPrefilled ? Tooltip(
          message: 'Pre-filled from your profile',
          child: Icon(Icons.account_circle, color: Colors.green, size: 20),
        ) : null,
        // Add a subtle background color for prefilled fields
        fillColor: isPrefilled ? Colors.green.shade50 : null,
        filled: isPrefilled,
      ),
      validator: required ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
    );
  }
  
  /// Submit the compensation claim form
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'You must be logged in to submit a claim';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Claim submitted successfully')),
        );
        
        // Navigate back to previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error submitting claim: $e';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compensation Claim Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Flight Information'),
              
              // Flight Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _airlineController,
                        decoration: const InputDecoration(
                          labelText: 'Airline',
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the airline';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _flightNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Flight Number',
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the flight number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _departureDateController,
                        decoration: const InputDecoration(
                          labelText: 'Departure Date',
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the departure date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _departureAirportController,
                        decoration: const InputDecoration(
                          labelText: 'Departure Airport',
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the departure airport';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _arrivalAirportController,
                        decoration: const InputDecoration(
                          labelText: 'Arrival Airport',
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the arrival airport';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader('Passenger Information'),
              
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
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        required: true,
                      ),
                      const SizedBox(height: 8),
                      _buildPrefilledFormField(
                        controller: _passengerEmailController,
                        controllerName: 'passengerEmail',
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        required: true,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _bookingReferenceController,
                        decoration: const InputDecoration(
                          labelText: 'Booking Reference',
                          hintText: 'Optional: Enter your booking reference',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _additionalInfoController,
                        decoration: const InputDecoration(
                          labelText: 'Additional Information',
                          hintText: 'Optional: Any other details about your claim',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Document Section
              const SizedBox(height: 24),
              _buildSectionHeader('Supporting Documents'),
              _buildDocumentSection(),
              
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
                        : const Text('Submit Claim', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
