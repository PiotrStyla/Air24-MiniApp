import 'package:flutter/material.dart';
import '../models/confirmed_flight.dart';

/// Service for handling compensation form operations
class CompensationFormService extends ChangeNotifier {
  // Form data storage
  Map<String, dynamic> _formData = {};
  
  /// Get the current form data
  Map<String, dynamic> get formData => _formData;
  
  /// Clear all form data
  void clearFormData() {
    _formData = {};
    notifyListeners();
  }
  
  /// Update form data with values from a flight
  void prefillFromFlight(ConfirmedFlight flight) {
    _formData = {
      ..._formData,
      'flightNumber': flight.callsign,
      'departureAirport': flight.originAirport,
      'arrivalAirport': flight.destinationAirport,
      'flightDate': flight.detectedAt,
    };
    notifyListeners();
  }
  
  /// Update a specific form field
  void updateField(String fieldName, dynamic value) {
    _formData[fieldName] = value;
    notifyListeners();
  }
  
  /// Check if all required fields are filled
  bool areRequiredFieldsFilled(List<String> requiredFields) {
    return requiredFields.every((field) => 
      _formData.containsKey(field) && 
      _formData[field] != null && 
      _formData[field].toString().isNotEmpty
    );
  }
}
