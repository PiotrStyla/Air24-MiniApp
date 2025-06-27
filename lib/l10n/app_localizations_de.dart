// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Flugentschädigung';

  @override
  String welcomeUser(String userName) {
    return 'Willkommen, $userName';
  }

  @override
  String get signOut => 'Abmelden';

  @override
  String get newClaim => 'Neuer Anspruch';

  @override
  String get home => 'Startseite';

  @override
  String get settings => 'Einstellungen';

  @override
  String get languageSelection => 'Sprache';

  @override
  String get passengerName => 'Name des Passagiers';

  @override
  String get passengerDetails => 'Passagierdetails';

  @override
  String get flightNumber => 'Flugnummer';

  @override
  String get airline => 'Fluggesellschaft';

  @override
  String get departureAirport => 'Abflughafen';

  @override
  String get arrivalAirport => 'Ankunftsflughafen';

  @override
  String get email => 'E-Mail';

  @override
  String get bookingReference => 'Buchungsreferenz';

  @override
  String get additionalInformation => 'Zusätzliche Informationen';

  @override
  String get optional => '(Optional)';

  @override
  String get thisFieldIsRequired => 'Dieses Feld ist erforderlich.';

  @override
  String get pleaseEnterDepartureAirport => 'Bitte geben Sie einen Abflughafen ein.';

  @override
  String get uploadDocuments => 'Dokumente hochladen';

  @override
  String get submitClaim => 'Anspruch einreichen';

  @override
  String get addDocument => 'Dokument hinzufügen';

  @override
  String get claimSubmittedSuccessfully => 'Claim submitted successfully!';

  @override
  String get completeAllFields => 'Bitte füllen Sie alle Felder aus.';

  @override
  String get pleaseCompleteAllFields => 'Please complete all required fields.';

  @override
  String get pleaseAttachDocuments => 'Please attach required documents.';

  @override
  String get allFieldsCompleted => 'All fields completed.';

  @override
  String get processingDocument => 'Dokument wird verarbeitet...';

  @override
  String get supportingDocuments => 'Unterstützende Dokumente';

  @override
  String get cropDocument => 'Dokument zuschneiden';

  @override
  String get crop => 'Zuschneiden';

  @override
  String get cropping => 'Wird zugeschnitten...';

  @override
  String get rotate => 'Drehen';

  @override
  String get aspectRatio => 'Seitenverhältnis';

  @override
  String get aspectRatioFree => 'Frei';

  @override
  String get aspectRatioSquare => 'Quadratisch';

  @override
  String get aspectRatioPortrait => 'Hochformat';

  @override
  String get aspectRatioLandscape => 'Querformat';

  @override
  String aspectRatioMode(String ratio) {
    return 'Seitenverhältnis: $ratio';
  }

  @override
  String get documentOcrResult => 'OCR-Ergebnis';

  @override
  String get extractedFields => 'Extrahierte Felder';

  @override
  String get fullText => 'Volltext';

  @override
  String get documentSaved => 'Dokument gespeichert.';

  @override
  String get useExtractedData => 'Extrahierte Daten verwenden';

  @override
  String get copyToClipboard => 'In die Zwischenablage kopiert.';

  @override
  String get documentType => 'Dokumententyp';

  @override
  String get saveDocument => 'Dokument speichern';

  @override
  String get fieldName => 'Feldname';

  @override
  String get done => 'Fertig';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Zurück';

  @override
  String get save => 'Speichern';

  @override
  String get welcomeMessage => 'Willkommen in der App!';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get fillForm => 'Formular ausfüllen';

  @override
  String get chooseUseInfo => 'Wählen Sie, wie Sie diese Informationen verwenden möchten:';

  @override
  String get fillPassengerFlight => 'Passagier- und Fluginformationen ausfüllen';

  @override
  String get ocrResults => 'OCR-Ergebnisse';

  @override
  String get noFieldsExtracted => 'Es wurden keine Felder aus dem Dokument extrahiert.';

  @override
  String get extractedInformation => 'Extrahierte Informationen';

  @override
  String get rawOcrText => 'Roher OCR-Text';

  @override
  String get copyAllText => 'Copy all text';

  @override
  String get claims => 'Claims';

  @override
  String get noClaimsYet => 'No Claims Yet';

  @override
  String get startCompensationClaimInstructions => 'Starten Sie Ihren Entschädigungsanspruch, indem Sie einen Flug aus dem Abschnitt EU-berechtigte Flüge auswählen';

  @override
  String get active => 'Aktiv';

  @override
  String get actionRequired => 'Handlung erforderlich';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get profileInfoCardTitle => 'Ihr Profil enthält Ihre persönlichen Daten und Kontaktinformationen. Diese werden verwendet, um Ihre Entschädigungsansprüche für Flüge zu bearbeiten und Sie über den Fortschritt auf dem Laufenden zu halten.';

  @override
  String get accountSettings => 'Kontoeinstellungen';

  @override
  String get accessibilityOptions => 'Barrierefreiheitsoptionen';

  @override
  String get configureAccessibilityDescription => 'Konfigurieren Sie hohen Kontrast, großen Text und Screenreader-Unterstützung';

  @override
  String get configureNotificationsDescription => 'Konfigurieren Sie, wie Sie Anspruchsaktualisierungen erhalten';

  @override
  String get tipProfileUpToDate => 'Halten Sie Ihr Profil auf dem neuesten Stand, um eine reibungslose Anspruchsbearbeitung zu gewährleisten.';

  @override
  String get tipInformationPrivate => 'Ihre Informationen sind privat und werden nur für Entschädigungsansprüche verwendet.';

  @override
  String get tipContactDetails => 'Stellen Sie sicher, dass Ihre Kontaktdaten korrekt sind, damit wir Sie bezüglich Ihres Anspruchs erreichen können.';

  @override
  String get tipAccessibilitySettings => 'Überprüfen Sie die Barrierefreiheitseinstellungen, um die App an Ihre Bedürfnisse anzupassen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String arrivalsAt(String airport) {
    return 'Ankünfte in $airport';
  }

  @override
  String get filterByAirline => 'Nach Fluggesellschaft filtern';

  @override
  String get flightStatusDelayed => 'Verspätet';

  @override
  String get flightStatusCancelled => 'Annulliert';

  @override
  String get flightStatusDiverted => 'Umgelenkt';

  @override
  String get flightStatusOnTime => 'Pünktlich';

  @override
  String get flight => 'Flug';

  @override
  String get flights => 'Flüge';

  @override
  String get myFlights => 'Meine Flüge';

  @override
  String get findFlight => 'Flug finden';

  @override
  String get flightDate => 'Flugdatum';

  @override
  String get checkCompensationEligibility => 'Anspruchsberechtigung prüfen';

  @override
  String get supportingDocumentsHint => 'Fügen Sie Bordkarten, Tickets und andere Dokumente bei, um Ihren Anspruch zu untermauern.';

  @override
  String get scanDocument => 'Dokument scannen';

  @override
  String get uploadDocument => 'Dokument hochladen';

  @override
  String get scanDocumentHint => 'Kamera verwenden, um das Formular automatisch auszufüllen';

  @override
  String get uploadDocumentHint => 'Aus dem Gerätespeicher auswählen';

  @override
  String get noDocumentsYet => 'Noch keine Dokumente angehängt';

  @override
  String get enterFlightNumberFirst => 'Bitte geben Sie zuerst eine Flugnummer ein';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get documentScanner => 'Dokumentenscanner';

  @override
  String get profileInformation => 'Profilinformationen';

  @override
  String get editPersonalInformation => 'Ihre persönlichen Daten bearbeiten';

  @override
  String get editPersonalAndContactInformation => 'Ihre persönlichen und Kontaktdaten bearbeiten';

  @override
  String get configureAccessibilityOptions => 'Barrierefreiheitsoptionen der App konfigurieren';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport => 'Hohen Kontrast, großen Text und Screenreader-Unterstützung konfigurieren';

  @override
  String get applicationPreferences => 'Anwendungseinstellungen';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get configureNotificationPreferences => 'Benachrichtigungseinstellungen konfigurieren';

  @override
  String get configureHowYouReceiveClaimUpdates => 'Konfigurieren Sie, wie Sie Anspruchsaktualisierungen erhalten';

  @override
  String get language => 'Sprache';

  @override
  String get changeApplicationLanguage => 'Anwendungssprache ändern';

  @override
  String get selectYourPreferredLanguage => 'Wählen Sie Ihre bevorzugte Sprache';

  @override
  String get tipsAndReminders => 'Tipps & Erinnerungen';

  @override
  String get importantTipsAboutProfileInformation => 'Wichtige Tipps zu Ihren Profilinformationen';

  @override
  String get noClaimsYetTitle => 'Noch keine Ansprüche';

  @override
  String get noClaimsYetSubtitle => 'Starten Sie Ihren Entschädigungsanspruch, indem Sie einen Flug aus dem Abschnitt EU-berechtigte Flüge auswählen';

  @override
  String get extractingText => 'Text wird extrahiert und Felder werden identifiziert';

  @override
  String get scanInstructions => 'Positionieren Sie Ihr Dokument im Rahmen und machen Sie ein Foto';

  @override
  String get formFilledWithScannedData => 'Formular mit gescannten Dokumentdaten gefüllt';

  @override
  String get flightDetails => 'Flugdetails';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get required => 'Erforderlich';

  @override
  String get submit => 'Einreichen';

  @override
  String get submissionChecklist => 'Einreichungs-Checkliste';

  @override
  String get documentAttached => 'Dokument angehängt';

  @override
  String get compensationClaimForm => 'Entschädigungsantragsformular';

  @override
  String get prefilledFromProfile => 'Aus Ihrem Profil vorausgefüllt';

  @override
  String get flightSearch => 'Flugsuche';

  @override
  String get searchFlightNumber => 'Mit Flugnummer suchen';

  @override
  String get delayedFlightDetected => 'Verspäteter Flug erkannt';

  @override
  String get flightDetected => 'Flug erkannt';

  @override
  String get flightLabel => 'Flug:';

  @override
  String get fromAirport => 'Von:';

  @override
  String get toAirport => 'Nach:';

  @override
  String get statusLabel => 'Status:';

  @override
  String get delayedEligible => 'Verspätet und potenziell anspruchsberechtigt';

  @override
  String get startClaim => 'Anspruch starten';

  @override
  String get euWideEligibleFlights => 'EU-weit entschädigungsberechtigte Flüge';

  @override
  String get requiredFieldsCompleted => 'Alle erforderlichen Felder sind ausgefüllt.';

  @override
  String get scanningDocumentsNote => 'Das Scannen von Dokumenten kann einige Felder vorausfüllen.';

  @override
  String get tipCheckEligibility => '• Stellen Sie sicher, dass Ihr Flug anspruchsberechtigt ist (z. B. Verspätung >3h, Annullierung, Nichtbeförderung).';

  @override
  String get tipDoubleCheckDetails => '• Überprüfen Sie alle Details vor dem Einreichen, um Verzögerungen zu vermeiden.';

  @override
  String get tooltipFaqHelp => 'Greifen Sie auf die häufig gestellten Fragen und den Hilfebereich zu';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Fehler beim Senden des Formulars: $errorMessage. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';
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
  String get reasonForClaimLabel => 'Grund für den Anspruch (z.B. Verspätung > 3h)';

  @override
  String get reasonForClaimHint => 'Bitte geben Sie einen Grund ein';

  @override
  String get compensationAmountOptionalLabel => 'Compensation Amount (optional)';

  @override
  String get compensationAmountHint => 'If you know the amount you are eligible for, enter it here';

  @override
  String get euWideCompensationTitle => 'EU-wide Compensation';

  @override
  String get last72HoursButton => 'Letzte 72 Stunden';

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
    return 'Anspruchsberechtigte Ankünfte bei $airportIcao';
  }

  @override
  String errorWithDetails(String error) {
    return 'Fehler: $error';
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
  String get retry => 'Wiederholen';

  @override
  String get carrierName => 'Fluggesellschaftsname';

  @override
  String get pickDate => 'Datum auswählen';

  @override
  String get clearDate => 'Datum löschen';

  @override
  String get noEligibleArrivalsFound => 'Keine anspruchsberechtigten Ankünfte für die ausgewählten Filter gefunden.';

  @override
  String flightAndAirline(String flightNumber, String airlineName) {
    return '$flightNumber - $airlineName';
  }

  @override
  String scheduledTime(String time) {
    return 'Geplant: $time';
  }

  @override
  String fromAirportName(String airportName) {
    return 'Von: $airportName';
  }

  @override
  String revisedTime(String time) {
    return 'Überarbeitet: $time';
  }

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get euCompensationEligible => 'EU-Entschädigung berechtigt';

  @override
  String actualTime(String time) {
    return 'Tatsächlich: $time';
  }

  @override
  String delayAmount(String delay) {
    return 'Verspätung: $delay';
  }

  @override
  String aircraftModel(String model) {
    return 'Flugzeug: $model';
  }

  @override
  String compensationAmount(String amount) {
    return 'Entschädigung: $amount';
  }

  @override
  String get flightNumberLabel => 'Flugnummer';

  @override
  String get flightNumberHint => 'Bitte geben Sie eine Flugnummer ein';

  @override
  String get departureAirportLabel => 'Abflughafen (IATA)';

  @override
  String get departureAirportHint => 'Bitte geben Sie einen Abflughafen ein';

  @override
  String get arrivalAirportLabel => 'Ankunftsflughafen (IATA)';

  @override
  String get arrivalAirportHint => 'Bitte geben Sie einen Ankunftsflughafen ein';

  @override
  String get flightDateLabel => 'Flugdatum';

  @override
  String get flightDateHint => 'Wählen Sie das Datum Ihres Fluges';

  @override
  String get flightDateError => 'Bitte wählen Sie ein Flugdatum';

  @override
  String get continueToAttachmentsButton => 'Weiter zu Anlagen';

  @override
  String get fieldValue => 'Feldwert';

  @override
  String get errorConnectionFailed => 'Verbindung fehlgeschlagen. Bitte überprüfen Sie Ihr Netzwerk.';

  @override
  String get submitNewClaimTitle => 'Neuen Anspruch einreichen';

  @override
  String get airlineLabel => 'Fluggesellschaft';

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
