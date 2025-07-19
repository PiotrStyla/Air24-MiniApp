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
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

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
  String get checkCompensationEligibility =>
      'Entschädigungsberechtigung prüfen';

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
  String get submitNewClaim => 'Neuen Anspruch einreichen';

  @override
  String get reasonForClaim => 'Grund für den Anspruch';

  @override
  String get flightDateHint => 'Flugdatum (JJJJ-MM-TT)';

  @override
  String get continueToAttachments => 'Weiter zu Anlagen';

  @override
  String get pleaseEnterFlightNumber => 'Bitte geben Sie eine Flugnummer ein';

  @override
  String get pleaseEnterArrivalAirport =>
      'Bitte geben Sie einen Ankunftsflughafen ein';

  @override
  String get pleaseEnterReason => 'Bitte geben Sie einen Grund ein';

  @override
  String get pleaseSelectFlightDate => 'Bitte wählen Sie ein Flugdatum';

  @override
  String get claimDetails => 'Anspruchsdetails';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get errorLoadingClaim => 'Fehler beim Laden des Anspruchs';

  @override
  String get retry => 'Wiederholen';

  @override
  String get unknownError => 'Unbekannter Fehler';

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
  String get networkError => 'Netzwerkfehler';

  @override
  String get generalError => 'Allgemeiner Fehler';

  @override
  String get loginRequiredForClaim =>
      'Anmeldung erforderlich, um einen Anspruch einzureichen';

  @override
  String get quickClaimTitle => 'Schnellanspruch';

  @override
  String get quickClaimInfoBanner =>
      'Für EU-berechtigte Flüge. Füllen Sie grundlegende Informationen für eine schnelle Vorabprüfung aus.';

  @override
  String get flightNumberHintQuickClaim => 'z.B. LH123';

  @override
  String get departureAirportHintQuickClaim => 'z.B. FRA';

  @override
  String get arrivalAirportHintQuickClaim => 'z.B. LHR';

  @override
  String get reasonForClaimLabel => 'Grund für den Anspruch';

  @override
  String get reasonForClaimHint => 'z.B. Verspätung, Annullierung';

  @override
  String get compensationAmountOptionalLabel =>
      'Entschädigungsbetrag (optional)';

  @override
  String get compensationAmountHint => 'z.B. 250€';

  @override
  String get euWideCompensationTitle => 'EU-weite Entschädigungen';

  @override
  String get last72HoursButton => 'Letzte 72 Stunden';

  @override
  String get scheduledLabel => 'Geplant';

  @override
  String get statusLabelEuList => 'Status';

  @override
  String get potentialCompensationLabel => 'Potenzielle Entschädigung';

  @override
  String get prefillCompensationFormButton =>
      'Entschädigungsformular ausfüllen';

  @override
  String get claimsTabActive => 'Aktiv';

  @override
  String get claimsTabActionRequired => 'Maßnahme erforderlich';

  @override
  String get claimsTabCompleted => 'Abgeschlossen';

  @override
  String get dialogTitleSuccess => 'Erfolg';

  @override
  String get dialogContentClaimSubmitted =>
      'Ihr Anspruch wurde erfolgreich eingereicht.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Dokumentenverwaltung';

  @override
  String get documentsForFlightTitle => 'Dokumente für Flug';

  @override
  String get errorLoadingDocuments => 'Fehler beim Laden der Dokumente';

  @override
  String get addDocumentTooltip => 'Dokument hinzufügen';

  @override
  String get deleteDocumentTitle => 'Dokument löschen';

  @override
  String get deleteDocumentMessage =>
      'Sind Sie sicher, dass Sie dieses Dokument löschen möchten?';

  @override
  String get delete => 'Löschen';

  @override
  String get errorMustBeLoggedIn =>
      'Sie müssen angemeldet sein, um diese Aktion durchzuführen';

  @override
  String get errorFailedToSubmitClaim => 'Fehler beim Einreichen des Anspruchs';

  @override
  String get dialogTitleError => 'Fehler';

  @override
  String get validatorFlightNumberRequired => 'Flugnummer ist erforderlich';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Geben Sie die Flugnummer ein, z.B. LH123';

  @override
  String get tooltipFlightDateQuickClaim => 'Wählen Sie das Datum Ihres Fluges';

  @override
  String get validatorDepartureAirportRequired =>
      'Abflughafen ist erforderlich';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Geben Sie den 3-stelligen IATA-Code für den Abflughafen ein';

  @override
  String get validatorArrivalAirportRequired =>
      'Ankunftsflughafen ist erforderlich';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Ankunftsflughafen für Quick Claim';

  @override
  String get hintTextReasonQuickClaim => 'z.B. Verspätung über 3 Stunden';

  @override
  String get validatorReasonRequired => 'Grund ist erforderlich';

  @override
  String get tooltipReasonQuickClaim =>
      'Beschreiben Sie kurz, warum Sie einen Anspruch einreichen';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Geben Sie den Betrag ein, wenn Sie wissen, wofür Sie berechtigt sind';

  @override
  String get tipsAndRemindersTitle => 'Tipps & Erinnerungen';

  @override
  String get tipSecureData =>
      'Wir schützen Ihre Daten mit Bankstandard-Verschlüsselung';

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
  String get continueToReview => 'Weiter zur Überprüfung';

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
  String get previewEmail => 'E-Mail-Vorschau';

  @override
  String get pdfPreviewMessage => 'PDF-Vorschau';

  @override
  String get downloadPdf => 'PDF herunterladen';

  @override
  String get filePreviewNotAvailable => 'Datevorschau nicht verfügbar';

  @override
  String get deleteDocument => 'Dokument löschen';

  @override
  String get deleteDocumentConfirmation =>
      'Sind Sie sicher, dass Sie dieses Dokument löschen möchten?';

  @override
  String get documentDeletedSuccess => 'Dokument erfolgreich gelöscht';

  @override
  String get documentDeleteFailed => 'Dokument konnte nicht gelöscht werden';

  @override
  String get other => 'andere';

  @override
  String get reviewYourClaim => 'Prüfen Sie Ihren Anspruch';

  @override
  String get reviewClaimDetails => 'Prüfen Sie die Anspruchsdetails';

  @override
  String get attachments => 'Anlagen';

  @override
  String get proceedToConfirmation => 'Weiter zur Bestätigung';

  @override
  String get confirmAndSend => 'Bestätigen und senden';

  @override
  String get errorLoadingEmailDetails => 'Fehler beim Laden der E-Mail-Details';

  @override
  String get noEmailInfo => 'Keine E-Mail-Informationen verfügbar';

  @override
  String get finalConfirmation => 'Abschließende Bestätigung';

  @override
  String get claimWillBeSentTo => 'Ihr Anspruch wird gesendet an';

  @override
  String get copyToYourEmail => 'Kopie an Ihre E-Mail';

  @override
  String get confirmAndSendEmail => 'Bestätigen und E-Mail senden';

  @override
  String get flightCompensationCheckerTitle => 'Flugentschädigungs-Prüfer';

  @override
  String get checkEligibilityForEu261 =>
      'Prüfen Sie, ob Ihr Flug für eine EU261-Entschädigung in Frage kommt';

  @override
  String get flightNumberPlaceholder => 'Flugnummer (z.B. LH123)';

  @override
  String get dateOptionalPlaceholder => 'Datum (JJJJ-MM-TT, optional)';

  @override
  String get leaveDateEmptyForToday => 'Leer lassen für heute';

  @override
  String get error => 'Fehler';

  @override
  String flightInfoFormat(String flightNumber, String airline) {
    return 'Flug $flightNumber - $airline';
  }

  @override
  String get status => 'Status';

  @override
  String get from => 'Von';

  @override
  String get to => 'Nach';

  @override
  String get delay => 'Verspätung';

  @override
  String minutesFormat(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get flightEligibleForCompensation =>
      'Ihr Flug hat Anspruch auf Entschädigung!';

  @override
  String get flightNotEligibleForCompensation =>
      'Ihr Flug hat keinen Anspruch auf Entschädigung.';

  @override
  String get potentialCompensation => 'Mögliche Entschädigung:';

  @override
  String get contactAirlineForClaim =>
      'Kontaktieren Sie die Fluggesellschaft, um Ihre Entschädigung gemäß EU-Verordnung 261/2004 zu beantragen.';

  @override
  String get reasonPrefix => 'Grund: ';

  @override
  String get delayLessThan3Hours => 'Flugverspätung ist weniger als 3 Stunden';

  @override
  String get notUnderEuJurisdiction =>
      'Flug unterliegt nicht der EU-Rechtsprechung';

  @override
  String get unknownReason => 'Unbekannter Grund';

  @override
  String get reviewAndConfirm => 'Überprüfen und bestätigen';

  @override
  String get pleaseConfirmDetails =>
      'Bitte bestätigen Sie, dass alle Details korrekt sind';

  @override
  String get emailAppOpenedMessage => 'E-Mail-App geöffnet';

  @override
  String emailAppErrorMessage(String email) {
    return 'Fehler beim Öffnen der E-Mail-App';
  }
}
