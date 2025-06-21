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
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flight Compensation'**
  String get appTitle;

  /// A welcome message for the user
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}'**
  String welcomeUser(String userName);

  /// Sign out button label
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// New claim button label
  ///
  /// In en, this message translates to:
  /// **'New Claim'**
  String get newClaim;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelection;

  /// No description provided for @passengerName.
  ///
  /// In en, this message translates to:
  /// **'Passenger Name'**
  String get passengerName;

  /// No description provided for @passengerDetails.
  ///
  /// In en, this message translates to:
  /// **'Passenger Details'**
  String get passengerDetails;

  /// No description provided for @flightNumber.
  ///
  /// In en, this message translates to:
  /// **'Flight Number'**
  String get flightNumber;

  /// No description provided for @airline.
  ///
  /// In en, this message translates to:
  /// **'Airline'**
  String get airline;

  /// No description provided for @departureAirport.
  ///
  /// In en, this message translates to:
  /// **'Departure Airport'**
  String get departureAirport;

  /// No description provided for @arrivalAirport.
  ///
  /// In en, this message translates to:
  /// **'Arrival Airport'**
  String get arrivalAirport;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @bookingReference.
  ///
  /// In en, this message translates to:
  /// **'Booking Reference'**
  String get bookingReference;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get thisFieldIsRequired;

  /// No description provided for @pleaseEnterDepartureAirport.
  ///
  /// In en, this message translates to:
  /// **'Please enter a departure airport.'**
  String get pleaseEnterDepartureAirport;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @submitClaim.
  ///
  /// In en, this message translates to:
  /// **'Submit Claim'**
  String get submitClaim;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @claimSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Claim submitted successfully!'**
  String get claimSubmittedSuccessfully;

  /// No description provided for @completeAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields.'**
  String get completeAllFields;

  /// No description provided for @supportingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents'**
  String get supportingDocuments;

  /// No description provided for @cropDocument.
  ///
  /// In en, this message translates to:
  /// **'Crop Document'**
  String get cropDocument;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @cropping.
  ///
  /// In en, this message translates to:
  /// **'Cropping...'**
  String get cropping;

  /// No description provided for @rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @aspectRatioFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get aspectRatioFree;

  /// No description provided for @aspectRatioSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get aspectRatioSquare;

  /// No description provided for @aspectRatioPortrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get aspectRatioPortrait;

  /// No description provided for @aspectRatioLandscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get aspectRatioLandscape;

  /// No description provided for @aspectRatioMode.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio: {ratio}'**
  String aspectRatioMode(String ratio);

  /// No description provided for @documentOcrResult.
  ///
  /// In en, this message translates to:
  /// **'OCR Result'**
  String get documentOcrResult;

  /// No description provided for @extractedFields.
  ///
  /// In en, this message translates to:
  /// **'Extracted Fields'**
  String get extractedFields;

  /// No description provided for @fullText.
  ///
  /// In en, this message translates to:
  /// **'Full Text'**
  String get fullText;

  /// No description provided for @documentSaved.
  ///
  /// In en, this message translates to:
  /// **'Document saved.'**
  String get documentSaved;

  /// No description provided for @useExtractedData.
  ///
  /// In en, this message translates to:
  /// **'Use Extracted Data'**
  String get useExtractedData;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard.'**
  String get copyToClipboard;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @saveDocument.
  ///
  /// In en, this message translates to:
  /// **'Save Document'**
  String get saveDocument;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldName;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the app!'**
  String get welcomeMessage;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @fillForm.
  ///
  /// In en, this message translates to:
  /// **'Fill Form'**
  String get fillForm;

  /// No description provided for @chooseUseInfo.
  ///
  /// In en, this message translates to:
  /// **'Choose how to use this information:'**
  String get chooseUseInfo;

  /// No description provided for @fillPassengerFlight.
  ///
  /// In en, this message translates to:
  /// **'Fill passenger and flight info'**
  String get fillPassengerFlight;

  /// No description provided for @ocrResults.
  ///
  /// In en, this message translates to:
  /// **'OCR Results'**
  String get ocrResults;

  /// No description provided for @noFieldsExtracted.
  ///
  /// In en, this message translates to:
  /// **'No fields were extracted from the document.'**
  String get noFieldsExtracted;

  /// No description provided for @extractedInformation.
  ///
  /// In en, this message translates to:
  /// **'Extracted Information'**
  String get extractedInformation;

  /// No description provided for @rawOcrText.
  ///
  /// In en, this message translates to:
  /// **'Raw OCR Text'**
  String get rawOcrText;

  /// No description provided for @copyAllText.
  ///
  /// In en, this message translates to:
  /// **'Copy all text'**
  String get copyAllText;

  /// No description provided for @claims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get claims;

  /// No description provided for @noClaimsYet.
  ///
  /// In en, this message translates to:
  /// **'No Claims Yet'**
  String get noClaimsYet;

  /// No description provided for @startCompensationClaimInstructions.
  ///
  /// In en, this message translates to:
  /// **'Start your compensation claim by selecting a flight from the EU Eligible Flights section'**
  String get startCompensationClaimInstructions;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @actionRequired.
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get actionRequired;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @profileInfoCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile contains your personal and contact information. This is used to process your flight compensation claims and keep you updated.'**
  String get profileInfoCardTitle;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @accessibilityOptions.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Options'**
  String get accessibilityOptions;

  /// No description provided for @configureAccessibilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure high contrast, large text, and screen reader support'**
  String get configureAccessibilityDescription;

  /// No description provided for @configureNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure how you receive claim updates'**
  String get configureNotificationsDescription;

  /// No description provided for @tipProfileUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Keep your profile up to date for smooth claim processing.'**
  String get tipProfileUpToDate;

  /// No description provided for @tipInformationPrivate.
  ///
  /// In en, this message translates to:
  /// **'Your information is private and only used for compensation claims.'**
  String get tipInformationPrivate;

  /// No description provided for @tipContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Make sure your contact details are correct so we can reach you about your claim.'**
  String get tipContactDetails;

  /// No description provided for @tipAccessibilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Check the Accessibility Settings to customize the app for your needs.'**
  String get tipAccessibilitySettings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @arrivalsAt.
  ///
  /// In en, this message translates to:
  /// **'Arrivals at {airport}'**
  String arrivalsAt(String airport);

  /// No description provided for @filterByAirline.
  ///
  /// In en, this message translates to:
  /// **'Filter by airline'**
  String get filterByAirline;

  /// No description provided for @flightStatusDelayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get flightStatusDelayed;

  /// No description provided for @flightStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get flightStatusCancelled;

  /// No description provided for @flightStatusDiverted.
  ///
  /// In en, this message translates to:
  /// **'Diverted'**
  String get flightStatusDiverted;

  /// No description provided for @flightStatusOnTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get flightStatusOnTime;

  /// No description provided for @flight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get flight;

  /// No description provided for @flights.
  ///
  /// In en, this message translates to:
  /// **'Flights'**
  String get flights;

  /// No description provided for @myFlights.
  ///
  /// In en, this message translates to:
  /// **'My Flights'**
  String get myFlights;

  /// No description provided for @findFlight.
  ///
  /// In en, this message translates to:
  /// **'Find Flight'**
  String get findFlight;

  /// No description provided for @flightDate.
  ///
  /// In en, this message translates to:
  /// **'Flight Date'**
  String get flightDate;

  /// No description provided for @checkCompensationEligibility.
  ///
  /// In en, this message translates to:
  /// **'Check Compensation Eligibility'**
  String get checkCompensationEligibility;

  /// No description provided for @supportingDocumentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach boarding passes, tickets, and other documents to strengthen your claim.'**
  String get supportingDocumentsHint;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @scanDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'Use camera to auto-fill form'**
  String get scanDocumentHint;

  /// No description provided for @uploadDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'Select from device storage'**
  String get uploadDocumentHint;

  /// No description provided for @noDocumentsYet.
  ///
  /// In en, this message translates to:
  /// **'No documents attached yet'**
  String get noDocumentsYet;

  /// No description provided for @enterFlightNumberFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter a flight number first'**
  String get enterFlightNumberFirst;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @documentScanner.
  ///
  /// In en, this message translates to:
  /// **'Document Scanner'**
  String get documentScanner;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @editPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit your personal information'**
  String get editPersonalInformation;

  /// No description provided for @editPersonalAndContactInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit your personal and contact information'**
  String get editPersonalAndContactInformation;

  /// No description provided for @configureAccessibilityOptions.
  ///
  /// In en, this message translates to:
  /// **'Configure accessibility options for the app'**
  String get configureAccessibilityOptions;

  /// No description provided for @configureHighContrastLargeTextAndScreenReaderSupport.
  ///
  /// In en, this message translates to:
  /// **'Configure high contrast, large text, and screen reader support'**
  String get configureHighContrastLargeTextAndScreenReaderSupport;

  /// No description provided for @applicationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Application Preferences'**
  String get applicationPreferences;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @configureNotificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Configure notification preferences'**
  String get configureNotificationPreferences;

  /// No description provided for @configureHowYouReceiveClaimUpdates.
  ///
  /// In en, this message translates to:
  /// **'Configure how you receive claim updates'**
  String get configureHowYouReceiveClaimUpdates;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeApplicationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change application language'**
  String get changeApplicationLanguage;

  /// No description provided for @selectYourPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectYourPreferredLanguage;

  /// No description provided for @tipsAndReminders.
  ///
  /// In en, this message translates to:
  /// **'Tips & Reminders'**
  String get tipsAndReminders;

  /// No description provided for @importantTipsAboutProfileInformation.
  ///
  /// In en, this message translates to:
  /// **'Important tips about your profile information'**
  String get importantTipsAboutProfileInformation;

  /// No description provided for @noClaimsYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Claims Yet'**
  String get noClaimsYetTitle;

  /// No description provided for @noClaimsYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your compensation claim by selecting a flight from the EU Eligible Flights section'**
  String get noClaimsYetSubtitle;

  /// No description provided for @extractingText.
  ///
  /// In en, this message translates to:
  /// **'Extracting text and identifying fields'**
  String get extractingText;

  /// No description provided for @scanInstructions.
  ///
  /// In en, this message translates to:
  /// **'Position your document within the frame and take a photo'**
  String get scanInstructions;

  /// No description provided for @formFilledWithScannedData.
  ///
  /// In en, this message translates to:
  /// **'Form filled with scanned document data'**
  String get formFilledWithScannedData;

  /// No description provided for @flightDetails.
  ///
  /// In en, this message translates to:
  /// **'Flight Details'**
  String get flightDetails;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submissionChecklist.
  ///
  /// In en, this message translates to:
  /// **'Submission Checklist'**
  String get submissionChecklist;

  /// No description provided for @documentAttached.
  ///
  /// In en, this message translates to:
  /// **'Document Attached'**
  String get documentAttached;

  /// No description provided for @compensationClaimForm.
  ///
  /// In en, this message translates to:
  /// **'Compensation Claim Form'**
  String get compensationClaimForm;

  /// No description provided for @prefilledFromProfile.
  ///
  /// In en, this message translates to:
  /// **'Prefilled from your profile'**
  String get prefilledFromProfile;

  /// No description provided for @flightSearch.
  ///
  /// In en, this message translates to:
  /// **'Flight Search'**
  String get flightSearch;

  /// No description provided for @searchFlightNumber.
  ///
  /// In en, this message translates to:
  /// **'Search using flight number'**
  String get searchFlightNumber;

  /// No description provided for @delayedFlightDetected.
  ///
  /// In en, this message translates to:
  /// **'Delayed Flight Detected'**
  String get delayedFlightDetected;

  /// No description provided for @flightDetected.
  ///
  /// In en, this message translates to:
  /// **'Flight Detected'**
  String get flightDetected;

  /// No description provided for @flightLabel.
  ///
  /// In en, this message translates to:
  /// **'Flight:'**
  String get flightLabel;

  /// No description provided for @fromAirport.
  ///
  /// In en, this message translates to:
  /// **'From:'**
  String get fromAirport;

  /// No description provided for @toAirport.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get toAirport;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get statusLabel;

  /// No description provided for @delayedEligible.
  ///
  /// In en, this message translates to:
  /// **'Delayed and potentially eligible'**
  String get delayedEligible;

  /// No description provided for @startClaim.
  ///
  /// In en, this message translates to:
  /// **'Start Claim'**
  String get startClaim;

  /// No description provided for @euWideEligibleFlights.
  ///
  /// In en, this message translates to:
  /// **'EU-wide Compensation Eligible Flights'**
  String get euWideEligibleFlights;

  /// No description provided for @requiredFieldsCompleted.
  ///
  /// In en, this message translates to:
  /// **'All required fields are completed.'**
  String get requiredFieldsCompleted;

  /// No description provided for @scanningDocumentsNote.
  ///
  /// In en, this message translates to:
  /// **'Scanning documents can pre-fill some fields.'**
  String get scanningDocumentsNote;

  /// Tip about checking flight eligibility
  ///
  /// In en, this message translates to:
  /// **'• Ensure your flight is eligible for compensation (e.g., delay >3h, cancellation, denied boarding).'**
  String get tipCheckEligibility;

  /// Tip about double-checking details
  ///
  /// In en, this message translates to:
  /// **'• Double-check all details before submitting to avoid delays.'**
  String get tipDoubleCheckDetails;

  /// No description provided for @tooltipFaqHelp.
  ///
  /// In en, this message translates to:
  /// **'Access the frequently asked questions and help section'**
  String get tooltipFaqHelp;

  /// Error message for form submission failure
  ///
  /// In en, this message translates to:
  /// **'Error submitting form: {errorMessage}. Please check your connection and try again.'**
  String formSubmissionError(String errorMessage);

  /// Error message for network error
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get generalError;

  /// Error message for unauthenticated user submitting a claim
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to submit a claim.'**
  String get loginRequiredForClaim;

  /// Title for the Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Quick Claim'**
  String get quickClaimTitle;

  /// Informational banner on the Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'For EU-eligible flights. Fill in basic info for a quick preliminary check.'**
  String get quickClaimInfoBanner;

  /// Hint text for flight number input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Usually a 2-letter airline code and digits, e.g. LH1234'**
  String get flightNumberHintQuickClaim;

  /// Hint text for departure airport input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'e.g. FRA for Frankfurt, LHR for London Heathrow'**
  String get departureAirportHintQuickClaim;

  /// Hint text for arrival airport input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'e.g. JFK for New York, CDG for Paris'**
  String get arrivalAirportHintQuickClaim;

  /// Label for the reason for claim field on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Reason for Claim'**
  String get reasonForClaimLabel;

  /// Hint text for reason for claim input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'State why you are claiming: delay, cancellation, denied boarding, etc.'**
  String get reasonForClaimHint;

  /// Label for the optional compensation amount field on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Compensation Amount (optional)'**
  String get compensationAmountOptionalLabel;

  /// Hint text for compensation amount input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'If you know the amount you are eligible for, enter it here'**
  String get compensationAmountHint;

  /// Title for the EU-wide compensation eligible flights screen
  ///
  /// In en, this message translates to:
  /// **'EU-wide Compensation'**
  String get euWideCompensationTitle;

  /// Button to filter flights from the last 144 hours
  ///
  /// In en, this message translates to:
  /// **'Last 144 hours'**
  String get last144HoursButton;

  /// Label for scheduled time in flight lists
  ///
  /// In en, this message translates to:
  /// **'Scheduled:'**
  String get scheduledLabel;

  /// Label for flight status in EU-wide flight list
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get statusLabelEuList;

  /// Label for potential compensation amount in flight lists
  ///
  /// In en, this message translates to:
  /// **'Potential Compensation:'**
  String get potentialCompensationLabel;

  /// Button to pre-fill compensation form from flight details
  ///
  /// In en, this message translates to:
  /// **'Pre-fill Compensation Form'**
  String get prefillCompensationFormButton;

  /// Label for the 'Active' tab in claims dashboard
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get claimsTabActive;

  /// Label for the 'Action Required' tab in claims dashboard
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get claimsTabActionRequired;

  /// Label for the 'Completed' tab in claims dashboard
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get claimsTabCompleted;

  /// Dialog title for successful operations
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get dialogTitleSuccess;

  /// Dialog content for successful claim submission
  ///
  /// In en, this message translates to:
  /// **'Your claim has been submitted successfully.'**
  String get dialogContentClaimSubmitted;

  /// Label for OK button in dialogs
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogButtonOK;

  /// Title for the document management screen
  ///
  /// In en, this message translates to:
  /// **'Document Management'**
  String get documentManagementTitle;

  /// Title for the document management screen when a flight is specified
  ///
  /// In en, this message translates to:
  /// **'Documents for flight'**
  String get documentsForFlightTitle;

  /// Error message when documents fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading Documents'**
  String get errorLoadingDocuments;

  /// Tooltip for the add document button
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocumentTooltip;

  /// Title for the delete document confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Document?'**
  String get deleteDocumentTitle;

  /// Message for the delete document confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get deleteDocumentMessage;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Error message when user is not logged in
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to perform this action.'**
  String get errorMustBeLoggedIn;

  /// Error message when claim submission fails
  ///
  /// In en, this message translates to:
  /// **'Failed to submit claim. Please try again.'**
  String get errorFailedToSubmitClaim;

  /// Dialog title for error messages
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get dialogTitleError;

  /// Validation error message for flight number field
  ///
  /// In en, this message translates to:
  /// **'Flight number is required.'**
  String get validatorFlightNumberRequired;

  /// Tooltip for flight number input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the flight number (e.g., BA2490).'**
  String get tooltipFlightNumberQuickClaim;

  /// Tooltip for flight date display on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Select the date of your flight.'**
  String get tooltipFlightDateQuickClaim;

  /// Validation error message for departure airport field
  ///
  /// In en, this message translates to:
  /// **'Departure airport is required.'**
  String get validatorDepartureAirportRequired;

  /// Tooltip for departure airport input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the 3-letter IATA code for the departure airport (e.g., LHR).'**
  String get tooltipDepartureAirportQuickClaim;

  /// Validation error message for arrival airport field
  ///
  /// In en, this message translates to:
  /// **'Arrival airport is required.'**
  String get validatorArrivalAirportRequired;

  /// Tooltip for arrival airport input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the 3-letter IATA code for the arrival airport (e.g., JFK).'**
  String get tooltipArrivalAirportQuickClaim;

  /// Hint text (placeholder) for reason input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Reason (delay, cancellation, etc.)'**
  String get hintTextReasonQuickClaim;

  /// Validation error message for reason field
  ///
  /// In en, this message translates to:
  /// **'Reason for claim is required.'**
  String get validatorReasonRequired;

  /// Tooltip for reason input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Briefly state the reason for your claim (e.g., 4-hour delay).'**
  String get tooltipReasonQuickClaim;

  /// Tooltip for compensation amount input on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the compensation amount if known (e.g., 250 EUR).'**
  String get tooltipCompensationAmountQuickClaim;

  /// Title for the Tips & Reminders section on Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Tips & Reminders'**
  String get tipsAndRemindersTitle;

  /// Tip about secure data processing
  ///
  /// In en, this message translates to:
  /// **'• Your data is stored securely and used only for claim processing.'**
  String get tipSecureData;

  /// Message shown while a document is being processed by OCR
  ///
  /// In en, this message translates to:
  /// **'Processing document...'**
  String get processingDocument;

  /// Label for a generic field value in debugging or display
  ///
  /// In en, this message translates to:
  /// **'Field Value'**
  String get fieldValue;

  /// Error message when a network connection fails
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please check your network.'**
  String get errorConnectionFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'pl', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
