// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get euCompensation => 'TODO: Translate \'EU Compensation\'';

  @override
  String get scheduledLabel => 'TODO: Translate \'Scheduled:\'';

  @override
  String get minutes => 'TODO: Translate \'minutes\'';

  @override
  String get aircraftLabel => 'TODO: Translate \'Aircraft:\'';

  @override
  String get prefillCompensationForm =>
      'TODO: Translate \'Pre-fill Compensation Form\'';

  @override
  String get confirmAndSend => 'TODO: Translate \'Confirm and Send\'';

  @override
  String get errorLoadingEmailDetails =>
      'TODO: Translate \'Error loading email details\'';

  @override
  String get noEmailInfo =>
      'TODO: Translate \'No email information available\'';

  @override
  String get finalConfirmation => 'TODO: Translate \'Final Confirmation\'';

  @override
  String get claimWillBeSentTo =>
      'TODO: Translate \'Your claim will be sent to:\'';

  @override
  String get copyToYourEmail =>
      'TODO: Translate \'A copy will be sent to your email:\'';

  @override
  String get previewEmail => 'TODO: Translate \'Preview Email\'';

  @override
  String get confirmAndSendEmail =>
      'TODO: Translate \'Confirm and Send Email\'';

  @override
  String get departureAirport => 'Aéroport de Départ';

  @override
  String get arrivalAirport => 'Aéroport d\'Arrivée';

  @override
  String get reasonForClaim => 'TODO: Translate \'Reason for Claim\'';

  @override
  String get attachments => 'TODO: Translate \'Attachments\'';

  @override
  String get proceedToConfirmation =>
      'TODO: Translate \'Proceed to Confirmation\'';

  @override
  String emailAppOpenedMessage(String email) {
    return 'TODO: Translate \'Your email app has been opened\'';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'TODO: Translate \'Failed to submit claim. Please try again.\'';
  }

  @override
  String get unknownError => 'TODO: Translate \'Unknown error\'';

  @override
  String get retry => 'TODO: Translate \'Retry\'';

  @override
  String get claimNotFound => 'Réclamation introuvable';

  @override
  String get claimNotFoundDesc =>
      'La réclamation demandée est introuvable. Elle a peut-être été supprimée.';

  @override
  String get backToDashboard => 'Retour au tableau de bord';

  @override
  String get reviewYourClaim => 'TODO: Translate \'Review Your Claim\'';

  @override
  String get reviewClaimDetails => 'TODO: Translate \'Review Claim Details\'';

  @override
  String get flightNumber => 'Numéro de Vol';

  @override
  String get flightDate => 'Date du Vol';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'TODO: Translate \'No flights matching filter: $filter\'';
  }

  @override
  String get statusLabel => 'Statut :';

  @override
  String get flightStatusDelayed => 'Retardé';

  @override
  String get potentialCompensation =>
      'TODO: Translate \'Potential Compensation\'';

  @override
  String get claimDetails => 'TODO: Translate \'Claim Details\'';

  @override
  String get refresh => 'TODO: Translate \'Refresh\'';

  @override
  String get errorLoadingClaim => 'TODO: Translate \'Error Loading Claim\'';

  @override
  String get euWideCompensationEligibleFlights =>
      'Vols éligibles à la compensation européenne';

  @override
  String get forceRefreshData => 'TODO: Translate \'Force Refresh Data\'';

  @override
  String get forcingFreshDataLoad =>
      'TODO: Translate \'Forcing fresh data load...\'';

  @override
  String get loadingExternalData => 'TODO: Translate \'Loading External Data\'';

  @override
  String get loadingExternalDataDescription =>
      'TODO: Translate \'Please wait while we fetch the latest flight data...\'';

  @override
  String lastHours(int hours) {
    return 'TODO: Translate \'Last $hours Hours\'';
  }

  @override
  String get errorConnectionFailed =>
      'Échec de la connexion. Veuillez vérifier votre réseau.';

  @override
  String formSubmissionError(String error) {
    return 'Erreur lors de la soumission du formulaire : $error. Veuillez vérifier votre connexion et réessayer.';
  }

  @override
  String get apiConnectionIssue => 'TODO: Translate \'API Connection Issue\'';

  @override
  String get noEligibleFlightsFound =>
      'TODO: Translate \'No Eligible Flights Found\'';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'TODO: Translate \'No flights eligible for EU compensation were found in the last $hours hours. Check again later.\'';
  }

  @override
  String get checkAgain => 'Vérifier à nouveau';

  @override
  String get filterByAirline => 'Filtrer par compagnie aérienne';

  @override
  String get saveDocument => 'Sauvegarder le Document';

  @override
  String get fieldName => 'Nom du Champ';

  @override
  String get fieldValue => 'Valeur du Champ';

  @override
  String get noFieldsExtracted => 'Aucun champ n\'a été extrait du document.';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get networkError => 'TODO: Translate \'Network Error\'';

  @override
  String get generalError => 'TODO: Translate \'General Error\'';

  @override
  String get loginRequiredForClaim =>
      'TODO: Translate \'Login Required for Claim\'';

  @override
  String get aspectRatio => 'Ratio d\'Aspect';

  @override
  String get documentOcrResult => 'Résultat OCR';

  @override
  String get extractedFields => 'Champs Extraits';

  @override
  String get fullText => 'Texte Complet';

  @override
  String get documentSaved => 'Document sauvegardé.';

  @override
  String get useExtractedData => 'Utiliser les Données Extraites';

  @override
  String get copyToClipboard => 'Copié dans le presse-papiers.';

  @override
  String get documentType => 'Type de Document';

  @override
  String get submitClaim => 'Soumettre la Réclamation';

  @override
  String get addDocument => 'Ajouter un Document';

  @override
  String get claimSubmittedSuccessfully => 'Réclamation soumise avec succès !';

  @override
  String get completeAllFields => 'Veuillez remplir tous les champs.';

  @override
  String get supportingDocuments => 'Documents Justificatifs';

  @override
  String get cropDocument => 'Rogner le Document';

  @override
  String get crop => 'Rogner';

  @override
  String get rotate => 'Pivoter';

  @override
  String get airline => 'Compagnie Aérienne';

  @override
  String get email => 'Email';

  @override
  String get bookingReference => 'Référence de Réservation';

  @override
  String get additionalInformation => 'Informations Additionnelles';

  @override
  String get optional => '(Optionnel)';

  @override
  String get thisFieldIsRequired => 'Ce champ est requis.';

  @override
  String get pleaseEnterDepartureAirport =>
      'Veuillez saisir un aéroport de départ.';

  @override
  String get uploadDocuments => 'Télécharger des Documents';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Retour';

  @override
  String get save => 'Sauvegarder';

  @override
  String get languageSelection => 'Langue';

  @override
  String get passengerName => 'Nom du Passager';

  @override
  String get passengerDetails => 'Détails du Passager';

  @override
  String get appTitle => 'Indemnisation de vol';

  @override
  String get welcomeMessage => 'Bienvenue dans l\'application !';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get required => 'Requis';

  @override
  String get emailAddress => 'TODO: Translate \'Email Address\'';

  @override
  String get documentDeleteFailed =>
      'TODO: Translate \'Failed to delete document\'';

  @override
  String get uploadNew => 'TODO: Translate \'Upload New\'';

  @override
  String get continueAction => 'TODO: Translate \'Continue\'';

  @override
  String get compensationClaimForm => 'Formulaire de Demande d\'Indemnisation';

  @override
  String get flight => 'Vol';

  @override
  String get passengerInformation =>
      'TODO: Translate \'Passenger Information\'';

  @override
  String get fullName => 'TODO: Translate \'Full Name\'';

  @override
  String get downloadPdf => 'TODO: Translate \'Download PDF\'';

  @override
  String get filePreviewNotAvailable =>
      'TODO: Translate \'File preview not available\'';

  @override
  String get deleteDocument => 'TODO: Translate \'Delete Document\'';

  @override
  String get deleteDocumentConfirmation =>
      'TODO: Translate \'Are you sure you want to delete this document?\'';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'TODO: Translate \'Delete\'';

  @override
  String get documentDeletedSuccess =>
      'TODO: Translate \'Document deleted successfully\'';

  @override
  String get attachDocuments => 'TODO: Translate \'Attach Documents\'';

  @override
  String get uploadingDocument => 'TODO: Translate \'Uploading document...\'';

  @override
  String get noDocuments => 'TODO: Translate \'No documents uploaded yet\'';

  @override
  String get uploadFirstDocument => 'TODO: Translate \'Upload First Document\'';

  @override
  String get claimAttachment => 'TODO: Translate \'Claim Attachment\'';

  @override
  String get other => 'autre';

  @override
  String get pdfPreviewMessage => 'TODO: Translate \'PDF Preview\'';

  @override
  String get tipsAndRemindersTitle => 'TODO: Translate \'Tips & Reminders\'';

  @override
  String get tipSecureData =>
      'TODO: Translate \'Your data is secure and encrypted\'';

  @override
  String get tipCheckEligibility =>
      '• Assurez-vous que votre vol est éligible à une indemnisation (par ex. retard >3h, annulation, refus d\'embarquement).';

  @override
  String get tipDoubleCheckDetails =>
      '• Vérifiez tous les détails avant de soumettre pour éviter les retards.';

  @override
  String get documentUploadSuccess =>
      'TODO: Translate \'Document uploaded successfully\'';

  @override
  String get uploadFailed =>
      'TODO: Translate \'Upload failed. Please try again.\'';

  @override
  String get reasonForClaimHint =>
      'TODO: Translate \'Describe why you are making this claim\'';

  @override
  String get validatorReasonRequired =>
      'TODO: Translate \'Reason for claim is required\'';

  @override
  String get tooltipReasonQuickClaim =>
      'TODO: Translate \'Explain why you believe you are entitled to compensation\'';

  @override
  String get compensationAmountOptionalLabel =>
      'TODO: Translate \'Requested Compensation Amount (Optional)\'';

  @override
  String get compensationAmountHint =>
      'TODO: Translate \'Enter amount if you have a specific request\'';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'TODO: Translate \'You can specify a compensation amount or leave it blank\'';

  @override
  String get continueToReview => 'TODO: Translate \'Continue to Review\'';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'TODO: Translate \'Enter the airport you departed from\'';

  @override
  String get arrivalAirportHintQuickClaim =>
      'TODO: Translate \'Enter airport code or name (e.g. LHR, London Heathrow)\'';

  @override
  String get validatorArrivalAirportRequired =>
      'TODO: Translate \'Arrival airport is required\'';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'TODO: Translate \'Enter the airport you arrived at\'';

  @override
  String get reasonForClaimLabel => 'TODO: Translate \'Reason for Claim\'';

  @override
  String get hintTextReasonQuickClaim =>
      'TODO: Translate \'Describe your claim reason here\'';

  @override
  String get flightNumberHintQuickClaim =>
      'TODO: Translate \'Enter flight number (e.g. LH123)\'';

  @override
  String get validatorFlightNumberRequired =>
      'TODO: Translate \'Flight number is required\'';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'TODO: Translate \'Enter the flight number for your claim\'';

  @override
  String get tooltipFlightDateQuickClaim =>
      'TODO: Translate \'Select the date of your flight\'';

  @override
  String get departureAirportHintQuickClaim =>
      'TODO: Translate \'Enter airport code or name (e.g. LHR, London Heathrow)\'';

  @override
  String get validatorDepartureAirportRequired =>
      'TODO: Translate \'Departure airport is required\'';

  @override
  String get underAppeal => 'TODO: Translate \'Under Appeal\'';

  @override
  String get unknown => 'TODO: Translate \'Unknown Status\'';

  @override
  String get errorMustBeLoggedIn =>
      'TODO: Translate \'You must be logged in to submit a claim\'';

  @override
  String get dialogTitleError => 'TODO: Translate \'Error\'';

  @override
  String get dialogButtonOK => 'TODO: Translate \'OK\'';

  @override
  String get quickClaimTitle => 'TODO: Translate \'Quick Claim Form\'';

  @override
  String get tooltipFaqHelp =>
      'Accéder à la foire aux questions et à la section d\'aide';

  @override
  String get quickClaimInfoBanner =>
      'TODO: Translate \'Fill out this form to submit a quick compensation claim for your flight. We\'ll help you through the process.\'';

  @override
  String get createClaim => 'TODO: Translate \'Create New Claim\'';

  @override
  String get submitted => 'TODO: Translate \'Submitted\'';

  @override
  String get inReview => 'TODO: Translate \'In Review\'';

  @override
  String get actionRequired => 'Action Requise';

  @override
  String get processing => 'TODO: Translate \'Processing\'';

  @override
  String get approved => 'TODO: Translate \'Approved\'';

  @override
  String get rejected => 'TODO: Translate \'Rejected\'';

  @override
  String get paid => 'TODO: Translate \'Paid\'';

  @override
  String flightRouteDetails(String departure, String arrival) {
    return 'TODO: Translate \'$departure to $arrival\'';
  }

  @override
  String get authenticationRequired =>
      'TODO: Translate \'Authentication Required\'';

  @override
  String get errorLoadingClaims => 'TODO: Translate \'Error loading claims\'';

  @override
  String get loginToViewClaimsDashboard =>
      'TODO: Translate \'Please log in to view your claims dashboard\'';

  @override
  String get logIn => 'TODO: Translate \'Log In\'';

  @override
  String get noClaimsYet => 'Aucune réclamation pour le moment';

  @override
  String get startCompensationClaimInstructions =>
      'Commencez votre demande d\'indemnisation en sélectionnant un vol dans la section Vols Éligibles de l\'UE';

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
  String get noClaimsYetTitle => 'Aucune Réclamation Pour le Moment';

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
      'Configurer la manière dont vous recevez les mises à jour des réclamations';

  @override
  String get notificationSettingsComingSoon =>
      'Notification settings coming soon!';

  @override
  String get changeApplicationLanguage => 'Changer la langue de l\'application';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get tipsAndReminders => 'Conseils & Rappels';

  @override
  String get tipProfileUpToDate =>
      'Gardez votre profil à jour pour un traitement fluide des réclamations.';

  @override
  String get tipInformationPrivate =>
      'Vos informations sont privées et utilisées uniquement pour les demandes d\'indemnisation.';

  @override
  String get tipContactDetails =>
      'Assurez-vous que vos coordonnées sont correctes afin que nous puissions vous contacter au sujet de votre réclamation.';

  @override
  String get tipAccessibilitySettings =>
      'Consultez les paramètres d\'accessibilité pour personnaliser l\'application selon vos besoins.';

  @override
  String get active => 'Active';

  @override
  String get completed => 'Terminée';

  @override
  String get genericUser => 'Generic User';

  @override
  String get signOut => 'Déconnexion';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get profileInformation => 'Informations du Profil';

  @override
  String get profileInfoCardTitle =>
      'Votre profil contient vos informations personnelles et de contact. Celles-ci sont utilisées pour traiter vos demandes d\'indemnisation de vol et vous tenir informé.';

  @override
  String get accountSettings => 'Paramètres du Compte';

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
  String get accessibilityOptions => 'Options d\'Accessibilité';

  @override
  String get configureAccessibilityDescription =>
      'Configurer le contraste élevé, le grand texte et le support du lecteur d\'écran';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get configureNotifications => 'Configure Notifications';

  @override
  String get eu261Rights =>
      'Sous le règlement EU261, vous avez droit à une compensation pour :\n• Retards de 3+ heures\n• Annulations de vol\n• Refus d\'embarquement\n• Détournements de vol';

  @override
  String get dontLetAirlinesWin =>
      'Ne laissez pas les compagnies aériennes éviter de payer ce que vous méritez !';

  @override
  String get submitClaimAnyway => 'Soumettre une Réclamation Quand Même';

  @override
  String get newClaim => 'Nouvelle Réclamation';

  @override
  String get notLoggedIn => 'Not Logged In';

  @override
  String get signIn => 'Sign In';

  @override
  String get checkFlightEligibilityButtonText =>
      'Vérifier l\'éligibilité à l\'indemnisation';

  @override
  String get euEligibleFlightsButtonText =>
      'Vols éligibles à l\'indemnisation dans l\'UE';

  @override
  String welcomeUser(String name, String role, Object userName) {
    return 'Bienvenue, $userName';
  }

  @override
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get contactAirlineForClaim => 'Contact Airline for Claim';

  @override
  String get flightMightNotBeEligible =>
      'Selon les données disponibles, votre vol pourrait ne pas être éligible à une compensation.';

  @override
  String get knowYourRights => 'Connaissez Vos Droits';

  @override
  String get airlineDataDisclaimer =>
      'Les compagnies aériennes sous-estiment parfois les retards ou modifient les statuts de vol. Si vous avez subi un retard de 3+ heures, une annulation ou un détournement, vous pourriez encore avoir droit à une compensation.';

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
  String get flightCompensationCheckerTitle =>
      'Vérificateur d\'indemnisation de vol';

  @override
  String get checkEligibilityForEu261 =>
      'Vérifier l\'éligibilité pour la compensation EU 261';

  @override
  String get flightNumberPlaceholder => 'Numéro de vol (ex. LO123)';

  @override
  String get pleaseEnterFlightNumber => 'Veuillez entrer un numéro de vol';

  @override
  String get dateOptionalPlaceholder => 'Date du vol (optionnel)';

  @override
  String get leaveDateEmptyForToday =>
      'Laisser vide pour la date d\'aujourd\'hui';

  @override
  String get checkCompensationEligibility =>
      'Vérifier l\'Éligibilité à l\'Indemnisation';

  @override
  String get continueToAttachmentsButton => 'Continuer vers les pièces jointes';

  @override
  String get flightNotFoundError =>
      'Vol non trouvé. Veuillez vérifier votre numéro de vol et réessayer.';

  @override
  String get invalidFlightNumberError =>
      'Format de numéro de vol invalide. Veuillez saisir un numéro de vol valide (ex. BA123, LH456).';

  @override
  String get networkTimeoutError =>
      'Délai de connexion dépassé. Veuillez vérifier votre connexion Internet et réessayer.';

  @override
  String get serverError =>
      'Serveur temporairement indisponible. Veuillez réessayer plus tard.';

  @override
  String get rateLimitError =>
      'Trop de requêtes. Veuillez patienter un moment et réessayer.';

  @override
  String get generalFlightCheckError =>
      'Impossible de vérifier les informations de vol. Veuillez vérifier les détails de votre vol et réessayer.';

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
  String get phoneNumber => 'Numéro de Téléphone';

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
  String get claims => 'Réclamations';

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
}
