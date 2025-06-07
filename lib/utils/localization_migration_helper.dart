import 'package:flutter/material.dart';
import 'localization_util.dart';

/// This class helps migrate from Flutter's AppLocalizations to our custom LocalizationUtil
/// It provides a drop-in replacement that mimics the AppLocalizations API but uses our
/// stable manual localization service under the hood.
///
/// Usage:
/// 1. Replace: `final localizations = AppLocalizations.of(context)!;`
/// 2. With: `final localizations = MigrationLocalizations.of(context);`
///
/// The interface is compatible so all existing calls will continue to work
class MigrationLocalizations {
  /// Get the instance for the current context - drop-in replacement for AppLocalizations.of(context)
  static MigrationLocalizations of(BuildContext? context) {
    // Track the current locale to force refreshes when it changes
    // This is critical to ensure UI updates when language changes
    final currentLocale = LocalizationUtil.currentLocale;
    debugPrint('MigrationLocalizations: Accessed with locale $currentLocale');
    
    // Instead of always returning the same instance, we return a new one when locale changes
    // This ensures that the translations are refreshed
    if (_lastLocale != currentLocale.toString()) {
      _lastLocale = currentLocale.toString();
      _instance = MigrationLocalizations._internal();
      debugPrint('MigrationLocalizations: Created new instance for locale $currentLocale');
    }
    
    return _instance;
  }

  // Track the locale for which the current instance was created
  static String? _lastLocale;
  
  // Instance that will be recreated when locale changes
  static MigrationLocalizations _instance = MigrationLocalizations._internal();

  MigrationLocalizations._internal() {
    debugPrint('MigrationLocalizations: Instance initialized');
  }
  
  // Common localized strings used in the app
  // Add all the necessary getters from AppLocalizations that are used in your app
  
  String get appTitle => LocalizationUtil.getText('appTitle', fallback: 'Flight Compensation');
  String get myFlights => LocalizationUtil.getText('myFlights', fallback: 'My Flights');
  String get faqHelp => LocalizationUtil.getText('faqHelp', fallback: 'FAQ & Help');
  String get myDocuments => LocalizationUtil.getText('myDocuments', fallback: 'My Documents');
  String get accessibility => LocalizationUtil.getText('accessibility', fallback: 'Accessibility');
  String get accountSettings => LocalizationUtil.getText('accountSettings', fallback: 'Account Settings');
  String get profileInformation => LocalizationUtil.getText('profileInformation', fallback: 'Profile Information');
  String get editPersonalInfo => LocalizationUtil.getText('editPersonalInfo', fallback: 'Edit your personal information');
  String get editPersonalInfoDesc => LocalizationUtil.getText('editPersonalInfoDesc', fallback: 'Edit your personal and contact information');
  String get accessibilityOptions => LocalizationUtil.getText('accessibilityOptions', fallback: 'Accessibility Options');
  String get accessibilityOptionsDesc => LocalizationUtil.getText('accessibilityOptionsDesc', fallback: 'Configure high contrast, large text, and screen reader support');
  String get configureAccessibility => LocalizationUtil.getText('configureAccessibility', fallback: 'Configure accessibility options for the app');
  String get notificationSettings => LocalizationUtil.getText('notificationSettings', fallback: 'Notification Settings');
  String get configureNotifications => LocalizationUtil.getText('configureNotifications', fallback: 'Configure notification preferences');
  String get configureUpdatePreferences => LocalizationUtil.getText('configureUpdatePreferences', fallback: 'Configure how you receive claim updates');
  String get notificationSettingsComingSoon => LocalizationUtil.getText('notificationSettingsComingSoon', fallback: 'Notification settings coming soon');
  String get selectPreferredLanguage => LocalizationUtil.getText('selectPreferredLanguage', fallback: 'Select your preferred language');
  String get tipsAndReminders => LocalizationUtil.getText('tipsAndReminders', fallback: 'Tips & Reminders');
  String get tipProfileUpToDate => LocalizationUtil.getText('tipProfileUpToDate', fallback: 'Keep your profile up to date for smooth claim processing.');
  String get tipDataPrivacy => LocalizationUtil.getText('tipDataPrivacy', fallback: 'Your information is private and only used for compensation claims.');
  String get tipContactDetails => LocalizationUtil.getText('tipContactDetails', fallback: 'Make sure your contact details are correct so we can reach you about your claim.');
  String get tipAccessibilitySettings => LocalizationUtil.getText('tipAccessibilitySettings', fallback: 'Check the Accessibility Settings to customize the app for your needs.');
  
