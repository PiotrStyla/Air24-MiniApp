// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get euCompensation => 'Indemnisation UE';

  @override
  String get scheduledLabel => 'Prévu :';

  @override
  String get minutes => 'minutes';

  @override
  String get aircraftLabel => 'Aéronef:';

  @override
  String get prefillCompensationForm =>
      'Pré-remplir le formulaire d\'indemnisation';

  @override
  String get confirmAndSend => 'Confirmer et Envoyer';

  @override
  String get errorLoadingEmailDetails =>
      'Erreur lors du chargement des détails de l\'email';

  @override
  String get noEmailInfo => 'Aucune information d\'email disponible';

  @override
  String get finalConfirmation => 'Confirmation Finale';

  @override
  String get claimWillBeSentTo => 'Votre réclamation sera envoyée à :';

  @override
  String get copyToYourEmail => 'Une copie sera envoyée à votre email :';

  @override
  String get previewEmail => 'Aperçu de l\'Email';

  @override
  String get confirmAndSendEmail => 'Confirmer et Envoyer l\'Email';

  @override
  String get attachmentsInfoNextStep =>
      'You can add attachments (e.g., tickets, boarding passes) in the next step.';

  @override
  String get departureAirport => 'Aéroport de Départ';

  @override
  String get arrivalAirport => 'Aéroport d\'Arrivée';

  @override
  String get reasonForClaim => 'Motif de la Réclamation';

  @override
  String get flightCancellationReason =>
      'Annulation de vol - demande d\'indemnisation au titre du règlement EU261 pour vol annulé';

  @override
  String get flightDelayReason =>
      'Retard de vol supérieur à 3 heures - demande d\'indemnisation au titre du règlement EU261 pour retard important';

  @override
  String get flightDiversionReason =>
      'Déroutement de vol - demande d\'indemnisation au titre du règlement EU261 pour vol dérouté';

  @override
  String get eu261CompensationReason =>
      'Demande d\'indemnisation au titre du règlement EU261 pour perturbation de vol';

  @override
  String get attachments => 'Pièces Jointes';

  @override
  String get proceedToConfirmation => 'Procéder à la Confirmation';

  @override
  String emailAppOpenedMessage(String email) {
    return 'Votre application email a été ouverte';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'Échec de la soumission de la réclamation. Veuillez réessayer.';
  }

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get retry => 'Réessayer';

  @override
  String get claimNotFound => 'Réclamation introuvable';

  @override
  String get claimNotFoundDesc =>
      'La réclamation demandée est introuvable. Elle a peut-être été supprimée.';

  @override
  String get backToDashboard => 'Retour au tableau de bord';

  @override
  String get reviewYourClaim => 'Examiner Votre Réclamation';

  @override
  String get reviewClaimDetails => 'Examiner les Détails de la Réclamation';

  @override
  String get flightNumber => 'Numéro de Vol';

  @override
  String get flightDate => 'Date du Vol';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Aucun vol correspondant au filtre : $filter';
  }

  @override
  String get statusLabel => 'Statut :';

  @override
  String get flightStatusDelayed => 'Retardé';

  @override
  String get potentialCompensation => 'Indemnisation Potentielle';

  @override
  String get claimDetails => 'Détails de la Réclamation';

  @override
  String get refresh => 'Actualiser';

  @override
  String get errorLoadingClaim => 'Erreur lors du Chargement de la Réclamation';

  @override
  String get euWideCompensationEligibleFlights =>
      'Vols éligibles à la compensation européenne';

  @override
  String get forceRefreshData => 'Forcer l’actualisation des données';

  @override
  String get forcingFreshDataLoad => 'Forçage du chargement des données…';

  @override
  String get loadingExternalData => 'Chargement des données externes';

  @override
  String get loadingExternalDataDescription =>
      'Veuillez patienter pendant que nous récupérons les dernières données de vol…';

  @override
  String lastHours(int hours) {
    return 'Dernières $hours heures';
  }

  @override
  String get errorConnectionFailed =>
      'Échec de la connexion. Veuillez vérifier votre réseau.';

  @override
  String formSubmissionError(String error) {
    return 'Erreur lors de la soumission du formulaire : $error. Veuillez vérifier votre connexion et réessayer.';
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
  String get apiConnectionIssue => 'Problème de connexion à l’API';

  @override
  String get noEligibleFlightsFound => 'Aucun vol éligible trouvé';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Aucun vol éligible à la compensation UE n’a été trouvé au cours des dernières $hours heures. Réessayez plus tard.';
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
  String get networkError => 'Erreur réseau';

  @override
  String get generalError => 'Erreur générale';

  @override
  String get loginRequiredForClaim => 'Connexion requise pour la réclamation';

  @override
  String get aspectRatio => 'Ratio d\'Aspect';

  @override
  String get documentOcrResult => 'Résultat OCR';

  @override
  String get extractedFields => 'Champs Extraits';

  @override
  String get fullText => 'Texte Complet';

  @override
  String get extractedInformation => 'Informations Extraites';

  @override
  String get rawOcrText => 'Texte OCR Brut';

  @override
  String get copyAllText => 'Copier tout le texte';

  @override
  String get fillForm => 'Remplir le Formulaire';

  @override
  String get chooseUseInfo => 'Choisissez comment utiliser ces informations :';

  @override
  String get fillPassengerFlight => 'Remplir les informations passager et vol';

  @override
  String get flightSearch => 'Recherche de Vol';

  @override
  String get searchFlightNumber => 'Rechercher par numéro de vol';

  @override
  String get done => 'Terminé';

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
  String get sendEmail => 'Send Email';

  @override
  String get resend => 'Resend';

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
  String get emailAddress => 'Adresse e-mail';

  @override
  String get documentDeleteFailed => 'Échec de la suppression du document';

  @override
  String get uploadNew => 'Télécharger un nouveau document';

  @override
  String get continueAction => 'Continuer';

  @override
  String get compensationClaimForm => 'Formulaire de Demande d\'Indemnisation';

  @override
  String get flight => 'Vol';

  @override
  String get passengerInformation => 'Informations du passager';

  @override
  String get fullName => 'Nom complet';

  @override
  String get downloadPdf => 'Télécharger le PDF';

  @override
  String get filePreviewNotAvailable => 'Aperçu du fichier non disponible';

  @override
  String get noFileSelected => 'Aucun fichier sélectionné';

  @override
  String get preview => 'Aperçu';

  @override
  String get downloadStarting => 'Démarrage du téléchargement...';

  @override
  String get fileTypeLabel => 'Type de fichier :';

  @override
  String get failedToLoadImage => 'Échec du chargement de l\'image';

  @override
  String get deleteDocument => 'Supprimer le document';

  @override
  String get deleteDocumentConfirmation =>
      'Voulez-vous vraiment supprimer ce document ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get documentDeletedSuccess => 'Document supprimé avec succès';

  @override
  String get attachDocuments => 'Joindre des documents';

  @override
  String get uploadingDocument => 'Téléchargement du document...';

  @override
  String get noDocuments => 'Aucun document téléchargé pour le moment';

  @override
  String get uploadFirstDocument => 'Télécharger le premier document';

  @override
  String get claimAttachment => 'Pièce jointe à la réclamation';

  @override
  String get other => 'autre';

  @override
  String get pdfPreviewMessage => 'Aperçu du PDF';

  @override
  String get tipsAndRemindersTitle => 'Conseils et rappels';

  @override
  String get tipSecureData => 'Vos données sont sécurisées et chiffrées';

  @override
  String get tipCheckEligibility =>
      '• Assurez-vous que votre vol est éligible à une indemnisation (par ex. retard >3h, annulation, refus d\'embarquement).';

  @override
  String get tipDoubleCheckDetails =>
      '• Vérifiez tous les détails avant de soumettre pour éviter les retards.';

  @override
  String get documentUploadSuccess =>
      'Le document a été téléchargé avec succès';

  @override
  String get uploadFailed => 'Le téléchargement a échoué. Veuillez réessayer.';

  @override
  String get reasonForClaimHint => 'Décrivez la raison de votre réclamation';

  @override
  String get validatorReasonRequired =>
      'Le motif de la réclamation est obligatoire';

  @override
  String get tooltipReasonQuickClaim =>
      'Expliquez pourquoi vous pensez avoir droit à une indemnisation';

  @override
  String get compensationAmountOptionalLabel =>
      'Montant d\'indemnisation demandé (facultatif)';

  @override
  String get compensationAmountHint =>
      'Entrez le montant si vous avez une demande spécifique';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Vous pouvez spécifier un montant d\'indemnisation ou le laisser vide';

  @override
  String get continueToReview => 'Continuer à la révision';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Entrez l\'aéroport de départ';

  @override
  String get arrivalAirportHintQuickClaim =>
      'Entrez le code ou le nom de l\'aéroport d\'arrivée (par exemple LHR, Londres Heathrow)';

  @override
  String get validatorArrivalAirportRequired =>
      'L\'aéroport d\'arrivée est obligatoire';

  @override
  String get tooltipArrivalAirportQuickClaim => 'Entrez l\'aéroport d\'arrivée';

  @override
  String get reasonForClaimLabel => 'Motif de la réclamation';

  @override
  String get hintTextReasonQuickClaim =>
      'Décrivez ici le motif de votre réclamation';

  @override
  String get flightNumberHintQuickClaim =>
      'Entrez le numéro de vol (par exemple LH123)';

  @override
  String get validatorFlightNumberRequired =>
      'Le numéro de vol est obligatoire';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Saisissez le numéro de vol de votre réclamation';

  @override
  String get tooltipFlightDateQuickClaim => 'Sélectionnez la date de votre vol';

  @override
  String get departureAirportHintQuickClaim =>
      'Entrez le code ou le nom de l’aéroport (ex. LHR, London Heathrow)';

  @override
  String get validatorDepartureAirportRequired =>
      'L’aéroport de départ est requis';

  @override
  String get underAppeal => 'En appel';

  @override
  String get unknown => 'Inconnu';

  @override
  String get errorMustBeLoggedIn =>
      'Vous devez être connecté pour soumettre une réclamation';

  @override
  String get dialogTitleError => 'Erreur';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get quickClaimTitle => 'Réclamation rapide';

  @override
  String get tooltipFaqHelp =>
      'Accéder à la foire aux questions et à la section d\'aide';

  @override
  String get quickClaimInfoBanner =>
      'Remplissez ce formulaire pour soumettre rapidement une demande d’indemnisation pour votre vol. Nous vous guiderons tout au long du processus.';

  @override
  String get createClaim => 'Créer une nouvelle réclamation';

  @override
  String get submitted => 'Soumise';

  @override
  String get inReview => 'En cours d’examen';

  @override
  String get actionRequired => 'Action Requise';

  @override
  String get processing => 'Traitement en cours';

  @override
  String get approved => 'Approuvée';

  @override
  String get rejected => 'Rejetée';

  @override
  String get paid => 'Payée';

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
    return '$departure vers $arrival';
  }

  @override
  String get authenticationRequired => 'Authentification requise';

  @override
  String get errorLoadingClaims => 'Erreur lors du chargement des réclamations';

  @override
  String get loginToViewClaimsDashboard =>
      'Connectez-vous pour voir votre tableau de bord des réclamations';

  @override
  String get logIn => 'Se connecter';

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
  String get receivedAmount => 'Received';

  @override
  String get noClaimsYetTitle => 'Aucune Réclamation Pour le Moment';

  @override
  String get noRecentEvents => 'No recent events';

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
  String get events => 'Events';

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

  @override
  String get supportOurMission => 'Soutenez Notre Mission';

  @override
  String get helpKeepAppFree =>
      'Aidez-nous à garder cette application gratuite et à soutenir les soins palliatifs';

  @override
  String get yourContributionMakesDifference =>
      'Votre contribution fait la différence';

  @override
  String get hospiceFoundation => 'Hospice Foundation';

  @override
  String get appDevelopment => 'App Development';

  @override
  String get comfortCareForPatients => 'Comfort and care for patients';

  @override
  String get newFeaturesAndImprovements =>
      'Nouvelles fonctionnalités et améliorations';

  @override
  String get chooseYourSupportAmount => 'Choose your support amount:';

  @override
  String get totalDonation => 'Total Donation';

  @override
  String get donationSummary => 'Donation Summary';

  @override
  String get choosePaymentMethod => 'Choisissez une méthode de paiement:';

  @override
  String get paymentMethod => 'Méthode de Paiement';

  @override
  String get creditDebitCard => 'Carte de Crédit/Débit';

  @override
  String get visaMastercardAmericanExpress =>
      'Visa, Mastercard, American Express';

  @override
  String get payWithPayPalAccount => 'Payez avec votre compte PayPal';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get notAvailableOnThisDevice => 'Not available on this device';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get quickAndSecure => 'Rapide et sécurisé';

  @override
  String get smallSupport => 'Petit Soutien';

  @override
  String get goodSupport => 'Bon Soutien';

  @override
  String get greatSupport => 'Grand Soutien';

  @override
  String yourAmountHelps(String amount) {
    return 'Votre $amount aide:';
  }

  @override
  String get hospicePatientCare => 'Soins aux patients en hospice';

  @override
  String get appImprovements => 'Améliorations de l\'application';

  @override
  String continueWithAmount(String amount) {
    return 'Continuer avec $amount';
  }

  @override
  String get selectAnAmount => 'Select an amount';

  @override
  String get maybeLater => 'Peut-être plus tard';

  @override
  String get securePaymentInfo =>
      'Secure payment • No hidden fees • Tax receipt';

  @override
  String get learnMoreHospiceFoundation =>
      'En savoir plus sur la Fondation Hospice: fundacja-hospicjum.org';

  @override
  String get touchIdOrFaceId => 'Touch ID ou Face ID';

  @override
  String get continueToPayment => 'Continuer vers le Paiement';

  @override
  String get selectAPaymentMethod => 'Sélectionnez une méthode de paiement';

  @override
  String get securePayment => 'Paiement Sécurisé';

  @override
  String get paymentSecurityInfo =>
      'Vos informations de paiement sont chiffrées et sécurisées. Nous ne stockons pas les détails de votre paiement.';

  @override
  String get taxReceiptEmail => 'Le reçu fiscal sera envoyé à votre email';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, American Express';

  @override
  String get notAvailableOnDevice => 'Non disponible sur cet appareil';

  @override
  String get comfortAndCareForPatients => 'Confort et soins pour les patients';

  @override
  String get chooseSupportAmount => 'Choisissez votre montant de soutien:';

  @override
  String get emailReadyTitle => 'Your Compensation Email is Ready to Send!';

  @override
  String get emailWillBeSentSecurely =>
      'Your email will be sent securely through our backend service';

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
      'Your email will be sent securely using encrypted transmission';

  @override
  String get sendingEllipsis => 'Sending...';

  @override
  String get sendEmailSecurely => 'Send Email Securely';

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
  String get predictingDelay => 'Prédiction du retard…';

  @override
  String get predictionUnavailable => 'Prédiction indisponible';

  @override
  String delayRiskPercent(int risk) {
    return 'Risque de retard $risk%';
  }

  @override
  String avgMinutesShort(int minutes) {
    return 'Moy. $minutes min';
  }

  @override
  String get attachmentGuidanceTitle => 'Attachments';

  @override
  String get emailPreviewAttachmentGuidance =>
      'Vous pourrez ajouter des pièces jointes à l\'étape suivante. Veuillez n\'inclure que des fichiers aux formats JPG, PNG ou PDF.';
}
