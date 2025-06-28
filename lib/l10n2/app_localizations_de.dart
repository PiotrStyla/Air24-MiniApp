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
  String get pleaseEnterDepartureAirport =>
      'Bitte geben Sie einen Abflughafen ein.';

  @override
  String get uploadDocuments => 'Dokumente hochladen';

  @override
  String get submitClaim => 'Anspruch einreichen';

  @override
  String get addDocument => 'Dokument hinzufügen';

  @override
  String get claimSubmittedSuccessfully => 'Anspruch erfolgreich eingereicht!';

  @override
  String get completeAllFields => 'Bitte füllen Sie alle Felder aus.';

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
  String get chooseUseInfo =>
      'Wählen Sie, wie Sie diese Informationen verwenden möchten:';

  @override
  String get fillPassengerFlight =>
      'Passagier- und Fluginformationen ausfüllen';

  @override
  String get ocrResults => 'OCR-Ergebnisse';

  @override
  String get noFieldsExtracted =>
      'Es wurden keine Felder aus dem Dokument extrahiert.';

  @override
  String get extractedInformation => 'Extrahierte Informationen';

  @override
  String get rawOcrText => 'Roher OCR-Text';

  @override
  String get copyAllText => 'Gesamten Text kopieren';

  @override
  String get claims => 'Ansprüche';

  @override
  String get noClaimsYet => 'Noch keine Ansprüche';

  @override
  String get startCompensationClaimInstructions =>
      'Starten Sie Ihren Entschädigungsantrag, indem Sie einen Flug aus dem Bereich \'EU-berechtigte Flüge\' auswählen';

  @override
  String get active => 'Aktiv';

  @override
  String get actionRequired => 'Handlung erforderlich';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get profileInfoCardTitle =>
      'Ihr Profil enthält Ihre persönlichen Daten und Kontaktinformationen. Diese werden verwendet, um Ihre Entschädigungsansprüche für Flüge zu bearbeiten und Sie über den Fortschritt auf dem Laufenden zu halten.';

  @override
  String get accountSettings => 'Kontoeinstellungen';

  @override
  String get accessibilityOptions => 'Barrierefreiheitsoptionen';

  @override
  String get configureAccessibilityDescription =>
      'Konfigurieren Sie hohen Kontrast, großen Text und Screenreader-Unterstützung';

  @override
  String get configureNotificationsDescription =>
      'Konfigurieren Sie, wie Sie Anspruchsaktualisierungen erhalten';

  @override
  String get tipProfileUpToDate => 'Halten Sie Ihr Profil aktuell';

  @override
  String get tipInformationPrivate => 'Ihre Informationen sind privat';

  @override
  String get tipContactDetails => 'Kontaktdetails';

  @override
  String get tipAccessibilitySettings => 'Barrierefreiheitseinstellungen';

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
  String get supportingDocumentsHint =>
      'Fügen Sie Bordkarten, Tickets und andere Dokumente bei, um Ihren Anspruch zu untermauern.';

  @override
  String get scanDocument => 'Dokument scannen';

  @override
  String get uploadDocument => 'Dokument hochladen';

  @override
  String get scanDocumentHint =>
      'Kamera verwenden, um das Formular automatisch auszufüllen';

  @override
  String get uploadDocumentHint => 'Aus dem Gerätespeicher auswählen';

  @override
  String get noDocumentsYet => 'Noch keine Dokumente angehängt';

  @override
  String get enterFlightNumberFirst =>
      'Bitte geben Sie zuerst eine Flugnummer ein';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get documentScanner => 'Dokumentenscanner';

  @override
  String get profileInformation => 'Profilinformationen';

  @override
  String get editPersonalInformation => 'Ihre persönlichen Daten bearbeiten';

  @override
  String get editPersonalAndContactInformation =>
      'Ihre persönlichen und Kontaktdaten bearbeiten';

  @override
  String get configureAccessibilityOptions =>
      'Barrierefreiheitsoptionen der App konfigurieren';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport =>
      'Hohen Kontrast, großen Text und Screenreader-Unterstützung konfigurieren';

  @override
  String get applicationPreferences => 'Anwendungseinstellungen';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get configureNotificationPreferences =>
      'Benachrichtigungseinstellungen konfigurieren';

  @override
  String get configureHowYouReceiveClaimUpdates =>
      'Konfigurieren Sie, wie Sie Anspruchsaktualisierungen erhalten';

  @override
  String get language => 'Sprache';

  @override
  String get changeApplicationLanguage => 'Anwendungssprache ändern';

  @override
  String get selectYourPreferredLanguage =>
      'Wählen Sie Ihre bevorzugte Sprache';

  @override
  String get tipsAndReminders => 'Tipps & Erinnerungen';

  @override
  String get importantTipsAboutProfileInformation =>
      'Wichtige Tipps zu Ihren Profilinformationen';

  @override
  String get noClaimsYetTitle => 'Noch keine Ansprüche';

  @override
  String get noClaimsYetSubtitle =>
      'Starten Sie Ihren Entschädigungsanspruch, indem Sie einen Flug aus dem Abschnitt EU-berechtigte Flüge auswählen';

  @override
  String get extractingText =>
      'Text wird extrahiert und Felder werden identifiziert';

  @override
  String get scanInstructions =>
      'Positionieren Sie Ihr Dokument im Rahmen und machen Sie ein Foto';

  @override
  String get formFilledWithScannedData =>
      'Formular mit gescannten Dokumentdaten gefüllt';

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
  String get claimNotFound => 'Anspruch nicht gefunden';

  @override
  String get claimNotFoundDesc =>
      'Der angeforderte Anspruch konnte nicht gefunden werden. Er wurde möglicherweise gelöscht.';

  @override
  String get backToDashboard => 'Zurück zum Dashboard';

  @override
  String get euWideEligibleFlights => 'EU-weit entschädigungsberechtigte Flüge';

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
  String get retry => 'Wiederholen';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get requiredFieldsCompleted =>
      'Alle erforderlichen Felder sind ausgefüllt.';

  @override
  String get scanningDocumentsNote =>
      'Das Scannen von Dokumenten kann einige Felder vorausfüllen.';

  @override
  String get tipCheckEligibility =>
      '• Stellen Sie sicher, dass Ihr Flug anspruchsberechtigt ist (z. B. Verspätung >3h, Annullierung, Nichtbeförderung).';

  @override
  String get tipDoubleCheckDetails =>
      '• Überprüfen Sie alle Details vor dem Einreichen, um Verzögerungen zu vermeiden.';

  @override
  String get tooltipFaqHelp =>
      'Greifen Sie auf die häufig gestellten Fragen und den Hilfebereich zu';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Fehler beim Senden des Formulars: $errorMessage. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';
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
  String get processingDocument => 'Dokument wird verarbeitet...';

  @override
  String get fieldValue => 'Feldwert';

  @override
  String get errorConnectionFailed =>
      'Verbindung fehlgeschlagen. Bitte überprüfen Sie Ihr Netzwerk.';

  @override
  String lastHours(int hours) {
    return 'Letzte $hours Stunden';
  }

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Keine Flüge entsprechen dem Filter: $filter';
  }

  @override
  String get forceRefreshData => 'Datenaktualisierung erzwingen';

  @override
  String get forcingFreshDataLoad =>
      'Erzwinge eine neue Datenaktualisierung...';

  @override
  String get checkAgain => 'Erneut prüfen';

  @override
  String get euWideCompensationEligibleFlights =>
      'EU-Entschädigungsberechtigte Flüge';

  @override
  String get noEligibleFlightsFound => 'Keine berechtigten Flüge gefunden';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Keine Flüge in den letzten $hours Stunden gefunden.';
  }

  @override
  String get apiConnectionIssue =>
      'API-Verbindungsproblem. Bitte versuchen Sie es erneut.';

  @override
  String get createClaim => 'Anspruch erstellen';

  @override
  String get submitted => 'Eingereicht';

  @override
  String get inReview => 'In Überprüfung';

  @override
  String get processing => 'In Bearbeitung';

  @override
  String get approved => 'Genehmigt';

  @override
  String get rejected => 'Abgelehnt';

  @override
  String get paid => 'Ausbezahlt';

  @override
  String get underAppeal => 'Im Einspruchsverfahren';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get errorLoadingClaims => 'Fehler beim Laden der Ansprüche';

  @override
  String get loginToViewClaimsDashboard =>
      'Bitte melden Sie sich an, um Ihr Anspruchs-Dashboard anzuzeigen';

  @override
  String get logIn => 'Anmelden';

  @override
  String claimForFlight(Object number, Object status) {
    return 'Anspruch für Flug $number - $status';
  }

  @override
  String flightRouteDetails(Object number, Object departure, Object arrival) {
    return 'Flug $number: $departure - $arrival';
  }

  @override
  String get viewClaimDetails => 'Anspruchsdetails anzeigen';

  @override
  String get totalCompensation => 'Gesamtentschädigung';

  @override
  String get pendingAmount => 'Ausstehender Betrag';

  @override
  String get pending => 'Ausstehend';

  @override
  String get claimsDashboard => 'Anspruchsdashboard';

  @override
  String get refreshDashboard => 'Dashboard aktualisieren';

  @override
  String get claimsSummary => 'Anspruchsübersicht';

  @override
  String get totalClaims => 'Gesamte Ansprüche';

  @override
  String get accessibilitySettings => 'Barrierefreiheitseinstellungen';

  @override
  String get configureAccessibility =>
      'Barrierefreiheitsoptionen konfigurieren';

  @override
  String get configureNotifications => 'Benachrichtigungen konfigurieren';

  @override
  String get notificationSettingsComingSoon =>
      'Benachrichtigungseinstellungen kommen bald!';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get editPersonalInfo => 'Persönliche Informationen bearbeiten';

  @override
  String get editPersonalInfoDescription =>
      'Aktualisieren Sie Ihre persönlichen Daten, Adresse und Kontaktinformationen';

  @override
  String errorSigningOut(String error) {
    return 'Fehler beim Abmelden: $error';
  }

  @override
  String get signInOrSignUp => 'Anmelden / Registrieren';

  @override
  String get genericUser => 'Benutzer';

  @override
  String get dismiss => 'Schließen';

  @override
  String get signInToTrackClaims =>
      'Melden Sie sich an, um Ihre Ansprüche zu verfolgen';

  @override
  String get createAccountDescription =>
      'Erstellen Sie ein Konto, um alle Ihre Entschädigungsansprüche einfach zu verfolgen';

  @override
  String get continueToAttachmentsButton => 'Weiter zu den Anhängen';

  @override
  String get country => 'Land';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get consentToShareData => 'Einwilligung zur Datenweitergabe';

  @override
  String get requiredForProcessing =>
      'Erforderlich für die Bearbeitung Ihrer Ansprüche';

  @override
  String get receiveNotifications => 'Benachrichtigungen erhalten';

  @override
  String get getClaimUpdates => 'Erhalten Sie Updates zu Ihren Ansprüchen';

  @override
  String get saveProfile => 'Profil speichern';

  @override
  String get passportNumber => 'Passnummer';

  @override
  String get nationality => 'Nationalität';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get dateFormat => 'TT/MM/JJJJ';

  @override
  String get address => 'Adresse';

  @override
  String get city => 'Stadt';

  @override
  String get postalCode => 'Postleitzahl';

  @override
  String get errorLoadingProfile => 'Fehler beim Laden des Profils';

  @override
  String get profileSaved => 'Profil erfolgreich gespeichert';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get profileAccuracyInfo =>
      'Bitte stellen Sie sicher, dass Ihre Profilinformationen korrekt sind';

  @override
  String get keepProfileUpToDate => 'Halten Sie Ihr Profil aktuell';

  @override
  String get profilePrivacy => 'Wir schützen Ihre Privatsphäre und Daten';

  @override
  String get correctContactDetails =>
      'Korrekte Kontaktdaten helfen bei der Entschädigung';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get attachDocuments => 'Dokumente anhängen';

  @override
  String get uploadingDocument => 'Dokument wird hochgeladen...';

  @override
  String get noDocuments => 'Sie haben keine Dokumente.';

  @override
  String get uploadFirstDocument => 'Erstes Dokument hochladen';

  @override
  String get uploadNew => 'Neu hochladen';

  @override
  String get documentUploadSuccess => 'Dokument erfolgreich hochgeladen!';

  @override
  String get uploadFailed =>
      'Hochladen fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get continueAction => 'Weiter';

  @override
  String get claimAttachment => 'Forderungsanhang';

  @override
  String get other => 'andere';

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
