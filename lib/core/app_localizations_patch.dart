import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'dart:developer' as developer;

/// CRITICAL EMERGENCY PATCH FOR NULL CHECK OPERATOR ERRORS
/// This extension provides a safe way to access AppLocalizations
/// without risking null check errors

/// Extension on BuildContext for safe AppLocalizations access
extension AppLocalizationsExt on BuildContext {
  /// Safely get AppLocalizations without risk of null check errors
  /// This method will never return null, instead providing a fallback
  AppLocalizations get l10n {
    AppLocalizations? localizations;
    try {
      localizations = Localizations.of<AppLocalizations>(this, AppLocalizations);
      if (localizations != null) {
        return localizations;
      }
    } catch (e) {
      debugPrint('⚠️ SAFETY: Error accessing AppLocalizations: $e');
    }
    
    debugPrint('⚠️ SAFETY: Creating DynamicEmergencyLocalizations');
    return DynamicEmergencyLocalizations();
  }
}

/// A highly dynamic emergency fallback for AppLocalizations
/// Uses Dart's noSuchMethod to handle ALL possible method calls
class DynamicEmergencyLocalizations implements AppLocalizations {
  // Store the locale - defaults to English
  final String locale;
  
  // Cache of common localization strings to avoid repeated logging
  final Map<String, String> _cachedValues = {};

  // Constructor
  DynamicEmergencyLocalizations([this.locale = 'en']);
  
  // Debug output to track which methods are being called
  void _logAccess(String methodName, List<dynamic>? positionalArgs) {
    // Don't log for methods that are called frequently
    if (!_frequentMethods.contains(methodName)) {
      developer.log(
        '🔍 EMERGENCY LOCALIZATION ACCESS: $methodName${positionalArgs != null ? ' with args: $positionalArgs' : ''}',
        name: 'EmergencyL10n',
      );
    }
  }

  // List of frequently called methods that we don't need to log every time
  static const List<String> _frequentMethods = [
    'home', 'settings', 'profile', 'welcome', 'genericUser', 'welcomeUser',
    'claimForFlight', 'flightRouteDetails', 'flightRouteDetailsWithNumber'
  ];

  //===================================================================
  // PROFILE SCREEN LOCALIZATIONS
  //===================================================================
  String get receiveNotifications => _getCachedValue('receiveNotifications', 'Receive Notifications');
  String get getClaimUpdates => _getCachedValue('getClaimUpdates', 'Get Claim Updates');
  String get saveProfile => _getCachedValue('saveProfile', 'Save Profile');
  String get profileInformation => _getCachedValue('profileInformation', 'Profile Information');
  String get name => _getCachedValue('name', 'Name');
  String get firstName => _getCachedValue('firstName', 'First Name');
  String get lastName => _getCachedValue('lastName', 'Last Name');
  String get email => _getCachedValue('email', 'Email');
  String get phone => _getCachedValue('phone', 'Phone');
  String get address => _getCachedValue('address', 'Address');
  String get city => _getCachedValue('city', 'City');
  String get country => _getCachedValue('country', 'Country');
  String get postalCode => _getCachedValue('postalCode', 'Postal Code');
  
  //===================================================================
  // CLAIM SUBMISSION SCREEN LOCALIZATIONS
  //===================================================================
  String get pleaseSelectFlightDate => _getCachedValue('pleaseSelectFlightDate', 'Please select a flight date');
  String get submitNewClaim => _getCachedValue('submitNewClaim', 'Submit New Claim');
  String get pleaseEnterArrivalAirport => _getCachedValue('pleaseEnterArrivalAirport', 'Please enter arrival airport');
  String get pleaseEnterReason => _getCachedValue('pleaseEnterReason', 'Please enter reason for claim');
  String get flightDateHint => _getCachedValue('flightDateHint', 'Select flight date');
  String get departureAirport => _getCachedValue('departureAirport', 'Departure Airport');
  String get arrivalAirport => _getCachedValue('arrivalAirport', 'Arrival Airport');
  String get flightNumber => _getCachedValue('flightNumber', 'Flight Number');
  String get flightDate => _getCachedValue('flightDate', 'Flight Date');
  String get reasonForClaim => _getCachedValue('reasonForClaim', 'Reason for Claim');
  String get attachments => _getCachedValue('attachments', 'Attachments');
  String get proceedToConfirmation => _getCachedValue('proceedToConfirmation', 'Proceed to Confirmation');
  String get submitClaim => _getCachedValue('submitClaim', 'Submit Claim');
  
