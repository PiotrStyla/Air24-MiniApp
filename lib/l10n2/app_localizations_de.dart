// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get euCompensation => 'EU-Entschädigung';

  @override
  String get scheduledLabel => 'Geplant';

  @override
  String get minutes => 'Minuten';

  @override
  String get aircraftLabel => 'Flugzeug:';

  @override
  String get prefillCompensationForm => 'Entschädigungsformular vorausfüllen';

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
  String get previewEmail => 'E-Mail-Vorschau';

  @override
  String get confirmAndSendEmail => 'Bestätigen und E-Mail senden';

  @override
  String get attachmentsInfoNextStep =>
      'You can add attachments (e.g., tickets, boarding passes) in the next step.';

  @override
  String get departureAirport => 'Abflughafen';

  @override
  String get arrivalAirport => 'Ankunftsflughafen';

  @override
  String get reasonForClaim => 'Grund für den Anspruch';

  @override
  String get flightCancellationReason =>
      'Flugannullierung - Antrag auf Entschädigung gemäß EU-Verordnung 261 für annullierten Flug';

  @override
  String get flightDelayReason =>
      'Flugverspätung über 3 Stunden - Antrag auf Entschädigung gemäß EU-Verordnung 261 für erhebliche Verspätung';

  @override
  String get flightDiversionReason =>
      'Flugumleitung - Antrag auf Entschädigung gemäß EU-Verordnung 261 für umgeleiteten Flug';

  @override
  String get eu261CompensationReason =>
      'Antrag auf Entschädigung gemäß EU-Verordnung 261 für Flugstörung';

  @override
  String get attachments => 'Anlagen';

  @override
  String get proceedToConfirmation => 'Weiter zur Bestätigung';

  @override
  String emailAppOpenedMessage(String email) {
    return 'E-Mail-App geöffnet';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'Fehler beim Einreichen des Anspruchs';
  }

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get retry => 'Wiederholen';

  @override
  String get claimNotFound => 'Anspruch nicht gefunden';

  @override
  String get claimNotFoundDesc =>
      'Der angeforderte Anspruch konnte nicht gefunden werden. Er wurde möglicherweise gelöscht.';

  @override
  String get backToDashboard => 'Zurück zum Dashboard';

  @override
  String get reviewYourClaim => 'Prüfen Sie Ihren Anspruch';

  @override
  String get reviewClaimDetails => 'Prüfen Sie die Anspruchsdetails';

  @override
  String get flightNumber => 'Flugnummer';

  @override
  String get flightDate => 'Flugdatum';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Keine Flüge entsprechen dem Filter: $filter';
  }

  @override
  String get statusLabel => 'Status:';

  @override
  String get flightStatusDelayed => 'Verspätet';

  @override
  String get potentialCompensation => 'Mögliche Entschädigung:';

  @override
  String get claimDetails => 'Anspruchsdetails';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get errorLoadingClaim => 'Fehler beim Laden des Anspruchs';

  @override
  String get euWideCompensationEligibleFlights =>
      'EU-Entschädigungsberechtigte Flüge';

  @override
  String get forceRefreshData => 'Datenaktualisierung erzwingen';

  @override
  String get forcingFreshDataLoad =>
      'Erzwinge eine neue Datenaktualisierung...';

  @override
  String get loadingExternalData => 'Externe Daten werden geladen';

  @override
  String get loadingExternalDataDescription =>
      'Bitte warten, während wir die neuesten Flugdaten abrufen...';

  @override
  String lastHours(int hours) {
    return 'Letzte $hours Stunden';
  }

  @override
  String get errorConnectionFailed =>
      'Verbindung fehlgeschlagen. Bitte überprüfen Sie Ihr Netzwerk.';

  @override
  String formSubmissionError(String error) {
    return 'Fehler beim Senden des Formulars: $error. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';
  }

  @override
  String get compensationEmailSuccess =>
      'Compensation email sent successfully!';

  @override
  String get compensationEmailFailed => 'Failed to send compensation email';

  @override
  String errorSendingEmail(String error) {
    return 'Error sending email: $error';
  }

  @override
  String get apiConnectionIssue =>
      'API-Verbindungsproblem. Bitte versuchen Sie es erneut.';

  @override
  String get noEligibleFlightsFound => 'Keine berechtigten Flüge gefunden';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Keine Flüge in den letzten $hours Stunden gefunden.';
  }

  @override
  String get checkAgain => 'Erneut prüfen';

  @override
  String get filterByAirline => 'Nach Fluggesellschaft filtern';

  @override
  String get saveDocument => 'Dokument speichern';

  @override
  String get fieldName => 'Feldname';

  @override
  String get fieldValue => 'Feldwert';

  @override
  String get noFieldsExtracted =>
      'Es wurden keine Felder aus dem Dokument extrahiert.';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get generalError => 'Allgemeiner Fehler';

  @override
  String get loginRequiredForClaim =>
      'Anmeldung erforderlich, um einen Anspruch einzureichen';

  @override
  String get aspectRatio => 'Seitenverhältnis';

  @override
  String get documentOcrResult => 'OCR-Ergebnis';

  @override
  String get extractedFields => 'Extrahierte Felder';

  @override
  String get fullText => 'Volltext';

  @override
  String get extractedInformation => 'Extrahierte Informationen';

  @override
  String get rawOcrText => 'Roher OCR-Text';

  @override
  String get copyAllText => 'Gesamten Text kopieren';

  @override
  String get fillForm => 'Formular ausfüllen';

  @override
  String get chooseUseInfo =>
      'Wählen Sie, wie Sie diese Informationen verwenden möchten:';

  @override
  String get fillPassengerFlight =>
      'Passagier- und Fluginformationen ausfüllen';

  @override
  String get flightSearch => 'Flugsuche';

  @override
  String get searchFlightNumber => 'Mit Flugnummer suchen';

  @override
  String get done => 'Fertig';

  @override
  String get documentSaved => 'Dokument gespeichert.';

  @override
  String get useExtractedData => 'Extrahierte Daten verwenden';

  @override
  String get copyToClipboard => 'In die Zwischenablage kopiert.';

  @override
  String get documentType => 'Dokumententyp';

  @override
  String get submitClaim => 'Anspruch einreichen';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get resend => 'Resend';

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
  String get rotate => 'Drehen';

  @override
  String get airline => 'Fluggesellschaft';

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
  String get languageSelection => 'Sprache';

  @override
  String get passengerName => 'Name des Passagiers';

  @override
  String get passengerDetails => 'Passagierdetails';

  @override
  String get appTitle => 'Flugentschädigung';

  @override
  String get welcomeMessage => 'Willkommen in der App!';

  @override
  String get home => 'Startseite';

  @override
  String get settings => 'Einstellungen';

  @override
  String get required => 'Erforderlich';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get documentDeleteFailed => 'Dokument konnte nicht gelöscht werden';

  @override
  String get uploadNew => 'Neu hochladen';

  @override
  String get continueAction => 'Weiter';

  @override
  String get compensationClaimForm => 'Entschädigungsantragsformular';

  @override
  String get flight => 'Flug';

  @override
  String get passengerInformation => 'Passagierinformationen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get downloadPdf => 'PDF herunterladen';

  @override
  String get filePreviewNotAvailable => 'Datevorschau nicht verfügbar';

  @override
  String get noFileSelected => 'Keine Datei ausgewählt';

  @override
  String get preview => 'Vorschau';

  @override
  String get downloadStarting => 'Download wird gestartet...';

  @override
  String get fileTypeLabel => 'Dateityp:';

  @override
  String get failedToLoadImage => 'Bild konnte nicht geladen werden';

  @override
  String get deleteDocument => 'Dokument löschen';

  @override
  String get deleteDocumentConfirmation =>
      'Sind Sie sicher, dass Sie dieses Dokument löschen möchten?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get documentDeletedSuccess => 'Dokument erfolgreich gelöscht';

  @override
  String get attachDocuments => 'Dokumente anhängen';

  @override
  String get uploadingDocument => 'Dokument wird hochgeladen...';

  @override
  String get noDocuments => 'Sie haben keine Dokumente.';

  @override
  String get uploadFirstDocument => 'Erstes Dokument hochladen';

  @override
  String get claimAttachment => 'Forderungsanhang';

  @override
  String get other => 'andere';

  @override
  String get pdfPreviewMessage => 'PDF-Vorschau';

  @override
  String get tipsAndRemindersTitle => 'Tipps & Erinnerungen';

  @override
  String get tipSecureData =>
      'Wir schützen Ihre Daten mit Bankstandard-Verschlüsselung';

  @override
  String get tipCheckEligibility =>
      '• Stellen Sie sicher, dass Ihr Flug anspruchsberechtigt ist (z. B. Verspätung >3h, Annullierung, Nichtbeförderung).';

  @override
  String get tipDoubleCheckDetails =>
      '• Überprüfen Sie alle Details vor dem Einreichen, um Verzögerungen zu vermeiden.';

  @override
  String get documentUploadSuccess => 'Dokument erfolgreich hochgeladen!';

  @override
  String get uploadFailed =>
      'Hochladen fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get reasonForClaimHint => 'z.B. Verspätung, Annullierung';

  @override
  String get validatorReasonRequired => 'Grund ist erforderlich';

  @override
  String get tooltipReasonQuickClaim =>
      'Beschreiben Sie kurz, warum Sie einen Anspruch einreichen';

  @override
  String get compensationAmountOptionalLabel =>
      'Entschädigungsbetrag (optional)';

  @override
  String get compensationAmountHint => 'z.B. 250€';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Geben Sie den Betrag ein, wenn Sie wissen, wofür Sie berechtigt sind';

  @override
  String get continueToReview => 'Weiter zur Überprüfung';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Geben Sie den 3-stelligen IATA-Code für den Abflughafen ein';

  @override
  String get arrivalAirportHintQuickClaim => 'z.B. LHR';

  @override
  String get validatorArrivalAirportRequired =>
      'Ankunftsflughafen ist erforderlich';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Ankunftsflughafen für Quick Claim';

  @override
  String get reasonForClaimLabel => 'Grund für den Anspruch';

  @override
  String get hintTextReasonQuickClaim => 'z.B. Verspätung über 3 Stunden';

  @override
  String get flightNumberHintQuickClaim => 'z.B. LH123';

  @override
  String get validatorFlightNumberRequired => 'Flugnummer ist erforderlich';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Geben Sie die Flugnummer ein, z.B. LH123';

  @override
  String get tooltipFlightDateQuickClaim => 'Wählen Sie das Datum Ihres Fluges';

  @override
  String get departureAirportHintQuickClaim => 'z.B. FRA';

  @override
  String get validatorDepartureAirportRequired =>
      'Abflughafen ist erforderlich';

  @override
  String get underAppeal => 'Im Einspruchsverfahren';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get errorMustBeLoggedIn =>
      'Sie müssen angemeldet sein, um diese Aktion durchzuführen';

  @override
  String get dialogTitleError => 'Fehler';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get quickClaimTitle => 'Schnellanspruch';

  @override
  String get tooltipFaqHelp =>
      'Greifen Sie auf die häufig gestellten Fragen und den Hilfebereich zu';

  @override
  String get quickClaimInfoBanner =>
      'Für EU-berechtigte Flüge. Füllen Sie grundlegende Informationen für eine schnelle Vorabprüfung aus.';

  @override
  String get createClaim => 'Anspruch erstellen';

  @override
  String get submitted => 'Eingereicht';

  @override
  String get inReview => 'In Überprüfung';

  @override
  String get actionRequired => 'Handlung erforderlich';

  @override
  String get processing => 'In Bearbeitung';

  @override
  String get approved => 'Genehmigt';

  @override
  String get rejected => 'Abgelehnt';

  @override
  String get paid => 'Ausbezahlt';

  @override
  String get emailStatusNotSent => 'Not sent';

  @override
  String get emailStatusSending => 'Sending';

  @override
  String get emailStatusSent => 'Sent';

  @override
  String get emailStatusFailed => 'Failed';

  @override
  String get emailStatusBounced => 'Bounced';

  @override
  String flightRouteDetails(String departure, String arrival) {
    return 'Flug $flightNumber: $departure - $arrival';
  }

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
  String get noClaimsYet => 'Noch keine Ansprüche';

  @override
  String get startCompensationClaimInstructions =>
      'Starten Sie Ihren Entschädigungsantrag, indem Sie einen Flug aus dem Bereich \'EU-berechtigte Flüge\' auswählen';

  @override
  String get claimsDashboard => 'Anspruchsdashboard';

  @override
  String get refreshDashboard => 'Dashboard aktualisieren';

  @override
  String get claimsSummary => 'Anspruchsübersicht';

  @override
  String get totalClaims => 'Gesamte Ansprüche';

  @override
  String get totalCompensation => 'Gesamtentschädigung';

  @override
  String get pendingAmount => 'Ausstehender Betrag';

  @override
  String get receivedAmount => 'Received';

  @override
  String get noClaimsYetTitle => 'Noch keine Ansprüche';

  @override
  String get noRecentEvents => 'No recent events';

  @override
  String get pending => 'Ausstehend';

  @override
  String get viewClaimDetails => 'Anspruchsdetails anzeigen';

  @override
  String claimForFlight(String flightNumber, String status) {
    return 'Anspruch für Flug $flightNumber - $status';
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
      'Konfigurieren Sie, wie Sie Anspruchsaktualisierungen erhalten';

  @override
  String get notificationSettingsComingSoon =>
      'Benachrichtigungseinstellungen kommen bald!';

  @override
  String get changeApplicationLanguage => 'Anwendungssprache ändern';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get tipsAndReminders => 'Tipps & Erinnerungen';

  @override
  String get tipProfileUpToDate => 'Halten Sie Ihr Profil aktuell';

  @override
  String get tipInformationPrivate => 'Ihre Informationen sind privat';

  @override
  String get tipContactDetails => 'Kontaktdetails';

  @override
  String get legalPrivacySectionTitle => 'Legal & Privacy';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc => 'How we handle your data';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDesc => 'Rules for using the service';

  @override
  String get cookiePolicy => 'Cookie Policy';

  @override
  String get cookiePolicyDesc => 'Cookie usage and categories';

  @override
  String get legalNoticeImprint => 'Legal Notice / Imprint';

  @override
  String get legalNoticeImprintDesc => 'Operator and contact details';

  @override
  String get accessibilityStatement => 'Accessibility Statement';

  @override
  String get accessibilityStatementDesc => 'Our accessibility commitments';

  @override
  String get manageCookiePreferences => 'Manage cookie preferences';

  @override
  String get manageCookiePreferencesDesc =>
      'Change analytics and marketing cookie settings';

  @override
  String get cookiePreferencesTitle => 'Cookie Preferences';

  @override
  String get cookiePreferencesIntro =>
      'We use cookies to improve your experience. Necessary cookies are always on.';

  @override
  String get analyticsLabel => 'Analytics';

  @override
  String get analyticsDesc => 'Helps us understand usage. Optional.';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String get marketingDesc => 'Personalized content/ads. Optional.';

  @override
  String get savePreferences => 'Save preferences';

  @override
  String get tipAccessibilitySettings => 'Barrierefreiheitseinstellungen';

  @override
  String get active => 'Aktiv';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get events => 'Events';

  @override
  String get genericUser => 'Benutzer';

  @override
  String get signOut => 'Abmelden';

  @override
  String errorSigningOut(String error) {
    return 'Fehler beim Abmelden: $error';
  }

  @override
  String get profileInformation => 'Profilinformationen';

  @override
  String get profileInfoCardTitle =>
      'Ihr Profil enthält Ihre persönlichen Daten und Kontaktinformationen. Diese werden verwendet, um Ihre Entschädigungsansprüche für Flüge zu bearbeiten und Sie über den Fortschritt auf dem Laufenden zu halten.';

  @override
  String get profileInfoBannerSemanticLabel =>
      'Informationen über die Verwendung Ihrer Profildaten';

  @override
  String get accountSettings => 'Kontoeinstellungen';

  @override
  String get editPersonalInfo => 'Persönliche Informationen bearbeiten';

  @override
  String get editPersonalInfoDescription =>
      'Aktualisieren Sie Ihre persönlichen Daten, Adresse und Kontaktinformationen';

  @override
  String get accessibilitySettings => 'Barrierefreiheitseinstellungen';

  @override
  String get configureAccessibility =>
      'Barrierefreiheitsoptionen konfigurieren';

  @override
  String get accessibilityOptions => 'Barrierefreiheitsoptionen';

  @override
  String get configureAccessibilityDescription =>
      'Konfigurieren Sie hohen Kontrast, großen Text und Screenreader-Unterstützung';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get configureNotifications => 'Benachrichtigungen konfigurieren';

  @override
  String get eu261Rights => 'EU261 Rights';

  @override
  String get dontLetAirlinesWin => 'Don\'t Let Airlines Win';

  @override
  String get submitClaimAnyway => 'Submit Claim Anyway';

  @override
  String get newClaim => 'Neuer Anspruch';

  @override
  String get notLoggedIn => 'Not Logged In';

  @override
  String get signIn => 'Sign In';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordTitle => 'Reset your password';

  @override
  String get signInSubtitle =>
      'Sign in to access your flight compensation claims';

  @override
  String get signUpSubtitle =>
      'Sign up to track your flight compensation claims';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email to receive a password reset link';

  @override
  String get emailHintExample => 'your.email@example.com';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordPlaceholder => '********';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get alreadyHaveAccountSignInCta => 'Already have an account? Sign In';

  @override
  String get dontHaveAccountSignUpCta => 'Don\'t have an account? Sign Up';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get passwordResetEmailSentMessage =>
      'Password reset email sent! Check your inbox.';

  @override
  String get authInvalidEmail => 'Please enter a valid email address';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authEmailRequired => 'Please enter your email';

  @override
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get authUnexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get authGoogleSignInFailed =>
      'Google sign-in failed. Please try again.';

  @override
  String get authPasswordResetFailed =>
      'Password reset failed. Please try again.';

  @override
  String get authSignOutFailed => 'Sign out failed. Please try again.';

  @override
  String get checkFlightEligibilityButtonText => 'Flugentschädigung prüfen';

  @override
  String get euEligibleFlightsButtonText =>
      'EU-weit entschädigungsberechtigte Flüge';

  @override
  String welcomeUser(String name, String role, Object userName) {
    return 'Willkommen, $userName';
  }

  @override
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get contactAirlineForClaim =>
      'Kontaktieren Sie die Fluggesellschaft, um Ihre Entschädigung gemäß EU-Verordnung 261/2004 zu beantragen.';

  @override
  String get flightMightNotBeEligible => 'Flight Might Not Be Eligible';

  @override
  String get knowYourRights => 'Know Your Rights';

  @override
  String get airlineDataDisclaimer => 'Airline Data Disclaimer';

  @override
  String get error => 'Fehler';

  @override
  String get status => 'Status';

  @override
  String get from => 'Von';

  @override
  String get to => 'Nach';

  @override
  String get delay => 'Verspätung';

  @override
  String get flightEligibleForCompensation =>
      'Ihr Flug hat Anspruch auf Entschädigung!';

  @override
  String flightInfoFormat(String flightCode, String flightDate) {
    return 'Flug $flightNumber - $airline';
  }

  @override
  String minutesFormat(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get flightCompensationCheckerTitle => 'Flugentschädigungs-Prüfer';

  @override
  String get checkEligibilityForEu261 =>
      'Prüfen Sie, ob Ihr Flug für eine EU261-Entschädigung in Frage kommt';

  @override
  String get flightNumberPlaceholder => 'Flugnummer (z.B. LH123)';

  @override
  String get pleaseEnterFlightNumber => 'Bitte geben Sie eine Flugnummer ein';

  @override
  String get dateOptionalPlaceholder => 'Datum (JJJJ-MM-TT, optional)';

  @override
  String get leaveDateEmptyForToday => 'Leer lassen für heute';

  @override
  String get checkCompensationEligibility =>
      'Entschädigungsberechtigung prüfen';

  @override
  String get continueToAttachmentsButton => 'Weiter zu den Anhängen';

  @override
  String get flightNotFoundError =>
      'Flug nicht gefunden. Bitte überprüfen Sie Ihre Flugnummer und versuchen Sie es erneut.';

  @override
  String get invalidFlightNumberError =>
      'Ungültiges Flugnummernformat. Bitte geben Sie eine gültige Flugnummer ein (z.B. BA123, LH456).';

  @override
  String get networkTimeoutError =>
      'Verbindungszeitüberschreitung. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get serverError =>
      'Server vorübergehend nicht verfügbar. Bitte versuchen Sie es später erneut.';

  @override
  String get rateLimitError =>
      'Zu viele Anfragen. Bitte warten Sie einen Moment und versuchen Sie es erneut.';

  @override
  String get generalFlightCheckError =>
      'Fluginformationen können nicht überprüft werden. Bitte überprüfen Sie Ihre Flugdaten und versuchen Sie es erneut.';

  @override
  String get receiveNotifications => 'Benachrichtigungen erhalten';

  @override
  String get getClaimUpdates => 'Erhalten Sie Updates zu Ihren Ansprüchen';

  @override
  String get saveProfile => 'Profil speichern';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Adresse';

  @override
  String get city => 'Stadt';

  @override
  String get country => 'Land';

  @override
  String get postalCode => 'Postleitzahl';

  @override
  String get pleaseSelectFlightDate => 'Bitte wählen Sie ein Flugdatum';

  @override
  String get submitNewClaim => 'Neuen Anspruch einreichen';

  @override
  String get pleaseEnterArrivalAirport =>
      'Bitte geben Sie einen Ankunftsflughafen ein';

  @override
  String get pleaseEnterReason => 'Bitte geben Sie einen Grund ein';

  @override
  String get flightDateHint => 'Flugdatum (JJJJ-MM-TT)';

  @override
  String get number => 'Number';

  @override
  String welcomeUser3(String name, String role, String company) {
    return 'Welcome, $name ($role at $company)';
  }

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get passportNumber => 'Passnummer';

  @override
  String get nationality => 'Nationalität';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get dateFormat => 'TT/MM/JJJJ';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get consentToShareData => 'Einwilligung zur Datenweitergabe';

  @override
  String get requiredForProcessing =>
      'Erforderlich für die Bearbeitung Ihrer Ansprüche';

  @override
  String get claims => 'Ansprüche';

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
  String get emailReadyToSend => 'Your Compensation Email is Ready!';

  @override
  String get emailCopyInstructions =>
      'Kopieren Sie die E-Mail-Details unten und fügen Sie sie in Ihre E-Mail-App ein';

  @override
  String get cc => 'CC';

  @override
  String get subject => 'Betreff';

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
  String get supportOurMission => 'Unterstützen Sie unsere Mission';

  @override
  String get helpKeepAppFree =>
      'Helfen Sie uns, diese App kostenlos zu halten und Hospizpflege zu unterstützen';

  @override
  String get yourContributionMakesDifference =>
      'Ihr Beitrag macht einen Unterschied';

  @override
  String get hospiceFoundation => 'Hospice Foundation';

  @override
  String get appDevelopment => 'App Development';

  @override
  String get comfortCareForPatients => 'Comfort and care for patients';

  @override
  String get newFeaturesAndImprovements => 'Neue Funktionen und Verbesserungen';

  @override
  String get chooseYourSupportAmount => 'Choose your support amount:';

  @override
  String get totalDonation => 'Total Donation';

  @override
  String get donationSummary => 'Donation Summary';

  @override
  String get choosePaymentMethod => 'Zahlungsmethode wählen:';

  @override
  String get paymentMethod => 'Zahlungsmethode';

  @override
  String get creditDebitCard => 'Kredit-/Debitkarte';

  @override
  String get visaMastercardAmericanExpress =>
      'Visa, Mastercard, American Express';

  @override
  String get payWithPayPalAccount => 'Mit Ihrem PayPal-Konto bezahlen';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get notAvailableOnThisDevice => 'Not available on this device';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get quickAndSecure => 'Schnell und sicher';

  @override
  String get smallSupport => 'Kleine Unterstützung';

  @override
  String get goodSupport => 'Gute Unterstützung';

  @override
  String get greatSupport => 'Große Unterstützung';

  @override
  String yourAmountHelps(String amount) {
    return 'Ihre $amount helfen:';
  }

  @override
  String get hospicePatientCare => 'Hospiz-Patientenpflege';

  @override
  String get appImprovements => 'App-Verbesserungen';

  @override
  String continueWithAmount(String amount) {
    return 'Weiter mit $amount';
  }

  @override
  String get selectAnAmount => 'Select an amount';

  @override
  String get maybeLater => 'Vielleicht später';

  @override
  String get securePaymentInfo =>
      'Secure payment • No hidden fees • Tax receipt';

  @override
  String get learnMoreHospiceFoundation =>
      'Mehr über die Hospiz-Stiftung erfahren: fundacja-hospicjum.org';

  @override
  String get touchIdOrFaceId => 'Touch ID oder Face ID';

  @override
  String get continueToPayment => 'Zur Zahlung fortfahren';

  @override
  String get selectAPaymentMethod => 'Wählen Sie eine Zahlungsmethode';

  @override
  String get securePayment => 'Sichere Zahlung';

  @override
  String get paymentSecurityInfo =>
      'Ihre Zahlungsinformationen sind verschlüsselt und sicher. Wir speichern keine Zahlungsdetails.';

  @override
  String get taxReceiptEmail =>
      'Die Steuerquittung wird an Ihre E-Mail gesendet';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, American Express';

  @override
  String get notAvailableOnDevice => 'Auf diesem Gerät nicht verfügbar';

  @override
  String get comfortAndCareForPatients => 'Komfort und Pflege für Patienten';

  @override
  String get chooseSupportAmount => 'Wählen Sie Ihren Unterstützungsbetrag:';

  @override
  String get emailReadyTitle =>
      'Ihre Entschädigungs-E-Mail ist zum Senden bereit!';

  @override
  String get emailWillBeSentSecurely =>
      'Ihre E-Mail wird sicher über unseren Backend-Dienst gesendet';

  @override
  String get toLabel => 'To:';

  @override
  String get ccLabel => 'CC:';

  @override
  String get subjectLabel => 'Subject:';

  @override
  String get emailBodyLabel => 'Email Body:';

  @override
  String get secureTransmissionNotice =>
      'Ihre E-Mail wird sicher mit verschlüsselter Übertragung gesendet';

  @override
  String get sendingEllipsis => 'Sending...';

  @override
  String get sendEmailSecurely => 'E-Mail sicher senden';

  @override
  String get openingEmailApp => 'Opening email app...';

  @override
  String get tipReturnBackGesture =>
      'Tip: to return, use your device Back gesture (not the Gmail arrow).';

  @override
  String get returnToAppTitle => 'Return to Flight Compensation';

  @override
  String get returnToAppBody => 'Tap to come back and finish your claim.';

  @override
  String get errorFailedToSendEmail => 'Failed to send email';

  @override
  String get unexpectedErrorSendingEmail =>
      'Unexpected error occurred while sending email';

  @override
  String get emailSentSuccessfully => 'Email sent successfully!';

  @override
  String get predictingDelay => 'Verspätung wird prognostiziert…';

  @override
  String get predictionUnavailable => 'Vorhersage nicht verfügbar';

  @override
  String delayRiskPercent(int risk) {
    return 'Verspätungsrisiko $risk%';
  }

  @override
  String avgMinutesShort(int minutes) {
    return 'Ø $minutes Min';
  }

  @override
  String get attachmentGuidanceTitle => 'Anhänge';

  @override
  String get emailPreviewAttachmentGuidance =>
      'Sie können im nächsten Schritt Anhänge hinzufügen. Bitte denken Sie daran, nur Dateien im JPG-, PNG- oder PDF-Format beizufügen.';

  @override
  String get emailClipboardFallbackPrimary =>
      'Keine E-Mail-App verfügbar. Der E-Mail-Inhalt wurde in Ihre Zwischenablage kopiert. Fügen Sie ihn in einen beliebigen E-Mail-Dienst ein.';

  @override
  String get emailClipboardFallbackAdvisory =>
      'Nach dem Einfügen können Sie den Text prüfen und korrigieren sowie Dokumente wie Tickets oder Bordkarten (JPG, PNG, PDF) anhängen.';
}
