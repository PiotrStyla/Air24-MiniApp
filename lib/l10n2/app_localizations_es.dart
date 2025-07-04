// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Compensación de Vuelo';

  @override
  String welcomeUser(String userName) {
    return 'Bienvenido, $userName';
  }

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get newClaim => 'Nueva Reclamación';

  @override
  String get home => 'Inicio';

  @override
  String get settings => 'Configuración';

  @override
  String get languageSelection => 'Idioma';

  @override
  String get passengerName => 'Nombre del Pasajero';

  @override
  String get passengerDetails => 'Detalles del Pasajero';

  @override
  String get flightNumber => 'Número de Vuelo';

  @override
  String get airline => 'Aerolínea';

  @override
  String get departureAirport => 'Aeropuerto de Salida';

  @override
  String get arrivalAirport => 'Aeropuerto de Llegada';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get bookingReference => 'Referencia de Reserva';

  @override
  String get additionalInformation => 'Información Adicional';

  @override
  String get optional => '(Opcional)';

  @override
  String get thisFieldIsRequired => 'Este campo es obligatorio.';

  @override
  String get pleaseEnterDepartureAirport =>
      'Por favor, ingrese un aeropuerto de salida.';

  @override
  String get uploadDocuments => 'Subir Documentos';

  @override
  String get submitClaim => 'Enviar Reclamación';

  @override
  String get addDocument => 'Añadir Documento';

  @override
  String get claimSubmittedSuccessfully => '¡Reclamación enviada con éxito!';

  @override
  String get completeAllFields => 'Por favor, complete todos los campos.';

  @override
  String get supportingDocuments => 'Documentos de Soporte';

  @override
  String get cropDocument => 'Recortar Documento';

  @override
  String get crop => 'Recortar';

  @override
  String get cropping => 'Recortando...';

  @override
  String get rotate => 'Girar';

  @override
  String get aspectRatio => 'Relación de Aspecto';

  @override
  String get aspectRatioFree => 'Libre';

  @override
  String get aspectRatioSquare => 'Cuadrado';

  @override
  String get aspectRatioPortrait => 'Retrato';

  @override
  String get aspectRatioLandscape => 'Paisaje';

  @override
  String aspectRatioMode(String ratio) {
    return 'Relación de aspecto: $ratio';
  }

  @override
  String get documentOcrResult => 'Resultado OCR';

  @override
  String get extractedFields => 'Campos Extraídos';

  @override
  String get fullText => 'Texto Completo';

  @override
  String get documentSaved => 'Documento guardado.';

  @override
  String get useExtractedData => 'Usar Datos Extraídos';

  @override
  String get copyToClipboard => 'Copiado al portapapeles.';

  @override
  String get documentType => 'Tipo de Documento';

  @override
  String get saveDocument => 'Guardar Documento';

  @override
  String get fieldName => 'Nombre del Campo';

  @override
  String get done => 'Hecho';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'Aceptar';

  @override
  String get back => 'Atrás';

  @override
  String get save => 'Guardar';

  @override
  String get welcomeMessage => '¡Bienvenido a la aplicación!';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get fillForm => 'Rellenar Formulario';

  @override
  String get chooseUseInfo => 'Elija cómo usar esta información:';

  @override
  String get fillPassengerFlight => 'Rellenar información de pasajero y vuelo';

  @override
  String get ocrResults => 'Resultados OCR';

  @override
  String get noFieldsExtracted => 'No se extrajeron campos del documento.';

  @override
  String get extractedInformation => 'Información Extraída';

  @override
  String get rawOcrText => 'Texto OCR sin procesar';

  @override
  String get copyAllText => 'Copiar Todo el Texto';

  @override
  String get claims => 'Reclamaciones';

  @override
  String get noClaimsYet => 'Aún no hay reclamaciones';

  @override
  String get startCompensationClaimInstructions =>
      'Inicie su reclamación de compensación seleccionando un vuelo en la sección Vuelos elegibles para la UE';

  @override
  String get active => 'Activa';

  @override
  String get actionRequired => 'Acción Requerida';

  @override
  String get completed => 'Completada';

  @override
  String get profileInfoCardTitle =>
      'Su perfil contiene su información personal y de contacto. Esto se utiliza para procesar sus reclamaciones de compensación de vuelo y mantenerlo informado.';

  @override
  String get accountSettings => 'Configuración de la Cuenta';

  @override
  String get accessibilityOptions => 'Opciones de Accesibilidad';

  @override
  String get configureAccessibilityDescription =>
      'Configurar alto contraste, texto grande y soporte para lector de pantalla';

  @override
  String get configureNotificationsDescription =>
      'Configurar cómo recibe las actualizaciones de las reclamaciones';

  @override
  String get tipProfileUpToDate => 'Mantenga su perfil actualizado';

  @override
  String get tipInformationPrivate => 'Su información es privada';

  @override
  String get tipContactDetails => 'Datos de Contacto';

  @override
  String get tipAccessibilitySettings => 'Configuración de Accesibilidad';

  @override
  String get cancel => 'Cancelar';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String arrivalsAt(String airport) {
    return 'Llegadas a $airport';
  }

  @override
  String get filterByAirline => 'Filtrar por aerolínea';

  @override
  String get flightStatusDelayed => 'Retrasado';

  @override
  String get flightStatusCancelled => 'Cancelado';

  @override
  String get flightStatusDiverted => 'Desviado';

  @override
  String get flightStatusOnTime => 'A tiempo';

  @override
  String get flight => 'Vuelo';

  @override
  String get flights => 'Vuelos';

  @override
  String get myFlights => 'Mis Vuelos';

  @override
  String get findFlight => 'Buscar Vuelo';

  @override
  String get flightDate => 'Fecha del Vuelo';

  @override
  String get checkCompensationEligibility =>
      'Verificar Elegibilidad de Compensación';

  @override
  String get supportingDocumentsHint =>
      'Adjunte tarjetas de embarque, billetes y otros documentos para respaldar su reclamación.';

  @override
  String get scanDocument => 'Escanear Documento';

  @override
  String get uploadDocument => 'Subir Documento';

  @override
  String get scanDocumentHint =>
      'Usar la cámara para rellenar automáticamente el formulario';

  @override
  String get uploadDocumentHint =>
      'Seleccionar desde el almacenamiento del dispositivo';

  @override
  String get noDocumentsYet => 'Aún no hay documentos adjuntos';

  @override
  String get enterFlightNumberFirst =>
      'Por favor, ingrese primero un número de vuelo';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get documentScanner => 'Escáner de Documentos';

  @override
  String get profileInformation => 'Información del Perfil';

  @override
  String get editPersonalInformation => 'Editar su información personal';

  @override
  String get editPersonalAndContactInformation =>
      'Editar su información personal y de contacto';

  @override
  String get configureAccessibilityOptions =>
      'Configurar las opciones de accesibilidad de la aplicación';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport =>
      'Configurar alto contraste, texto grande y soporte para lector de pantalla';

  @override
  String get applicationPreferences => 'Preferencias de la Aplicación';

  @override
  String get notificationSettings => 'Configuración de Notificaciones';

  @override
  String get configureNotificationPreferences =>
      'Configurar preferencias de notificación';

  @override
  String get configureHowYouReceiveClaimUpdates =>
      'Configurar cómo recibe las actualizaciones de las reclamaciones';

  @override
  String get language => 'Idioma';

  @override
  String get changeApplicationLanguage => 'Cambiar el idioma de la aplicación';

  @override
  String get selectYourPreferredLanguage => 'Seleccione su idioma preferido';

  @override
  String get tipsAndReminders => 'Consejos y Recordatorios';

  @override
  String get importantTipsAboutProfileInformation =>
      'Consejos importantes sobre la información de su perfil';

  @override
  String get noClaimsYetTitle => 'Aún No Hay Reclamaciones';

  @override
  String get noClaimsYetSubtitle =>
      'Comience su reclamación de compensación seleccionando un vuelo de la sección Vuelos Elegibles de la UE';

  @override
  String get extractingText => 'Extrayendo texto e identificando campos';

  @override
  String get scanInstructions =>
      'Coloque su documento dentro del marco y tome una foto';

  @override
  String get formFilledWithScannedData =>
      'Formulario rellenado con datos del documento escaneado';

  @override
  String get flightDetails => 'Detalles del Vuelo';

  @override
  String get phoneNumber => 'Número de Teléfono';

  @override
  String get required => 'Obligatorio';

  @override
  String get submit => 'Enviar';

  @override
  String get submissionChecklist => 'Lista de Verificación de Envío';

  @override
  String get documentAttached => 'Documento Adjunto';

  @override
  String get compensationClaimForm =>
      'Formulario de Reclamación de Compensación';

  @override
  String get prefilledFromProfile => 'Prellenado desde su perfil';

  @override
  String get flightSearch => 'Búsqueda de Vuelos';

  @override
  String get searchFlightNumber => 'Buscar por número de vuelo';

  @override
  String get delayedFlightDetected => 'Vuelo Retrasado Detectado';

  @override
  String get flightDetected => 'Vuelo Detectado';

  @override
  String get flightLabel => 'Vuelo:';

  @override
  String get fromAirport => 'Desde:';

  @override
  String get toAirport => 'A:';

  @override
  String get statusLabel => 'Estado:';

  @override
  String get delayedEligible => 'Retrasado y potencialmente elegible';

  @override
  String get startClaim => 'Iniciar Reclamación';

  @override
  String get claimNotFound => 'Reclamación no encontrada';

  @override
  String get claimNotFoundDesc =>
      'La reclamación solicitada no se pudo encontrar. Puede que haya sido eliminada.';

  @override
  String get backToDashboard => 'Volver al panel';

  @override
  String get euWideEligibleFlights =>
      'Vuelos elegibles para compensación en toda la UE';

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
  String get retry => 'Reintentar';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get requiredFieldsCompleted =>
      'Todos los campos obligatorios están completos.';

  @override
  String get scanningDocumentsNote =>
      'Escanear documentos puede prellenar algunos campos.';

  @override
  String get tipCheckEligibility =>
      '• Asegúrese de que su vuelo sea elegible para compensación (p. ej., retraso >3h, cancelación, denegación de embarque).';

  @override
  String get tipDoubleCheckDetails =>
      '• Verifique todos los detalles antes de enviar para evitar demoras.';

  @override
  String get tooltipFaqHelp =>
      'Acceder a las preguntas frecuentes y la sección de ayuda';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Error al enviar el formulario: $errorMessage. Verifique su conexión e inténtelo de nuevo.';
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
  String get last72HoursButton => 'Últimas 72 horas';

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
  String get processingDocument => 'Procesando documento...';

  @override
  String get fieldValue => 'Valor del Campo';

  @override
  String get errorConnectionFailed =>
      'Falló la conexión. Por favor, revise su red.';

  @override
  String lastHours(int hours) {
    return 'Últimas $hours horas';
  }

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'No hay vuelos que coincidan con el filtro: $filter';
  }

  @override
  String get forceRefreshData => 'Forzar actualización de datos';

  @override
  String get forcingFreshDataLoad => 'Forzando una nueva carga de datos...';

  @override
  String get checkAgain => 'Volver a comprobar';

  @override
  String get euWideCompensationEligibleFlights =>
      'Vuelos elegibles para compensación en la UE';

  @override
  String get noEligibleFlightsFound => 'No se encontraron vuelos elegibles';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'No se encontraron vuelos en las últimas $hours horas.';
  }

  @override
  String get apiConnectionIssue =>
      'Problema de conexión con la API. Por favor, inténtelo de nuevo.';

  @override
  String get createClaim => 'Crear reclamación';

  @override
  String get submitted => 'Enviado';

  @override
  String get inReview => 'En revisión';

  @override
  String get processing => 'Procesando';

  @override
  String get approved => 'Aprobado';

  @override
  String get rejected => 'Rechazado';

  @override
  String get paid => 'Pagado';

  @override
  String get underAppeal => 'En apelación';

  @override
  String get unknown => 'Desconocido';

  @override
  String get authenticationRequired => 'Autenticación Requerida';

  @override
  String get errorLoadingClaims => 'Error al cargar las reclamaciones';

  @override
  String get loginToViewClaimsDashboard =>
      'Por favor, inicie sesión para ver su panel de reclamaciones';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String claimForFlight(Object number, Object status) {
    return 'Reclamación para el vuelo $number - $status';
  }

  @override
  String flightRouteDetails(Object number, Object departure, Object arrival) {
    return 'Vuelo $number: $departure - $arrival';
  }

  @override
  String get viewClaimDetails => 'Ver detalles de la reclamación';

  @override
  String get totalCompensation => 'Compensación Total';

  @override
  String get pendingAmount => 'Monto Pendiente';

  @override
  String get pending => 'Pendiente';

  @override
  String get claimsDashboard => 'Panel de Reclamaciones';

  @override
  String get refreshDashboard => 'Actualizar Panel';

  @override
  String get claimsSummary => 'Resumen de Reclamaciones';

  @override
  String get totalClaims => 'Total de Reclamaciones';

  @override
  String get accessibilitySettings => 'Configuración de Accesibilidad';

  @override
  String get configureAccessibility => 'Configurar opciones de accesibilidad';

  @override
  String get configureNotifications => 'Configurar notificaciones';

  @override
  String get notificationSettingsComingSoon =>
      '¡Configuración de notificaciones próximamente!';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get editPersonalInfo => 'Editar Información Personal';

  @override
  String get editPersonalInfoDescription =>
      'Actualice sus datos personales, dirección e información de contacto';

  @override
  String errorSigningOut(String error) {
    return 'Error al cerrar sesión: $error';
  }

  @override
  String get signInOrSignUp => 'Iniciar Sesión / Registrarse';

  @override
  String get genericUser => 'Usuario';

  @override
  String get dismiss => 'Cerrar';

  @override
  String get signInToTrackClaims =>
      'Inicie sesión para seguir sus reclamaciones';

  @override
  String get createAccountDescription =>
      'Cree una cuenta para seguir fácilmente todas sus reclamaciones de compensación';

  @override
  String get continueToAttachmentsButton => 'Continuar a los archivos adjuntos';

  @override
  String get continueToReview => 'Continue to Review';

  @override
  String get country => 'País';

  @override
  String get privacySettings => 'Configuración de Privacidad';

  @override
  String get consentToShareData => 'Consentimiento para Compartir Datos';

  @override
  String get requiredForProcessing =>
      'Requerido para procesar sus reclamaciones';

  @override
  String get receiveNotifications => 'Recibir Notificaciones';

  @override
  String get getClaimUpdates =>
      'Reciba actualizaciones sobre sus reclamaciones';

  @override
  String get saveProfile => 'Guardar Perfil';

  @override
  String get passportNumber => 'Número de Pasaporte';

  @override
  String get nationality => 'Nacionalidad';

  @override
  String get dateOfBirth => 'Fecha de Nacimiento';

  @override
  String get dateFormat => 'DD/MM/AAAA';

  @override
  String get address => 'Dirección';

  @override
  String get city => 'Ciudad';

  @override
  String get postalCode => 'Código Postal';

  @override
  String get errorLoadingProfile => 'Error al cargar el perfil';

  @override
  String get profileSaved => 'Perfil guardado con éxito';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get profileAccuracyInfo =>
      'Por favor, asegúrese de que la información de su perfil sea precisa';

  @override
  String get keepProfileUpToDate => 'Mantenga su perfil actualizado';

  @override
  String get profilePrivacy => 'Protegemos su privacidad y datos';

  @override
  String get correctContactDetails =>
      'Los datos de contacto correctos ayudan con la compensación';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get attachDocuments => 'Adjuntar Documentos';

  @override
  String get uploadingDocument => 'Subiendo documento...';

  @override
  String get noDocuments => 'No tienes documentos.';

  @override
  String get uploadFirstDocument => 'Subir Primer Documento';

  @override
  String get uploadNew => 'Subir Nuevo';

  @override
  String get documentUploadSuccess => '¡Documento subido exitosamente!';

  @override
  String get uploadFailed => 'Error al subir. Por favor, intenta de nuevo.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get claimAttachment => 'Adjunto de Reclamo';

  @override
  String get other => 'otro';

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
