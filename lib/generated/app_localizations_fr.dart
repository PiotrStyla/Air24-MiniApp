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
  String get pleaseEnterDepartureAirport => 'Veuillez saisir un aéroport de départ.';

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
  String get startCompensationClaimInstructions => 'Commencez votre demande d\'indemnisation en sélectionnant un vol dans la section Vols Éligibles de l\'UE';

  @override
  String get active => 'Active';

  @override
  String get actionRequired => 'Action Requise';

  @override
  String get completed => 'Terminée';

  @override
  String get profileInfoCardTitle => 'Votre profil contient vos informations personnelles et de contact. Celles-ci sont utilisées pour traiter vos demandes d\'indemnisation de vol et vous tenir informé.';

  @override
  String get accountSettings => 'Paramètres du Compte';

  @override
  String get accessibilityOptions => 'Options d\'Accessibilité';

  @override
  String get configureAccessibilityDescription => 'Configurer le contraste élevé, le grand texte et le support du lecteur d\'écran';

  @override
  String get configureNotificationsDescription => 'Configurer la manière dont vous recevez les mises à jour des réclamations';

  @override
  String get tipProfileUpToDate => 'Gardez votre profil à jour pour un traitement fluide des réclamations.';

  @override
  String get tipInformationPrivate => 'Vos informations sont privées et utilisées uniquement pour les demandes d\'indemnisation.';

  @override
  String get tipContactDetails => 'Assurez-vous que vos coordonnées sont correctes afin que nous puissions vous contacter au sujet de votre réclamation.';

  @override
  String get tipAccessibilitySettings => 'Consultez les paramètres d\'accessibilité pour personnaliser l\'application selon vos besoins.';

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
  String get checkCompensationEligibility => 'Vérifier l\'Éligibilité à l\'Indemnisation';

  @override
  String get supportingDocumentsHint => 'Joignez les cartes d\'embarquement, les billets et d\'autres documents pour renforcer votre demande.';

  @override
  String get scanDocument => 'Scanner un Document';

  @override
  String get uploadDocument => 'Télécharger un Document';

  @override
  String get scanDocumentHint => 'Utiliser l\'appareil photo pour remplir automatiquement le formulaire';

  @override
  String get uploadDocumentHint => 'Sélectionner depuis le stockage de l\'appareil';

  @override
  String get noDocumentsYet => 'Aucun document joint pour le moment';

  @override
  String get enterFlightNumberFirst => 'Veuillez d\'abord saisir un numéro de vol';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get documentScanner => 'Scanner de Documents';

  @override
  String get profileInformation => 'Informations du Profil';

  @override
  String get editPersonalInformation => 'Modifier vos informations personnelles';

  @override
  String get editPersonalAndContactInformation => 'Modifier vos informations personnelles et de contact';

  @override
  String get configureAccessibilityOptions => 'Configurer les options d\'accessibilité de l\'application';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport => 'Configurer le contraste élevé, le grand texte et le support du lecteur d\'écran';

  @override
  String get applicationPreferences => 'Préférences de l\'Application';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get configureNotificationPreferences => 'Configurer les préférences de notification';

  @override
  String get configureHowYouReceiveClaimUpdates => 'Configurer la manière dont vous recevez les mises à jour des réclamations';

  @override
  String get language => 'Langue';

  @override
  String get changeApplicationLanguage => 'Changer la langue de l\'application';

  @override
  String get selectYourPreferredLanguage => 'Sélectionnez votre langue préférée';

  @override
  String get tipsAndReminders => 'Conseils & Rappels';

  @override
  String get importantTipsAboutProfileInformation => 'Conseils importants concernant vos informations de profil';

  @override
  String get noClaimsYetTitle => 'Aucune Réclamation Pour le Moment';

  @override
  String get noClaimsYetSubtitle => 'Commencez votre demande d\'indemnisation en sélectionnant un vol dans la section Vols Éligibles de l\'UE';

  @override
  String get extractingText => 'Extraction du texte et identification des champs';

  @override
  String get scanInstructions => 'Positionnez votre document dans le cadre et prenez une photo';

  @override
  String get formFilledWithScannedData => 'Formulaire rempli avec les données du document scanné';

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
  String get euWideEligibleFlights => 'Vols Éligibles à l\'Indemnisation à l\'échelle de l\'UE';

  @override
  String get requiredFieldsCompleted => 'Tous les champs requis sont remplis.';

  @override
  String get scanningDocumentsNote => 'La numérisation de documents peut pré-remplir certains champs.';

  @override
  String get tipCheckEligibility => '• Assurez-vous que votre vol est éligible à une indemnisation (par ex. retard >3h, annulation, refus d\'embarquement).';

  @override
  String get tipDoubleCheckDetails => '• Vérifiez tous les détails avant de soumettre pour éviter les retards.';

  @override
  String get tooltipFaqHelp => 'Accéder à la foire aux questions et à la section d\'aide';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Erreur lors de la soumission du formulaire : $errorMessage. Veuillez vérifier votre connexion et réessayer.';
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
  String get reasonForClaimLabel => 'Reason for Claim';

  @override
  String get reasonForClaimHint => 'State why you are claiming: delay, cancellation, denied boarding, etc.';

  @override
  String get compensationAmountOptionalLabel => 'Compensation Amount (optional)';

  @override
  String get compensationAmountHint => 'If you know the amount you are eligible for, enter it here';

  @override
  String get euWideCompensationTitle => 'EU-wide Compensation';

  @override
  String get last144HoursButton => 'Last 144 hours';

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
  String get processingDocument => 'Traitement du document...';

  @override
  String get fieldValue => 'Valeur du Champ';

  @override
  String get errorConnectionFailed => 'Échec de la connexion. Veuillez vérifier votre réseau.';
}
