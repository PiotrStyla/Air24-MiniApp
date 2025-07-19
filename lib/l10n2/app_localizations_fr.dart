// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Indemnisation de vol';

  @override
  String welcomeUser(String userName) {
    return 'Bienvenue, $userName';
  }

  @override
  String get signOut => 'Déconnexion';

  @override
  String get newClaim => 'Nouvelle Réclamation';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get languageSelection => 'Langue';

  @override
  String get passengerName => 'Nom du Passager';

  @override
  String get passengerDetails => 'Détails du Passager';

  @override
  String get flightNumber => 'Numéro de Vol';

  @override
  String get airline => 'Compagnie Aérienne';

  @override
  String get departureAirport => 'Aéroport de Départ';

  @override
  String get arrivalAirport => 'Aéroport d\'Arrivée';

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
  String get cropping => 'Rognage...';

  @override
  String get rotate => 'Pivoter';

  @override
  String get aspectRatio => 'Ratio d\'Aspect';

  @override
  String get aspectRatioFree => 'Libre';

  @override
  String get aspectRatioSquare => 'Carré';

  @override
  String get aspectRatioPortrait => 'Portrait';

  @override
  String get aspectRatioLandscape => 'Paysage';

  @override
  String aspectRatioMode(String ratio) {
    return 'Ratio d\'aspect : $ratio';
  }

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
  String get saveDocument => 'Sauvegarder le Document';

  @override
  String get fieldName => 'Nom du Champ';

  @override
  String get done => 'Terminé';

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
  String get welcomeMessage => 'Bienvenue dans l\'application !';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get fillForm => 'Remplir le Formulaire';

  @override
  String get chooseUseInfo => 'Choisissez comment utiliser ces informations :';

  @override
  String get fillPassengerFlight => 'Remplir les informations passager et vol';

  @override
  String get ocrResults => 'Résultats OCR';

  @override
  String get noFieldsExtracted => 'Aucun champ n\'a été extrait du document.';

  @override
  String get extractedInformation => 'Informations Extraites';

  @override
  String get rawOcrText => 'Texte OCR Brut';

  @override
  String get copyAllText => 'Copier tout le texte';

  @override
  String get claims => 'Réclamations';

  @override
  String get noClaimsYet => 'Aucune réclamation pour le moment';

  @override
  String get startCompensationClaimInstructions =>
      'Commencez votre demande d\'indemnisation en sélectionnant un vol dans la section Vols Éligibles de l\'UE';

  @override
  String get active => 'Active';

  @override
  String get actionRequired => 'Action Requise';

  @override
  String get completed => 'Terminée';

  @override
  String get profileInfoCardTitle =>
      'Votre profil contient vos informations personnelles et de contact. Celles-ci sont utilisées pour traiter vos demandes d\'indemnisation de vol et vous tenir informé.';

  @override
  String get accountSettings => 'Paramètres du Compte';

  @override
  String get accessibilityOptions => 'Options d\'Accessibilité';

  @override
  String get configureAccessibilityDescription =>
      'Configurer le contraste élevé, le grand texte et le support du lecteur d\'écran';

  @override
  String get configureNotificationsDescription =>
      'Configurer la manière dont vous recevez les mises à jour des réclamations';

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
  String get cancel => 'Annuler';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String arrivalsAt(String airport) {
    return 'Arrivées à $airport';
  }

  @override
  String get filterByAirline => 'Filtrer par compagnie aérienne';

  @override
  String get flightStatusDelayed => 'Retardé';

  @override
  String get flightStatusCancelled => 'Annulé';

  @override
  String get flightStatusDiverted => 'Détourné';

  @override
  String get flightStatusOnTime => 'À l\'heure';

  @override
  String get flight => 'Vol';

  @override
  String get flights => 'Vols';

  @override
  String get myFlights => 'Mes Vols';

  @override
  String get findFlight => 'Trouver un Vol';

  @override
  String get flightDate => 'Date du Vol';

  @override
  String get checkCompensationEligibility =>
      'Vérifier l\'Éligibilité à l\'Indemnisation';

  @override
  String get supportingDocumentsHint =>
      'Joignez les cartes d\'embarquement, les billets et d\'autres documents pour renforcer votre demande.';

  @override
  String get scanDocument => 'Scanner un Document';

  @override
  String get uploadDocument => 'Télécharger un Document';

  @override
  String get scanDocumentHint =>
      'Utiliser l\'appareil photo pour remplir automatiquement le formulaire';

  @override
  String get uploadDocumentHint =>
      'Sélectionner depuis le stockage de l\'appareil';

  @override
  String get noDocumentsYet => 'Aucun document joint pour le moment';

  @override
  String get enterFlightNumberFirst =>
      'Veuillez d\'abord saisir un numéro de vol';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get documentScanner => 'Scanner de Documents';

  @override
  String get profileInformation => 'Informations du Profil';

  @override
  String get editPersonalInformation =>
      'Modifier vos informations personnelles';

  @override
  String get editPersonalAndContactInformation =>
      'Modifier vos informations personnelles et de contact';

  @override
  String get configureAccessibilityOptions =>
      'Configurer les options d\'accessibilité de l\'application';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport =>
      'Configurer le contraste élevé, le grand texte et le support du lecteur d\'écran';

  @override
  String get applicationPreferences => 'Préférences de l\'Application';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get configureNotificationPreferences =>
      'Configurer les préférences de notification';

  @override
  String get configureHowYouReceiveClaimUpdates =>
      'Configurer la manière dont vous recevez les mises à jour des réclamations';

  @override
  String get language => 'Langue';

  @override
  String get changeApplicationLanguage => 'Changer la langue de l\'application';

  @override
  String get selectYourPreferredLanguage =>
      'Sélectionnez votre langue préférée';

  @override
  String get tipsAndReminders => 'Conseils & Rappels';

  @override
  String get importantTipsAboutProfileInformation =>
      'Conseils importants concernant vos informations de profil';

  @override
  String get noClaimsYetTitle => 'Aucune Réclamation Pour le Moment';

  @override
  String get noClaimsYetSubtitle =>
      'Commencez votre demande d\'indemnisation en sélectionnant un vol dans la section Vols Éligibles de l\'UE';

  @override
  String get extractingText =>
      'Extraction du texte et identification des champs';

  @override
  String get scanInstructions =>
      'Positionnez votre document dans le cadre et prenez une photo';

  @override
  String get formFilledWithScannedData =>
      'Formulaire rempli avec les données du document scanné';

  @override
  String get flightDetails => 'Détails du Vol';

  @override
  String get phoneNumber => 'Numéro de Téléphone';

  @override
  String get required => 'Requis';

  @override
  String get submit => 'Soumettre';

  @override
  String get submissionChecklist => 'Liste de Contrôle de Soumission';

  @override
  String get documentAttached => 'Document Joint';

  @override
  String get compensationClaimForm => 'Formulaire de Demande d\'Indemnisation';

  @override
  String get prefilledFromProfile => 'Pré-rempli depuis votre profil';

  @override
  String get flightSearch => 'Recherche de Vol';

  @override
  String get searchFlightNumber => 'Rechercher par numéro de vol';

  @override
  String get delayedFlightDetected => 'Vol Retardé Détecté';

  @override
  String get flightDetected => 'Vol Détecté';

  @override
  String get flightLabel => 'Vol :';

  @override
  String get fromAirport => 'De :';

  @override
  String get toAirport => 'À :';

  @override
  String get statusLabel => 'Statut :';

  @override
  String get delayedEligible => 'Retardé et potentiellement éligible';

  @override
  String get startClaim => 'Commencer la Réclamation';

  @override
  String get claimNotFound => 'Réclamation introuvable';

  @override
  String get claimNotFoundDesc =>
      'La réclamation demandée est introuvable. Elle a peut-être été supprimée.';

  @override
  String get backToDashboard => 'Retour au tableau de bord';

  @override
  String get euWideEligibleFlights =>
      'Vols Éligibles à l\'Indemnisation à l\'échelle de l\'UE';

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
  String get requiredFieldsCompleted => 'Tous les champs requis sont remplis.';

  @override
  String get scanningDocumentsNote =>
      'La numérisation de documents peut pré-remplir certains champs.';

  @override
  String get tipCheckEligibility =>
      '• Assurez-vous que votre vol est éligible à une indemnisation (par ex. retard >3h, annulation, refus d\'embarquement).';

  @override
  String get tipDoubleCheckDetails =>
      '• Vérifiez tous les détails avant de soumettre pour éviter les retards.';

  @override
  String get tooltipFaqHelp =>
      'Accéder à la foire aux questions et à la section d\'aide';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Erreur lors de la soumission du formulaire : $errorMessage. Veuillez vérifier votre connexion et réessayer.';
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
  String get last72HoursButton => 'Dernières 72 heures';

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
  String get processingDocument => 'Traitement du document...';

  @override
  String get fieldValue => 'Valeur du Champ';

  @override
  String get errorConnectionFailed =>
      'Échec de la connexion. Veuillez vérifier votre réseau.';

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
  String get checkAgain => 'Vérifier à nouveau';

  @override
  String get euWideCompensationEligibleFlights =>
      'Vols éligibles à la compensation européenne';

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
  String get other => 'autre';

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
  String get flightCompensationCheckerTitle => 'Flight Compensation Checker';

  @override
  String get checkEligibilityForEu261 =>
      'Check if your flight is eligible for EU261 compensation';

  @override
  String get flightNumberPlaceholder => 'Flight Number (e.g., BA123)';

  @override
  String get dateOptionalPlaceholder => 'Date (YYYY-MM-DD, optional)';

  @override
  String get leaveDateEmptyForToday => 'Leave empty for today';

  @override
  String get error => 'Error';

  @override
  String flightInfoFormat(String flightNumber, String airline) {
    return 'Flight $flightNumber - $airline';
  }

  @override
  String get status => 'Status';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get delay => 'Delay';

  @override
  String minutesFormat(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get flightEligibleForCompensation =>
      'Your flight is eligible for compensation!';

  @override
  String get flightNotEligibleForCompensation =>
      'Your flight is not eligible for compensation.';

  @override
  String get potentialCompensation => 'Potential Compensation:';

  @override
  String get contactAirlineForClaim =>
      'Contact the airline to claim your compensation under EU Regulation 261/2004.';

  @override
  String get reasonPrefix => 'Reason: ';

  @override
  String get delayLessThan3Hours => 'Flight delay is less than 3 hours';

  @override
  String get notUnderEuJurisdiction => 'Flight is not under EU jurisdiction';

  @override
  String get unknownReason => 'Unknown reason';

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
