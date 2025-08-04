// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get euCompensation => 'EU Compensation';

  @override
  String get scheduledLabel => 'Scheduled:';

  @override
  String get minutes => 'minutes';

  @override
  String get aircraftLabel => 'Aircraft:';

  @override
  String get prefillCompensationForm => 'Pre-fill Compensation Form';

  @override
  String get confirmAndSend => 'Confirm and Send';

  @override
  String get errorLoadingEmailDetails => 'Error loading email details';

  @override
  String get noEmailInfo => 'No email information available';

  @override
  String get finalConfirmation => 'Final Confirmation';

  @override
  String get claimWillBeSentTo => 'Your claim will be sent to:';

  @override
  String get copyToYourEmail => 'A copy will be sent to your email:';

  @override
  String get previewEmail => 'Preview Email';

  @override
  String get confirmAndSendEmail => 'Confirm and Send Email';

  @override
  String get departureAirport => 'Departure Airport';

  @override
  String get arrivalAirport => 'Arrival Airport';

  @override
  String get reasonForClaim => 'Reason for Claim';

  @override
  String get attachments => 'Attachments';

  @override
  String get proceedToConfirmation => 'Proceed to Confirmation';

  @override
  String emailAppOpenedMessage(String email) {
    return 'Your email app has been opened';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'Failed to submit claim. Please try again.';
  }

  @override
  String get unknownError => 'Unknown error';

  @override
  String get retry => 'Retry';

  @override
  String get claimNotFound => 'Claim Not Found';

  @override
  String get claimNotFoundDesc =>
      'The requested claim could not be found or may have been deleted';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get reviewYourClaim => 'Review Your Claim';

  @override
  String get reviewClaimDetails => 'Review Claim Details';

  @override
  String get flightNumber => 'Flight Number';

  @override
  String get flightDate => 'Flight Date';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'No flights matching filter: $filter';
  }

  @override
  String get statusLabel => 'Status';

  @override
  String get flightStatusDelayed => 'Delayed';

  @override
  String get potentialCompensation => 'Potential Compensation';

  @override
  String get claimDetails => 'Claim Details';

  @override
  String get refresh => 'Refresh';

  @override
  String get errorLoadingClaim => 'Error Loading Claim';

  @override
  String get euWideCompensationEligibleFlights =>
      'EU-Wide Compensation Eligible Flights';

  @override
  String get forceRefreshData => 'Force Refresh Data';

  @override
  String get forcingFreshDataLoad => 'Forcing fresh data load...';

  @override
  String get loadingExternalData => 'Loading External Data';

  @override
  String get loadingExternalDataDescription =>
      'Please wait while we fetch the latest flight data...';

  @override
  String lastHours(int hours) {
    return 'Last $hours Hours';
  }

  @override
  String get errorConnectionFailed => 'Connection failed';

  @override
  String formSubmissionError(String error) {
    return 'Form submission error: $error';
  }

  @override
  String get apiConnectionIssue => 'API Connection Issue';

  @override
  String get noEligibleFlightsFound => 'No Eligible Flights Found';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'No flights eligible for EU compensation were found in the last $hours hours. Check again later.';
  }

  @override
  String get checkAgain => 'Check Again';

  @override
  String get filterByAirline => 'Filter by airline';

  @override
  String get saveDocument => 'Save Document';

  @override
  String get fieldName => 'Field Name';

  @override
  String get fieldValue => 'Field Value';

  @override
  String get noFieldsExtracted => 'No Fields Extracted';

  @override
  String get copiedToClipboard => 'Copied to Clipboard';

  @override
  String get networkError => 'Network Error';

  @override
  String get generalError => 'General Error';

  @override
  String get loginRequiredForClaim => 'Login Required for Claim';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get documentOcrResult => 'Document OCR Result';

  @override
  String get extractedFields => 'Extracted Fields';

  @override
  String get fullText => 'Full Text';

  @override
  String get documentSaved => 'Document Saved';

  @override
  String get useExtractedData => 'Use Extracted Data';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get documentType => 'Document Type';

  @override
  String get submitClaim => 'Submit Claim';

  @override
  String get addDocument => 'Add Document';

  @override
  String get claimSubmittedSuccessfully => 'Claim Submitted Successfully';

  @override
  String get completeAllFields => 'Complete All Fields';

  @override
  String get supportingDocuments => 'Supporting Documents';

  @override
  String get cropDocument => 'Crop Document';

  @override
  String get crop => 'Crop';

  @override
  String get rotate => 'Rotate';

  @override
  String get airline => 'Airline';

  @override
  String get email => 'Email';

  @override
  String get bookingReference => 'Booking Reference';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get optional => 'Optional';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get pleaseEnterDepartureAirport => 'Please enter departure airport';

  @override
  String get uploadDocuments => 'Upload Documents';

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
  String get languageSelection => 'Language Selection';

  @override
  String get passengerName => 'Passenger Name';

  @override
  String get passengerDetails => 'Passenger Details';

  @override
  String get appTitle => 'Flight Compensation';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get required => 'Required';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get documentDeleteFailed => 'Failed to delete document';

  @override
  String get uploadNew => 'Upload New';

  @override
  String get continueAction => 'Continue';

  @override
  String get compensationClaimForm => 'Compensation Claim Form';

  @override
  String get flight => 'Flight';

  @override
  String get passengerInformation => 'Passenger Information';

  @override
  String get fullName => 'Full Name';

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
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get documentDeletedSuccess => 'Document deleted successfully';

  @override
  String get attachDocuments => 'Attach Documents';

  @override
  String get uploadingDocument => 'Uploading document...';

  @override
  String get noDocuments => 'No documents uploaded yet';

  @override
  String get uploadFirstDocument => 'Upload First Document';

  @override
  String get claimAttachment => 'Claim Attachment';

  @override
  String get other => 'Other';

  @override
  String get pdfPreviewMessage => 'PDF Preview';

  @override
  String get tipsAndRemindersTitle => 'Tips & Reminders';

  @override
  String get tipSecureData => 'Your data is secure and encrypted';

  @override
  String get tipCheckEligibility =>
      'Check eligibility before submitting a claim';

  @override
  String get tipDoubleCheckDetails =>
      'Double-check all flight details before submission';

  @override
  String get documentUploadSuccess => 'Document uploaded successfully';

  @override
  String get uploadFailed => 'Upload failed. Please try again.';

  @override
  String get reasonForClaimHint => 'Describe why you are making this claim';

  @override
  String get validatorReasonRequired => 'Reason for claim is required';

  @override
  String get tooltipReasonQuickClaim =>
      'Explain why you believe you are entitled to compensation';

  @override
  String get compensationAmountOptionalLabel =>
      'Requested Compensation Amount (Optional)';

  @override
  String get compensationAmountHint =>
      'Enter amount if you have a specific request';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'You can specify a compensation amount or leave it blank';

  @override
  String get continueToReview => 'Continue to Review';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Enter the airport you departed from';

  @override
  String get arrivalAirportHintQuickClaim =>
      'Enter airport code or name (e.g. LHR, London Heathrow)';

  @override
  String get validatorArrivalAirportRequired => 'Arrival airport is required';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Enter the airport you arrived at';

  @override
  String get reasonForClaimLabel => 'Reason for Claim';

  @override
  String get hintTextReasonQuickClaim => 'Describe your claim reason here';

  @override
  String get flightNumberHintQuickClaim => 'Enter flight number (e.g. LH123)';

  @override
  String get validatorFlightNumberRequired => 'Flight number is required';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Enter the flight number for your claim';

  @override
  String get tooltipFlightDateQuickClaim => 'Select the date of your flight';

  @override
  String get departureAirportHintQuickClaim =>
      'Enter airport code or name (e.g. LHR, London Heathrow)';

  @override
  String get validatorDepartureAirportRequired =>
      'Departure airport is required';

  @override
  String get underAppeal => 'Under Appeal';

  @override
  String get unknown => 'Unknown';

  @override
  String get errorMustBeLoggedIn => 'You must be logged in to submit a claim';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get quickClaimTitle => 'Quick Claim Form';

  @override
  String get tooltipFaqHelp => 'View Frequently Asked Questions';

  @override
  String get quickClaimInfoBanner =>
      'Fill out this form to submit a quick compensation claim for your flight. We\'ll help you through the process.';

  @override
  String get createClaim => 'Create New Claim';

  @override
  String get submitted => 'Submitted';

  @override
  String get inReview => 'In Review';

  @override
  String get actionRequired => 'Action Required';

  @override
  String get processing => 'Processing';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get paid => 'Paid';

  @override
  String flightRouteDetails(String departure, String arrival) {
    return '$departure to $arrival';
  }

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get errorLoadingClaims => 'Error loading claims';

  @override
  String get loginToViewClaimsDashboard =>
      'Please log in to view your claims dashboard';

  @override
  String get logIn => 'Log In';

  @override
  String get noClaimsYet => 'No Claims Yet';

  @override
  String get startCompensationClaimInstructions =>
      'Start by creating a new compensation claim for your flight. We\'ll guide you through the process.';

  @override
  String get claimsDashboard => 'Claims Dashboard';

  @override
  String get refreshDashboard => 'Refresh Dashboard';

  @override
  String get claimsSummary => 'Claims Summary';

  @override
  String get totalClaims => 'Total Claims';

  @override
  String get totalCompensation => 'Total Compensation';

  @override
  String get pendingAmount => 'Pending Amount';

  @override
  String get noClaimsYetTitle => 'No Claims in this Category';

  @override
  String get pending => 'Pending';

  @override
  String get viewClaimDetails => 'View claim details';

  @override
  String claimForFlight(String flightNumber, String status) {
    return 'Claim for flight $flightNumber - $status';
  }

  @override
  String flightRouteDetailsWithNumber(
      String flightNumber,
      String departure,
      String arrival,
      String number,
      String airline,
      String departureAirport,
      String arrivalAirport,
      String date,
      String time) {
    return '$flightNumber: $departure to $arrival $airline';
  }

  @override
  String get configureNotificationsDescription =>
      'Receive updates about claim status and important information';

  @override
  String get notificationSettingsComingSoon =>
      'Notification settings coming soon!';

  @override
  String get changeApplicationLanguage => 'Change Application Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get tipsAndReminders => 'Tips and Reminders';

  @override
  String get tipProfileUpToDate =>
      '• Keep your profile up-to-date for faster claim processing.';

  @override
  String get tipInformationPrivate =>
      '• Your information is kept private and secure.';

  @override
  String get tipContactDetails =>
      '• Correct contact details help with compensation.';

  @override
  String get tipAccessibilitySettings =>
      '• Configure accessibility settings to customize your experience.';

  @override
  String get active => 'Active';

  @override
  String get completed => 'Completed';

  @override
  String get genericUser => 'Generic User';

  @override
  String get signOut => 'Sign Out';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get profileInfoCardTitle => 'Personal Information';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get editPersonalInfo => 'Edit Personal Information';

  @override
  String get editPersonalInfoDescription =>
      'Update your name, email, and other personal details';

  @override
  String get accessibilitySettings => 'Accessibility Settings';

  @override
  String get configureAccessibility => 'Configure Accessibility';

  @override
  String get accessibilityOptions => 'Accessibility Options';

  @override
  String get configureAccessibilityDescription =>
      'Adjust text size, contrast, and other accessibility features';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get configureNotifications => 'Configure Notifications';

  @override
  String get eu261Rights => 'EU261 Rights';

  @override
  String get dontLetAirlinesWin => 'Don\'t Let Airlines Win';

  @override
  String get submitClaimAnyway => 'Submit Claim Anyway';

  @override
  String get newClaim => 'New Claim';

  @override
  String get notLoggedIn => 'Not Logged In';

  @override
  String get signIn => 'Sign In';

  @override
  String get checkFlightEligibilityButtonText => 'Check Flight Eligibility';

  @override
  String get euEligibleFlightsButtonText => 'EU Eligible Flights';

  @override
  String welcomeUser(String name, String role, Object userName) {
    return 'Welcome, $name ($role)';
  }

  @override
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get contactAirlineForClaim => 'Contact Airline for Claim';

  @override
  String get flightMightNotBeEligible => 'Flight Might Not Be Eligible';

  @override
  String get knowYourRights => 'Know Your Rights';

  @override
  String get airlineDataDisclaimer => 'Airline Data Disclaimer';

  @override
  String get error => 'Error';

  @override
  String get status => 'Status';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get delay => 'Delay';

  @override
  String get flightEligibleForCompensation =>
      'Flight Eligible For Compensation';

  @override
  String flightInfoFormat(String flightCode, String flightDate) {
    return 'Flight $flightCode on $flightDate';
  }

  @override
  String minutesFormat(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get flightCompensationCheckerTitle => 'Flight Compensation Checker';

  @override
  String get checkEligibilityForEu261 =>
      'Check Eligibility for EU 261 Compensation';

  @override
  String get flightNumberPlaceholder => 'Flight Number (e.g., LO123)';

  @override
  String get pleaseEnterFlightNumber => 'Please enter a flight number';

  @override
  String get dateOptionalPlaceholder => 'Flight Date (optional)';

  @override
  String get leaveDateEmptyForToday => 'Leave empty for today\'s date';

  @override
  String get checkCompensationEligibility => 'Check Compensation Eligibility';

  @override
  String get continueToAttachmentsButton => 'Continue to Attachments';

  @override
  String get flightNotFoundError => 'Flight not found';

  @override
  String get invalidFlightNumberError => 'Invalid flight number';

  @override
  String get networkTimeoutError => 'Network timeout, please try again';

  @override
  String get serverError => 'Server error';

  @override
  String get rateLimitError => 'Too many requests, please try again later';

  @override
  String get generalFlightCheckError => 'Error checking flight eligibility';

  @override
  String get receiveNotifications => 'Receive Notifications';

  @override
  String get getClaimUpdates => 'Get Claim Updates';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get country => 'Country';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get pleaseSelectFlightDate => 'Please select a flight date';

  @override
  String get submitNewClaim => 'Submit New Claim';

  @override
  String get pleaseEnterArrivalAirport => 'Please enter arrival airport';

  @override
  String get pleaseEnterReason => 'Please enter reason for claim';

  @override
  String get flightDateHint => 'Select flight date';

  @override
  String get number => 'Number';

  @override
  String welcomeUser3(String name, String role, String company) {
    return 'Welcome, $name ($role at $company)';
  }

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get passportNumber => 'Passport Number';

  @override
  String get nationality => 'Nationality';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get dateFormat => 'DD/MM/YYYY';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get consentToShareData =>
      'I consent to share my data for claim processing';

  @override
  String get requiredForProcessing => 'Required for processing your claim';

  @override
  String get claims => 'Claims';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileAccuracyInfo =>
      'Please ensure your profile information is accurate for claim processing';

  @override
  String get keepProfileUpToDate => 'Keep your profile up to date';

  @override
  String get profilePrivacy =>
      'Your data is secure and only used for claim processing';

  @override
  String get correctContactDetails => 'Ensure contact details are correct';

  @override
  String get emailReadyToSend => 'Your Compensation Email is Ready!';

  @override
  String get emailCopyInstructions =>
      'Copy the email details below and paste them into your email app';

  @override
  String get cc => 'CC';

  @override
  String get subject => 'Subject';

  @override
  String get emailBody => 'Email Body';

  @override
  String get howToSendEmail => 'How to send this email:';

  @override
  String get emailStep1 => 'Tap \"Copy Email\" below';

  @override
  String get emailStep2 => 'Open your email app (Gmail, Outlook, etc.)';

  @override
  String get emailStep3 => 'Create a new email';

  @override
  String get emailStep4 => 'Paste the copied content';

  @override
  String get emailStep5 => 'Send your compensation claim!';

  @override
  String get copyEmail => 'Copy Email';

  @override
  String get emailCopiedSuccess => 'Email copied to clipboard!';

  @override
  String get supportOurMission => 'Support Our Mission';

  @override
  String get helpKeepAppFree =>
      'Help us keep this app free and support hospice care';

  @override
  String get yourContributionMakesDifference =>
      'Your contribution makes a difference';

  @override
  String get hospiceFoundation => 'Hospice Foundation';

  @override
  String get appDevelopment => 'App Development';

  @override
  String get comfortCareForPatients => 'Comfort and care for patients';

  @override
  String get newFeaturesAndImprovements => 'New features and improvements';

  @override
  String get chooseYourSupportAmount => 'Choose your support amount:';

  @override
  String get totalDonation => 'Total Donation';

  @override
  String get donationSummary => 'Donation Summary';

  @override
  String get choosePaymentMethod => 'Choose payment method:';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get creditDebitCard => 'Credit/Debit Card';

  @override
  String get visaMastercardAmericanExpress =>
      'Visa, Mastercard, American Express';

  @override
  String get payWithPayPalAccount => 'Pay with your PayPal account';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get notAvailableOnThisDevice => 'Not available on this device';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get quickAndSecure => 'Quick and secure';

  @override
  String get smallSupport => 'Small Support';

  @override
  String get goodSupport => 'Good Support';

  @override
  String get greatSupport => 'Great Support';

  @override
  String yourAmountHelps(String amount) {
    return 'Your $amount helps:';
  }

  @override
  String get hospicePatientCare => 'Hospice patient care';

  @override
  String get appImprovements => 'App improvements';

  @override
  String continueWithAmount(String amount) {
    return 'Continue with $amount';
  }

  @override
  String get selectAnAmount => 'Select an amount';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get securePaymentInfo =>
      'Secure payment • No hidden fees • Tax receipt';

  @override
  String get learnMoreHospiceFoundation =>
      'Learn more about Hospice Foundation: fundacja-hospicjum.org';

  @override
  String get touchIdOrFaceId => 'Touch ID or Face ID';

  @override
  String get continueToPayment => 'Continue to Payment';

  @override
  String get selectAPaymentMethod => 'Select a payment method';

  @override
  String get securePayment => 'Secure Payment';

  @override
  String get paymentSecurityInfo =>
      'Your payment information is encrypted and secure. We do not store your payment details.';

  @override
  String get taxReceiptEmail => 'Tax receipt will be sent to your email';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, American Express';

  @override
  String get notAvailableOnDevice => 'Not available on this device';

  @override
  String get comfortAndCareForPatients => 'Comfort and care for patients';

  @override
  String get chooseSupportAmount => 'Choose your support amount:';
}
