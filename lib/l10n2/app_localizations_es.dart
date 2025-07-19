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
  String get copiedToClipboard => 'Copiado al portapapeles';

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
  String get accessibilityOptions => 'Opciones de accesibilidad';

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
      'Verificar Elegibilidad para Compensación';

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
  String get submitNewClaim => 'Enviar nueva reclamación';

  @override
  String get reasonForClaim => 'Motivo de la reclamación';

  @override
  String get flightDateHint => 'Seleccionar fecha del vuelo';

  @override
  String get continueToAttachments => 'Continuar a archivos adjuntos';

  @override
  String get pleaseEnterFlightNumber => 'Por favor, ingrese un número de vuelo';

  @override
  String get pleaseEnterArrivalAirport =>
      'Por favor, introduce el aeropuerto de llegada';

  @override
  String get pleaseEnterReason =>
      'Por favor, introduce un motivo para la reclamación';

  @override
  String get pleaseSelectFlightDate =>
      'Por favor, selecciona la fecha del vuelo';

  @override
  String get claimDetails => 'Detalles de la reclamación';

  @override
  String get refresh => 'Actualizar';

  @override
  String get errorLoadingClaim => 'Error al cargar la reclamación';

  @override
  String get retry => 'Reintentar';

  @override
  String get unknownError => 'Error desconocido';

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
  String get networkError => 'Error de red';

  @override
  String get generalError => 'Error general';

  @override
  String get loginRequiredForClaim =>
      'Se requiere inicio de sesión para presentar una reclamación';

  @override
  String get quickClaimTitle => 'Reclamación rápida';

  @override
  String get quickClaimInfoBanner =>
      'Complete los detalles de su vuelo para verificar la elegibilidad para compensación';

  @override
  String get flightNumberHintQuickClaim => 'Número de vuelo (ej. LH123)';

  @override
  String get departureAirportHintQuickClaim => 'Aeropuerto de salida (ej. MAD)';

  @override
  String get arrivalAirportHintQuickClaim => 'Aeropuerto de llegada (ej. BCN)';

  @override
  String get reasonForClaimLabel => 'Motivo de la reclamación';

  @override
  String get reasonForClaimHint => 'Ej. retraso, cancelación';

  @override
  String get compensationAmountOptionalLabel =>
      'Cantidad de compensación (opcional)';

  @override
  String get compensationAmountHint => 'Ej. 250€';

  @override
  String get euWideCompensationTitle => 'Compensaciones a nivel de la UE';

  @override
  String get last72HoursButton => 'Últimas 72 horas';

  @override
  String get scheduledLabel => 'Programado';

  @override
  String get statusLabelEuList => 'Estado';

  @override
  String get potentialCompensationLabel => 'Compensación potencial';

  @override
  String get prefillCompensationFormButton =>
      'Rellenar formulario de compensación';

  @override
  String get claimsTabActive => 'Activas';

  @override
  String get claimsTabActionRequired => 'Acción requerida';

  @override
  String get claimsTabCompleted => 'Completadas';

  @override
  String get dialogTitleSuccess => 'Éxito';

  @override
  String get dialogContentClaimSubmitted =>
      'Su reclamación ha sido enviada con éxito.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Gestión de documentos';

  @override
  String get documentsForFlightTitle => 'Documentos para vuelo';

  @override
  String get errorLoadingDocuments => 'Error al cargar documentos';

  @override
  String get addDocumentTooltip => 'Añadir documento';

  @override
  String get deleteDocumentTitle => 'Eliminar documento';

  @override
  String get deleteDocumentMessage =>
      '¿Está seguro de que desea eliminar este documento?';

  @override
  String get delete => 'Eliminar';

  @override
  String get errorMustBeLoggedIn =>
      'Debe iniciar sesión para realizar esta acción';

  @override
  String get errorFailedToSubmitClaim => 'Error al enviar la reclamación';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get validatorFlightNumberRequired => 'Número de vuelo es obligatorio';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Introduzca el número de vuelo, p.ej. IB123';

  @override
  String get tooltipFlightDateQuickClaim => 'Seleccione la fecha de su vuelo';

  @override
  String get validatorDepartureAirportRequired =>
      'Aeropuerto de salida es obligatorio';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Introduzca el código IATA de 3 letras del aeropuerto de salida';

  @override
  String get validatorArrivalAirportRequired =>
      'Aeropuerto de llegada es obligatorio';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Introduzca el código IATA de 3 letras del aeropuerto de llegada';

  @override
  String get hintTextReasonQuickClaim => 'p.ej. Retraso de más de 3 horas';

  @override
  String get validatorReasonRequired => 'Motivo es obligatorio';

  @override
  String get tooltipReasonQuickClaim =>
      'Describa brevemente por qué está presentando una reclamación';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Introduzca la cantidad si conoce a cuánto tiene derecho';

  @override
  String get tipsAndRemindersTitle => 'Consejos y recordatorios';

  @override
  String get tipSecureData =>
      'Protegemos sus datos con cifrado de nivel bancario';

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
  String get accessibilitySettings => 'Configuración de accesibilidad';

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
  String get continueToReview => 'Continuar a revisión';

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
  String get previewEmail => 'Vista previa de correo electrónico';

  @override
  String get pdfPreviewMessage => 'Vista previa de PDF';

  @override
  String get downloadPdf => 'Descargar PDF';

  @override
  String get filePreviewNotAvailable => 'Vista previa de archivo no disponible';

  @override
  String get deleteDocument => 'Eliminar documento';

  @override
  String get deleteDocumentConfirmation =>
      '¿Está seguro de que desea eliminar este documento?';

  @override
  String get documentDeletedSuccess => 'Documento eliminado con éxito';

  @override
  String get documentDeleteFailed => 'Error al eliminar el documento';

  @override
  String get other => 'otro';

  @override
  String get reviewYourClaim => 'Revise su reclamación';

  @override
  String get reviewClaimDetails => 'Revise los detalles de la reclamación';

  @override
  String get attachments => 'Archivos adjuntos';

  @override
  String get proceedToConfirmation => 'Proceder a confirmación';

  @override
  String get confirmAndSend => 'Confirmar y enviar';

  @override
  String get errorLoadingEmailDetails =>
      'Error al cargar los detalles del correo electrónico';

  @override
  String get noEmailInfo =>
      'No hay información de correo electrónico disponible';

  @override
  String get finalConfirmation => 'Confirmación final';

  @override
  String get claimWillBeSentTo => 'Su reclamación se enviará a';

  @override
  String get copyToYourEmail => 'Copia a su correo electrónico';

  @override
  String get confirmAndSendEmail => 'Confirmar y enviar correo electrónico';

  @override
  String get flightCompensationCheckerTitle =>
      'Verificador de Compensación de Vuelos';

  @override
  String get checkEligibilityForEu261 =>
      'Verifique si su vuelo es elegible para compensación según la normativa EU261';

  @override
  String get flightNumberPlaceholder => 'Número de vuelo (ej. IB123)';

  @override
  String get dateOptionalPlaceholder => 'Fecha (AAAA-MM-DD, opcional)';

  @override
  String get leaveDateEmptyForToday => 'Dejar en blanco para hoy';

  @override
  String get error => 'Error';

  @override
  String flightInfoFormat(String flightNumber, String airline) {
    return 'Vuelo $flightNumber - $airline';
  }

  @override
  String get status => 'Estado';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get delay => 'Retraso';

  @override
  String minutesFormat(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get flightEligibleForCompensation =>
      '¡Su vuelo es elegible para compensación!';

  @override
  String get flightNotEligibleForCompensation =>
      'Su vuelo no es elegible para compensación.';

  @override
  String get potentialCompensation => 'Compensación Potencial:';

  @override
  String get contactAirlineForClaim =>
      'Contacte a la aerolínea para reclamar su compensación según el Reglamento UE 261/2004.';

  @override
  String get reasonPrefix => 'Razón: ';

  @override
  String get delayLessThan3Hours => 'El retraso del vuelo es menor a 3 horas';

  @override
  String get notUnderEuJurisdiction =>
      'El vuelo no está bajo jurisdicción de la UE';

  @override
  String get unknownReason => 'Razón desconocida';

  @override
  String get reviewAndConfirm => 'Revisar y confirmar';

  @override
  String get pleaseConfirmDetails =>
      'Por favor, confirme que todos los detalles son correctos';

  @override
  String get emailAppOpenedMessage =>
      'Aplicación de correo electrónico abierta';

  @override
  String emailAppErrorMessage(String email) {
    return 'Error al abrir la aplicación de correo electrónico';
  }
}
