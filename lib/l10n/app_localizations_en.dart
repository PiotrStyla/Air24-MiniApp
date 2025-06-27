// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flight Compensation';

  @override
  String welcomeUser(String userName) {
    return 'Welcome, $userName';
  }

  @override
  String get signOut => 'Sign Out';

  @override
  String get newClaim => 'New Claim';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get languageSelection => 'Language';

  @override
  String get passengerName => 'Passenger Name';

  @override
  String get passengerDetails => 'Passenger Details';

  @override
  String get flightNumber => 'Flight Number';

  @override
  String get airline => 'Airline';

  @override
  String get departureAirport => 'Departure Airport';

  @override
  String get arrivalAirport => 'Arrival Airport';

  @override
  String get email => 'Email';

  @override
  String get bookingReference => 'Booking Reference';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get optional => '(Optional)';

  @override
  String get thisFieldIsRequired => 'This field is required.';

  @override
  String get pleaseEnterDepartureAirport => 'Please enter a departure airport.';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get submitClaim => 'Submit Claim';

  @override
  String get addDocument => 'Add Document';

  @override
  String get claimSubmittedSuccessfully => 'Claim submitted successfully!';

  @override
  String get completeAllFields => 'Please complete all fields.';

  @override
  String get pleaseCompleteAllFields => 'Please complete all required fields.';

  @override
  String get pleaseAttachDocuments => 'Please attach required documents.';

  @override
  String get allFieldsCompleted => 'All fields completed.';

  @override
  String get processingDocument => 'Processing document...';

  @override
  String get supportingDocuments => 'Supporting Documents';

  @override
  String get cropDocument => 'Crop Document';

  @override
  String get crop => 'Crop';

  @override
  String get cropping => 'Cropping...';

  @override
  String get rotate => 'Rotate';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get aspectRatioFree => 'Free';

  @override
  String get aspectRatioSquare => 'Square';

  @override
  String get aspectRatioPortrait => 'Portrait';

  @override
  String get aspectRatioLandscape => 'Landscape';

  @override
  String aspectRatioMode(String ratio) {
    return 'Aspect Ratio: $ratio';
  }

  @override
  String get documentOcrResult => 'OCR Result';

  @override
  String get extractedFields => 'Extracted Fields';

  @override
  String get fullText => 'Full Text';

  @override
  String get documentSaved => 'Document saved.';

  @override
  String get useExtractedData => 'Use Extracted Data';

  @override
  String get copyToClipboard => 'Copied to clipboard.';

  @override
  String get documentType => 'Document Type';

  @override
  String get saveDocument => 'Save Document';

  @override
  String get fieldName => 'Field Name';

  @override
  String get done => 'Done';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get welcomeMessage => 'Welcome to the app!';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get fillForm => 'Fill Form';

  @override
  String get chooseUseInfo => 'Choose how to use this information:';

  @override
  String get fillPassengerFlight => 'Fill passenger and flight info';

  @override
  String get ocrResults => 'OCR Results';

  @override
  String get noFieldsExtracted => 'No fields were extracted from the document.';

  @override
  String get extractedInformation => 'Extracted Information';

  @override
  String get rawOcrText => 'Raw OCR Text';

  @override
  String get copyAllText => 'Copy all text';

  @override
  String get claims => 'Claims';

  @override
  String get noClaimsYet => 'No Claims Yet';

  @override
  String get startCompensationClaimInstructions => 'Start your compensation claim by selecting a flight from the EU Eligible Flights section';

  @override
  String get active => 'Active';

  @override
  String get actionRequired => 'Action Required';

  @override
  String get completed => 'Completed';

  @override
  String get profileInfoCardTitle => 'Your profile contains your personal and contact information. This is used to process your flight compensation claims and keep you updated.';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get accessibilityOptions => 'Accessibility Options';

  @override
  String get configureAccessibilityDescription => 'Configure high contrast, large text, and screen reader support';

  @override
  String get configureNotificationsDescription => 'Configure how you receive claim updates';

  @override
  String get tipProfileUpToDate => 'Keep your profile up to date for smooth claim processing.';

  @override
  String get tipInformationPrivate => 'Your information is private and only used for compensation claims.';

  @override
  String get tipContactDetails => 'Make sure your contact details are correct so we can reach you about your claim.';

  @override
  String get tipAccessibilitySettings => 'Check the Accessibility Settings to customize the app for your needs.';

  @override
  String get cancel => 'Cancel';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String arrivalsAt(String airport) {
    return 'Arrivals at $airport';
  }

  @override
  String get filterByAirline => 'Filter by airline';

  @override
  String get flightStatusDelayed => 'Delayed';

  @override
  String get flightStatusCancelled => 'Cancelled';

  @override
  String get flightStatusDiverted => 'Diverted';

  @override
  String get flightStatusOnTime => 'On time';

  @override
  String get flight => 'Flight';

  @override
  String get flights => 'Flights';

  @override
  String get myFlights => 'My Flights';

  @override
  String get findFlight => 'Find Flight';

  @override
  String get flightDate => 'Flight Date';

  @override
  String get checkCompensationEligibility => 'Check Compensation Eligibility';

  @override
  String get supportingDocumentsHint => 'Attach boarding passes, tickets, and other documents to strengthen your claim.';

  @override
  String get scanDocument => 'Scan Document';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get scanDocumentHint => 'Use camera to auto-fill form';

  @override
  String get uploadDocumentHint => 'Select from device storage';

  @override
  String get noDocumentsYet => 'No documents attached yet';

  @override
  String get enterFlightNumberFirst => 'Please enter a flight number first';

  @override
  String get viewAll => 'View All';

  @override
  String get documentScanner => 'Document Scanner';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get editPersonalInformation => 'Edit your personal information';

  @override
  String get editPersonalAndContactInformation => 'Edit your personal and contact information';

  @override
  String get configureAccessibilityOptions => 'Configure accessibility options for the app';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport => 'Configure high contrast, large text, and screen reader support';

  @override
  String get applicationPreferences => 'Application Preferences';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get configureNotificationPreferences => 'Configure notification preferences';

  @override
  String get configureHowYouReceiveClaimUpdates => 'Configure how you receive claim updates';

  @override
  String get language => 'Language';

  @override
  String get changeApplicationLanguage => 'Change application language';

  @override
  String get selectYourPreferredLanguage => 'Select your preferred language';

  @override
  String get tipsAndReminders => 'Tips & Reminders';

  @override
  String get importantTipsAboutProfileInformation => 'Important tips about your profile information';

  @override
  String get noClaimsYetTitle => 'No Claims Yet';

  @override
  String get noClaimsYetSubtitle => 'Start your compensation claim by selecting a flight from the EU Eligible Flights section';

  @override
  String get extractingText => 'Extracting text and identifying fields';

  @override
  String get scanInstructions => 'Position your document within the frame and take a photo';

  @override
  String get formFilledWithScannedData => 'Form filled with scanned document data';

  @override
  String get flightDetails => 'Flight Details';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get required => 'Required';

  @override
  String get submit => 'Submit';

  @override
  String get submissionChecklist => 'Submission Checklist';

  @override
  String get documentAttached => 'Document Attached';

  @override
  String get compensationClaimForm => 'Compensation Claim Form';

  @override
  String get prefilledFromProfile => 'Prefilled from your profile';

  @override
  String get flightSearch => 'Flight Search';

  @override
  String get searchFlightNumber => 'Search using flight number';

  @override
  String get delayedFlightDetected => 'Delayed Flight Detected';

  @override
  String get flightDetected => 'Flight Detected';

  @override
  String get flightLabel => 'Flight:';

  @override
  String get fromAirport => 'From:';

  @override
  String get toAirport => 'To:';

  @override
  String get statusLabel => 'Status:';

  @override
  String get delayedEligible => 'Delayed and potentially eligible';

  @override
  String get startClaim => 'Start Claim';

  @override
  String get euWideEligibleFlights => 'EU-wide Compensation Eligible Flights';

  @override
  String get requiredFieldsCompleted => 'All required fields are completed.';

  @override
  String get scanningDocumentsNote => 'Scanning documents can pre-fill some fields.';

  @override
  String get tipCheckEligibility => '• Ensure your flight is eligible for compensation (e.g., delay >3h, cancellation, denied boarding).';

  @override
  String get tipDoubleCheckDetails => '• Double-check all details before submitting to avoid delays.';

  @override
  String get tooltipFaqHelp => 'Access the frequently asked questions and help section';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get networkError => 'Network error. Please check your internet connection.';

  @override
  String get generalError => 'An unexpected error occurred. Please try again later.';

  @override
  String get loginRequiredForClaim => 'You must be logged in to submit a claim.';

  @override
  String get quickClaimTitle => 'Quick Claim';

  @override
  String get quickClaimInfoBanner => 'For EU-eligible flights. Fill in basic info for a quick preliminary check.';

  @override
  String get flightNumberHintQuickClaim => 'Usually a 2-letter airline code and digits, e.g. LH1234';

  @override
  String get departureAirportHintQuickClaim => 'e.g. FRA for Frankfurt, LHR for London Heathrow';

  @override
  String get arrivalAirportHintQuickClaim => 'e.g. JFK for New York, CDG for Paris';

  @override
  String get reasonForClaimLabel => 'Reason for Claim';

  @override
  String get reasonForClaimHint => 'State why you are claiming: delay, cancellation, denied boarding, etc.';

  @override
  String get compensationAmountOptionalLabel => 'Compensation Amount (optional)';

  @override
  String get compensationAmountHint => 'If you know the amount you are eligible for, enter it here';

  @override
  String get euWideCompensationTitle => 'EU-wide Compensation';

  @override
  String get last72HoursButton => 'Last 72 hours';

  @override
  String get scheduledLabel => 'Scheduled:';

  @override
  String get statusLabelEuList => 'Status:';

  @override
  String get potentialCompensationLabel => 'Potential Compensation:';

  @override
  String get prefillCompensationFormButton => 'Pre-fill Compensation Form';

  @override
  String get claimsTabActive => 'Active';

  @override
  String get claimsTabActionRequired => 'Action Required';

  @override
  String get claimsTabCompleted => 'Completed';

  @override
  String get dialogTitleSuccess => 'Success!';

  @override
  String get dialogContentClaimSubmitted => 'Your claim has been submitted successfully.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Document Management';

  @override
  String get attachDocumentsTitle => 'Attach Documents';

  @override
  String get uploadNewButton => 'Upload New';

  @override
  String get continueButton => 'Continue';

  @override
  String get noDocumentsMessage => 'You have no documents.';

  @override
  String get uploadFirstDocumentButton => 'Upload First Document';

  @override
  String get uploadingMessage => 'Uploading document...';

  @override
  String get uploadSuccessMessage => 'Document uploaded successfully!';

  @override
  String get uploadFailedMessage => 'Upload failed. Please try again.';

  @override
  String get claimAttachment => 'Claim Attachment';

  @override
  String get documentsForFlightTitle => 'Documents for flight';

  @override
  String get errorLoadingDocuments => 'Error Loading Documents';

  @override
  String get addDocumentTooltip => 'Add Document';

  @override
  String get deleteDocumentTitle => 'Delete Document?';

  @override
  String get deleteDocumentMessage => 'Are you sure you want to delete';

  @override
  String get delete => 'Delete';

  @override
  String get errorMustBeLoggedIn => 'You must be logged in to perform this action.';

  @override
  String get errorFailedToSubmitClaim => 'Failed to submit claim. Please try again.';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get validatorFlightNumberRequired => 'Flight number is required.';

  @override
  String get tooltipFlightNumberQuickClaim => 'Enter the flight number (e.g., BA2490).';

  @override
  String get tooltipFlightDateQuickClaim => 'Select the date of your flight.';

  @override
  String get validatorDepartureAirportRequired => 'Departure airport is required.';

  @override
  String get euEligibleFlightsTitle => 'EU Eligible Flights';

  @override
  String get filterByAirlineName => 'Filter by Airline Name';

  @override
  String get loadingFlights => 'Loading eligible flights...';

  @override
  String get errorLoadingFlights => 'Error loading flights';

  @override
  String get noEligibleFlightsFound => 'No eligible flights found.';

  @override
  String get noFlightsMatchFilter => 'No flights match your filter.';

  @override
  String get checkCompensation => 'Check Compensation';

  @override
  String get tooltipDepartureAirportQuickClaim => 'Enter the 3-letter IATA code for the departure airport (e.g., LHR).';

  @override
  String get validatorArrivalAirportRequired => 'Arrival airport is required.';

  @override
  String get tooltipArrivalAirportQuickClaim => 'Enter the 3-letter IATA code for the arrival airport (e.g., JFK).';

  @override
  String get hintTextReasonQuickClaim => 'Reason (delay, cancellation, etc.)';

  @override
  String get validatorReasonRequired => 'Reason for claim is required.';

  @override
  String get tooltipReasonQuickClaim => 'Briefly state the reason for your claim (e.g., 4-hour delay).';

  @override
  String get tooltipCompensationAmountQuickClaim => 'Enter the compensation amount if known (e.g., 250 EUR).';

  @override
  String get tipsAndRemindersTitle => 'Tips & Reminders';

  @override
  String get tipSecureData => '• Your data is stored securely and used only for claim processing.';

  @override
  String compensationEligibleArrivalsAt(String airportIcao) {
    return 'Eligible Arrivals at $airportIcao';
  }

  @override
  String errorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get signInToTrackClaims => 'Sign in to track your claims';

  @override
  String get createAccountDescription => 'Create an account or sign in to manage your compensation claims.';

  @override
  String get signInOrSignUp => 'Sign In / Sign Up';

  @override
  String get genericUser => 'User';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get carrierName => 'Carrier Name';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get clearDate => 'Clear Date';

  @override
  String get noEligibleArrivalsFound => 'No compensation-eligible arrivals found for the selected filters.';

  @override
  String flightAndAirline(String flightNumber, String airlineName) {
    return '$flightNumber - $airlineName';
  }

  @override
  String scheduledTime(String time) {
    return 'Scheduled: $time';
  }

  @override
  String fromAirportName(String airportName) {
    return 'From: $airportName';
  }

  @override
  String revisedTime(String time) {
    return 'Revised: $time';
  }

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get euCompensationEligible => 'EU Compensation Eligible';

  @override
  String actualTime(String time) {
    return 'Actual: $time';
  }

  @override
  String delayAmount(String delay) {
    return 'Delay: $delay';
  }

  @override
  String aircraftModel(String model) {
    return 'Aircraft: $model';
  }

  @override
  String compensationAmount(String amount) {
    return 'Compensation: $amount';
  }

  @override
  String get flightNumberLabel => 'Flight Number';

  @override
  String get flightNumberHint => 'e.g., BA2490';

  @override
  String get departureAirportLabel => 'Departure Airport';

  @override
  String get departureAirportHint => 'e.g., LHR';

  @override
  String get arrivalAirportLabel => 'Arrival Airport';

  @override
  String get arrivalAirportHint => 'e.g., JFK';

  @override
  String get flightDateLabel => 'Flight Date';

  @override
  String get flightDateHint => 'Select the date of your flight';

  @override
  String get flightDateError => 'Please select a flight date';

  @override
  String get continueToAttachmentsButton => 'Continue to Attachments';

  @override
  String get fieldValue => 'Field Value';

  @override
  String get errorConnectionFailed => 'Connection failed';

  @override
  String get submitNewClaimTitle => 'Submit New Claim';

  @override
  String get airlineLabel => 'Airline';

  @override
  String get other => 'Other';

  @override
  String get documentTypeBoardingPass => 'Boarding Pass';

  @override
  String get documentTypeId => 'ID Document';

  @override
  String get documentTypeTicket => 'Ticket';

  @override
  String get documentTypeBookingConfirmation => 'Booking Confirmation';

  @override
  String get documentTypeETicket => 'E-Ticket';

  @override
  String get documentTypeLuggageTag => 'Luggage Tag';

  @override
  String get documentTypeDelayConfirmation => 'Delay Confirmation';

  @override
  String get documentTypeHotelReceipt => 'Hotel Receipt';

  @override
  String get documentTypeMealReceipt => 'Meal Receipt';

  @override
  String get documentTypeTransportReceipt => 'Transport Receipt';

  @override
  String get documentTypeOther => 'Other';
}