  //===================================================================
  // ERROR MESSAGES
  //===================================================================
  String get unknownError => _getCachedValue('unknownError', 'Unknown Error');
  String get retry => _getCachedValue('retry', 'Retry');
  String get claimNotFound => _getCachedValue('claimNotFound', 'Claim Not Found');
  String get claimNotFoundDesc => _getCachedValue('claimNotFoundDesc', 'The claim you are looking for could not be found');
  String get backToDashboard => _getCachedValue('backToDashboard', 'Back to Dashboard');
  String get reviewYourClaim => _getCachedValue('reviewYourClaim', 'Review Your Claim');
  String get reviewClaimDetails => _getCachedValue('reviewClaimDetails', 'Review Claim Details');
  
  //===================================================================
  // DASHBOARD LOCALIZATIONS
  //===================================================================
  String get eu261Rights => _getCachedValue('eu261Rights', 'EU 261 Rights');
  String get dontLetAirlinesWin => _getCachedValue('dontLetAirlinesWin', 'Don\'t let airlines win');
  String get submitClaimAnyway => _getCachedValue('submitClaimAnyway', 'Submit claim anyway');
  String get number => _getCachedValue('number', 'Number');
  String get newClaim => _getCachedValue('newClaim', 'New Claim');
  String get notLoggedIn => _getCachedValue('notLoggedIn', 'Not logged in');
  String get signIn => _getCachedValue('signIn', 'Sign In');
  String get signOut => _getCachedValue('signOut', 'Sign Out');
  String get home => _getCachedValue('home', 'Home');
  String get settings => _getCachedValue('settings', 'Settings');
  String get profile => _getCachedValue('profile', 'Profile');
  String get welcome => _getCachedValue('welcome', 'Welcome');
  String get genericUser => _getCachedValue('genericUser', 'User');
  String get checkFlightEligibilityButtonText => _getCachedValue('checkFlightEligibilityButtonText', 'Check Flight Compensation Eligibility');
  String get euEligibleFlightsButtonText => _getCachedValue('euEligibleFlightsButtonText', 'EU-Wide Compensation Eligible Flights');
  
  //===================================================================
  // COMMON METHOD IMPLEMENTATIONS
  //===================================================================
  // Support for direct pattern matching on frequently used methods with parameters
  
  // Method with parameters to match AppLocalizations
  @override
  String welcomeUser(String name, String role, Object userName) {
    _logAccess('welcomeUser', [name, role, userName]);
    return 'Welcome $name, you are logged in as a $role';
  }

  // Method with 3 parameters - the overload that actually exists in code
  String welcomeUser3(String name, String role, String company) {
    return 'Welcome, $name ($role at $company)';
  }

  // Method with 2 parameters
  String claimForFlight(String flightNumber, String status) {
    return 'Claim for $flightNumber ($status)';
  }

  // Method with 3 parameters to match AppLocalizations
  @override
  String flightRouteDetails(String departure, String arrival) {
    return '$departure → $arrival';
  }
  
  // Method with all required parameters according to AppLocalizations
  @override
  String flightRouteDetailsWithNumber(
    String departureCode,
    String arrivalCode,
    String departureCity,
    String arrivalCity,
    String flightNumber,
    String airline,
    String date,
    String departureTime,
    Object arrivalTime
  ) {
    return '$departureCity ($departureCode) → $arrivalCity ($arrivalCode) | $airline $flightNumber | $date $departureTime - $arrivalTime';
  }