  // Claims dashboard getters
  String get active => LocalizationUtil.getText('active', fallback: 'Active');
  String get actionRequired => LocalizationUtil.getText('actionRequired', fallback: 'Action Required');
  String get completed => LocalizationUtil.getText('completed', fallback: 'Completed');
  String get refreshDashboard => LocalizationUtil.getText('refreshDashboard', fallback: 'Refresh Dashboard');
  String get claimStats => LocalizationUtil.getText('claimStats', fallback: 'Claim Statistics');
  String get claimsSummary => LocalizationUtil.getText('claimsSummary', fallback: 'Claims Summary');
  String get totalClaims => LocalizationUtil.getText('totalClaims', fallback: 'Total Claims');
  String get pendingClaims => LocalizationUtil.getText('pendingClaims', fallback: 'Pending Claims');
  String get successfulClaims => LocalizationUtil.getText('successfulClaims', fallback: 'Successful Claims');
  String get totalCompensation => LocalizationUtil.getText('totalCompensation', fallback: 'Total Compensation');
  String get noClaims => LocalizationUtil.getText('noClaims', fallback: 'No Claims');
  String get startNewClaim => LocalizationUtil.getText('startNewClaim', fallback: 'Start New Claim');
  String get claimDetails => LocalizationUtil.getText('claimDetails', fallback: 'Claim Details');
  String get status => LocalizationUtil.getText('status', fallback: 'Status');
  String get dateSubmitted => LocalizationUtil.getText('dateSubmitted', fallback: 'Date Submitted');
  
