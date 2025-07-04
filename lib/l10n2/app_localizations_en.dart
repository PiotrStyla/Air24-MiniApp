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
  String get flightNumber => 'Flight Number:';

  @override
  String get airline => 'Airline';

  @override
  String get departureAirport => 'Departure Airport:';

  @override
  String get arrivalAirport => 'Arrival Airport:';

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
  String get startCompensationClaimInstructions =>
      'Start your compensation claim by selecting a flight from the EU Eligible Flights section';

  @override
  String get active => 'Active';

  @override
  String get actionRequired => 'Action Required';

  @override
  String get completed => 'Completed';

  @override
  String get profileInfoCardTitle =>
      'Your profile contains your personal and contact information. This is used to process your flight compensation claims and keep you updated.';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get accessibilityOptions => 'Accessibility Options';

  @override
  String get configureAccessibilityDescription =>
      'Configure high contrast, large text, and screen reader support';

  @override
  String get configureNotificationsDescription =>
      'Configure how you receive claim updates';

  @override
  String get tipProfileUpToDate => 'Keep Your Profile Up-to-date';

  @override
  String get tipInformationPrivate => 'Your Information is Private';

  @override
  String get tipContactDetails => 'Contact Details';

  @override
  String get tipAccessibilitySettings => 'Accessibility Settings';

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
  String get flightDate => 'Flight Date:';

  @override
  String get checkCompensationEligibility => 'Check Compensation Eligibility';

  @override
  String get supportingDocumentsHint =>
      'Attach boarding passes, tickets, and other documents to strengthen your claim.';

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
  String get editPersonalAndContactInformation =>
      'Edit your personal and contact information';

  @override
  String get configureAccessibilityOptions =>
      'Configure accessibility options for the app';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport =>
      'Configure high contrast, large text, and screen reader support';

  @override
  String get applicationPreferences => 'Application Preferences';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get configureNotificationPreferences =>
      'Configure notification preferences';

  @override
  String get configureHowYouReceiveClaimUpdates =>
      'Configure how you receive claim updates';

  @override
  String get language => 'Language';

  @override
  String get changeApplicationLanguage => 'Change application language';

  @override
  String get selectYourPreferredLanguage => 'Select your preferred language';

  @override
  String get tipsAndReminders => 'Tips & Reminders';

  @override
  String get importantTipsAboutProfileInformation =>
      'Important tips about your profile information';

  @override
  String get noClaimsYetTitle => 'No Claims Yet';

  @override
  String get noClaimsYetSubtitle =>
      'Start your compensation claim by selecting a flight from the EU Eligible Flights section';

  @override
  String get extractingText => 'Extracting text and identifying fields';

  @override
  String get scanInstructions =>
      'Position your document within the frame and take a photo';

  @override
  String get formFilledWithScannedData =>
      'Form filled with scanned document data';

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
  String get claimNotFound => 'Claim Not Found';

  @override
  String get claimNotFoundDesc =>
      'The requested claim could not be found. It may have been deleted.';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get euWideEligibleFlights => 'EU-wide Compensation Eligible Flights';

  @override
  String get submitNewClaim => 'Submit New Claim';

  @override
  String get reasonForClaim => 'Reason for Claim:';

  @override
  String get flightDateHint => 'Select the date of your flight';

  @override
  String get continueToAttachments => 'Continue to Attachments';

  @override
  String get pleaseEnterFlightNumber => 'Please enter a flight number';

  @override
  String get pleaseEnterArrivalAirport => 'Please enter an arrival airport';

  @override
  String get pleaseEnterReason => 'Please enter a reason';

  @override
  String get pleaseSelectFlightDate => 'Please select a flight date.';

  @override
  String get claimDetails => 'Claim Details';

  @override
  String get refresh => 'Refresh';

  @override
  String get errorLoadingClaim => 'Error loading claim';

  @override
  String get retry => 'Retry';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get requiredFieldsCompleted => 'All required fields are completed.';

  @override
  String get scanningDocumentsNote =>
      'Scanning documents can pre-fill some fields.';

  @override
  String get tipCheckEligibility =>
      'Check EU Regulation 261/2004 eligibility before claiming.';

  @override
  String get tipDoubleCheckDetails =>
      'Double-check all details before submitting your claim.';

  @override
  String get tooltipFaqHelp => 'View FAQ help';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get generalError =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get loginRequiredForClaim =>
      'You must be logged in to submit a claim.';

  @override
  String get quickClaimTitle => 'Quick Claim';

  @override
  String get quickClaimInfoBanner =>
      'For EU-eligible flights. Fill in basic info for a quick preliminary check.';

  @override
  String get flightNumberHintQuickClaim =>
      'Usually a 2-letter airline code and digits, e.g. LH1234';

  @override
  String get departureAirportHintQuickClaim =>
      'e.g. FRA for Frankfurt, LHR for London Heathrow';

  @override
  String get arrivalAirportHintQuickClaim =>
      'e.g. JFK for New York, CDG for Paris';

  @override
  String get reasonForClaimLabel => 'Reason for Claim';

  @override
  String get reasonForClaimHint =>
      'Provide details about what happened with your flight';

  @override
  String get compensationAmountOptionalLabel =>
      'Compensation Amount (optional)';

  @override
  String get compensationAmountHint =>
      'If you know the amount you are eligible for, enter it here';

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
  String get dialogContentClaimSubmitted =>
      'Your claim has been submitted successfully.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Document Management';

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
  String get errorMustBeLoggedIn =>
      'You must be logged in to perform this action.';

  @override
  String get errorFailedToSubmitClaim =>
      'Failed to submit claim. Please try again.';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get validatorFlightNumberRequired => 'Flight number is required.';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Enter the flight number as shown on your ticket or booking';

  @override
  String get tooltipFlightDateQuickClaim =>
      'Date when your flight was scheduled to depart';

  @override
  String get validatorDepartureAirportRequired =>
      'Departure airport is required.';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Enter the 3-letter IATA code for the departure airport';

  @override
  String get validatorArrivalAirportRequired => 'Arrival airport is required.';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Enter the 3-letter IATA code for the arrival airport';

  @override
  String get hintTextReasonQuickClaim =>
      'State why you are claiming: delay, cancellation, denied boarding, etc.';

  @override
  String get validatorReasonRequired => 'Reason for claim is required.';

  @override
  String get tooltipReasonQuickClaim =>
      'Explain the reason for your claim in detail';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Enter the amount if you know what you are eligible for';

  @override
  String get tipsAndRemindersTitle => 'Tips and Reminders';

  @override
  String get tipSecureData => 'Your data is secure and encrypted.';

  @override
  String get processingDocument => 'Processing document...';

  @override
  String get fieldValue => 'Field Value';

  @override
  String get errorConnectionFailed =>
      'Connection failed. Please check your network.';

  @override
  String lastHours(int hours) {
    return 'Last $hours hours';
  }

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'No flights matching filter: $filter';
  }

  @override
  String get forceRefreshData => 'Force refresh data';

  @override
  String get forcingFreshDataLoad => 'Forcing a fresh data load...';

  @override
  String get checkAgain => 'Check again';

  @override
  String get euWideCompensationEligibleFlights =>
      'EU Compensation Eligible Flights';

  @override
  String get noEligibleFlightsFound => 'No eligible flights found';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'No flights found in the last $hours hours.';
  }

  @override
  String get apiConnectionIssue => 'API connection issue. Please try again.';

  @override
  String get createClaim => 'Create a Claim';

  @override
  String get submitted => 'Submitted';

  @override
  String get inReview => 'Under Review';

  @override
  String get processing => 'Processing';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get paid => 'Paid';

  @override
  String get underAppeal => 'Under Appeal';

  @override
  String get unknown => 'Unknown';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get errorLoadingClaims => 'Error Loading Claims';

  @override
  String get loginToViewClaimsDashboard =>
      'Please log in to view your claims dashboard';

  @override
  String get logIn => 'Log In';

  @override
  String claimForFlight(Object number, Object status) {
    return 'Claim for flight $number - $status';
  }

  @override
  String flightRouteDetails(Object number, Object departure, Object arrival) {
    return 'Flight $number: $departure - $arrival';
  }

  @override
  String get viewClaimDetails => 'View claim details';

  @override
  String get totalCompensation => 'Total Compensation';

  @override
  String get pendingAmount => 'Pending Amount';

  @override
  String get pending => 'Pending';

  @override
  String get claimsDashboard => 'Claims Dashboard';

  @override
  String get refreshDashboard => 'Refresh Dashboard';

  @override
  String get claimsSummary => 'Claims Summary';

  @override
  String get totalClaims => 'Total Claims';

  @override
  String get accessibilitySettings => 'Accessibility Settings';

  @override
  String get configureAccessibility => 'Configure accessibility options';

  @override
  String get configureNotifications => 'Configure notifications';

  @override
  String get notificationSettingsComingSoon =>
      'Notification settings coming soon!';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get editPersonalInfo => 'Edit Personal Information';

  @override
  String get editPersonalInfoDescription =>
      'Update your personal details, address, and contact information';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get signInOrSignUp => 'Sign In / Sign Up';

  @override
  String get genericUser => 'User';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get signInToTrackClaims => 'Sign in to track your claims';

  @override
  String get createAccountDescription =>
      'Create an account to easily track all your compensation claims';

  @override
  String get continueToAttachmentsButton => 'Continue to Attachments';

  @override
  String get continueToReview => 'Continue to Review';

  @override
  String get country => 'Country';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get consentToShareData => 'Consent to Share Data';

  @override
  String get requiredForProcessing => 'Required for processing your claims';

  @override
  String get receiveNotifications => 'Receive Notifications';

  @override
  String get getClaimUpdates => 'Get updates about your claims';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get passportNumber => 'Passport Number';

  @override
  String get nationality => 'Nationality';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get dateFormat => 'DD/MM/YYYY';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get profileSaved => 'Profile saved successfully';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileAccuracyInfo =>
      'Please ensure your profile information is accurate';

  @override
  String get keepProfileUpToDate => 'Keep your profile up to date';

  @override
  String get profilePrivacy => 'We protect your privacy and data';

  @override
  String get correctContactDetails =>
      'Correct contact details help with compensation';

  @override
  String get fullName => 'Full Name';

  @override
  String get attachDocuments => 'Attach Documents';

  @override
  String get uploadingDocument => 'Uploading document...';

  @override
  String get noDocuments => 'You have no documents.';

  @override
  String get uploadFirstDocument => 'Upload First Document';

  @override
  String get uploadNew => 'Upload New';

  @override
  String get documentUploadSuccess => 'Document uploaded successfully!';

  @override
  String get uploadFailed => 'Upload failed. Please try again.';

  @override
  String get continueAction => 'Continue';

  @override
  String get claimAttachment => 'Claim Attachment';

  @override
  String get previewEmail => 'Preview Email';

  @override
  String get pdfPreviewMessage => 'PDF preview would be shown here.';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String get deleteDocumentConfirmation =>
      'Are you sure you want to delete this document?';

  @override
  String get documentDeletedSuccess => 'Document deleted successfully';

  @override
  String get documentDeleteFailed => 'Failed to delete document';

  @override
  String get other => 'other';

  @override
  String get reviewYourClaim => 'Step 1: Review Your Claim';

  @override
  String get reviewClaimDetails =>
      'Please review the details of your claim before proceeding.';

  @override
  String get attachments => 'Attachments:';

  @override
  String get proceedToConfirmation => 'Proceed to Confirmation';

  @override
  String get confirmAndSend => 'Step 2: Confirm & Send';

  @override
  String get errorLoadingEmailDetails => 'Error: Could not load email details.';

  @override
  String get noEmailInfo =>
      'Could not find email information for the user or airline.';

  @override
  String get finalConfirmation => 'Final Confirmation';

  @override
  String get claimWillBeSentTo => 'The claim will be sent to:';

  @override
  String get copyToYourEmail => 'A copy will be sent to your email:';

  @override
  String get confirmAndSendEmail => 'Confirm and Send Email';

  @override
  String get reviewAndConfirm => 'Review and Confirm';

  @override
  String get pleaseConfirmDetails =>
      'Please confirm that these details are correct:';

  @override
  String get emailAppOpenedMessage =>
      'Your email app has been opened. Please send the email to finalize your claim.';

  @override
  String emailAppErrorMessage(String email) {
    return 'Could not open email app. Please send your claim manually to $email.';
  }
}
