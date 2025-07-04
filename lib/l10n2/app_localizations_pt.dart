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
  String get signOut => 'Sair';

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
  String get pleaseEnterDepartureAirport =>
      'Por favor, introduza um aeroporto de partida.';

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
  String get fillPassengerFlight =>
      'Preencher informações do passageiro e do voo';

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
  String get noClaimsYet => 'Ainda não há solicitações';

  @override
  String get startCompensationClaimInstructions =>
      'Inicie sua solicitação de compensação selecionando um voo na seção Voos elegíveis para a UE';

  @override
  String get active => 'Ativa';

  @override
  String get actionRequired => 'Ação Necessária';

  @override
  String get completed => 'Concluída';

  @override
  String get profileInfoCardTitle =>
      'O seu perfil contém as suas informações pessoais e de contacto. Estas são usadas para processar as suas reclamações de compensação de voo e mantê-lo informado.';

  @override
  String get accountSettings => 'Definições da Conta';

  @override
  String get accessibilityOptions => 'Opções de Acessibilidade';

  @override
  String get configureAccessibilityDescription =>
      'Configurar contraste elevado, texto grande e suporte para leitor de ecrã';

  @override
  String get configureNotificationsDescription =>
      'Configurar como recebe atualizações de reclamações';

  @override
  String get tipProfileUpToDate => 'Mantenha seu perfil atualizado';

  @override
  String get tipInformationPrivate => 'Suas informações são privadas';

  @override
  String get tipContactDetails => 'Detalhes de Contato';

  @override
  String get tipAccessibilitySettings => 'Configurações de Acessibilidade';

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
  String get checkCompensationEligibility =>
      'Verificar Elegibilidade para Compensação';

  @override
  String get supportingDocumentsHint =>
      'Anexe cartões de embarque, bilhetes e outros documentos para fortalecer a sua reclamação.';

  @override
  String get scanDocument => 'Digitalizar Documento';

  @override
  String get uploadDocument => 'Carregar Documento';

  @override
  String get scanDocumentHint =>
      'Usar a câmara para preencher automaticamente o formulário';

  @override
  String get uploadDocumentHint => 'Selecionar do armazenamento do dispositivo';

  @override
  String get noDocumentsYet => 'Ainda não há documentos anexados';

  @override
  String get enterFlightNumberFirst =>
      'Por favor, introduza primeiro um número de voo';

  @override
  String get viewAll => 'Ver Tudo';

  @override
  String get documentScanner => 'Scanner de Documentos';

  @override
  String get profileInformation => 'Informação do Perfil';

  @override
  String get editPersonalInformation => 'Editar as suas informações pessoais';

  @override
  String get editPersonalAndContactInformation =>
      'Editar as suas informações pessoais e de contacto';

  @override
  String get configureAccessibilityOptions =>
      'Configurar as opções de acessibilidade da aplicação';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport =>
      'Configurar contraste elevado, texto grande e suporte para leitor de ecrã';

  @override
  String get applicationPreferences => 'Preferências da Aplicação';

  @override
  String get notificationSettings => 'Definições de Notificação';

  @override
  String get configureNotificationPreferences =>
      'Configurar preferências de notificação';

  @override
  String get configureHowYouReceiveClaimUpdates =>
      'Configurar como recebe atualizações de reclamações';

  @override
  String get language => 'Idioma';

  @override
  String get changeApplicationLanguage => 'Alterar idioma da aplicação';

  @override
  String get selectYourPreferredLanguage => 'Selecione o seu idioma preferido';

  @override
  String get tipsAndReminders => 'Dicas e Lembretes';

  @override
  String get importantTipsAboutProfileInformation =>
      'Dicas importantes sobre as informações do seu perfil';

  @override
  String get noClaimsYetTitle => 'Ainda Não Há Reclamações';

  @override
  String get noClaimsYetSubtitle =>
      'Comece a sua reclamação de compensação selecionando um voo na secção Voos Elegíveis da UE';

  @override
  String get extractingText => 'A extrair texto e a identificar campos';

  @override
  String get scanInstructions =>
      'Posicione o seu documento dentro da moldura e tire uma foto';

  @override
  String get formFilledWithScannedData =>
      'Formulário preenchido com dados do documento digitalizado';

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
  String get claimNotFound => 'Reclamação não encontrada';

  @override
  String get claimNotFoundDesc =>
      'A reclamação solicitada não pôde ser encontrada. Pode ter sido excluída.';

  @override
  String get backToDashboard => 'Voltar ao painel';

  @override
  String get euWideEligibleFlights =>
      'Voos elegíveis para compensação em toda a UE';

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
  String get retry => 'Tentar novamente';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get requiredFieldsCompleted =>
      'Todos os campos obrigatórios estão preenchidos.';

  @override
  String get scanningDocumentsNote =>
      'A digitalização de documentos pode pré-preencher alguns campos.';

  @override
  String get tipCheckEligibility =>
      '• Certifique-se de que o seu voo é elegível para compensação (ex: atraso >3h, cancelamento, recusa de embarque).';

  @override
  String get tipDoubleCheckDetails =>
      '• Verifique todos os detalhes antes de submeter para evitar atrasos.';

  @override
  String get tooltipFaqHelp =>
      'Aceder às perguntas frequentes e secção de ajuda';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Erro ao submeter o formulário: $errorMessage. Verifique a sua ligação e tente novamente.';
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
  String get processingDocument => 'Processando documento...';

  @override
  String get fieldValue => 'Valor do Campo';

  @override
  String get errorConnectionFailed =>
      'Falha na ligação. Por favor, verifique a sua rede.';

  @override
  String lastHours(int hours) {
    return 'Últimas $hours horas';
  }

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Nenhum voo corresponde ao filtro: $filter';
  }

  @override
  String get forceRefreshData => 'Forçar atualização de dados';

  @override
  String get forcingFreshDataLoad =>
      'Forçando uma nova atualização de dados...';

  @override
  String get checkAgain => 'Verificar novamente';

  @override
  String get euWideCompensationEligibleFlights =>
      'Voos elegíveis para compensação na UE';

  @override
  String get noEligibleFlightsFound => 'Nenhum voo elegível encontrado';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Nenhum voo encontrado nas últimas $hours horas.';
  }

  @override
  String get apiConnectionIssue =>
      'Problema de conexão com a API. Por favor, tente novamente.';

  @override
  String get createClaim => 'Criar solicitação';

  @override
  String get submitted => 'Enviado';

  @override
  String get inReview => 'Em análise';

  @override
  String get processing => 'Processando';

  @override
  String get approved => 'Aprovado';

  @override
  String get rejected => 'Rejeitado';

  @override
  String get paid => 'Pago';

  @override
  String get underAppeal => 'Em recurso';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get authenticationRequired => 'Autenticação Necessária';

  @override
  String get errorLoadingClaims => 'Erro ao carregar solicitações';

  @override
  String get loginToViewClaimsDashboard =>
      'Por favor, faça login para ver o seu painel de solicitações';

  @override
  String get logIn => 'Entrar';

  @override
  String claimForFlight(Object number, Object status) {
    return 'Solicitação para voo $number - $status';
  }

  @override
  String flightRouteDetails(Object number, Object departure, Object arrival) {
    return 'Voo $number: $departure - $arrival';
  }

  @override
  String get viewClaimDetails => 'Ver detalhes da solicitação';

  @override
  String get totalCompensation => 'Compensação Total';

  @override
  String get pendingAmount => 'Valor Pendente';

  @override
  String get pending => 'Pendente';

  @override
  String get claimsDashboard => 'Painel de Solicitações';

  @override
  String get refreshDashboard => 'Atualizar Painel';

  @override
  String get claimsSummary => 'Resumo das Solicitações';

  @override
  String get totalClaims => 'Total de Solicitações';

  @override
  String get accessibilitySettings => 'Configurações de Acessibilidade';

  @override
  String get configureAccessibility => 'Configurar opções de acessibilidade';

  @override
  String get configureNotifications => 'Configurar notificações';

  @override
  String get notificationSettingsComingSoon =>
      'Configurações de notificações em breve!';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get editPersonalInfo => 'Editar Informações Pessoais';

  @override
  String get editPersonalInfoDescription =>
      'Atualize seus dados pessoais, endereço e informações de contato';

  @override
  String errorSigningOut(String error) {
    return 'Erro ao sair: $error';
  }

  @override
  String get signInOrSignUp => 'Entrar / Cadastrar-se';

  @override
  String get genericUser => 'Usuário';

  @override
  String get dismiss => 'Dispensar';

  @override
  String get signInToTrackClaims => 'Entre para acompanhar suas solicitações';

  @override
  String get createAccountDescription =>
      'Crie uma conta para acompanhar facilmente todas as suas solicitações de compensação';

  @override
  String get continueToAttachmentsButton => 'Continuar para Anexos';

  @override
  String get continueToReview => 'Continue to Review';

  @override
  String get country => 'País';

  @override
  String get privacySettings => 'Configurações de Privacidade';

  @override
  String get consentToShareData => 'Consentimento para Compartilhar Dados';

  @override
  String get requiredForProcessing =>
      'Necessário para processar suas solicitações';

  @override
  String get receiveNotifications => 'Receber Notificações';

  @override
  String get getClaimUpdates => 'Receba atualizações sobre suas solicitações';

  @override
  String get saveProfile => 'Salvar Perfil';

  @override
  String get passportNumber => 'Número do Passaporte';

  @override
  String get nationality => 'Nacionalidade';

  @override
  String get dateOfBirth => 'Data de Nascimento';

  @override
  String get dateFormat => 'DD/MM/AAAA';

  @override
  String get address => 'Endereço';

  @override
  String get city => 'Cidade';

  @override
  String get postalCode => 'Código Postal';

  @override
  String get errorLoadingProfile => 'Erro ao carregar perfil';

  @override
  String get profileSaved => 'Perfil salvo com sucesso';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get profileAccuracyInfo =>
      'Por favor, certifique-se de que as informações do seu perfil estão precisas';

  @override
  String get keepProfileUpToDate => 'Mantenha seu perfil atualizado';

  @override
  String get profilePrivacy => 'Protegemos sua privacidade e dados';

  @override
  String get correctContactDetails =>
      'Dados de contato corretos ajudam com a compensação';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get attachDocuments => 'Anexar Documentos';

  @override
  String get uploadingDocument => 'Enviando documento...';

  @override
  String get noDocuments => 'Você não tem documentos.';

  @override
  String get uploadFirstDocument => 'Enviar Primeiro Documento';

  @override
  String get uploadNew => 'Enviar Novo';

  @override
  String get documentUploadSuccess => 'Documento enviado com sucesso!';

  @override
  String get uploadFailed => 'Falha no envio. Por favor, tente novamente.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get claimAttachment => 'Anexo de Reclamação';

  @override
  String get other => 'outro';

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