  // Compensation Claim Form
  String get compensationClaimForm => LocalizationUtil.getText('compensationClaimForm', fallback: 'Compensation Claim Form');
  String get addDocument => LocalizationUtil.getText('addDocument', fallback: 'Add Document');
  String get scanDocument => LocalizationUtil.getText('scanDocument', fallback: 'Scan Document');
  String get scanDocumentHint => LocalizationUtil.getText('scanDocumentHint', fallback: 'Use your camera to scan a document');
  String get useScannedInfo => LocalizationUtil.getText('useScannedInfo', fallback: 'Use Scanned Information?');
  String get scannedInfoFound => LocalizationUtil.getText('scannedInfoFound', fallback: 'We found useful information in your scanned document. Would you like to fill the form with this data?');
  String get noButton => LocalizationUtil.getText('noButton', fallback: 'No');
  String get yesFillForm => LocalizationUtil.getText('yesFillForm', fallback: 'Yes, Fill Form');
  String get uploadDocument => LocalizationUtil.getText('uploadDocument', fallback: 'Upload Document');
  String get uploadDocumentHint => LocalizationUtil.getText('uploadDocumentHint', fallback: 'Choose a file from your device');
  String get cancel => LocalizationUtil.getText('cancel', fallback: 'Cancel');
  String get airline => LocalizationUtil.getText('airline', fallback: 'Airline');
  String get thisFieldIsRequired => LocalizationUtil.getText('thisFieldIsRequired', fallback: 'This field is required');
  String get flightNumber => LocalizationUtil.getText('flightNumber', fallback: 'Flight Number');
  String get departureDate => LocalizationUtil.getText('departureDate', fallback: 'Departure Date');
  String get departureAirport => LocalizationUtil.getText('departureAirport', fallback: 'Departure Airport');
  String get arrivalAirport => LocalizationUtil.getText('arrivalAirport', fallback: 'Arrival Airport');
  String get pleaseEnterDepartureAirport => LocalizationUtil.getText('pleaseEnterDepartureAirport', fallback: 'Please enter departure airport');
  String get supportingDocuments => LocalizationUtil.getText('supportingDocuments', fallback: 'Supporting Documents');
  String get supportingDocumentsHint => LocalizationUtil.getText('supportingDocumentsHint', fallback: 'Add tickets, boarding passes, or other relevant documents');
  String get noDocumentsYet => LocalizationUtil.getText('noDocumentsYet', fallback: 'No documents added yet');
  String get viewAll => LocalizationUtil.getText('viewAll', fallback: 'View All');
  String get completeAllFields => LocalizationUtil.getText('completeAllFields', fallback: 'Please complete all required fields');
  String get loginRequiredForClaim => LocalizationUtil.getText('loginRequiredForClaim', fallback: 'You need to be logged in to submit a claim');
  String get claimSubmittedSuccessfully => LocalizationUtil.getText('claimSubmittedSuccessfully', fallback: 'Your claim has been submitted successfully');
  String get networkError => LocalizationUtil.getText('networkError', fallback: 'Network error: Please check your connection');
  String get generalError => LocalizationUtil.getText('generalError', fallback: 'An error occurred');
  String get scanningDocumentsNote => LocalizationUtil.getText('scanningDocumentsNote', fallback: 'You can scan documents like boarding passes and tickets');
  String get submitClaim => LocalizationUtil.getText('submitClaim', fallback: 'Submit Claim');
  String get uploaded => LocalizationUtil.getText('uploaded', fallback: 'Uploaded');
  String get scanned => LocalizationUtil.getText('scanned', fallback: 'Scanned');
  String get uploadBoardingPass => LocalizationUtil.getText('uploadBoardingPass', fallback: 'Upload Boarding Pass');
  String get scanBoardingPass => LocalizationUtil.getText('scanBoardingPass', fallback: 'Scan Boarding Pass');
  String get chooseUseInfo => LocalizationUtil.getText('chooseUseInfo', fallback: 'Choose how to use this information');
  String get fillPassengerFlight => LocalizationUtil.getText('fillPassengerFlight', fallback: 'Fill passenger and flight details in compensation form');
  String get flightSearch => LocalizationUtil.getText('flightSearch', fallback: 'Search for this flight');
  String get copyAllText => LocalizationUtil.getText('copyAllText', fallback: 'Copy All Text');
  String get copiedToClipboard => LocalizationUtil.getText('copiedToClipboard', fallback: 'Text copied to clipboard');
  String get fillForm => LocalizationUtil.getText('fillForm', fallback: 'Fill Form');
  String get noFieldsExtracted => LocalizationUtil.getText('noFieldsExtracted', fallback: 'No fields were extracted from the document');
  String get extractedInformation => LocalizationUtil.getText('extractedInformation', fallback: 'Extracted Information');
  String get rawOcrText => LocalizationUtil.getText('rawOcrText', fallback: 'Raw OCR Text');
  String get fullText => LocalizationUtil.getText('fullText', fallback: 'Full Text');
  String get done => LocalizationUtil.getText('done', fallback: 'Done');
  String get useExtractedData => LocalizationUtil.getText('useExtractedData', fallback: 'Use Extracted Data');
  String get documentOcrResult => LocalizationUtil.getText('documentOcrResult', fallback: 'OCR Result');
  String get extractedFields => LocalizationUtil.getText('extractedFields', fallback: 'Extracted Fields');
  String get aspectRatioPortrait => LocalizationUtil.getText('aspectRatioPortrait', fallback: 'Portrait');
  String get aspectRatioLandscape => LocalizationUtil.getText('aspectRatioLandscape', fallback: 'Landscape');
  String get aspectRatioFree => LocalizationUtil.getText('aspectRatioFree', fallback: 'Free');
  String get aspectRatioSquare => LocalizationUtil.getText('aspectRatioSquare', fallback: 'Square');
  String get crop => LocalizationUtil.getText('crop', fallback: 'Crop');
  String get cropping => LocalizationUtil.getText('cropping', fallback: 'Cropping...');
  String get cropDocument => LocalizationUtil.getText('cropDocument', fallback: 'Crop Document');
  String get aspectRatio => LocalizationUtil.getText('aspectRatio', fallback: 'Aspect Ratio');
  String get delay => LocalizationUtil.getText('delay', fallback: 'Delay');
  String get potentialCompensationLabel => LocalizationUtil.getText('potentialCompensationLabel', fallback: 'Potential Compensation');
  String get documentScanner => LocalizationUtil.getText('documentScanner', fallback: 'Document Scanner');
  String get processingDocument => LocalizationUtil.getText('processingDocument', fallback: 'Processing Document...');
  String get extractingText => LocalizationUtil.getText('extractingText', fallback: 'Extracting text...');
  String get flightLabel => LocalizationUtil.getText('flightLabel', fallback: 'Flight:');
  String get dateLabel => LocalizationUtil.getText('dateLabel', fallback: 'Date:');
  String get statusLabel => LocalizationUtil.getText('statusLabel', fallback: 'Status:');
  String get prefillCompensationForm => LocalizationUtil.getText('prefillCompensationForm', fallback: 'Pre-fill Compensation Form');
  String get requiredFieldsCompleted => LocalizationUtil.getText('requiredFieldsCompleted', fallback: 'All required fields completed');
  String get home => LocalizationUtil.getText('home', fallback: 'Home');
  String get claims => LocalizationUtil.getText('claims', fallback: 'Claims');
  String get profile => LocalizationUtil.getText('profile', fallback: 'Profile');
  String get additionalInformation => LocalizationUtil.getText('additionalInformation', fallback: 'Additional Information');
  String get fieldName => LocalizationUtil.getText('fieldName', fallback: 'Field Name');
  String get fieldValue => LocalizationUtil.getText('fieldValue', fallback: 'Field Value');
  String get errorConnectionFailed => LocalizationUtil.getText('errorConnectionFailed', fallback: 'Connection Failed');
  String get copyToClipboard => LocalizationUtil.getText('copyToClipboard', fallback: 'Copy to Clipboard');
  String get documentType => LocalizationUtil.getText('documentType', fallback: 'Document Type');
  String get saveDocument => LocalizationUtil.getText('saveDocument', fallback: 'Save Document');
  String get uploadDocuments => LocalizationUtil.getText('uploadDocuments', fallback: 'Upload Documents');
  String get rotate => LocalizationUtil.getText('rotate', fallback: 'Rotate');
  String get documentSaved => LocalizationUtil.getText('documentSaved', fallback: 'Document Saved');
  
