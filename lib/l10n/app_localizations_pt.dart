// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Compensação de Voo';

  @override
  String welcomeUser(String userName) {
    return 'Bem-vindo, $userName';
  }

  @override
  String get signOut => 'Terminar Sessão';

  @override
  String get newClaim => 'Nova Reclamação';

  @override
  String get home => 'Início';

  @override
  String get settings => 'Definições';

  @override
  String get languageSelection => 'Idioma';

  @override
  String get passengerName => 'Nome do Passageiro';

  @override
  String get passengerDetails => 'Detalhes do Passageiro';

  @override
  String get flightNumber => 'Número do Voo';

  @override
  String get airline => 'Companhia Aérea';

  @override
  String get departureAirport => 'Aeroporto de Partida';

  @override
  String get arrivalAirport => 'Aeroporto de Chegada';

  @override
  String get email => 'Email';

  @override
  String get bookingReference => 'Referência da Reserva';

  @override
  String get additionalInformation => 'Informação Adicional';

  @override
  String get optional => '(Opcional)';

  @override
  String get thisFieldIsRequired => 'Este campo é obrigatório.';

  @override
  String get pleaseEnterDepartureAirport => 'Por favor, introduza um aeroporto de partida.';

  @override
  String get uploadDocuments => 'Carregar Documentos';

  @override
  String get submitClaim => 'Submeter Reclamação';

  @override
  String get addDocument => 'Adicionar Documento';

  @override
  String get claimSubmittedSuccessfully => 'Reclamação submetida com sucesso!';

  @override
  String get completeAllFields => 'Por favor, preencha todos os campos.';

  @override
  String get pleaseCompleteAllFields => 'Please complete all required fields.';

  @override
  String get pleaseAttachDocuments => 'Please attach required documents.';

  @override
  String get allFieldsCompleted => 'All fields completed.';

  @override
  String get processingDocument => 'Processando documento...';

  @override
  String get supportingDocuments => 'Documentos de Suporte';

  @override
  String get cropDocument => 'Recortar Documento';

  @override
  String get crop => 'Recortar';

  @override
  String get cropping => 'A recortar...';

  @override
  String get rotate => 'Rodar';

  @override
  String get aspectRatio => 'Proporção';

  @override
  String get aspectRatioFree => 'Livre';

  @override
  String get aspectRatioSquare => 'Quadrado';

  @override
  String get aspectRatioPortrait => 'Retrato';

  @override
  String get aspectRatioLandscape => 'Paisagem';

  @override
  String aspectRatioMode(String ratio) {
    return 'Proporção: $ratio';
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
  String get useExtractedData => 'Usar Dados Extraídos';

  @override
  String get copyToClipboard => 'Copiado para a área de transferência.';

  @override
  String get documentType => 'Tipo de Documento';

  @override
  String get saveDocument => 'Guardar Documento';

  @override
  String get fieldName => 'Nome do Campo';

  @override
  String get done => 'Concluído';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Voltar';

  @override
  String get save => 'Guardar';

  @override
  String get welcomeMessage => 'Bem-vindo à aplicação!';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get fillForm => 'Preencher Formulário';

  @override
  String get chooseUseInfo => 'Escolha como usar esta informação:';

  @override
  String get fillPassengerFlight => 'Preencher informações do passageiro e do voo';

  @override
  String get ocrResults => 'Resultados OCR';

  @override
  String get noFieldsExtracted => 'Nenhum campo foi extraído do documento.';

  @override
  String get extractedInformation => 'Informação Extraída';

  @override
  String get rawOcrText => 'Texto OCR Bruto';

  @override
  String get copyAllText => 'Copiar Todo o Texto';

  @override
  String get claims => 'Reclamações';

  @override
  String get noClaimsYet => 'No Claims Yet';

  @override
  String get startCompensationClaimInstructions => 'Start your compensation claim by selecting a flight from the EU Eligible Flights section';

  @override
  String get active => 'Ativa';

  @override
  String get actionRequired => 'Ação Necessária';

  @override
  String get completed => 'Concluída';

  @override
  String get profileInfoCardTitle => 'O seu perfil contém as suas informações pessoais e de contacto. Estas são usadas para processar as suas reclamações de compensação de voo e mantê-lo informado.';

  @override
  String get accountSettings => 'Definições da Conta';

  @override
  String get accessibilityOptions => 'Opções de Acessibilidade';

  @override
  String get configureAccessibilityDescription => 'Configurar contraste elevado, texto grande e suporte para leitor de ecrã';

  @override
  String get configureNotificationsDescription => 'Configurar como recebe atualizações de reclamações';

  @override
  String get tipProfileUpToDate => 'Mantenha o seu perfil atualizado para um processamento tranquilo das reclamações.';

  @override
  String get tipInformationPrivate => 'A sua informação é privada e usada apenas para reclamações de compensação.';

  @override
  String get tipContactDetails => 'Certifique-se de que os seus detalhes de contacto estão corretos para que o possamos contactar sobre a sua reclamação.';

  @override
  String get tipAccessibilitySettings => 'Reveja as definições de acessibilidade para personalizar a aplicação às suas necessidades.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get next => 'Seguinte';

  @override
  String get previous => 'Anterior';

  @override
  String arrivalsAt(String airport) {
    return 'Chegadas a $airport';
  }

  @override
  String get filterByAirline => 'Filtrar por companhia aérea';

  @override
  String get flightStatusDelayed => 'Atrasado';

  @override
  String get flightStatusCancelled => 'Cancelado';

  @override
  String get flightStatusDiverted => 'Desviado';

  @override
  String get flightStatusOnTime => 'A tempo';

  @override
  String get flight => 'Voo';

  @override
  String get flights => 'Voos';

  @override
  String get myFlights => 'Os Meus Voos';

  @override
  String get findFlight => 'Encontrar Voo';

  @override
  String get flightDate => 'Data do Voo';

  @override
  String get checkCompensationEligibility => 'Verificar Elegibilidade para Compensação';

  @override
  String get supportingDocumentsHint => 'Anexe cartões de embarque, bilhetes e outros documentos para fortalecer a sua reclamação.';

  @override
  String get scanDocument => 'Digitalizar Documento';

  @override
  String get uploadDocument => 'Carregar Documento';

  @override
  String get scanDocumentHint => 'Usar a câmara para preencher automaticamente o formulário';

  @override
  String get uploadDocumentHint => 'Selecionar do armazenamento do dispositivo';

  @override
  String get noDocumentsYet => 'Ainda não há documentos anexados';

  @override
  String get enterFlightNumberFirst => 'Por favor, introduza primeiro um número de voo';

  @override
  String get viewAll => 'Ver Tudo';

  @override
  String get documentScanner => 'Scanner de Documentos';

  @override
  String get profileInformation => 'Informação do Perfil';

  @override
  String get editPersonalInformation => 'Editar as suas informações pessoais';

  @override
  String get editPersonalAndContactInformation => 'Editar as suas informações pessoais e de contacto';

  @override
  String get configureAccessibilityOptions => 'Configurar as opções de acessibilidade da aplicação';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport => 'Configurar contraste elevado, texto grande e suporte para leitor de ecrã';

  @override
  String get applicationPreferences => 'Preferências da Aplicação';

  @override
  String get notificationSettings => 'Definições de Notificação';

  @override
  String get configureNotificationPreferences => 'Configurar preferências de notificação';

  @override
  String get configureHowYouReceiveClaimUpdates => 'Configurar como recebe atualizações de reclamações';

  @override
  String get language => 'Idioma';

  @override
  String get changeApplicationLanguage => 'Alterar idioma da aplicação';

  @override
  String get selectYourPreferredLanguage => 'Selecione o seu idioma preferido';

  @override
  String get tipsAndReminders => 'Dicas e Lembretes';

  @override
  String get importantTipsAboutProfileInformation => 'Dicas importantes sobre as informações do seu perfil';

  @override
  String get noClaimsYetTitle => 'Ainda Não Há Reclamações';

  @override
  String get noClaimsYetSubtitle => 'Comece a sua reclamação de compensação selecionando um voo na secção Voos Elegíveis da UE';

  @override
  String get extractingText => 'A extrair texto e a identificar campos';

  @override
  String get scanInstructions => 'Posicione o seu documento dentro da moldura e tire uma foto';

  @override
  String get formFilledWithScannedData => 'Formulário preenchido com dados do documento digitalizado';

  @override
  String get flightDetails => 'Detalhes do Voo';

  @override
  String get phoneNumber => 'Número de Telefone';

  @override
  String get required => 'Obrigatório';

  @override
  String get submit => 'Submeter';

  @override
  String get submissionChecklist => 'Lista de Verificação da Submissão';

  @override
  String get documentAttached => 'Documento Anexado';

  @override
  String get compensationClaimForm => 'Formulário de Reclamação de Compensação';

  @override
  String get prefilledFromProfile => 'Pré-preenchido a partir do seu perfil';

  @override
  String get flightSearch => 'Pesquisa de Voos';

  @override
  String get searchFlightNumber => 'Pesquisar por número de voo';

  @override
  String get delayedFlightDetected => 'Voo Atrasado Detetado';

  @override
  String get flightDetected => 'Voo Detetado';

  @override
  String get flightLabel => 'Voo:';

  @override
  String get fromAirport => 'De:';

  @override
  String get toAirport => 'Para:';

  @override
  String get statusLabel => 'Estado:';

  @override
  String get delayedEligible => 'Atrasado e potencialmente elegível';

  @override
  String get startClaim => 'Iniciar Reclamação';

  @override
  String get euWideEligibleFlights => 'Voos elegíveis para compensação em toda a UE';

  @override
  String get requiredFieldsCompleted => 'Todos os campos obrigatórios estão preenchidos.';

  @override
  String get scanningDocumentsNote => 'A digitalização de documentos pode pré-preencher alguns campos.';

  @override
  String get tipCheckEligibility => '• Certifique-se de que o seu voo é elegível para compensação (ex: atraso >3h, cancelamento, recusa de embarque).';

  @override
  String get tipDoubleCheckDetails => '• Verifique todos os detalhes antes de submeter para evitar atrasos.';

  @override
  String get tooltipFaqHelp => 'Aceder às perguntas frequentes e secção de ajuda';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Erro ao submeter o formulário: $errorMessage. Verifique a sua ligação e tente novamente.';
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
  String get reasonForClaimLabel => 'Motivo da Reclamação (ex: Atraso > 3h)';

  @override
  String get reasonForClaimHint => 'Por favor, introduza um motivo';

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
  String get claimAttachment => 'Anexo de Reclamação';

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
    return 'Chegadas elegíveis para compensação em $airportIcao';
  }

  @override
  String errorWithDetails(String error) {
    return 'Erro: $error';
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
  String get retry => 'Tentar novamente';

  @override
  String get carrierName => 'Nome da transportadora';

  @override
  String get pickDate => 'Escolher data';

  @override
  String get clearDate => 'Limpar data';

  @override
  String get noEligibleArrivalsFound => 'Não foram encontradas chegadas elegíveis para compensação para os filtros selecionados.';

  @override
  String flightAndAirline(String flightNumber, String airlineName) {
    return '$flightNumber - $airlineName';
  }

  @override
  String scheduledTime(String time) {
    return 'Agendado: $time';
  }

  @override
  String fromAirportName(String airportName) {
    return 'De: $airportName';
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
  String get euCompensationEligible => 'Elegível para compensação da UE';

  @override
  String actualTime(String time) {
    return 'Real: $time';
  }

  @override
  String delayAmount(String delay) {
    return 'Atraso: $delay';
  }

  @override
  String aircraftModel(String model) {
    return 'Aeronave: $model';
  }

  @override
  String compensationAmount(String amount) {
    return 'Compensação: $amount';
  }

  @override
  String get flightNumberLabel => 'Número do Voo';

  @override
  String get flightNumberHint => 'Por favor, introduza um número de voo';

  @override
  String get departureAirportLabel => 'Aeroporto de Partida (IATA)';

  @override
  String get departureAirportHint => 'Por favor, introduza um aeroporto de partida';

  @override
  String get arrivalAirportLabel => 'Aeroporto de Chegada (IATA)';

  @override
  String get arrivalAirportHint => 'Por favor, introduza um aeroporto de chegada';

  @override
  String get flightDateLabel => 'Data do Voo';

  @override
  String get flightDateHint => 'Selecione a data do seu voo';

  @override
  String get flightDateError => 'Por favor, selecione uma data de voo';

  @override
  String get continueToAttachmentsButton => 'Continuar para Anexos';

  @override
  String get fieldValue => 'Valor do Campo';

  @override
  String get errorConnectionFailed => 'Falha na ligação. Por favor, verifique a sua rede.';

  @override
  String get submitNewClaimTitle => 'Submeter Nova Reclamação';

  @override
  String get airlineLabel => 'Companhia Aérea';

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
  String get documentTypeOther => 'Outro';
}
