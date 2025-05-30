import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';
import '../widgets/claim_checklist_widget.dart';
import '../models/compensation_claim_submission.dart';

class CompensationClaimFormScreen extends StatefulWidget {
  final Map<String, dynamic> flightData;
  
  const CompensationClaimFormScreen({Key? key, required this.flightData}) : super(key: key);

  @override
  _CompensationClaimFormScreenState createState() => _CompensationClaimFormScreenState();
}

class _CompensationClaimFormScreenState extends State<CompensationClaimFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _airlineController;
  late TextEditingController _flightNumberController;
  late TextEditingController _departureDateController;
  late TextEditingController _departureAirportController;
  late TextEditingController _arrivalAirportController;
  late TextEditingController _delayController;
  late TextEditingController _compensationAmountController;
  late TextEditingController _passengerNameController;
  late TextEditingController _passengerEmailController;
  late TextEditingController _passengerPhoneController;
  late TextEditingController _passengerNationalityController;
  late TextEditingController _passengerPassportController;
  late TextEditingController _passengerAddressController;
  late TextEditingController _passengerCityController;
  late TextEditingController _passengerPostalCodeController;
  late TextEditingController _passengerCountryController;
  late TextEditingController _bookingReferenceController;
  late TextEditingController _additionalInfoController;

  bool _isLoading = true;
  String _errorMessage = '';
  bool _isChecklistComplete = true; // Auto-set to true since the flight is already verified
  
  // Track which fields were prefilled from profile
  Map<String, bool> _prefilledFields = {};
  
  // Track completed checklist items
  Map<String, bool> _checklistItems = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize all controllers with empty values
    _airlineController = TextEditingController(text: '');
    _flightNumberController = TextEditingController(text: '');
    _departureDateController = TextEditingController(text: '');
    _departureAirportController = TextEditingController(text: '');
    _arrivalAirportController = TextEditingController(text: '');
    _delayController = TextEditingController(text: '');
    _compensationAmountController = TextEditingController(text: '');
    _passengerNameController = TextEditingController(text: '');
    _passengerEmailController = TextEditingController(text: '');
    _passengerPhoneController = TextEditingController(text: '');
    _passengerNationalityController = TextEditingController(text: '');
    _passengerPassportController = TextEditingController(text: '');
    _passengerAddressController = TextEditingController(text: '');
    _passengerCityController = TextEditingController(text: '');
    _passengerPostalCodeController = TextEditingController(text: '');
    _passengerCountryController = TextEditingController(text: '');
    _bookingReferenceController = TextEditingController(text: '');
    _additionalInfoController = TextEditingController(text: '');
    
    // Process flight data first
    _processFlightData();
    
    // Then load the user profile from Firebase
    _loadUserProfile();
  }
  
  void _processFlightData() {
    try {
      debugPrint('Processing flight data: ${widget.flightData}');
      final flight = widget.flightData;
      
      // Extract airline
      String airline = '';
      if (flight['airline'] is Map && flight['airline'].containsKey('name')) {
        airline = flight['airline']['name'] ?? '';
      } else if (flight['airline'] is String) {
        airline = flight['airline'];
      } else if (flight['airline_name'] is String) {
        airline = flight['airline_name'];
      }
      
      // Extract flight number
      String flightNumber = '';
      if (flight['number'] != null) {
        flightNumber = flight['number'].toString();
      } else if (flight['flight_number'] != null) {
        flightNumber = flight['flight_number'].toString();
      } else if (flight['flight'] != null) {
        flightNumber = flight['flight'].toString();
      }
      
      // Extract departure info
      String departureAirport = '';
      String departureDate = '';
      if (flight['departure'] is Map) {
        if (flight['departure']['airport'] is Map) {
          departureAirport = '${flight['departure']['airport']['name'] ?? ''} (${flight['departure']['airport']['iata'] ?? flight['departure']['airport']['icao'] ?? ''})';
        }
        
        if (flight['departure']['scheduledTime'] is Map) {
          String dateTimeStr = flight['departure']['scheduledTime']['local'] ?? '';
          if (dateTimeStr.isNotEmpty) {
            try {
              DateTime dt = DateTime.parse(dateTimeStr.replaceAll(' ', 'T'));
              departureDate = DateFormat('yyyy-MM-dd').format(dt);
            } catch (e) {
              departureDate = dateTimeStr.split(' ').first;
            }
          }
        }
      }
      
      if (departureAirport.isEmpty && flight['departure_airport'] is String) {
        departureAirport = flight['departure_airport'];
      }
      
      if (departureDate.isEmpty && flight['departure_date'] is String) {
        departureDate = flight['departure_date'];
      }
      
      // Extract arrival info
      String arrivalAirport = '';
      if (flight['arrival'] is Map && flight['arrival']['airport'] is Map) {
        arrivalAirport = '${flight['arrival']['airport']['name'] ?? ''} (${flight['arrival']['airport']['iata'] ?? flight['arrival']['airport']['icao'] ?? ''})';
      } else if (flight['arrival_airport'] is String) {
        arrivalAirport = flight['arrival_airport'];
      }
      
      // Get delay information
      String delay = '';
      if (flight['delay_minutes'] != null) {
        delay = _formatDelay(flight['delay_minutes']);
      } else if (flight['delay'] != null) {
        delay = _formatDelay(flight['delay']);
      } else if (flight['status'] == 'Cancelled') {
        delay = 'Flight Cancelled';
      }
      
      // Get compensation amount
      String compensation = '';
      if (flight['compensation_amount_eur'] != null) {
        compensation = '€${flight['compensation_amount_eur']}';
      } else if (flight['compensationAmount'] != null) {
        compensation = '€${flight['compensationAmount']}';
      } else if (flight['distance_km'] != null) {
        // Use the distance to calculate based on EU261 rules
        int distanceKm = flight['distance_km'];
        if (distanceKm <= 1500) {
          compensation = '€250';
        } else if (distanceKm <= 3500) {
          compensation = '€400';
        } else {
          compensation = '€600';
        }
      }
      
      // Update controller values
      _airlineController.text = airline;
      _flightNumberController.text = flightNumber;
      _departureDateController.text = departureDate;
      _departureAirportController.text = departureAirport;
      _arrivalAirportController.text = arrivalAirport;
      _delayController.text = delay;
      _compensationAmountController.text = compensation;
      
      debugPrint('Flight data processed successfully');
    } catch (e) {
      debugPrint('Error processing flight data: $e');
      setState(() {
        _errorMessage = 'Error processing flight data. Using default values.';
      });
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      // Get the current user from Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      debugPrint('Current Firebase user: ${user?.email ?? 'No user logged in'}');
      
      if (user != null) {
        // Use the FirestoreService to get the user profile
        final firestoreService = FirestoreService();
        debugPrint('Attempting to load profile for user: ${user.uid}');
        
        final userProfile = await firestoreService.getUserProfile(user.uid);
        debugPrint('Profile loaded: ${userProfile != null ? 'Yes' : 'No'}');
        
        if (userProfile != null && mounted) {
          debugPrint('Setting profile data: ${userProfile.fullName}, ${userProfile.email}');
          
          // Pre-fill the form with user data - track which fields were prefilled
          _setAndTrackPrefill('_passengerNameController', _passengerNameController, userProfile.fullName);
          _setAndTrackPrefill('_passengerEmailController', _passengerEmailController, userProfile.email);
          
          // Add additional fields from the profile
          if (userProfile.phoneNumber != null && userProfile.phoneNumber!.isNotEmpty) {
            _setAndTrackPrefill('_passengerPhoneController', _passengerPhoneController, userProfile.phoneNumber!);
          }
          
          if (userProfile.nationality != null && userProfile.nationality!.isNotEmpty) {
            _setAndTrackPrefill('_passengerNationalityController', _passengerNationalityController, userProfile.nationality!);
          }
          
          if (userProfile.passportNumber != null && userProfile.passportNumber!.isNotEmpty) {
            _setAndTrackPrefill('_passengerPassportController', _passengerPassportController, userProfile.passportNumber!);
          }
          
          if (userProfile.addressLine != null && userProfile.addressLine!.isNotEmpty) {
            _setAndTrackPrefill('_passengerAddressController', _passengerAddressController, userProfile.addressLine!);
          }
          
          if (userProfile.city != null && userProfile.city!.isNotEmpty) {
            _setAndTrackPrefill('_passengerCityController', _passengerCityController, userProfile.city!);
          }
          
          if (userProfile.postalCode != null && userProfile.postalCode!.isNotEmpty) {
            _setAndTrackPrefill('_passengerPostalCodeController', _passengerPostalCodeController, userProfile.postalCode!);
          }
          
          if (userProfile.country != null && userProfile.country!.isNotEmpty) {
            _setAndTrackPrefill('_passengerCountryController', _passengerCountryController, userProfile.country!);
          }
        } else {
          // If no profile exists, use basic user data from Firebase Auth
          if (mounted) {
            // Use what's available from the Firebase user object
            if (user.displayName != null && user.displayName!.isNotEmpty) {
              _setAndTrackPrefill('_passengerNameController', _passengerNameController, user.displayName!);
            }
            if (user.email != null && user.email!.isNotEmpty) {
              _setAndTrackPrefill('_passengerEmailController', _passengerEmailController, user.email!);
            }
            if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
              _setAndTrackPrefill('_passengerPhoneController', _passengerPhoneController, user.phoneNumber!);
            }
            
            debugPrint('Using Firebase Auth data: ${user.displayName}, ${user.email}');
            
            // Set default country based on device locale if available
            final locale = WidgetsBinding.instance.window.locale;
            if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
              _setAndTrackPrefill('_passengerCountryController', _passengerCountryController, _getCountryName(locale.countryCode!));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      // We already have default values set, so no need for additional fallback
    } finally {
      // Always set loading to false when we're done, whether successful or not
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Helper to set controller text and track that it was prefilled
  void _setAndTrackPrefill(String controllerName, TextEditingController controller, String value) {
    controller.text = value;
    _prefilledFields[controllerName] = true;
  }
  
  // Get country name from country code
  String _getCountryName(String countryCode) {
    final Map<String, String> countryCodes = {
      'US': 'United States',
      'GB': 'United Kingdom',
      'PL': 'Poland',
      'DE': 'Germany',
      'FR': 'France',
      'ES': 'Spain',
      'IT': 'Italy',
      // Add more as needed
    };
    
    return countryCodes[countryCode] ?? countryCode;
  }
  
  @override
  void dispose() {
    _airlineController.dispose();
    _flightNumberController.dispose();
    _departureDateController.dispose();
    _departureAirportController.dispose();
    _arrivalAirportController.dispose();
    _delayController.dispose();
    _compensationAmountController.dispose();
    _passengerNameController.dispose();
    _passengerEmailController.dispose();
    _passengerPhoneController.dispose();
    _passengerNationalityController.dispose();
    _passengerPassportController.dispose();
    _passengerAddressController.dispose();
    _passengerCityController.dispose();
    _passengerPostalCodeController.dispose();
    _passengerCountryController.dispose();
    _bookingReferenceController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }
  
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Compensation Claim Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error message if any
              if (_errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(_errorMessage, style: TextStyle(color: Colors.red.shade800)),
                ),
              
              // Flight Information Section
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Flight Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    if (_airlineController.text.isNotEmpty)
                      TextFormField(
                        controller: _airlineController,
                        decoration: const InputDecoration(labelText: 'Airline'),
                        readOnly: true,
                      ),
                      
                    if (_flightNumberController.text.isNotEmpty)
                      TextFormField(
                        controller: _flightNumberController,
                        decoration: const InputDecoration(labelText: 'Flight Number'),
                        readOnly: true,
                      ),
                      
                    if (_departureDateController.text.isNotEmpty)
                      TextFormField(
                        controller: _departureDateController,
                        decoration: const InputDecoration(labelText: 'Date of Flight'),
                        readOnly: true,
                      ),
                      
                    if (_departureAirportController.text.isNotEmpty)
                      TextFormField(
                        controller: _departureAirportController,
                        decoration: const InputDecoration(labelText: 'Departure Airport'),
                        readOnly: true,
                      ),
                      
                    if (_arrivalAirportController.text.isNotEmpty)
                      TextFormField(
                        controller: _arrivalAirportController,
                        decoration: const InputDecoration(labelText: 'Arrival Airport'),
                        readOnly: true,
                      ),
                  ],
                ),
              ),
              
              // Delay and Compensation Section
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Compensation Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    if (_delayController.text.isNotEmpty)
                      TextFormField(
                        controller: _delayController,
                        decoration: const InputDecoration(labelText: 'Delay / Cancellation'),
                        readOnly: true,
                      ),
                      
                    if (_compensationAmountController.text.isNotEmpty)
                      TextFormField(
                        controller: _compensationAmountController,
                        decoration: const InputDecoration(labelText: 'Potential Compensation'),
                        readOnly: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Passenger Information Section
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Passenger Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_prefilledFields.isNotEmpty)
                          Tooltip(
                            message: 'Some fields were pre-filled from your profile',
                            child: Chip(
                              label: const Text('Pre-filled'),
                              backgroundColor: Colors.green.shade100,
                              avatar: Icon(Icons.account_circle, color: Colors.green.shade700, size: 18),
                              labelStyle: TextStyle(color: Colors.green.shade700, fontSize: 12),
                              padding: const EdgeInsets.all(2),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPrefilledFormField(
                      controller: _passengerNameController,
                      controllerName: '_passengerNameController',
                      labelText: 'Full Name', 
                      hintText: 'Your full legal name',
                      required: true,
                    ),
                    const SizedBox(height: 8),
                    _buildPrefilledFormField(
                      controller: _passengerEmailController,
                      controllerName: '_passengerEmailController',
                      labelText: 'Email Address', 
                      hintText: 'Your email address',
                      required: true,
                    ),
                    const SizedBox(height: 8),
                    _buildPrefilledFormField(
                      controller: _passengerPhoneController,
                      controllerName: '_passengerPhoneController',
                      labelText: 'Phone Number', 
                      hintText: 'Your phone number',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPrefilledFormField(
                            controller: _passengerNationalityController,
                            controllerName: '_passengerNationalityController',
                            labelText: 'Nationality', 
                            hintText: 'Your nationality',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPrefilledFormField(
                            controller: _passengerPassportController,
                            controllerName: '_passengerPassportController',
                            labelText: 'Passport/ID', 
                            hintText: 'Your passport/ID number',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Address Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildPrefilledFormField(
                      controller: _passengerAddressController,
                      controllerName: '_passengerAddressController',
                      labelText: 'Address', 
                      hintText: 'Street address',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPrefilledFormField(
                            controller: _passengerCityController,
                            controllerName: '_passengerCityController',
                            labelText: 'City', 
                            hintText: 'City',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPrefilledFormField(
                            controller: _passengerPostalCodeController,
                            controllerName: '_passengerPostalCodeController',
                            labelText: 'Postal Code', 
                            hintText: 'Postal code',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildPrefilledFormField(
                      controller: _passengerCountryController,
                      controllerName: '_passengerCountryController',
                      labelText: 'Country', 
                      hintText: 'Country',
                    ),
                    const SizedBox(height: 16),
                    const Text('Claim Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        hintText: 'Optional: Any additional details',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              
              // No Checklist Section for Pre-verified Flights
              // We're not using a checklist since these flights are already verified
              
              // Submit Button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'SUBMIT CLAIM', 
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Get current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('User not logged in');
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
        
        // Create claim submission
        final claimSubmission = CompensationClaimSubmission.fromFormData(
          userId: user.uid,
          formData: formData,
          flightData: widget.flightData,
          completedChecklistItems: _checklistItems.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toList(),
          hasAllDocuments: _checklistItems['documents'] ?? false,
        );
        
        // Save to Firestore
        final firestoreService = FirestoreService();
        await firestoreService.submitCompensationClaim(claimSubmission);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Claim submitted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        // Navigate back after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } catch (e) {
        // Show error message
        if (mounted) {
          setState(() {
            _errorMessage = 'Error submitting claim: ${e.toString()}';
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit claim: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        // Reset loading state if still mounted
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
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
}
