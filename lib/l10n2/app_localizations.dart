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

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flight Compensation'**
  String get appTitle;

  /// Welcome message with user name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}'**
  String welcomeUser(String userName);

  /// Label for sign out button
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

  /// Label for flight number field.
  ///
  /// In en, this message translates to:
  /// **'Flight Number:'**
  String get flightNumber;

  /// No description provided for @airline.
  ///
  /// In en, this message translates to:
  /// **'Airline'**
  String get airline;

  /// Label for departure airport field.
  ///
  /// In en, this message translates to:
  /// **'Departure Airport:'**
  String get departureAirport;

  /// Label for arrival airport field.
  ///
  /// In en, this message translates to:
  /// **'Arrival Airport:'**
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

  /// Button text to go back.
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

  /// Displayed when there are no claims yet on the dashboard
  ///
  /// In en, this message translates to:
  /// **'No Claims Yet'**
  String get noClaimsYet;

  /// Instructions for starting a compensation claim when no claims exist
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

  /// Tip for keeping profile information current
  ///
  /// In en, this message translates to:
  /// **'Keep Your Profile Up-to-date'**
  String get tipProfileUpToDate;

  /// Tip indicating privacy of profile information
  ///
  /// In en, this message translates to:
  /// **'Your Information is Private'**
  String get tipInformationPrivate;

  /// Label for contact details section in profile
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get tipContactDetails;

  /// Label for accessibility settings section in profile
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
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

  /// Label for flight date field.
  ///
  /// In en, this message translates to:
  /// **'Flight Date:'**
  String get flightDate;

  /// Button label for checking compensation eligibility
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

  /// Title shown when a claim cannot be found.
  ///
  /// In en, this message translates to:
  /// **'Claim Not Found'**
  String get claimNotFound;

  /// Description shown when a claim cannot be found.
  ///
  /// In en, this message translates to:
  /// **'The requested claim could not be found. It may have been deleted.'**
  String get claimNotFoundDesc;

  /// Button label to return to the dashboard from a not found screen.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @euWideEligibleFlights.
  ///
  /// In en, this message translates to:
  /// **'EU-wide Compensation Eligible Flights'**
  String get euWideEligibleFlights;

  /// No description provided for @submitNewClaim.
  ///
  /// In en, this message translates to:
  /// **'Submit New Claim'**
  String get submitNewClaim;

  /// Label for reason field.
  ///
  /// In en, this message translates to:
  /// **'Reason for Claim:'**
  String get reasonForClaim;

  /// No description provided for @flightDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select the date of your flight'**
  String get flightDateHint;

  /// No description provided for @continueToAttachments.
  ///
  /// In en, this message translates to:
  /// **'Continue to Attachments'**
  String get continueToAttachments;

  /// Validation message for empty flight number
  ///
  /// In en, this message translates to:
  /// **'Please enter a flight number'**
  String get pleaseEnterFlightNumber;

  /// No description provided for @pleaseEnterArrivalAirport.
  ///
  /// In en, this message translates to:
  /// **'Please enter an arrival airport'**
  String get pleaseEnterArrivalAirport;

  /// No description provided for @pleaseEnterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get pleaseEnterReason;

  /// No description provided for @pleaseSelectFlightDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a flight date.'**
  String get pleaseSelectFlightDate;

  /// No description provided for @claimDetails.
  ///
  /// In en, this message translates to:
  /// **'Claim Details'**
  String get claimDetails;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @errorLoadingClaim.
  ///
  /// In en, this message translates to:
  /// **'Error loading claim'**
  String get errorLoadingClaim;

  /// Button label for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

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

  /// Tip about checking eligibility in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Check EU Regulation 261/2004 eligibility before claiming.'**
  String get tipCheckEligibility;

  /// Tip about double-checking details in the quick claim screen
  ///
  /// In en, this message translates to:
  /// **'Double-check all details before submitting your claim.'**
  String get tipDoubleCheckDetails;

  /// Tooltip text for the FAQ help button
  ///
  /// In en, this message translates to:
  /// **'View FAQ help'**
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

  /// Info banner text for the Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'For EU-eligible flights. Fill in basic info for a quick preliminary check.'**
  String get quickClaimInfoBanner;

  /// Helper text for flight number input in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Usually a 2-letter airline code and digits, e.g. LH1234'**
  String get flightNumberHintQuickClaim;

  /// Helper text for departure airport input in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'e.g. FRA for Frankfurt, LHR for London Heathrow'**
  String get departureAirportHintQuickClaim;

  /// Helper text for arrival airport input in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'e.g. JFK for New York, CDG for Paris'**
  String get arrivalAirportHintQuickClaim;

  /// Label for the reason field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Reason for Claim'**
  String get reasonForClaimLabel;

  /// Helper text for the reason field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Provide details about what happened with your flight'**
  String get reasonForClaimHint;

  /// Label for the optional compensation amount field
  ///
  /// In en, this message translates to:
  /// **'Compensation Amount (optional)'**
  String get compensationAmountOptionalLabel;

  /// Helper text for the compensation amount field
  ///
  /// In en, this message translates to:
  /// **'If you know the amount you are eligible for, enter it here'**
  String get compensationAmountHint;

  /// Title for the EU-wide compensation eligible flights screen
  ///
  /// In en, this message translates to:
  /// **'EU-wide Compensation'**
  String get euWideCompensationTitle;

  /// Button to filter flights from the last 72 hours
  ///
  /// In en, this message translates to:
  /// **'Last 72 hours'**
  String get last72HoursButton;

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

  /// Label for delete button
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

  /// Tooltip for flight number field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the flight number as shown on your ticket or booking'**
  String get tooltipFlightNumberQuickClaim;

  /// Tooltip for flight date field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Date when your flight was scheduled to depart'**
  String get tooltipFlightDateQuickClaim;

  /// Validation error message for departure airport field
  ///
  /// In en, this message translates to:
  /// **'Departure airport is required.'**
  String get validatorDepartureAirportRequired;

  /// Tooltip for departure airport field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the 3-letter IATA code for the departure airport'**
  String get tooltipDepartureAirportQuickClaim;

  /// Validation error message for arrival airport field
  ///
  /// In en, this message translates to:
  /// **'Arrival airport is required.'**
  String get validatorArrivalAirportRequired;

  /// Tooltip for arrival airport field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the 3-letter IATA code for the arrival airport'**
  String get tooltipArrivalAirportQuickClaim;

  /// Hint text for the reason input in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'State why you are claiming: delay, cancellation, denied boarding, etc.'**
  String get hintTextReasonQuickClaim;

  /// Validation error message for reason field
  ///
  /// In en, this message translates to:
  /// **'Reason for claim is required.'**
  String get validatorReasonRequired;

  /// Tooltip for reason field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Explain the reason for your claim in detail'**
  String get tooltipReasonQuickClaim;

  /// Tooltip for compensation amount field in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Enter the amount if you know what you are eligible for'**
  String get tooltipCompensationAmountQuickClaim;

  /// Title for tips and reminders section in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Tips and Reminders'**
  String get tipsAndRemindersTitle;

  /// Tip about data security in Quick Claim screen
  ///
  /// In en, this message translates to:
  /// **'Your data is secure and encrypted.'**
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

  /// Label for filtering flights in the last N hours
  ///
  /// In en, this message translates to:
  /// **'Last {hours} hours'**
  String lastHours(int hours);

  /// Message shown when no flights match the selected filter
  ///
  /// In en, this message translates to:
  /// **'No flights matching filter: {filter}'**
  String noFlightsMatchingFilter(String filter);

  /// Tooltip for button to force refresh data
  ///
  /// In en, this message translates to:
  /// **'Force refresh data'**
  String get forceRefreshData;

  /// Snackbar message shown when forcing a fresh data load
  ///
  /// In en, this message translates to:
  /// **'Forcing a fresh data load...'**
  String get forcingFreshDataLoad;

  /// Button label to re-check or retry fetching flights
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get checkAgain;

  /// Title for the screen or section listing EU compensation eligible flights
  ///
  /// In en, this message translates to:
  /// **'EU Compensation Eligible Flights'**
  String get euWideCompensationEligibleFlights;

  /// Message shown when no eligible flights are found
  ///
  /// In en, this message translates to:
  /// **'No eligible flights found'**
  String get noEligibleFlightsFound;

  /// Description for empty state when no eligible flights are found
  ///
  /// In en, this message translates to:
  /// **'No flights found in the last {hours} hours.'**
  String noEligibleFlightsDescription(int hours);

  /// Message shown when there is a problem connecting to the API
  ///
  /// In en, this message translates to:
  /// **'API connection issue. Please try again.'**
  String get apiConnectionIssue;

  /// Button label for creating a new claim
  ///
  /// In en, this message translates to:
  /// **'Create a Claim'**
  String get createClaim;

  /// Status text for a submitted claim
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// Status text for a claim that is being reviewed
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get inReview;

  /// Status text for a claim that is being processed
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// Status text for a claim that has been approved
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Status text for a claim that has been rejected
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Status text for a claim that has been paid out
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Status text for a claim that is under appeal
  ///
  /// In en, this message translates to:
  /// **'Under Appeal'**
  String get underAppeal;

  /// Text for unknown values
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Title shown when authentication is required
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// Error message when claims cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Error Loading Claims'**
  String get errorLoadingClaims;

  /// Message shown when user needs to log in to view claims
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your claims dashboard'**
  String get loginToViewClaimsDashboard;

  /// Button label for login action
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Text showing claim for a specific flight with status
  ///
  /// In en, this message translates to:
  /// **'Claim for flight {number} - {status}'**
  String claimForFlight(Object number, Object status);

  /// Text showing flight route details with departure and arrival
  ///
  /// In en, this message translates to:
  /// **'Flight {number}: {departure} - {arrival}'**
  String flightRouteDetails(Object number, Object departure, Object arrival);

  /// Accessibility hint for viewing claim details
  ///
  /// In en, this message translates to:
  /// **'View claim details'**
  String get viewClaimDetails;

  /// Label for total compensation amount in dashboard analytics
  ///
  /// In en, this message translates to:
  /// **'Total Compensation'**
  String get totalCompensation;

  /// Label for pending compensation amount in dashboard analytics
  ///
  /// In en, this message translates to:
  /// **'Pending Amount'**
  String get pendingAmount;

  /// Text shown when compensation amount is pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Title for the claims dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Claims Dashboard'**
  String get claimsDashboard;

  /// Tooltip for the refresh button on dashboard
  ///
  /// In en, this message translates to:
  /// **'Refresh Dashboard'**
  String get refreshDashboard;

  /// Title for the claims summary section
  ///
  /// In en, this message translates to:
  /// **'Claims Summary'**
  String get claimsSummary;

  /// Label for the total claims count
  ///
  /// In en, this message translates to:
  /// **'Total Claims'**
  String get totalClaims;

  /// Title for accessibility settings section
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
  String get accessibilitySettings;

  /// Semantic label for accessibility settings button
  ///
  /// In en, this message translates to:
  /// **'Configure accessibility options'**
  String get configureAccessibility;

  /// Semantic label for notification settings button
  ///
  /// In en, this message translates to:
  /// **'Configure notifications'**
  String get configureNotifications;

  /// Message indicating notifications feature is in development
  ///
  /// In en, this message translates to:
  /// **'Notification settings coming soon!'**
  String get notificationSettingsComingSoon;

  /// Label for language selection button
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Label for button to edit personal information
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Information'**
  String get editPersonalInfo;

  /// Description of what editing personal information allows
  ///
  /// In en, this message translates to:
  /// **'Update your personal details, address, and contact information'**
  String get editPersonalInfoDescription;

  /// Error message shown when signing out fails
  ///
  /// In en, this message translates to:
  /// **'Error signing out: {error}'**
  String errorSigningOut(String error);

  /// Label for sign in or sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign In / Sign Up'**
  String get signInOrSignUp;

  /// Generic name for user when actual name is not available
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get genericUser;

  /// Label for dismiss button
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Message encouraging user to sign in to track claims
  ///
  /// In en, this message translates to:
  /// **'Sign in to track your claims'**
  String get signInToTrackClaims;

  /// Description of benefits of creating an account
  ///
  /// In en, this message translates to:
  /// **'Create an account to easily track all your compensation claims'**
  String get createAccountDescription;

  /// Button label to proceed to attachments screen
  ///
  /// In en, this message translates to:
  /// **'Continue to Attachments'**
  String get continueToAttachmentsButton;

  /// Button label to proceed to review screen
  ///
  /// In en, this message translates to:
  /// **'Continue to Review'**
  String get continueToReview;

  /// Label for country field
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Label for privacy settings section
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Label for consent to share data switch
  ///
  /// In en, this message translates to:
  /// **'Consent to Share Data'**
  String get consentToShareData;

  /// Description for consent to share data
  ///
  /// In en, this message translates to:
  /// **'Required for processing your claims'**
  String get requiredForProcessing;

  /// Label for receive notifications switch
  ///
  /// In en, this message translates to:
  /// **'Receive Notifications'**
  String get receiveNotifications;

  /// Description for receive notifications
  ///
  /// In en, this message translates to:
  /// **'Get updates about your claims'**
  String get getClaimUpdates;

  /// Button label to save profile changes
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// Label for passport number field
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportNumber;

  /// Label for nationality field
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// Label for date of birth field
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Hint text for date format
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateFormat;

  /// Label for address field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Label for city field
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Label for postal code field
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// Error message when profile cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;

  /// Success message when profile is saved
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// Title for profile edit screen
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Information about keeping profile information accurate
  ///
  /// In en, this message translates to:
  /// **'Please ensure your profile information is accurate'**
  String get profileAccuracyInfo;

  /// Instruction to keep profile information current
  ///
  /// In en, this message translates to:
  /// **'Keep your profile up to date'**
  String get keepProfileUpToDate;

  /// Statement about profile privacy
  ///
  /// In en, this message translates to:
  /// **'We protect your privacy and data'**
  String get profilePrivacy;

  /// Explanation about importance of correct contact details
  ///
  /// In en, this message translates to:
  /// **'Correct contact details help with compensation'**
  String get correctContactDetails;

  /// Label for full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Title for document attachment screen
  ///
  /// In en, this message translates to:
  /// **'Attach Documents'**
  String get attachDocuments;

  /// Message shown when a document is being uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploading document...'**
  String get uploadingDocument;

  /// Message shown when user has no documents
  ///
  /// In en, this message translates to:
  /// **'You have no documents.'**
  String get noDocuments;

  /// Button label to upload first document
  ///
  /// In en, this message translates to:
  /// **'Upload First Document'**
  String get uploadFirstDocument;

  /// Button label to upload a new document
  ///
  /// In en, this message translates to:
  /// **'Upload New'**
  String get uploadNew;

  /// Success message when document is uploaded
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully!'**
  String get documentUploadSuccess;

  /// Error message when document upload fails
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Please try again.'**
  String get uploadFailed;

  /// Label for button to continue to the next screen
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Label for claim attachment item
  ///
  /// In en, this message translates to:
  /// **'Claim Attachment'**
  String get claimAttachment;

  /// Label for button to preview email
  ///
  /// In en, this message translates to:
  /// **'Preview Email'**
  String get previewEmail;

  /// Message shown in place of PDF preview
  ///
  /// In en, this message translates to:
  /// **'PDF preview would be shown here.'**
  String get pdfPreviewMessage;

  /// Label for button to download PDF
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// Message shown when file preview is not available
  ///
  /// In en, this message translates to:
  /// **'File preview not available'**
  String get filePreviewNotAvailable;

  /// Title for document deletion confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// Confirmation message for document deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this document?'**
  String get deleteDocumentConfirmation;

  /// Success message after document deletion
  ///
  /// In en, this message translates to:
  /// **'Document deleted successfully'**
  String get documentDeletedSuccess;

  /// Error message when document deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete document'**
  String get documentDeleteFailed;

  /// The label for the 'other' document type.
  ///
  /// In en, this message translates to:
  /// **'other'**
  String get other;

  /// Title for the claim review screen.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Review Your Claim'**
  String get reviewYourClaim;

  /// Instructions for reviewing claim details.
  ///
  /// In en, this message translates to:
  /// **'Please review the details of your claim before proceeding.'**
  String get reviewClaimDetails;

  /// Label for attachments section.
  ///
  /// In en, this message translates to:
  /// **'Attachments:'**
  String get attachments;

  /// Button text to proceed to confirmation screen.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Confirmation'**
  String get proceedToConfirmation;

  /// Title for the claim confirmation screen.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Confirm & Send'**
  String get confirmAndSend;

  /// Error message when email details cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not load email details.'**
  String get errorLoadingEmailDetails;

  /// Error message when email information is missing.
  ///
  /// In en, this message translates to:
  /// **'Could not find email information for the user or airline.'**
  String get noEmailInfo;

  /// Title for final confirmation section.
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get finalConfirmation;

  /// Label for airline email.
  ///
  /// In en, this message translates to:
  /// **'The claim will be sent to:'**
  String get claimWillBeSentTo;

  /// Label for user email.
  ///
  /// In en, this message translates to:
  /// **'A copy will be sent to your email:'**
  String get copyToYourEmail;

  /// Button text for confirming and sending email in claim confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Confirm and Send Email'**
  String get confirmAndSendEmail;

  /// Title for the Flight Compensation Checker screen
  ///
  /// In en, this message translates to:
  /// **'Flight Compensation Checker'**
  String get flightCompensationCheckerTitle;

  /// Header text for the EU261 eligibility checker
  ///
  /// In en, this message translates to:
  /// **'Check if your flight is eligible for EU261 compensation'**
  String get checkEligibilityForEu261;

  /// Placeholder text for flight number input field
  ///
  /// In en, this message translates to:
  /// **'Flight Number (e.g., BA123)'**
  String get flightNumberPlaceholder;

  /// Placeholder text for optional date input field
  ///
  /// In en, this message translates to:
  /// **'Date (YYYY-MM-DD, optional)'**
  String get dateOptionalPlaceholder;

  /// Hint text for date field
  ///
  /// In en, this message translates to:
  /// **'Leave empty for today'**
  String get leaveDateEmptyForToday;

  /// Error text for error messages
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Format for displaying flight info with number and airline
  ///
  /// In en, this message translates to:
  /// **'Flight {flightNumber} - {airline}'**
  String flightInfoFormat(String flightNumber, String airline);

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// From label for departure airport
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To label for arrival airport
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Delay label
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// Format for displaying minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutesFormat(int minutes);

  /// Message shown when flight is eligible for compensation
  ///
  /// In en, this message translates to:
  /// **'Your flight is eligible for compensation!'**
  String get flightEligibleForCompensation;

  /// Message shown when flight is not eligible for compensation
  ///
  /// In en, this message translates to:
  /// **'Your flight is not eligible for compensation.'**
  String get flightNotEligibleForCompensation;

  /// Label for potential compensation amount
  ///
  /// In en, this message translates to:
  /// **'Potential Compensation:'**
  String get potentialCompensation;

  /// Instruction for claiming compensation
  ///
  /// In en, this message translates to:
  /// **'Contact the airline to claim your compensation under EU Regulation 261/2004.'**
  String get contactAirlineForClaim;

  /// Prefix for showing reason for ineligibility
  ///
  /// In en, this message translates to:
  /// **'Reason: '**
  String get reasonPrefix;

  /// Reason for ineligibility due to short delay
  ///
  /// In en, this message translates to:
  /// **'Flight delay is less than 3 hours'**
  String get delayLessThan3Hours;

  /// Reason for ineligibility due to jurisdiction
  ///
  /// In en, this message translates to:
  /// **'Flight is not under EU jurisdiction'**
  String get notUnderEuJurisdiction;

  /// Default reason when specific reason is not available
  ///
  /// In en, this message translates to:
  /// **'Unknown reason'**
  String get unknownReason;

  /// Button text for reviewing and confirming the claim before submission
  ///
  /// In en, this message translates to:
  /// **'Review and Confirm'**
  String get reviewAndConfirm;

  /// Header text for the confirmation step asking user to verify claim details
  ///
  /// In en, this message translates to:
  /// **'Please confirm that these details are correct:'**
  String get pleaseConfirmDetails;

  /// Message shown after email app is opened.
  ///
  /// In en, this message translates to:
  /// **'Your email app has been opened. Please send the email to finalize your claim.'**
  String get emailAppOpenedMessage;

  /// Error message when email app cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app. Please send your claim manually to {email}.'**
  String emailAppErrorMessage(String email);
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
