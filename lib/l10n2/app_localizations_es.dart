// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get euCompensation => 'Compensación UE';

  @override
  String get scheduledLabel => 'Programado';

  @override
  String get minutes => 'minutos';

  @override
  String get aircraftLabel => 'Aeronave:';

  @override
  String get prefillCompensationForm => 'Rellenar Formulario de Compensación';

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
  String get attachmentsInfoNextStep =>
      'You can add attachments (e.g., tickets, boarding passes) in the next step.';

  @override
  String get departureAirport => 'Aeropuerto de Salida';

  @override
  String get arrivalAirport => 'Aeropuerto de Llegada';

  @override
  String get reasonForClaim => 'Motivo de la reclamación';

  @override
  String get flightCancellationReason =>
      'Cancelación de vuelo - solicitando compensación bajo la regulación EU261 por vuelo cancelado';

  @override
  String get flightDelayReason =>
      'Retraso de vuelo superior a 3 horas - solicitando compensación bajo la regulación EU261 por retraso significativo';

  @override
  String get flightDiversionReason =>
      'Desvío de vuelo - solicitando compensación bajo la regulación EU261 por vuelo desviado';

  @override
  String get eu261CompensationReason =>
      'Solicitando compensación bajo la regulación EU261 por interrupción de vuelo';

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
  String get loadingExternalData => 'Cargando Datos Externos';

  @override
  String get loadingExternalDataDescription =>
      'Por favor espere mientras obtenemos los últimos datos de vuelo...';

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
  String get extractedInformation => 'Información Extraída';

  @override
  String get rawOcrText => 'Texto OCR sin procesar';

  @override
  String get copyAllText => 'Copiar Todo el Texto';

  @override
  String get fillForm => 'Rellenar Formulario';

  @override
  String get chooseUseInfo => 'Elija cómo usar esta información:';

  @override
  String get fillPassengerFlight => 'Rellenar información de pasajero y vuelo';

  @override
  String get flightSearch => 'Búsqueda de Vuelos';

  @override
  String get searchFlightNumber => 'Buscar por número de vuelo';

  @override
  String get done => 'Hecho';

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
  String get sendEmail => 'Send Email';

  @override
  String get resend => 'Resend';

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
  String get emailAddress => 'Dirección de Email';

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
  String get passengerInformation => 'Información del Pasajero';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get downloadPdf => 'Descargar PDF';

  @override
  String get filePreviewNotAvailable => 'Vista previa de archivo no disponible';

  @override
  String get noFileSelected => 'Ningún archivo seleccionado';

  @override
  String get preview => 'Vista previa';

  @override
  String get downloadStarting => 'Iniciando descarga...';

  @override
  String get fileTypeLabel => 'Tipo de archivo:';

  @override
  String get failedToLoadImage => 'No se pudo cargar la imagen';

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
  String get receivedAmount => 'Received';

  @override
  String get noClaimsYetTitle => 'Aún No Hay Reclamaciones';

  @override
  String get noRecentEvents => 'No recent events';

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
  String get legalPrivacySectionTitle => 'Legal y Privacidad';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get privacyPolicyDesc => 'Cómo gestionamos sus datos';

  @override
  String get termsOfService => 'Términos del Servicio';

  @override
  String get termsOfServiceDesc => 'Normas para usar el servicio';

  @override
  String get cookiePolicy => 'Política de Cookies';

  @override
  String get cookiePolicyDesc => 'Uso de cookies y categorías';

  @override
  String get legalNoticeImprint => 'Aviso Legal / Información Legal';

  @override
  String get legalNoticeImprintDesc => 'Operador y datos de contacto';

  @override
  String get accessibilityStatement => 'Declaración de Accesibilidad';

  @override
  String get accessibilityStatementDesc =>
      'Nuestros compromisos de accesibilidad';

  @override
  String get manageCookiePreferences => 'Gestionar preferencias de cookies';

  @override
  String get manageCookiePreferencesDesc =>
      'Cambiar la configuración de cookies de analítica y marketing';

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
  String get tipAccessibilitySettings => 'Configuración de Accesibilidad';

  @override
  String get active => 'Activa';

  @override
  String get completed => 'Completada';

  @override
  String get events => 'Events';

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
  String get profileInfoBannerSemanticLabel =>
      'Información sobre el uso de los datos de su perfil';

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

  @override
  String get supportOurMission => 'Apoya Nuestra Misión';

  @override
  String get helpKeepAppFree =>
      'Ayúdanos a mantener esta aplicación gratuita y apoyar el cuidado de hospicio';

  @override
  String get yourContributionMakesDifference =>
      'Tu contribución marca la diferencia';

  @override
  String get hospiceFoundation => 'Fundación de Hospicio';

  @override
  String get appDevelopment => 'Desarrollo de la Aplicación';

  @override
  String get comfortCareForPatients => 'Comodidad y cuidado para pacientes';

  @override
  String get newFeaturesAndImprovements => 'Nuevas características y mejoras';

  @override
  String get chooseYourSupportAmount => 'Elige tu cantidad de apoyo:';

  @override
  String get totalDonation => 'Donación Total';

  @override
  String get donationSummary => 'Resumen de Donación';

  @override
  String get choosePaymentMethod => 'Elige método de pago:';

  @override
  String get paymentMethod => 'Método de Pago';

  @override
  String get creditDebitCard => 'Tarjeta de Crédito/Débito';

  @override
  String get visaMastercardAmericanExpress =>
      'Visa, Mastercard, American Express';

  @override
  String get payWithPayPalAccount => 'Pagar con tu cuenta de PayPal';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get notAvailableOnThisDevice => 'No disponible en este dispositivo';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get quickAndSecure => 'Rápido y seguro';

  @override
  String get smallSupport => 'Apoyo Pequeño';

  @override
  String get goodSupport => 'Buen Apoyo';

  @override
  String get greatSupport => 'Gran Apoyo';

  @override
  String yourAmountHelps(String amount) {
    return 'Tu $amount ayuda:';
  }

  @override
  String get hospicePatientCare => 'Cuidado de pacientes de hospicio';

  @override
  String get appImprovements => 'Mejoras de la aplicación';

  @override
  String continueWithAmount(String amount) {
    return 'Continuar con $amount';
  }

  @override
  String get selectAnAmount => 'Selecciona una cantidad';

  @override
  String get maybeLater => 'Tal vez más tarde';

  @override
  String get securePaymentInfo =>
      'Pago seguro • Sin tarifas ocultas • Recibo fiscal';

  @override
  String get learnMoreHospiceFoundation =>
      'Aprende más sobre la Fundación de Hospicio: fundacja-hospicjum.org';

  @override
  String get touchIdOrFaceId => 'Touch ID o Face ID';

  @override
  String get continueToPayment => 'Continuar al Pago';

  @override
  String get selectAPaymentMethod => 'Selecciona un método de pago';

  @override
  String get securePayment => 'Pago Seguro';

  @override
  String get paymentSecurityInfo =>
      'Tu información de pago está cifrada y segura. No almacenamos los detalles de tu pago.';

  @override
  String get taxReceiptEmail => 'El recibo fiscal será enviado a tu email';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, American Express';

  @override
  String get notAvailableOnDevice => 'No disponible en este dispositivo';

  @override
  String get comfortAndCareForPatients => 'Comodidad y cuidado para pacientes';

  @override
  String get chooseSupportAmount => 'Elige tu cantidad de apoyo:';

  @override
  String get emailReadyTitle =>
      '¡Su correo electrónico de compensación está listo para enviar!';

  @override
  String get emailWillBeSentSecurely =>
      'Su correo electrónico se enviará de forma segura a través de nuestro servicio backend';

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
      'Su correo electrónico se enviará de forma segura mediante transmisión cifrada';

  @override
  String get sendingEllipsis => 'Sending...';

  @override
  String get sendEmailSecurely => 'Enviar correo electrónico de forma segura';

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
  String get predictingDelay => 'Calculando retraso…';

  @override
  String get predictionUnavailable => 'Predicción no disponible';

  @override
  String delayRiskPercent(int risk) {
    return 'Riesgo de retraso $risk%';
  }

  @override
  String avgMinutesShort(int minutes) {
    return 'Prom. $minutes min';
  }

  @override
  String get attachmentGuidanceTitle => 'Attachments';

  @override
  String get emailPreviewAttachmentGuidance =>
      'Podrá añadir archivos adjuntos en el siguiente paso. Por favor, recuerde incluir únicamente archivos en formato JPG, PNG o PDF.';

  @override
  String get worldIdVerifyTitle => 'Verificar con World ID';

  @override
  String get worldIdVerifyDesc =>
      'Verifique su identidad de forma privada con World ID. Esto nos ayuda a prevenir abusos y mantener la app gratuita.';

  @override
  String get worldIdVerifySemantic =>
      'Verifique su humanidad con Worldcoin World ID. Solo disponible en la web por ahora.';

  @override
  String get worldIdTemporarilyUnavailable =>
      'World ID no está disponible temporalmente. Por favor, inténtelo más tarde.';

  @override
  String get worldAppSignInTitle => 'Iniciar sesión con World App';

  @override
  String get worldAppSignInDesc =>
      'Inicie sesión con World App para verificar su identidad. Esto ayuda a prevenir abusos y mantener la app gratuita.';

  @override
  String get worldAppOpenError =>
      'No se pudo abrir World App. Por favor, inténtelo de nuevo.';

  @override
  String worldAppOpenException(String error) {
    return 'Error al abrir World App: $error';
  }

  @override
  String get worldIdOidcTitle => 'Iniciar sesión con World ID (OIDC)';

  @override
  String get worldIdOidcDesc =>
      'Inicie sesión con World ID mediante OIDC + PKCE seguro.';

  @override
  String get emailClipboardFallbackPrimary =>
      'No hay ninguna aplicación de correo electrónico disponible. El contenido del correo electrónico se ha copiado en su portapapeles. Péguelo en cualquier servicio de correo.';

  @override
  String get emailClipboardFallbackAdvisory =>
      'Después de pegar, puede revisar y corregir el texto y adjuntar documentos como billetes o tarjetas de embarque (JPG, PNG, PDF).';
}
