import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n2/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pl'),
    Locale('pt')
  ];

  /// Label for EU compensation tag on eligible flights
  ///
  /// In en, this message translates to:
  /// **'EU Compensation'**
  String get euCompensation;

  /// Label for scheduled flight time
  ///
  /// In en, this message translates to:
  /// **'Scheduled:'**
  String get scheduledLabel;

  /// Text for minutes unit
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Aircraft label for flight details
  ///
  /// In en, this message translates to:
  /// **'Aircraft:'**
  String get aircraftLabel;

  /// Button text for pre-filling compensation form
  ///
  /// In en, this message translates to:
  /// **'Pre-fill Compensation Form'**
  String get prefillCompensationForm;

  /// Button label for confirming and sending an email
  ///
  /// In en, this message translates to:
  /// **'Confirm and Send'**
  String get confirmAndSend;

  /// Error message when email details cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Error loading email details'**
  String get errorLoadingEmailDetails;

  /// Message when no email information is available
  ///
  /// In en, this message translates to:
  /// **'No email information available'**
  String get noEmailInfo;

  /// Title for the final confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get finalConfirmation;

  /// Text explaining where the claim will be sent
  ///
  /// In en, this message translates to:
  /// **'Your claim will be sent to:'**
  String get claimWillBeSentTo;

  /// Text explaining that a copy will be sent to the user's email
  ///
  /// In en, this message translates to:
  /// **'A copy will be sent to your email:'**
  String get copyToYourEmail;

  /// Button label for previewing email before sending
  ///
  /// In en, this message translates to:
  /// **'Preview Email'**
  String get previewEmail;

  /// Button label for confirming and sending email
  ///
  /// In en, this message translates to:
  /// **'Confirm and Send Email'**
  String get confirmAndSendEmail;

  /// Label for departure airport field
  ///
  /// In en, this message translates to:
  /// **'Departure Airport'**
  String get departureAirport;

  /// Label for arrival airport field
  ///
  /// In en, this message translates to:
  /// **'Arrival Airport'**
  String get arrivalAirport;

  /// Label for reason for claim field
  ///
  /// In en, this message translates to:
  /// **'Reason for Claim'**
  String get reasonForClaim;

  /// Label for attachments section
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// Button label to proceed to confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Proceed to Confirmation'**
  String get proceedToConfirmation;

  /// Message shown when the email app is opened
  ///
  /// In en, this message translates to:
  /// **'Your email app has been opened'**
  String emailAppOpenedMessage(String email);

  /// Error message shown when claim submission fails
  ///
  /// In en, this message translates to:
  /// **'Failed to submit claim. Please try again.'**
  String errorFailedToSubmitClaim(String error);

  /// Generic unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// Button label to retry an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title shown when a claim is not found
  ///
  /// In en, this message translates to:
  /// **'Claim Not Found'**
  String get claimNotFound;

  /// Description shown when a claim is not found
  ///
  /// In en, this message translates to:
  /// **'The requested claim could not be found or may have been deleted'**
  String get claimNotFoundDesc;

  /// Button label to go back to dashboard
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// Title for the claim review screen
  ///
  /// In en, this message translates to:
  /// **'Review Your Claim'**
  String get reviewYourClaim;

  /// Header for reviewing claim details
  ///
  /// In en, this message translates to:
  /// **'Review Claim Details'**
  String get reviewClaimDetails;

  /// Label for flight number field
  ///
  /// In en, this message translates to:
  /// **'Flight Number'**
  String get flightNumber;

  /// Label for flight date field
  ///
  /// In en, this message translates to:
  /// **'Flight Date'**
  String get flightDate;

  /// Message shown when no flights match the filter
  ///
  /// In en, this message translates to:
  /// **'No flights matching filter: {filter}'**
  String noFlightsMatchingFilter(String filter);

  /// Label for flight status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Status indicating flight is delayed
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get flightStatusDelayed;

  /// Label for potential compensation amount
  ///
  /// In en, this message translates to:
  /// **'Potential Compensation'**
  String get potentialCompensation;

  /// Title for claim details screen
  ///
  /// In en, this message translates to:
  /// **'Claim Details'**
  String get claimDetails;

  /// Button label to refresh content
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Error message when claim loading fails
  ///
  /// In en, this message translates to:
  /// **'Error Loading Claim'**
  String get errorLoadingClaim;

  /// Title for EU eligible flights screen
  ///
  /// In en, this message translates to:
  /// **'EU-Wide Compensation Eligible Flights'**
  String get euWideCompensationEligibleFlights;

  /// Tooltip for refresh button
  ///
  /// In en, this message translates to:
  /// **'Force Refresh Data'**
  String get forceRefreshData;

  /// Message when forcing data refresh
  ///
  /// In en, this message translates to:
  /// **'Forcing fresh data load...'**
  String get forcingFreshDataLoad;

  /// Title for loading screen
  ///
  /// In en, this message translates to:
  /// **'Loading External Data'**
  String get loadingExternalData;

  /// Message when loading external data
  ///
  /// In en, this message translates to:
  /// **'Please wait while we fetch the latest flight data...'**
  String get loadingExternalDataDescription;

  /// Time period label for flight list
  ///
  /// In en, this message translates to:
  /// **'Last {hours} Hours'**
  String lastHours(int hours);

  /// Error message when connection fails
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get errorConnectionFailed;

  /// Error message for form submission errors
  ///
  /// In en, this message translates to:
  /// **'Form submission error: {error}'**
  String formSubmissionError(String error);

  /// Title for API connection issue
  ///
  /// In en, this message translates to:
  /// **'API Connection Issue'**
  String get apiConnectionIssue;

  /// Message when no eligible flights are found
  ///
  /// In en, this message translates to:
  /// **'No Eligible Flights Found'**
  String get noEligibleFlightsFound;

  /// Description when no eligible flights are found
  ///
  /// In en, this message translates to:
  /// **'No flights eligible for EU compensation were found in the last {hours} hours. Check again later.'**
  String noEligibleFlightsDescription(int hours);

  /// Button label to check again
  ///
  /// In en, this message translates to:
  /// **'Check Again'**
  String get checkAgain;

  /// Hint text for airline filter
  ///
  /// In en, this message translates to:
  /// **'Filter by airline'**
  String get filterByAirline;

  /// Button label to save document
  ///
  /// In en, this message translates to:
  /// **'Save Document'**
  String get saveDocument;

  /// Label for field name
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldName;

  /// Label for field value
  ///
  /// In en, this message translates to:
  /// **'Field Value'**
  String get fieldValue;

  /// Message when no fields are extracted
  ///
  /// In en, this message translates to:
  /// **'No Fields Extracted'**
  String get noFieldsExtracted;

  /// Message when text is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to Clipboard'**
  String get copiedToClipboard;

  /// Generic network error message
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkError;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'General Error'**
  String get generalError;

  /// Message indicating login is required to submit a claim
  ///
  /// In en, this message translates to:
  /// **'Login Required for Claim'**
  String get loginRequiredForClaim;

  /// Label for aspect ratio
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// Title for OCR result section
  ///
  /// In en, this message translates to:
  /// **'Document OCR Result'**
  String get documentOcrResult;

  /// Title for extracted fields section
  ///
  /// In en, this message translates to:
  /// **'Extracted Fields'**
  String get extractedFields;

  /// Title for full text section
  ///
  /// In en, this message translates to:
  /// **'Full Text'**
  String get fullText;

  /// Message when document is saved
  ///
  /// In en, this message translates to:
  /// **'Document Saved'**
  String get documentSaved;

  /// Button label for using extracted data
  ///
  /// In en, this message translates to:
  /// **'Use Extracted Data'**
  String get useExtractedData;

  /// Button label for copying to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// Label for document type
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// Button label for submitting a claim
  ///
  /// In en, this message translates to:
  /// **'Submit Claim'**
  String get submitClaim;

  /// Button label for adding a document
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// Message when a claim is submitted successfully
  ///
  /// In en, this message translates to:
  /// **'Claim Submitted Successfully'**
  String get claimSubmittedSuccessfully;

  /// Message prompting user to complete all fields
  ///
  /// In en, this message translates to:
  /// **'Complete All Fields'**
  String get completeAllFields;

  /// Title for supporting documents section
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents'**
  String get supportingDocuments;

  /// Title for crop document screen
  ///
  /// In en, this message translates to:
  /// **'Crop Document'**
  String get cropDocument;

  /// Button label for crop action
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// Button label for rotate action
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// Label for airline field
  ///
  /// In en, this message translates to:
  /// **'Airline'**
  String get airline;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for booking reference field
  ///
  /// In en, this message translates to:
  /// **'Booking Reference'**
  String get bookingReference;

  /// Label for additional information field
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// Label for optional fields
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Error message for required fields
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// Error message for missing departure airport
  ///
  /// In en, this message translates to:
  /// **'Please enter departure airport'**
  String get pleaseEnterDepartureAirport;

  /// Button label for uploading documents
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// Text for yes button/response
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Text for no button/response
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Text for ok button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Text for back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Text for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Language Selection'**
  String get languageSelection;

  /// Label for passenger name field
  ///
  /// In en, this message translates to:
  /// **'Passenger Name'**
  String get passengerName;

  /// Title for passenger details section
  ///
  /// In en, this message translates to:
  /// **'Passenger Details'**
  String get passengerDetails;

  /// Title of the app
  ///
  /// In en, this message translates to:
  /// **'Flight Compensation'**
  String get appTitle;

  /// Welcome message shown on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeMessage;

  /// Label for home tab/button
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for settings tab/button
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Error message for required fields
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Label for email address field
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Error message shown when document deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete document'**
  String get documentDeleteFailed;

  /// Label for upload new document button
  ///
  /// In en, this message translates to:
  /// **'Upload New'**
  String get uploadNew;

  /// Label for continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Title for compensation claim form screen
  ///
  /// In en, this message translates to:
  /// **'Compensation Claim Form'**
  String get compensationClaimForm;

  /// Label for flight information
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get flight;

  /// Header for passenger information section
  ///
  /// In en, this message translates to:
  /// **'Passenger Information'**
  String get passengerInformation;

  /// Label for full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Label for download PDF button
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// Message shown when file preview is not available
  ///
  /// In en, this message translates to:
  /// **'File preview not available'**
  String get filePreviewNotAvailable;

  /// Title for delete document confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// Confirmation message for document deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this document?'**
  String get deleteDocumentConfirmation;

  /// Label for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Message shown when document is deleted successfully
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeletedSuccess;

  /// Title for document attachment screen
  ///
  /// In en, this message translates to:
  /// **'Attach Documents'**
  String get attachDocuments;

  /// Text shown when a document is being uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploading document...'**
  String get uploadingDocument;

  /// Text shown when no documents have been uploaded
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded yet'**
  String get noDocuments;

  /// Button text to upload the first document
  ///
  /// In en, this message translates to:
  /// **'Upload First Document'**
  String get uploadFirstDocument;

  /// Default name for claim attachments
  ///
  /// In en, this message translates to:
  /// **'Claim Attachment'**
  String get claimAttachment;

  /// Label for other document type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Message shown when viewing a PDF preview
  ///
  /// In en, this message translates to:
  /// **'PDF Preview'**
  String get pdfPreviewMessage;

  /// Title for tips and reminders section
  ///
  /// In en, this message translates to:
  /// **'Tips & Reminders'**
  String get tipsAndRemindersTitle;

  /// Tip about data security
  ///
  /// In en, this message translates to:
  /// **'Your data is secure and encrypted'**
  String get tipSecureData;

  /// Tip to check eligibility first
  ///
  /// In en, this message translates to:
  /// **'Check eligibility before submitting a claim'**
  String get tipCheckEligibility;

  /// Tip to verify flight details
  ///
  /// In en, this message translates to:
  /// **'Double-check all flight details before submission'**
  String get tipDoubleCheckDetails;

  /// Message shown when document upload is successful
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadSuccess;

  /// Message shown when document upload fails
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Please try again.'**
  String get uploadFailed;

  /// Helper text for reason for claim field
  ///
  /// In en, this message translates to:
  /// **'Describe why you are making this claim'**
  String get reasonForClaimHint;

  /// Validation message when reason for claim is empty
  ///
  /// In en, this message translates to:
  /// **'Reason for claim is required'**
  String get validatorReasonRequired;

  /// Tooltip for reason field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Explain why you believe you are entitled to compensation'**
  String get tooltipReasonQuickClaim;

  /// Label for optional compensation amount field
  ///
  /// In en, this message translates to:
  /// **'Requested Compensation Amount (Optional)'**
  String get compensationAmountOptionalLabel;

  /// Helper text for compensation amount field
  ///
  /// In en, this message translates to:
  /// **'Enter amount if you have a specific request'**
  String get compensationAmountHint;

  /// Tooltip for compensation amount in quick claim form
  ///
  /// In en, this message translates to:
  /// **'You can specify a compensation amount or leave it blank'**
  String get tooltipCompensationAmountQuickClaim;

  /// Button text to proceed to review screen
  ///
  /// In en, this message translates to:
  /// **'Continue to Review'**
  String get continueToReview;

  /// Tooltip for departure airport field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Enter the airport you departed from'**
  String get tooltipDepartureAirportQuickClaim;

  /// Helper text for arrival airport field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Enter airport code or name (e.g. LHR, London Heathrow)'**
  String get arrivalAirportHintQuickClaim;

  /// Validation message when arrival airport is empty
  ///
  /// In en, this message translates to:
  /// **'Arrival airport is required'**
  String get validatorArrivalAirportRequired;

  /// Tooltip for arrival airport field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Enter the airport you arrived at'**
  String get tooltipArrivalAirportQuickClaim;

  /// Label for reason for claim field
  ///
  /// In en, this message translates to:
  /// **'Reason for Claim'**
  String get reasonForClaimLabel;

  /// Hint text for reason field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Describe your claim reason here'**
  String get hintTextReasonQuickClaim;

  /// Helper text for flight number field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Enter flight number (e.g. LH123)'**
  String get flightNumberHintQuickClaim;

  /// Validation message when flight number is empty
  ///
  /// In en, this message translates to:
  /// **'Flight number is required'**
  String get validatorFlightNumberRequired;

  /// Tooltip for flight number field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Enter the flight number for your claim'**
  String get tooltipFlightNumberQuickClaim;

  /// Tooltip for flight date field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Select the date of your flight'**
  String get tooltipFlightDateQuickClaim;

  /// Helper text for departure airport field in quick claim form
  ///
  /// In en, this message translates to:
  /// **'Enter airport code or name (e.g. LHR, London Heathrow)'**
  String get departureAirportHintQuickClaim;

  /// Validation message when departure airport is empty
  ///
  /// In en, this message translates to:
  /// **'Departure airport is required'**
  String get validatorDepartureAirportRequired;

  /// Status label for a claim that is under appeal
  ///
  /// In en, this message translates to:
  /// **'Under Appeal'**
  String get underAppeal;

  /// Unknown value placeholder
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Error message shown when trying to access the claim form without being logged in
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to submit a claim'**
  String get errorMustBeLoggedIn;

  /// Title for error dialog boxes
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get dialogTitleError;

  /// OK button text for dialog boxes
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogButtonOK;

  /// Title for the quick claim screen
  ///
  /// In en, this message translates to:
  /// **'Quick Claim Form'**
  String get quickClaimTitle;

  /// Tooltip for FAQ help button
  ///
  /// In en, this message translates to:
  /// **'View Frequently Asked Questions'**
  String get tooltipFaqHelp;

  /// Information banner text at the top of quick claim form
  ///
  /// In en, this message translates to:
  /// **'Fill out this form to submit a quick compensation claim for your flight. We\'ll help you through the process.'**
  String get quickClaimInfoBanner;

  /// Button label for creating a new claim
  ///
  /// In en, this message translates to:
  /// **'Create New Claim'**
  String get createClaim;

  /// Status label for a submitted claim
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// Status label for a claim being reviewed
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get inReview;

  /// Status label for a claim requiring action from the user
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get actionRequired;

  /// Status label for a claim being processed
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// Status label for an approved claim
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Status label for a rejected claim
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Status label for a paid claim
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Format for displaying flight route details
  ///
  /// In en, this message translates to:
  /// **'{departure} to {arrival}'**
  String flightRouteDetails(String departure, String arrival);

  /// Message shown when authentication is required to view claims
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// Error message when claims cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Error loading claims'**
  String get errorLoadingClaims;

  /// Message prompting user to log in to view claims dashboard
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your claims dashboard'**
  String get loginToViewClaimsDashboard;

  /// Button label for logging in
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Message shown when user has no claims
  ///
  /// In en, this message translates to:
  /// **'No Claims Yet'**
  String get noClaimsYet;

  /// Instructions for starting a new compensation claim
  ///
  /// In en, this message translates to:
  /// **'Start by creating a new compensation claim for your flight. We\'ll guide you through the process.'**
  String get startCompensationClaimInstructions;

  /// Title for the claims dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Claims Dashboard'**
  String get claimsDashboard;

  /// Tooltip for dashboard refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh Dashboard'**
  String get refreshDashboard;

  /// Title for claims summary section
  ///
  /// In en, this message translates to:
  /// **'Claims Summary'**
  String get claimsSummary;

  /// Label for total claims count
  ///
  /// In en, this message translates to:
  /// **'Total Claims'**
  String get totalClaims;

  /// Label for total compensation amount
  ///
  /// In en, this message translates to:
  /// **'Total Compensation'**
  String get totalCompensation;

  /// Label for pending compensation amount
  ///
  /// In en, this message translates to:
  /// **'Pending Amount'**
  String get pendingAmount;

  /// Title shown when no claims exist in a category
  ///
  /// In en, this message translates to:
  /// **'No Claims in this Category'**
  String get noClaimsYetTitle;

  /// Status label for pending compensation
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Semantic label for viewing claim details
  ///
  /// In en, this message translates to:
  /// **'View claim details'**
  String get viewClaimDetails;

  /// Semantic description of a claim item
  ///
  /// In en, this message translates to:
  /// **'Claim for flight {flightNumber} - {status}'**
  String claimForFlight(String flightNumber, String status);

  /// Format for displaying flight route details with flight number
  ///
  /// In en, this message translates to:
  /// **'{flightNumber}: {departure} to {arrival} {airline}'**
  String flightRouteDetailsWithNumber(
      String flightNumber,
      String departure,
      String arrival,
      String number,
      String airline,
      String departureAirport,
      String arrivalAirport,
      String date,
      String time);

  /// Description for notification configuration
  ///
  /// In en, this message translates to:
  /// **'Receive updates about claim status and important information'**
  String get configureNotificationsDescription;

  /// Message indicating notification feature is coming soon
  ///
  /// In en, this message translates to:
  /// **'Notification settings coming soon!'**
  String get notificationSettingsComingSoon;

  /// Label for language change option
  ///
  /// In en, this message translates to:
  /// **'Change Application Language'**
  String get changeApplicationLanguage;

  /// Label for language selection button
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Title for tips and reminders section
  ///
  /// In en, this message translates to:
  /// **'Tips and Reminders'**
  String get tipsAndReminders;

  /// Tip about keeping profile updated
  ///
  /// In en, this message translates to:
  /// **'• Keep your profile up-to-date for faster claim processing.'**
  String get tipProfileUpToDate;

  /// Tip about privacy of information
  ///
  /// In en, this message translates to:
  /// **'• Your information is kept private and secure.'**
  String get tipInformationPrivate;

  /// Tip about importance of correct contact details
  ///
  /// In en, this message translates to:
  /// **'• Correct contact details help with compensation.'**
  String get tipContactDetails;

  /// Tip about accessibility settings
  ///
  /// In en, this message translates to:
  /// **'• Configure accessibility settings to customize your experience.'**
  String get tipAccessibilitySettings;

  /// Tab label for active claims
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Tab label for completed claims
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @genericUser.
  ///
  /// In en, this message translates to:
  /// **'Generic User'**
  String get genericUser;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @errorSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Error signing out: {error}'**
  String errorSigningOut(String error);

  /// Auto-generated for profileInformation
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @profileInfoCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profileInfoCardTitle;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @editPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Information'**
  String get editPersonalInfo;

  /// No description provided for @editPersonalInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your name, email, and other personal details'**
  String get editPersonalInfoDescription;

  /// No description provided for @accessibilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
  String get accessibilitySettings;

  /// No description provided for @configureAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Configure Accessibility'**
  String get configureAccessibility;

  /// No description provided for @accessibilityOptions.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Options'**
  String get accessibilityOptions;

  /// No description provided for @configureAccessibilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust text size, contrast, and other accessibility features'**
  String get configureAccessibilityDescription;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @configureNotifications.
  ///
  /// In en, this message translates to:
  /// **'Configure Notifications'**
  String get configureNotifications;

  /// Auto-generated for eu261Rights
  ///
  /// In en, this message translates to:
  /// **'EU261 Rights'**
  String get eu261Rights;

  /// Auto-generated for dontLetAirlinesWin
  ///
  /// In en, this message translates to:
  /// **'Don\'t Let Airlines Win'**
  String get dontLetAirlinesWin;

  /// Auto-generated for submitClaimAnyway
  ///
  /// In en, this message translates to:
  /// **'Submit Claim Anyway'**
  String get submitClaimAnyway;

  /// No description provided for @newClaim.
  ///
  /// In en, this message translates to:
  /// **'New Claim'**
  String get newClaim;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get notLoggedIn;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @checkFlightEligibilityButtonText.
  ///
  /// In en, this message translates to:
  /// **'Check Flight Eligibility'**
  String get checkFlightEligibilityButtonText;

  /// No description provided for @euEligibleFlightsButtonText.
  ///
  /// In en, this message translates to:
  /// **'EU Eligible Flights'**
  String get euEligibleFlightsButtonText;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name} ({role})'**
  String welcomeUser(String name, String role, Object userName);

  /// No description provided for @errorFormSubmissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Error submitting form: {errorMessage}. Please check your connection and try again.'**
  String errorFormSubmissionFailed(String errorMessage);

  /// No description provided for @contactAirlineForClaim.
  ///
  /// In en, this message translates to:
  /// **'Contact Airline for Claim'**
  String get contactAirlineForClaim;

  /// No description provided for @flightMightNotBeEligible.
  ///
  /// In en, this message translates to:
  /// **'Flight Might Not Be Eligible'**
  String get flightMightNotBeEligible;

  /// No description provided for @knowYourRights.
  ///
  /// In en, this message translates to:
  /// **'Know Your Rights'**
  String get knowYourRights;

  /// No description provided for @airlineDataDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Airline Data Disclaimer'**
  String get airlineDataDisclaimer;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @delay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// No description provided for @flightEligibleForCompensation.
  ///
  /// In en, this message translates to:
  /// **'Flight Eligible For Compensation'**
  String get flightEligibleForCompensation;

  /// No description provided for @flightInfoFormat.
  ///
  /// In en, this message translates to:
  /// **'Flight {flightCode} on {flightDate}'**
  String flightInfoFormat(String flightCode, String flightDate);

  /// No description provided for @minutesFormat.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutesFormat(int minutes);

  /// No description provided for @flightCompensationCheckerTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Compensation Checker'**
  String get flightCompensationCheckerTitle;

  /// No description provided for @checkEligibilityForEu261.
  ///
  /// In en, this message translates to:
  /// **'Check Eligibility for EU 261 Compensation'**
  String get checkEligibilityForEu261;

  /// No description provided for @flightNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Flight Number (e.g., LO123)'**
  String get flightNumberPlaceholder;

  /// No description provided for @pleaseEnterFlightNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a flight number'**
  String get pleaseEnterFlightNumber;

  /// No description provided for @dateOptionalPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Flight Date (optional)'**
  String get dateOptionalPlaceholder;

  /// No description provided for @leaveDateEmptyForToday.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for today\'s date'**
  String get leaveDateEmptyForToday;

  /// No description provided for @checkCompensationEligibility.
  ///
  /// In en, this message translates to:
  /// **'Check Compensation Eligibility'**
  String get checkCompensationEligibility;

  /// No description provided for @continueToAttachmentsButton.
  ///
  /// In en, this message translates to:
  /// **'Continue to Attachments'**
  String get continueToAttachmentsButton;

  /// No description provided for @flightNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'Flight not found'**
  String get flightNotFoundError;

  /// No description provided for @invalidFlightNumberError.
  ///
  /// In en, this message translates to:
  /// **'Invalid flight number'**
  String get invalidFlightNumberError;

  /// No description provided for @networkTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'Network timeout, please try again'**
  String get networkTimeoutError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @rateLimitError.
  ///
  /// In en, this message translates to:
  /// **'Too many requests, please try again later'**
  String get rateLimitError;

  /// No description provided for @generalFlightCheckError.
  ///
  /// In en, this message translates to:
  /// **'Error checking flight eligibility'**
  String get generalFlightCheckError;

  /// Auto-generated for receiveNotifications
  ///
  /// In en, this message translates to:
  /// **'Receive Notifications'**
  String get receiveNotifications;

  /// Auto-generated for getClaimUpdates
  ///
  /// In en, this message translates to:
  /// **'Get Claim Updates'**
  String get getClaimUpdates;

  /// Auto-generated for saveProfile
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// Auto-generated for firstName
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Auto-generated for lastName
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Auto-generated for name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Auto-generated for phone
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Auto-generated for address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Auto-generated for city
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Auto-generated for country
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Auto-generated for postalCode
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// Auto-generated for pleaseSelectFlightDate
  ///
  /// In en, this message translates to:
  /// **'Please select a flight date'**
  String get pleaseSelectFlightDate;

  /// Auto-generated for submitNewClaim
  ///
  /// In en, this message translates to:
  /// **'Submit New Claim'**
  String get submitNewClaim;

  /// Auto-generated for pleaseEnterArrivalAirport
  ///
  /// In en, this message translates to:
  /// **'Please enter arrival airport'**
  String get pleaseEnterArrivalAirport;

  /// Auto-generated for pleaseEnterReason
  ///
  /// In en, this message translates to:
  /// **'Please enter reason for claim'**
  String get pleaseEnterReason;

  /// Auto-generated for flightDateHint
  ///
  /// In en, this message translates to:
  /// **'Select flight date'**
  String get flightDateHint;

  /// Auto-generated for number
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// Auto-generated for welcomeUser3
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name} ({role} at {company})'**
  String welcomeUser3(String name, String role, String company);

  /// Auto-generated for phoneNumber
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Auto-generated for passportNumber
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportNumber;

  /// Auto-generated for nationality
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// Auto-generated for dateOfBirth
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Auto-generated for dateFormat
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateFormat;

  /// Auto-generated for privacySettings
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Auto-generated for consentToShareData
  ///
  /// In en, this message translates to:
  /// **'I consent to share my data for claim processing'**
  String get consentToShareData;

  /// Auto-generated for requiredForProcessing
  ///
  /// In en, this message translates to:
  /// **'Required for processing your claim'**
  String get requiredForProcessing;

  /// Auto-generated for claims
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get claims;

  /// Auto-generated for errorLoadingProfile
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// Auto-generated for profileSaved
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// Auto-generated for editProfile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Auto-generated for profileAccuracyInfo
  ///
  /// In en, this message translates to:
  /// **'Please ensure your profile information is accurate for claim processing'**
  String get profileAccuracyInfo;

  /// Auto-generated for keepProfileUpToDate
  ///
  /// In en, this message translates to:
  /// **'Keep your profile up to date'**
  String get keepProfileUpToDate;

  /// Auto-generated for profilePrivacy
  ///
  /// In en, this message translates to:
  /// **'Your data is secure and only used for claim processing'**
  String get profilePrivacy;

  /// Auto-generated for correctContactDetails
  ///
  /// In en, this message translates to:
  /// **'Ensure contact details are correct'**
  String get correctContactDetails;

  /// Title for email preview dialog
  ///
  /// In en, this message translates to:
  /// **'Your Compensation Email is Ready!'**
  String get emailReadyToSend;

  /// Instructions for copying email content
  ///
  /// In en, this message translates to:
  /// **'Copy the email details below and paste them into your email app'**
  String get emailCopyInstructions;

  /// Label for CC (carbon copy) email field
  ///
  /// In en, this message translates to:
  /// **'CC'**
  String get cc;

  /// Label for email subject field
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// Label for email body section
  ///
  /// In en, this message translates to:
  /// **'Email Body'**
  String get emailBody;

  /// Instructions header for email sending steps
  ///
  /// In en, this message translates to:
  /// **'How to send this email:'**
  String get howToSendEmail;

  /// First step in email sending instructions
  ///
  /// In en, this message translates to:
  /// **'Tap \"Copy Email\" below'**
  String get emailStep1;

  /// Second step in email sending instructions
  ///
  /// In en, this message translates to:
  /// **'Open your email app (Gmail, Outlook, etc.)'**
  String get emailStep2;

  /// Third step in email sending instructions
  ///
  /// In en, this message translates to:
  /// **'Create a new email'**
  String get emailStep3;

  /// Fourth step in email sending instructions
  ///
  /// In en, this message translates to:
  /// **'Paste the copied content'**
  String get emailStep4;

  /// Fifth step in email sending instructions
  ///
  /// In en, this message translates to:
  /// **'Send your compensation claim!'**
  String get emailStep5;

  /// Button text to copy email content
  ///
  /// In en, this message translates to:
  /// **'Copy Email'**
  String get copyEmail;

  /// Success message when email is copied
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard!'**
  String get emailCopiedSuccess;

  /// Support our mission screen title
  ///
  /// In en, this message translates to:
  /// **'Support Our Mission'**
  String get supportOurMission;

  /// Support mission description
  ///
  /// In en, this message translates to:
  /// **'Help us keep this app free and support hospice care'**
  String get helpKeepAppFree;

  /// Contribution impact message
  ///
  /// In en, this message translates to:
  /// **'Your contribution makes a difference'**
  String get yourContributionMakesDifference;

  /// Label for hospice foundation donation split
  ///
  /// In en, this message translates to:
  /// **'Hospice Foundation'**
  String get hospiceFoundation;

  /// Label for app development donation split
  ///
  /// In en, this message translates to:
  /// **'App Development'**
  String get appDevelopment;

  /// Description for hospice foundation
  ///
  /// In en, this message translates to:
  /// **'Comfort and care for patients'**
  String get comfortCareForPatients;

  /// App development description
  ///
  /// In en, this message translates to:
  /// **'New features and improvements'**
  String get newFeaturesAndImprovements;

  /// Label for amount selection
  ///
  /// In en, this message translates to:
  /// **'Choose your support amount:'**
  String get chooseYourSupportAmount;

  /// Label for total donation amount
  ///
  /// In en, this message translates to:
  /// **'Total Donation'**
  String get totalDonation;

  /// Title for donation summary section
  ///
  /// In en, this message translates to:
  /// **'Donation Summary'**
  String get donationSummary;

  /// Choose payment method section title
  ///
  /// In en, this message translates to:
  /// **'Choose payment method:'**
  String get choosePaymentMethod;

  /// Payment method screen title
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Credit/Debit card payment method title
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get creditDebitCard;

  /// Supported card types
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, American Express'**
  String get visaMastercardAmericanExpress;

  /// PayPal payment description
  ///
  /// In en, this message translates to:
  /// **'Pay with your PayPal account'**
  String get payWithPayPalAccount;

  /// Apple Pay payment option
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// Message for unavailable payment methods
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get notAvailableOnThisDevice;

  /// Google Pay payment option
  ///
  /// In en, this message translates to:
  /// **'Google Pay'**
  String get googlePay;

  /// Google Pay description
  ///
  /// In en, this message translates to:
  /// **'Quick and secure'**
  String get quickAndSecure;

  /// Label for small donation amount
  ///
  /// In en, this message translates to:
  /// **'Small Support'**
  String get smallSupport;

  /// Label for good donation amount
  ///
  /// In en, this message translates to:
  /// **'Good Support'**
  String get goodSupport;

  /// Great support amount label
  ///
  /// In en, this message translates to:
  /// **'Great Support'**
  String get greatSupport;

  /// Impact preview title showing how donation amount helps
  ///
  /// In en, this message translates to:
  /// **'Your {amount} helps:'**
  String yourAmountHelps(String amount);

  /// Hospice patient care description
  ///
  /// In en, this message translates to:
  /// **'Hospice patient care'**
  String get hospicePatientCare;

  /// App improvements description
  ///
  /// In en, this message translates to:
  /// **'App improvements'**
  String get appImprovements;

  /// Continue button text with donation amount
  ///
  /// In en, this message translates to:
  /// **'Continue with {amount}'**
  String continueWithAmount(String amount);

  /// Button text when no amount is selected
  ///
  /// In en, this message translates to:
  /// **'Select an amount'**
  String get selectAnAmount;

  /// Maybe later button text
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// Security and payment information text
  ///
  /// In en, this message translates to:
  /// **'Secure payment • No hidden fees • Tax receipt'**
  String get securePaymentInfo;

  /// Information text about hospice foundation with website link
  ///
  /// In en, this message translates to:
  /// **'Learn more about Hospice Foundation: fundacja-hospicjum.org'**
  String get learnMoreHospiceFoundation;

  /// Apple Pay authentication description
  ///
  /// In en, this message translates to:
  /// **'Touch ID or Face ID'**
  String get touchIdOrFaceId;

  /// Continue to payment button text
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// Button text when no payment method is selected
  ///
  /// In en, this message translates to:
  /// **'Select a payment method'**
  String get selectAPaymentMethod;

  /// Secure payment title
  ///
  /// In en, this message translates to:
  /// **'Secure Payment'**
  String get securePayment;

  /// Payment security information text
  ///
  /// In en, this message translates to:
  /// **'Your payment information is encrypted and secure. We do not store your payment details.'**
  String get paymentSecurityInfo;

  /// Tax receipt email notification text
  ///
  /// In en, this message translates to:
  /// **'Tax receipt will be sent to your email'**
  String get taxReceiptEmail;

  /// Credit card types description
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, American Express'**
  String get visaMastercardAmex;

  /// Message when payment method is not available on device
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get notAvailableOnDevice;

  /// Hospice foundation description
  ///
  /// In en, this message translates to:
  /// **'Comfort and care for patients'**
  String get comfortAndCareForPatients;

  /// Choose support amount instruction
  ///
  /// In en, this message translates to:
  /// **'Choose your support amount:'**
  String get chooseSupportAmount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'pl',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