  // Document types
  String get boardingPass => LocalizationUtil.getText('boardingPass', fallback: 'Boarding Pass');
  String get ticket => LocalizationUtil.getText('ticket', fallback: 'Ticket');
  String get luggageTag => LocalizationUtil.getText('luggageTag', fallback: 'Luggage Tag');
  String get delayConfirmation => LocalizationUtil.getText('delayConfirmation', fallback: 'Delay Confirmation');
  String get hotelReceipt => LocalizationUtil.getText('hotelReceipt', fallback: 'Hotel Receipt');
  String get mealReceipt => LocalizationUtil.getText('mealReceipt', fallback: 'Meal Receipt');
  String get transportReceipt => LocalizationUtil.getText('transportReceipt', fallback: 'Transport Receipt');
  String get otherDocument => LocalizationUtil.getText('otherDocument', fallback: 'Other Document');
  String get submissionChecklistTitle => LocalizationUtil.getText('submissionChecklistTitle', fallback: 'Submission Checklist');
  String get back => LocalizationUtil.getText('back', fallback: 'Back');
  String get save => LocalizationUtil.getText('save', fallback: 'Save');
  String get languageSelection => LocalizationUtil.getText('languageSelection', fallback: 'Language Selection');
  String get yes => LocalizationUtil.getText('yes', fallback: 'Yes');
  String get no => LocalizationUtil.getText('no', fallback: 'No');
  String get ok => LocalizationUtil.getText('ok', fallback: 'OK');
  String get welcomeMessage => LocalizationUtil.getText('welcomeMessage', fallback: 'Welcome to Flight Compensation App');
  String get settings => LocalizationUtil.getText('settings', fallback: 'Settings');
  String get startClaim => LocalizationUtil.getText('startClaim', fallback: 'Start Claim');
  String get euWideEligibleFlights => LocalizationUtil.getText('euWideEligibleFlights', fallback: 'EU-Wide Eligible Flights');
  String get dismiss => LocalizationUtil.getText('dismiss', fallback: 'Dismiss');
  String get delayedEligible => LocalizationUtil.getText('delayedEligible', fallback: 'Delayed & Eligible');
  String get flightDetected => LocalizationUtil.getText('flightDetected', fallback: 'Flight Detected');
  String get delayedFlightDetected => LocalizationUtil.getText('delayedFlightDetected', fallback: 'Delayed Flight Detected');
  
  // Parameterized localization methods
  String fromAirport(String airport) => LocalizationUtil.getText('fromAirport', 
    fallback: 'From: $airport', 
    replacements: {'airport': airport});
    
  String toAirport(String airport) => LocalizationUtil.getText('toAirport', 
    fallback: 'To: $airport', 
    replacements: {'airport': airport});
    
  String flightLabelWithValue(String flightNumber) => LocalizationUtil.getText('flightLabelWithValue', 
    fallback: 'Flight: $flightNumber', 
    replacements: {'flightNumber': flightNumber});
    
