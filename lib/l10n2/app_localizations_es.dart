// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get euCompensation => 'TODO: Translate \'EU Compensation\'';

  @override
  String get scheduledLabel => 'Programado';

  @override
  String get minutes => 'TODO: Translate \'minutes\'';

  @override
  String get aircraftLabel => 'TODO: Translate \'Aircraft:\'';

  @override
  String get prefillCompensationForm =>
      'TODO: Translate \'Pre-fill Compensation Form\'';

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
  String get previewEmail => 'Vista previa de correo electrónico';

  @override
  String get confirmAndSendEmail => 'Confirmar y enviar correo electrónico';

  @override
  String get departureAirport => 'Aeropuerto de Salida';

  @override
  String get arrivalAirport => 'Aeropuerto de Llegada';

  @override
  String get reasonForClaim => 'Motivo de la reclamación';

  @override
  String get attachments => 'Archivos adjuntos';

  @override
  String get proceedToConfirmation => 'Proceder a confirmación';

  @override
  String emailAppOpenedMessage(String email) {
    return 'Aplicación de correo electrónico abierta';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'Error al enviar la reclamación';
  }

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get retry => 'Reintentar';

  @override
  String get claimNotFound => 'Reclamación no encontrada';

  @override
  String get claimNotFoundDesc =>
      'La reclamación solicitada no se pudo encontrar. Puede que haya sido eliminada.';

  @override
  String get backToDashboard => 'Volver al panel';

  @override
  String get reviewYourClaim => 'Revise su reclamación';

  @override
  String get reviewClaimDetails => 'Revise los detalles de la reclamación';

  @override
  String get flightNumber => 'Número de Vuelo';

  @override
  String get flightDate => 'Fecha del Vuelo';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'No hay vuelos que coincidan con el filtro: $filter';
  }

  @override
  String get statusLabel => 'Estado:';

  @override
  String get flightStatusDelayed => 'Retrasado';

  @override
  String get potentialCompensation => 'Compensación Potencial:';

  @override
  String get claimDetails => 'Detalles de la reclamación';

  @override
  String get refresh => 'Actualizar';

  @override
  String get errorLoadingClaim => 'Error al cargar la reclamación';

  @override
  String get euWideCompensationEligibleFlights =>
      'Vuelos elegibles para compensación en la UE';

  @override
  String get forceRefreshData => 'Forzar actualización de datos';

  @override
  String get forcingFreshDataLoad => 'Forzando una nueva carga de datos...';

  @override
  String get loadingExternalData => 'TODO: Translate \'Loading External Data\'';

  @override
  String get loadingExternalDataDescription =>
      'TODO: Translate \'Please wait while we fetch the latest flight data...\'';

  @override
  String lastHours(int hours) {
    return 'Últimas $hours horas';
  }

  @override
  String get errorConnectionFailed =>
      'Falló la conexión. Por favor, revise su red.';

  @override
  String formSubmissionError(String error) {
    return 'Error al enviar el formulario: $error. Verifique su conexión e inténtelo de nuevo.';
  }

  @override
  String get apiConnectionIssue =>
      'Problema de conexión con la API. Por favor, inténtelo de nuevo.';

  @override
  String get noEligibleFlightsFound => 'No se encontraron vuelos elegibles';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'No se encontraron vuelos en las últimas $hours horas.';
  }

  @override
  String get checkAgain => 'Volver a comprobar';

  @override
  String get filterByAirline => 'Filtrar por aerolínea';

  @override
  String get saveDocument => 'Guardar Documento';

  @override
  String get fieldName => 'Nombre del Campo';

  @override
  String get fieldValue => 'Valor del Campo';

  @override
  String get noFieldsExtracted => 'No se extrajeron campos del documento.';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get networkError => 'Error de red';

  @override
  String get generalError => 'Error general';

  @override
  String get loginRequiredForClaim =>
      'Se requiere inicio de sesión para presentar una reclamación';

  @override
  String get aspectRatio => 'Relación de Aspecto';

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
  String get rotate => 'Girar';

  @override
  String get airline => 'Aerolínea';

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
  String get languageSelection => 'Idioma';

  @override
  String get passengerName => 'Nombre del Pasajero';

  @override
  String get passengerDetails => 'Detalles del Pasajero';

  @override
  String get appTitle => 'Compensación de Vuelo';

  @override
  String get welcomeMessage => '¡Bienvenido a la aplicación!';

  @override
  String get home => 'Inicio';

  @override
  String get settings => 'Configuración';

  @override
  String get required => 'Obligatorio';

  @override
  String get emailAddress => 'TODO: Translate \'Email Address\'';

  @override
  String get documentDeleteFailed => 'Error al eliminar el documento';

  @override
  String get uploadNew => 'Subir Nuevo';

  @override
  String get continueAction => 'Continuar';

  @override
  String get compensationClaimForm =>
      'Formulario de Reclamación de Compensación';

  @override
  String get flight => 'Vuelo';

  @override
  String get passengerInformation =>
      'TODO: Translate \'Passenger Information\'';

  @override
  String get fullName => 'Nombre Completo';

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
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get documentDeletedSuccess => 'Documento eliminado con éxito';

  @override
  String get attachDocuments => 'Adjuntar Documentos';

  @override
  String get uploadingDocument => 'Subiendo documento...';

  @override
  String get noDocuments => 'No tienes documentos.';

  @override
  String get uploadFirstDocument => 'Subir Primer Documento';

  @override
  String get claimAttachment => 'Adjunto de Reclamo';

  @override
  String get other => 'otro';

  @override
  String get pdfPreviewMessage => 'Vista previa de PDF';

  @override
  String get tipsAndRemindersTitle => 'Consejos y recordatorios';

  @override
  String get tipSecureData =>
      'Protegemos sus datos con cifrado de nivel bancario';

  @override
  String get tipCheckEligibility =>
      '• Asegúrese de que su vuelo sea elegible para compensación (p. ej., retraso >3h, cancelación, denegación de embarque).';

  @override
  String get tipDoubleCheckDetails =>
      '• Verifique todos los detalles antes de enviar para evitar demoras.';

  @override
  String get documentUploadSuccess => '¡Documento subido exitosamente!';

  @override
  String get uploadFailed => 'Error al subir. Por favor, intenta de nuevo.';

  @override
  String get reasonForClaimHint => 'Ej. retraso, cancelación';

  @override
  String get validatorReasonRequired => 'Motivo es obligatorio';

  @override
  String get tooltipReasonQuickClaim =>
      'Describa brevemente por qué está presentando una reclamación';

  @override
  String get compensationAmountOptionalLabel =>
      'Cantidad de compensación (opcional)';

  @override
  String get compensationAmountHint => 'Ej. 250€';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Introduzca la cantidad si conoce a cuánto tiene derecho';

  @override
  String get continueToReview => 'Continuar a revisión';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Introduzca el código IATA de 3 letras del aeropuerto de salida';

  @override
  String get arrivalAirportHintQuickClaim => 'Aeropuerto de llegada (ej. BCN)';

  @override
  String get validatorArrivalAirportRequired =>
      'Aeropuerto de llegada es obligatorio';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Introduzca el código IATA de 3 letras del aeropuerto de llegada';

  @override
  String get reasonForClaimLabel => 'Motivo de la reclamación';

  @override
  String get hintTextReasonQuickClaim => 'p.ej. Retraso de más de 3 horas';

  @override
  String get flightNumberHintQuickClaim => 'Número de vuelo (ej. LH123)';

  @override
  String get validatorFlightNumberRequired => 'Número de vuelo es obligatorio';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Introduzca el número de vuelo, p.ej. IB123';

  @override
  String get tooltipFlightDateQuickClaim => 'Seleccione la fecha de su vuelo';

  @override
  String get departureAirportHintQuickClaim => 'Aeropuerto de salida (ej. MAD)';

  @override
  String get validatorDepartureAirportRequired =>
      'Aeropuerto de salida es obligatorio';

  @override
  String get underAppeal => 'En apelación';

  @override
  String get unknown => 'Desconocido';

  @override
  String get errorMustBeLoggedIn =>
      'Debe iniciar sesión para realizar esta acción';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get quickClaimTitle => 'Reclamación rápida';

  @override
  String get tooltipFaqHelp =>
      'Acceder a las preguntas frecuentes y la sección de ayuda';

  @override
  String get quickClaimInfoBanner =>
      'Complete los detalles de su vuelo para verificar la elegibilidad para compensación';

  @override
  String get createClaim => 'Crear reclamación';

  @override
  String get submitted => 'Enviado';

  @override
  String get inReview => 'En revisión';

  @override
  String get actionRequired => 'Acción Requerida';

  @override
  String get processing => 'Procesando';

  @override
  String get approved => 'Aprobado';

  @override
  String get rejected => 'Rechazado';

  @override
  String get paid => 'Pagado';

  @override
  String flightRouteDetails(String departure, String arrival) {
    return 'Vuelo $flightNumber: $departure - $arrival';
  }

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
  String get noClaimsYet => 'Aún no hay reclamaciones';

  @override
  String get startCompensationClaimInstructions =>
      'Inicie su reclamación de compensación seleccionando un vuelo en la sección Vuelos elegibles para la UE';

  @override
  String get claimsDashboard => 'Panel de Reclamaciones';

  @override
  String get refreshDashboard => 'Actualizar Panel';

  @override
  String get claimsSummary => 'Resumen de Reclamaciones';

  @override
  String get totalClaims => 'Total de Reclamaciones';

  @override
  String get totalCompensation => 'Compensación Total';

  @override
  String get pendingAmount => 'Monto Pendiente';

  @override
  String get noClaimsYetTitle => 'Aún No Hay Reclamaciones';

  @override
  String get pending => 'Pendiente';

  @override
  String get viewClaimDetails => 'Ver detalles de la reclamación';

  @override
  String claimForFlight(String flightNumber, String status) {
    return 'Reclamación para el vuelo $flightNumber - $status';
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
      'Configurar cómo recibe las actualizaciones de las reclamaciones';

  @override
  String get notificationSettingsComingSoon =>
      '¡Configuración de notificaciones próximamente!';

  @override
  String get changeApplicationLanguage => 'Cambiar el idioma de la aplicación';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get tipsAndReminders => 'Consejos y Recordatorios';

  @override
  String get tipProfileUpToDate => 'Mantenga su perfil actualizado';

  @override
  String get tipInformationPrivate => 'Su información es privada';

  @override
  String get tipContactDetails => 'Datos de Contacto';

  @override
  String get tipAccessibilitySettings => 'Configuración de Accesibilidad';

  @override
  String get active => 'Activa';

  @override
  String get completed => 'Completada';

  @override
  String get genericUser => 'Usuario';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String errorSigningOut(String error) {
    return 'Error al cerrar sesión: $error';
  }

  @override
  String get profileInformation => 'Información del Perfil';

  @override
  String get profileInfoCardTitle =>
      'Su perfil contiene su información personal y de contacto. Esto se utiliza para procesar sus reclamaciones de compensación de vuelo y mantenerlo informado.';

  @override
  String get accountSettings => 'Configuración de la Cuenta';

  @override
  String get editPersonalInfo => 'Editar Información Personal';

  @override
  String get editPersonalInfoDescription =>
      'Actualice sus datos personales, dirección e información de contacto';

  @override
  String get accessibilitySettings => 'Configuración de accesibilidad';

  @override
  String get configureAccessibility => 'Configurar opciones de accesibilidad';

  @override
  String get accessibilityOptions => 'Opciones de accesibilidad';

  @override
  String get configureAccessibilityDescription =>
      'Configurar alto contraste, texto grande y soporte para lector de pantalla';

  @override
  String get notificationSettings => 'Configuración de Notificaciones';

  @override
  String get configureNotifications => 'Configurar notificaciones';

  @override
  String get eu261Rights =>
      'Bajo la regulación EU261, tiene derecho a compensación por:\n• Retrasos de 3+ horas\n• Cancelaciones de vuelos\n• Denegación de embarque\n• Desvíos de vuelos';

  @override
  String get dontLetAirlinesWin =>
      '¡No permita que las aerolíneas eviten pagar lo que se le debe!';

  @override
  String get submitClaimAnyway => 'Presentar Reclamo de Todos Modos';

  @override
  String get newClaim => 'Nueva Reclamación';

  @override
  String get notLoggedIn => 'Not Logged In';

  @override
  String get signIn => 'Sign In';

  @override
  String get checkFlightEligibilityButtonText =>
      'Verificar elegibilidad de compensación por vuelo';

  @override
  String get euEligibleFlightsButtonText =>
      'Vuelos elegibles para compensación en la UE';

  @override
  String welcomeUser(String name, String role, Object userName) {
    return 'Bienvenido, $userName';
  }

  @override
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get contactAirlineForClaim =>
      'Contacte a la aerolínea para reclamar su compensación según el Reglamento UE 261/2004.';

  @override
  String get flightMightNotBeEligible =>
      'Según los datos disponibles, su vuelo podría no ser elegible para compensación.';

  @override
  String get knowYourRights => 'Conozca Sus Derechos';

  @override
  String get airlineDataDisclaimer =>
      'Las aerolíneas a veces subreportan retrasos o cambian el estado de los vuelos. Si experimentó un retraso de 3+ horas, cancelación o desvío, aún puede tener derecho a compensación.';

  @override
  String get error => 'Error';

  @override
  String get status => 'Estado';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get delay => 'Retraso';

  @override
  String get flightEligibleForCompensation =>
      '¡Su vuelo es elegible para compensación!';

  @override
  String flightInfoFormat(String flightCode, String flightDate) {
    return 'Vuelo $flightNumber - $airline';
  }

  @override
  String minutesFormat(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get flightCompensationCheckerTitle =>
      'Verificador de Compensación de Vuelos';

  @override
  String get checkEligibilityForEu261 =>
      'Verifique si su vuelo es elegible para compensación según la normativa EU261';

  @override
  String get flightNumberPlaceholder => 'Número de vuelo (ej. IB123)';

  @override
  String get pleaseEnterFlightNumber => 'Por favor, ingrese un número de vuelo';

  @override
  String get dateOptionalPlaceholder => 'Fecha (AAAA-MM-DD, opcional)';

  @override
  String get leaveDateEmptyForToday => 'Dejar en blanco para hoy';

  @override
  String get checkCompensationEligibility =>
      'Verificar Elegibilidad para Compensación';

  @override
  String get continueToAttachmentsButton => 'Continuar a los archivos adjuntos';

  @override
  String get flightNotFoundError =>
      'Vuelo no encontrado. Por favor, verifique su número de vuelo e inténtelo de nuevo.';

  @override
  String get invalidFlightNumberError =>
      'Formato de número de vuelo inválido. Por favor, ingrese un número de vuelo válido (ej. BA123, LH456).';

  @override
  String get networkTimeoutError =>
      'Tiempo de conexión agotado. Por favor, verifique su conexión a internet e inténtelo de nuevo.';

  @override
  String get serverError =>
      'Servidor temporalmente no disponible. Por favor, inténtelo más tarde.';

  @override
  String get rateLimitError =>
      'Demasiadas solicitudes. Por favor, espere un momento e inténtelo de nuevo.';

  @override
  String get generalFlightCheckError =>
      'No se puede verificar la información del vuelo. Por favor, verifique los detalles de su vuelo e inténtelo de nuevo.';

  @override
  String get receiveNotifications => 'Recibir Notificaciones';

  @override
  String get getClaimUpdates =>
      'Reciba actualizaciones sobre sus reclamaciones';

  @override
  String get saveProfile => 'Guardar Perfil';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Dirección';

  @override
  String get city => 'Ciudad';

  @override
  String get country => 'País';

  @override
  String get postalCode => 'Código Postal';

  @override
  String get pleaseSelectFlightDate =>
      'Por favor, selecciona la fecha del vuelo';

  @override
  String get submitNewClaim => 'Enviar nueva reclamación';

  @override
  String get pleaseEnterArrivalAirport =>
      'Por favor, introduce el aeropuerto de llegada';

  @override
  String get pleaseEnterReason =>
      'Por favor, introduce un motivo para la reclamación';

  @override
  String get flightDateHint => 'Seleccionar fecha del vuelo';

  @override
  String get number => 'Number';

  @override
  String welcomeUser3(String name, String role, String company) {
    return 'Welcome, $name ($role at $company)';
  }

  @override
  String get phoneNumber => 'Número de Teléfono';

  @override
  String get passportNumber => 'Número de Pasaporte';

  @override
  String get nationality => 'Nacionalidad';

  @override
  String get dateOfBirth => 'Fecha de Nacimiento';

  @override
  String get dateFormat => 'DD/MM/AAAA';

  @override
  String get privacySettings => 'Configuración de Privacidad';

  @override
  String get consentToShareData => 'Consentimiento para Compartir Datos';

  @override
  String get requiredForProcessing =>
      'Requerido para procesar sus reclamaciones';

  @override
  String get claims => 'Reclamaciones';

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
  String get emailReadyToSend => '¡Su email de compensación está listo!';

  @override
  String get emailCopyInstructions =>
      'Copie los detalles del email a continuación y péguelos en su aplicación de email';

  @override
  String get cc => 'CC';

  @override
  String get subject => 'Asunto';

  @override
  String get emailBody => 'Cuerpo del Email';

  @override
  String get howToSendEmail => 'Cómo enviar este email:';

  @override
  String get emailStep1 => 'Toque \"Copiar Email\" a continuación';

  @override
  String get emailStep2 => 'Abra su aplicación de email (Gmail, Outlook, etc.)';

  @override
  String get emailStep3 => 'Cree un nuevo email';

  @override
  String get emailStep4 => 'Pegue el contenido copiado';

  @override
  String get emailStep5 => '¡Envíe su reclamo de compensación!';

  @override
  String get copyEmail => 'Copiar Email';

  @override
  String get emailCopiedSuccess => '¡Email copiado al portapapeles!';
}
