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
  String get pleaseEnterDepartureAirport => 'Por favor, ingrese un aeropuerto de salida.';

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
  String get pleaseCompleteAllFields => 'Please complete all required fields.';

  @override
  String get pleaseAttachDocuments => 'Please attach required documents.';

  @override
  String get allFieldsCompleted => 'All fields completed.';

  @override
  String get processingDocument => 'Procesando documento...';

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
  String get startCompensationClaimInstructions => 'Comience su reclamación de compensación seleccionando un vuelo de la sección Vuelos Elegibles de la UE';

  @override
  String get active => 'Activa';

  @override
  String get actionRequired => 'Acción Requerida';

  @override
  String get completed => 'Completada';

  @override
  String get profileInfoCardTitle => 'Su perfil contiene su información personal y de contacto. Esto se utiliza para procesar sus reclamaciones de compensación de vuelo y mantenerlo informado.';

  @override
  String get accountSettings => 'Configuración de la Cuenta';

  @override
  String get accessibilityOptions => 'Opciones de Accesibilidad';

  @override
  String get configureAccessibilityDescription => 'Configurar alto contraste, texto grande y soporte para lector de pantalla';

  @override
  String get configureNotificationsDescription => 'Configurar cómo recibe las actualizaciones de las reclamaciones';

  @override
  String get tipProfileUpToDate => 'Mantenga su perfil actualizado para un procesamiento fluido de las reclamaciones.';

  @override
  String get tipInformationPrivate => 'Su información es privada y se utiliza únicamente para reclamaciones de compensación.';

  @override
  String get tipContactDetails => 'Asegúrese de que sus datos de contacto sean correctos para que podamos comunicarnos con usted sobre su reclamación.';

  @override
  String get tipAccessibilitySettings => 'Revise la configuración de accesibilidad para personalizar la aplicación según sus necesidades.';

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
  String get checkCompensationEligibility => 'Verificar Elegibilidad de Compensación';

  @override
  String get supportingDocumentsHint => 'Adjunte tarjetas de embarque, billetes y otros documentos para respaldar su reclamación.';

  @override
  String get scanDocument => 'Escanear Documento';

  @override
  String get uploadDocument => 'Subir Documento';

  @override
  String get scanDocumentHint => 'Usar la cámara para rellenar automáticamente el formulario';

  @override
  String get uploadDocumentHint => 'Seleccionar desde el almacenamiento del dispositivo';

  @override
  String get noDocumentsYet => 'Aún no hay documentos adjuntos';

  @override
  String get enterFlightNumberFirst => 'Por favor, ingrese primero un número de vuelo';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get documentScanner => 'Escáner de Documentos';

  @override
  String get profileInformation => 'Información del Perfil';

  @override
  String get editPersonalInformation => 'Editar su información personal';

  @override
  String get editPersonalAndContactInformation => 'Editar su información personal y de contacto';

  @override
  String get configureAccessibilityOptions => 'Configurar las opciones de accesibilidad de la aplicación';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport => 'Configurar alto contraste, texto grande y soporte para lector de pantalla';

  @override
  String get applicationPreferences => 'Preferencias de la Aplicación';

  @override
  String get notificationSettings => 'Configuración de Notificaciones';

  @override
  String get configureNotificationPreferences => 'Configurar preferencias de notificación';

  @override
  String get configureHowYouReceiveClaimUpdates => 'Configurar cómo recibe las actualizaciones de las reclamaciones';

  @override
  String get language => 'Idioma';

  @override
  String get changeApplicationLanguage => 'Cambiar el idioma de la aplicación';

  @override
  String get selectYourPreferredLanguage => 'Seleccione su idioma preferido';

  @override
  String get tipsAndReminders => 'Consejos y Recordatorios';

  @override
  String get importantTipsAboutProfileInformation => 'Consejos importantes sobre la información de su perfil';

  @override
  String get noClaimsYetTitle => 'Aún No Hay Reclamaciones';

  @override
  String get noClaimsYetSubtitle => 'Comience su reclamación de compensación seleccionando un vuelo de la sección Vuelos Elegibles de la UE';

  @override
  String get extractingText => 'Extrayendo texto e identificando campos';

  @override
  String get scanInstructions => 'Coloque su documento dentro del marco y tome una foto';

  @override
  String get formFilledWithScannedData => 'Formulario rellenado con datos del documento escaneado';

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
  String get compensationClaimForm => 'Formulario de Reclamación de Compensación';

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
  String get euWideEligibleFlights => 'Vuelos elegibles para compensación en toda la UE';

  @override
  String get requiredFieldsCompleted => 'Todos los campos obligatorios están completos.';

  @override
  String get scanningDocumentsNote => 'Escanear documentos puede prellenar algunos campos.';

  @override
  String get tipCheckEligibility => '• Asegúrese de que su vuelo sea elegible para compensación (p. ej., retraso >3h, cancelación, denegación de embarque).';

  @override
  String get tipDoubleCheckDetails => '• Verifique todos los detalles antes de enviar para evitar demoras.';

  @override
  String get tooltipFaqHelp => 'Acceder a las preguntas frecuentes y la sección de ayuda';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Error al enviar el formulario: $errorMessage. Verifique su conexión e inténtelo de nuevo.';
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
  String get reasonForClaimLabel => 'Reason for Claim (e.g., Delay > 3h)';

  @override
  String get reasonForClaimHint => 'Please enter a reason';

  @override
  String get compensationAmountOptionalLabel => 'Compensation Amount (optional)';

  @override
  String get compensationAmountHint => 'If you know the amount you are eligible for, enter it here';

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
  String get dialogContentClaimSubmitted => 'Your claim has been submitted successfully.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Document Management';

  @override
  String get attachDocumentsTitle => 'Attach Documents';

  @override
  String get uploadNewButton => 'Upload New';

  @override
  String get continueButton => 'Continue';

  @override
  String get noDocumentsMessage => 'You have no documents.';

  @override
  String get uploadFirstDocumentButton => 'Upload First Document';

  @override
  String get uploadingMessage => 'Uploading document...';

  @override
  String get uploadSuccessMessage => 'Document uploaded successfully!';

  @override
  String get uploadFailedMessage => 'Upload failed. Please try again.';

  @override
  String get claimAttachment => 'Adjunto de Reclamación';

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
  String get euEligibleFlightsTitle => 'EU Eligible Flights';

  @override
  String get filterByAirlineName => 'Filter by Airline Name';

  @override
  String get loadingFlights => 'Loading eligible flights...';

  @override
  String get errorLoadingFlights => 'Error loading flights';

  @override
  String get noEligibleFlightsFound => 'No eligible flights found.';

  @override
  String get noFlightsMatchFilter => 'No flights match your filter.';

  @override
  String get checkCompensation => 'Check Compensation';

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
  String compensationEligibleArrivalsAt(String airportIcao) {
    return 'Llegadas elegibles en $airportIcao';
  }

  @override
  String errorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get signInToTrackClaims => 'Sign in to track your claims';

  @override
  String get createAccountDescription => 'Create an account or sign in to manage your compensation claims.';

  @override
  String get signInOrSignUp => 'Sign In / Sign Up';

  @override
  String get genericUser => 'User';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get carrierName => 'Nombre de la aerolínea';

  @override
  String get pickDate => 'Seleccionar fecha';

  @override
  String get clearDate => 'Borrar fecha';

  @override
  String get noEligibleArrivalsFound => 'No se encontraron llegadas elegibles para compensación con los filtros seleccionados.';

  @override
  String flightAndAirline(String flightNumber, String airlineName) {
    return '$flightNumber - $airlineName';
  }

  @override
  String scheduledTime(String time) {
    return 'Programado: $time';
  }

  @override
  String fromAirportName(String airportName) {
    return 'Desde: $airportName';
  }

  @override
  String revisedTime(String time) {
    return 'Revisado: $time';
  }

  @override
  String status(String status) {
    return 'Estado: $status';
  }

  @override
  String get euCompensationEligible => 'Elegible para compensación de la UE';

  @override
  String actualTime(String time) {
    return 'Real: $time';
  }

  @override
  String delayAmount(String delay) {
    return 'Retraso: $delay';
  }

  @override
  String aircraftModel(String model) {
    return 'Aeronave: $model';
  }

  @override
  String compensationAmount(String amount) {
    return 'Compensación: $amount';
  }

  @override
  String get flightNumberLabel => 'Flight Number';

  @override
  String get flightNumberHint => 'Please enter a flight number';

  @override
  String get departureAirportLabel => 'Departure Airport (IATA)';

  @override
  String get departureAirportHint => 'Please enter a departure airport';

  @override
  String get arrivalAirportLabel => 'Arrival Airport (IATA)';

  @override
  String get arrivalAirportHint => 'Please enter an arrival airport';

  @override
  String get flightDateLabel => 'Flight Date';

  @override
  String get flightDateHint => 'Select the date of your flight';

  @override
  String get flightDateError => 'Please select a flight date';

  @override
  String get continueToAttachmentsButton => 'Continue to Attachments';

  @override
  String get fieldValue => 'Valor del Campo';

  @override
  String get errorConnectionFailed => 'Falló la conexión. Por favor, revise su red.';

  @override
  String get submitNewClaimTitle => 'Submit New Claim';

  @override
  String get airlineLabel => 'Airline';

  @override
  String get other => 'Other';

  @override
  String get documentTypeBoardingPass => 'Boarding Pass';

  @override
  String get documentTypeId => 'ID Document';

  @override
  String get documentTypeTicket => 'Ticket';

  @override
  String get documentTypeBookingConfirmation => 'Booking Confirmation';

  @override
  String get documentTypeETicket => 'E-Ticket';

  @override
  String get documentTypeLuggageTag => 'Luggage Tag';

  @override
  String get documentTypeDelayConfirmation => 'Delay Confirmation';

  @override
  String get documentTypeHotelReceipt => 'Hotel Receipt';

  @override
  String get documentTypeMealReceipt => 'Meal Receipt';

  @override
  String get documentTypeTransportReceipt => 'Transport Receipt';

  @override
  String get documentTypeOther => 'Otro';
}