  String statusLabelWithValue(String status) => LocalizationUtil.getText('statusLabelWithValue', 
    fallback: 'Status: $status', 
    replacements: {'status': status});
  String get optional => LocalizationUtil.getText('optional', fallback: 'Optional');
  String get submissionChecklist => LocalizationUtil.getText('submissionChecklist', fallback: 'Submission Checklist');
  String get email => LocalizationUtil.getText('email', fallback: 'Email');
  String get bookingReference => LocalizationUtil.getText('bookingReference', fallback: 'Booking Reference');
  String get passengerDetails => LocalizationUtil.getText('passengerDetails', fallback: 'Passenger Details');
  String get passengerName => LocalizationUtil.getText('passengerName', fallback: 'Passenger Name');
  String get searchFlightNumber => LocalizationUtil.getText('searchFlightNumber', fallback: 'Search Flight Number');
  String get enterFlightNumberFirst => LocalizationUtil.getText('enterFlightNumberFirst', fallback: 'Please enter a flight number first');
  String get prefilledFromProfile => LocalizationUtil.getText('prefilledFromProfile', fallback: 'Some fields have been pre-filled from your profile');
  String get flightDetails => LocalizationUtil.getText('flightDetails', fallback: 'Flight Details');
  String get flightDate => LocalizationUtil.getText('flightDate', fallback: 'Flight Date');
  
  // Claims Screen
  String get myClaims => LocalizationUtil.getText('myClaims', fallback: 'My Claims');
  String get claimsListDescription => LocalizationUtil.getText('claimsListDescription', fallback: 'Below is a list of your submitted claims. Track the status, view details, or take action as needed.');
  String get manualClaimEntry => LocalizationUtil.getText('manualClaimEntry', fallback: 'Manual Claim Entry');
  String get loginRequired => LocalizationUtil.getText('loginRequired', fallback: 'You must be logged in to view your claims.');
  String get error => LocalizationUtil.getText('error', fallback: 'Error');
  String get noClaimsYet => LocalizationUtil.getText('noClaimsYet', fallback: 'No Claims Yet');
  String get startCompensationClaim => LocalizationUtil.getText('startCompensationClaim', fallback: 'Start your compensation claim by selecting a flight from the EU Eligible Flights section');
  String get createClaim => LocalizationUtil.getText('createClaim', fallback: 'Create a Claim');
  String get euWideCompensation => LocalizationUtil.getText('euWideCompensation', fallback: 'EU-wide Compensation Eligible Flights');
  
  // Flight Compensation Checker
  String get checkCompensationEligibility => LocalizationUtil.getText('checkCompensationEligibility', fallback: 'Check Compensation Eligibility');
  String get checkEligibilityTitle => LocalizationUtil.getText('checkEligibilityTitle', fallback: 'Check if your flight is eligible for EU261 compensation');
  String get flightNumberHint => LocalizationUtil.getText('flightNumberHint', fallback: 'Flight Number (e.g., BA123)');
  String get dateOptionalHint => LocalizationUtil.getText('dateOptionalHint', fallback: 'Date (YYYY-MM-DD, optional)');
  String get leaveEmptyForToday => LocalizationUtil.getText('leaveEmptyForToday', fallback: 'Leave empty for today');
  
  // EU Eligible Flights
  String delayWithMinutes(String minutes) => LocalizationUtil.getText('delayWithMinutes', 
    fallback: 'Delay: $minutes', 
    replacements: {'minutes': minutes});
  
  // Method to get a string for a key that isn't covered by the predefined getters
  String? getString(String key) {
    return LocalizationUtil.getText(key, fallback: key);
  }
  
  // Methods with parameters for formatted strings
  String formSubmissionError(String errorDetails) {
    return LocalizationUtil.getText('formSubmissionError', 
      replacements: {'error': errorDetails}, 
      fallback: 'Form submission error: $errorDetails');
  }
  
  String aspectRatioMode(String mode) {
    return LocalizationUtil.getText('aspectRatioMode',
      replacements: {'mode': mode},
      fallback: 'Aspect ratio: $mode');
  }
  
  // For handling string replacement in localized strings
  String replaceParams(String value, Map<String, String> params) {
    String result = value;
    params.forEach((key, val) {
      result = result.replaceAll('{$key}', val);
    });
    return result;
  }
}