  // Error messages
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }
  
  String errorFailedToSubmitClaim(String error) {
    return 'Failed to submit claim: $error';
  }
  
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Form submission failed: $errorMessage';
  }
  
  // Direct implementation of formSubmissionError to match generated localization methods
  @override
  String formSubmissionError(String error) {
    _logAccess('formSubmissionError', [error]);
    return 'Form submission error: $error';
  }
  
  String emailAppOpenedMessage(String email) {
    return 'Email app opened with $email';
  }

  // Helper method to cache and retrieve values
  String _getCachedValue(String key, String defaultValue) {
    if (!_cachedValues.containsKey(key)) {
      _cachedValues[key] = defaultValue;
    }
    return _cachedValues[key]!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Get method name for debugging
    final methodName = invocation.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '');
    _logAccess(methodName, invocation.positionalArguments);
    
    // For getters, return a placeholder string
    if (invocation.isGetter) {
      return _getCachedValue(methodName, 'Text ($methodName)');
    }
    
    // For methods with arguments, include first arg in the response if available
    if (invocation.positionalArguments.isNotEmpty) {
      final arg = invocation.positionalArguments.first;
      
      // For well-known parameter formats
      if (methodName == 'welcomeUser') {
        if (invocation.positionalArguments.length == 3) {
          // Full 3-parameter signature found in build errors
          return welcomeUser3(
            arg.toString(),
            invocation.positionalArguments[1].toString(),
            invocation.positionalArguments[2].toString()
          );
        } else {
          // Default to 3-parameter version with defaults for missing arguments
          return welcomeUser(arg.toString(), 'user', 'default');
        }
      } else if (methodName == 'claimForFlight' && invocation.positionalArguments.length == 2) {
        return claimForFlight(
          arg.toString(),
          invocation.positionalArguments[1].toString()
        );
      } else if (methodName == 'flightRouteDetails') {
        // Handle both 2 and 3 parameter versions
        final departure = arg.toString();
        final arrival = invocation.positionalArguments.length > 1 ? invocation.positionalArguments[1].toString() : '';
        
        return flightRouteDetails(departure, arrival);
      } else if (methodName == 'flightRouteDetailsWithNumber') {
        // Handle both 3 and 5 parameter versions
        if (invocation.positionalArguments.length >= 3) {
          final departureAirport = arg.toString();
          final arrivalAirport = invocation.positionalArguments[1].toString();
          final flightNumber = invocation.positionalArguments[2].toString();
          final date = invocation.positionalArguments.length > 3 ? invocation.positionalArguments[3].toString() : '';
          final time = invocation.positionalArguments.length > 4 ? invocation.positionalArguments[4].toString() : '';
          
          // Match the full signature by providing all required parameters
          return flightRouteDetailsWithNumber(
            departureAirport,  // departureCode
            arrivalAirport,    // arrivalCode
            departureAirport,  // departureCity
            arrivalAirport,    // arrivalCity
            flightNumber,      // flightNumber
            '',                // airline
            date,              // date
            time,              // departureTime
            ''                 // arrivalTime (as Object)
          );
        }
      } else if (methodName == 'errorSigningOut' && invocation.positionalArguments.length == 1) {
        return errorSigningOut(arg.toString());
      } else if (methodName == 'errorFormSubmissionFailed' && invocation.positionalArguments.length == 1) {
        return errorFormSubmissionFailed(arg.toString());
      } else if (methodName == 'errorFailedToSubmitClaim' && invocation.positionalArguments.length == 1) {
        return errorFailedToSubmitClaim(arg.toString());
      } else if (methodName == 'emailAppOpenedMessage' && invocation.positionalArguments.length == 1) {
        return emailAppOpenedMessage(arg.toString());
      }
      
      // Default for other methods with arguments
      return 'Text ($methodName: $arg)';
    }
    
    // Default fallback
    return _getCachedValue(methodName, 'Text ($methodName)');
  }
}
