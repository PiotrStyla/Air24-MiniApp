// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get euCompensation => 'Compensação UE';

  @override
  String get scheduledLabel => 'Programado:';

  @override
  String get minutes => 'minutos';

  @override
  String get aircraftLabel => 'Aeronave:';

  @override
  String get prefillCompensationForm =>
      'Pré-preencher Formulário de Compensação';

  @override
  String get confirmAndSend => 'Confirmar e Enviar';

  @override
  String get errorLoadingEmailDetails => 'Erro ao carregar detalhes do email';

  @override
  String get noEmailInfo => 'Nenhuma informação de email disponível';

  @override
  String get finalConfirmation => 'Confirmação Final';

  @override
  String get claimWillBeSentTo => 'A sua reclamação será enviada para:';

  @override
  String get copyToYourEmail => 'Uma cópia será enviada para o seu email:';

  @override
  String get previewEmail => 'Pré-visualizar Email';

  @override
  String get confirmAndSendEmail => 'Confirmar e Enviar Email';

  @override
  String get attachmentsInfoNextStep =>
      'You can add attachments (e.g., tickets, boarding passes) in the next step.';

  @override
  String get departureAirport => 'Aeroporto de Partida';

  @override
  String get arrivalAirport => 'Aeroporto de Chegada';

  @override
  String get reasonForClaim => 'Motivo da Reclamação';

  @override
  String get flightCancellationReason =>
      'Cancelamento de voo - solicitando compensação sob o regulamento EU261 por voo cancelado';

  @override
  String get flightDelayReason =>
      'Atraso de voo superior a 3 horas - solicitando compensação sob o regulamento EU261 por atraso significativo';

  @override
  String get flightDiversionReason =>
      'Desvio de voo - solicitando compensação sob o regulamento EU261 por voo desviado';

  @override
  String get eu261CompensationReason =>
      'Solicitando compensação sob o regulamento EU261 por interrupção de voo';

  @override
  String get attachments => 'Anexos';

  @override
  String get proceedToConfirmation => 'Prosseguir para Confirmação';

  @override
  String emailAppOpenedMessage(String email) {
    return 'A sua aplicação de email foi aberta';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'Falha ao submeter reclamação. Tente novamente.';
  }

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get claimNotFound => 'Reclamação não encontrada';

  @override
  String get claimNotFoundDesc =>
      'A reclamação solicitada não pôde ser encontrada. Pode ter sido excluída.';

  @override
  String get backToDashboard => 'Voltar ao painel';

  @override
  String get reviewYourClaim => 'Rever a Sua Reclamação';

  @override
  String get reviewClaimDetails => 'Rever Detalhes da Reclamação';

  @override
  String get flightNumber => 'Número do Voo';

  @override
  String get flightDate => 'Data do Voo';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Nenhum voo corresponde ao filtro: $filter';
  }

  @override
  String get statusLabel => 'Estado:';

  @override
  String get flightStatusDelayed => 'Atrasado';

  @override
  String get potentialCompensation => 'Compensação Potencial';

  @override
  String get claimDetails => 'Detalhes da Reclamação';

  @override
  String get refresh => 'Atualizar';

  @override
  String get errorLoadingClaim => 'Erro ao Carregar Reclamação';

  @override
  String get euWideCompensationEligibleFlights =>
      'Voos elegíveis para compensação na UE';

  @override
  String get forceRefreshData => 'Forçar atualização de dados';

  @override
  String get forcingFreshDataLoad =>
      'Forçando uma nova atualização de dados...';

  @override
  String get loadingExternalData => 'Carregando Dados Externos';

  @override
  String get loadingExternalDataDescription =>
      'Aguarde enquanto buscamos os dados de voo mais recentes...';

  @override
  String lastHours(int hours) {
    return 'Últimas $hours horas';
  }

  @override
  String get errorConnectionFailed =>
      'Falha na ligação. Por favor, verifique a sua rede.';

  @override
  String formSubmissionError(String error) {
    return 'Erro ao submeter o formulário: $error. Verifique a sua ligação e tente novamente.';
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
      'Problema de conexão com a API. Por favor, tente novamente.';

  @override
  String get noEligibleFlightsFound => 'Nenhum voo elegível encontrado';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Nenhum voo encontrado nas últimas $hours horas.';
  }

  @override
  String get checkAgain => 'Verificar novamente';

  @override
  String get filterByAirline => 'Filtrar por companhia aérea';

  @override
  String get saveDocument => 'Guardar Documento';

  @override
  String get fieldName => 'Nome do Campo';

  @override
  String get fieldValue => 'Valor do Campo';

  @override
  String get noFieldsExtracted => 'Nenhum campo foi extraído do documento.';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get networkError => 'Erro de rede';

  @override
  String get generalError => 'Erro geral';

  @override
  String get loginRequiredForClaim =>
      'Login necessário para enviar a reclamação';

  @override
  String get aspectRatio => 'Proporção';

  @override
  String get documentOcrResult => 'Resultado OCR';

  @override
  String get extractedFields => 'Campos Extraídos';

  @override
  String get fullText => 'Texto Completo';

  @override
  String get extractedInformation => 'Informação Extraída';

  @override
  String get rawOcrText => 'Texto OCR Bruto';

  @override
  String get copyAllText => 'Copiar Todo o Texto';

  @override
  String get fillForm => 'Preencher Formulário';

  @override
  String get chooseUseInfo => 'Escolha como usar esta informação:';

  @override
  String get fillPassengerFlight =>
      'Preencher informações do passageiro e do voo';

  @override
  String get flightSearch => 'Pesquisa de Voos';

  @override
  String get searchFlightNumber => 'Pesquisar por número de voo';

  @override
  String get done => 'Concluído';

  @override
  String get documentSaved => 'Documento guardado.';

  @override
  String get useExtractedData => 'Usar Dados Extraídos';

  @override
  String get copyToClipboard => 'Copiado para a área de transferência.';

  @override
  String get documentType => 'Tipo de Documento';

  @override
  String get submitClaim => 'Submeter Reclamação';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get resend => 'Resend';

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
  String get rotate => 'Rodar';

  @override
  String get airline => 'Companhia Aérea';

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
  String get languageSelection => 'Idioma';

  @override
  String get passengerName => 'Nome do Passageiro';

  @override
  String get passengerDetails => 'Detalhes do Passageiro';

  @override
  String get appTitle => 'Compensação de Voo';

  @override
  String get welcomeMessage => 'Bem-vindo à aplicação!';

  @override
  String get home => 'Início';

  @override
  String get settings => 'Definições';

  @override
  String get required => 'Obrigatório';

  @override
  String get emailAddress => 'Endereço de e-mail';

  @override
  String get documentDeleteFailed => 'Falha ao excluir documento';

  @override
  String get uploadNew => 'Enviar Novo';

  @override
  String get continueAction => 'Continuar';

  @override
  String get compensationClaimForm => 'Formulário de Reclamação de Compensação';

  @override
  String get flight => 'Voo';

  @override
  String get passengerInformation => 'Informações do passageiro';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get downloadPdf => 'Baixar PDF';

  @override
  String get filePreviewNotAvailable =>
      'Pré-visualização do arquivo não disponível';

  @override
  String get noFileSelected => 'Nenhum arquivo selecionado';

  @override
  String get preview => 'Visualizar';

  @override
  String get downloadStarting => 'Iniciando download...';

  @override
  String get fileTypeLabel => 'Tipo de arquivo:';

  @override
  String get failedToLoadImage => 'Falha ao carregar a imagem';

  @override
  String get deleteDocument => 'Excluir documento';

  @override
  String get deleteDocumentConfirmation =>
      'Tem certeza de que deseja excluir este documento?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get documentDeletedSuccess => 'Documento excluído com sucesso';

  @override
  String get attachDocuments => 'Anexar Documentos';

  @override
  String get uploadingDocument => 'Enviando documento...';

  @override
  String get noDocuments => 'Você não tem documentos.';

  @override
  String get uploadFirstDocument => 'Enviar Primeiro Documento';

  @override
  String get claimAttachment => 'Anexo de Reclamação';

  @override
  String get other => 'outro';

  @override
  String get pdfPreviewMessage => 'Prévia do PDF';

  @override
  String get tipsAndRemindersTitle => 'Dicas e lembretes';

  @override
  String get tipSecureData => 'Seus dados são seguros e criptografados';

  @override
  String get tipCheckEligibility =>
      '• Certifique-se de que o seu voo é elegível para compensação (ex: atraso >3h, cancelamento, recusa de embarque).';

  @override
  String get tipDoubleCheckDetails =>
      '• Verifique todos os detalhes antes de submeter para evitar atrasos.';

  @override
  String get documentUploadSuccess => 'Documento enviado com sucesso!';

  @override
  String get uploadFailed => 'Falha no envio. Por favor, tente novamente.';

  @override
  String get reasonForClaimHint =>
      'Descreva porque está a apresentar esta reclamação';

  @override
  String get validatorReasonRequired => 'O motivo da reclamação é obrigatório';

  @override
  String get tooltipReasonQuickClaim =>
      'Explique porque considera ter direito a indemnização';

  @override
  String get compensationAmountOptionalLabel =>
      'Valor de compensação solicitado (opcional)';

  @override
  String get compensationAmountHint =>
      'Informe um valor se tiver um pedido específico';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Você pode informar um valor de compensação ou deixar em branco';

  @override
  String get continueToReview => 'Continuar para revisão';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Informe o aeroporto de partida';

  @override
  String get arrivalAirportHintQuickClaim =>
      'Digite o código ou nome do aeroporto (ex.: LHR, London Heathrow)';

  @override
  String get validatorArrivalAirportRequired =>
      'O aeroporto de chegada é obrigatório';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Informe o aeroporto de chegada';

  @override
  String get reasonForClaimLabel => 'Motivo da Reclamação';

  @override
  String get hintTextReasonQuickClaim =>
      'Descreva aqui o motivo da sua reclamação';

  @override
  String get flightNumberHintQuickClaim =>
      'Digite o número do voo (ex.: LH123)';

  @override
  String get validatorFlightNumberRequired => 'O número do voo é obrigatório';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Informe o número do voo para sua reclamação';

  @override
  String get tooltipFlightDateQuickClaim => 'Selecione a data do seu voo';

  @override
  String get departureAirportHintQuickClaim =>
      'Digite o código ou nome do aeroporto (ex.: LHR, London Heathrow)';

  @override
  String get validatorDepartureAirportRequired =>
      'O aeroporto de partida é obrigatório';

  @override
  String get underAppeal => 'Em recurso';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get errorMustBeLoggedIn =>
      'Você deve estar conectado para enviar uma reclamação';

  @override
  String get dialogTitleError => 'Erro';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get quickClaimTitle => 'Formulário de reclamação rápida';

  @override
  String get tooltipFaqHelp =>
      'Aceder às perguntas frequentes e secção de ajuda';

  @override
  String get quickClaimInfoBanner =>
      'Preencha este formulário para enviar rapidamente uma reclamação de compensação pelo seu voo. Vamos ajudar você no processo.';

  @override
  String get createClaim => 'Criar solicitação';

  @override
  String get submitted => 'Enviado';

  @override
  String get inReview => 'Em análise';

  @override
  String get actionRequired => 'Ação Necessária';

  @override
  String get processing => 'Processando';

  @override
  String get approved => 'Aprovado';

  @override
  String get rejected => 'Rejeitado';

  @override
  String get paid => 'Pago';

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
    return 'Voo $flightNumber: $departure - $arrival';
  }

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
  String get noClaimsYet => 'Ainda não há solicitações';

  @override
  String get startCompensationClaimInstructions =>
      'Inicie sua solicitação de compensação selecionando um voo na seção Voos elegíveis para a UE';

  @override
  String get claimsDashboard => 'Painel de Solicitações';

  @override
  String get refreshDashboard => 'Atualizar Painel';

  @override
  String get claimsSummary => 'Resumo das Solicitações';

  @override
  String get totalClaims => 'Total de Solicitações';

  @override
  String get totalCompensation => 'Compensação Total';

  @override
  String get pendingAmount => 'Valor Pendente';

  @override
  String get receivedAmount => 'Received';

  @override
  String get noClaimsYetTitle => 'Ainda Não Há Reclamações';

  @override
  String get noRecentEvents => 'No recent events';

  @override
  String get pending => 'Pendente';

  @override
  String get viewClaimDetails => 'Ver detalhes da solicitação';

  @override
  String claimForFlight(String flightNumber, String status) {
    return 'Solicitação para voo $flightNumber - $status';
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
      'Configurar como recebe atualizações de reclamações';

  @override
  String get notificationSettingsComingSoon =>
      'Configurações de notificações em breve!';

  @override
  String get changeApplicationLanguage => 'Alterar idioma da aplicação';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get tipsAndReminders => 'Dicas e Lembretes';

  @override
  String get tipProfileUpToDate => 'Mantenha seu perfil atualizado';

  @override
  String get tipInformationPrivate => 'Suas informações são privadas';

  @override
  String get tipContactDetails => 'Detalhes de Contato';

  @override
  String get tipAccessibilitySettings => 'Configurações de Acessibilidade';

  @override
  String get active => 'Ativa';

  @override
  String get completed => 'Concluída';

  @override
  String get events => 'Events';

  @override
  String get genericUser => 'Usuário';

  @override
  String get signOut => 'Sair';

  @override
  String errorSigningOut(String error) {
    return 'Erro ao sair: $error';
  }

  @override
  String get profileInformation => 'Informação do Perfil';

  @override
  String get profileInfoCardTitle =>
      'O seu perfil contém as suas informações pessoais e de contacto. Estas são usadas para processar as suas reclamações de compensação de voo e mantê-lo informado.';

  @override
  String get accountSettings => 'Definições da Conta';

  @override
  String get editPersonalInfo => 'Editar Informações Pessoais';

  @override
  String get editPersonalInfoDescription =>
      'Atualize seus dados pessoais, endereço e informações de contato';

  @override
  String get accessibilitySettings => 'Configurações de acessibilidade';

  @override
  String get configureAccessibility => 'Configurar opções de acessibilidade';

  @override
  String get accessibilityOptions => 'Opções de acessibilidade';

  @override
  String get configureAccessibilityDescription =>
      'Configurar contraste elevado, texto grande e suporte para leitor de ecrã';

  @override
  String get notificationSettings => 'Definições de Notificação';

  @override
  String get configureNotifications => 'Configurar notificações';

  @override
  String get eu261Rights =>
      'Sob o regulamento EU261, você tem direito à compensação por:\n• Atrasos de 3+ horas\n• Cancelamentos de voos\n• Negação de embarque\n• Desvios de voos';

  @override
  String get dontLetAirlinesWin =>
      'Não deixe as companhias aéreas evitarem pagar o que você merece!';

  @override
  String get submitClaimAnyway => 'Enviar Reclamação Mesmo Assim';

  @override
  String get newClaim => 'Nova Reclamação';

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
      'Verificar elegibilidade para compensação';

  @override
  String get euEligibleFlightsButtonText =>
      'Voos elegíveis para compensação na UE';

  @override
  String welcomeUser(String name, String role, Object userName) {
    return 'Bem-vindo, $userName';
  }

  @override
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get contactAirlineForClaim => 'Contact Airline for Claim';

  @override
  String get flightMightNotBeEligible =>
      'Com base nos dados disponíveis, seu voo pode não ser elegível para compensação.';

  @override
  String get knowYourRights => 'Conheça Seus Direitos';

  @override
  String get airlineDataDisclaimer =>
      'As companhias aéreas às vezes subestimam atrasos ou alteram status de voos. Se você experimentou um atraso de 3+ horas, cancelamento ou desvio, ainda pode ter direito à compensação.';

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
      'Verificador de Compensação de Voo';

  @override
  String get checkEligibilityForEu261 =>
      'Verificar elegibilidade para compensação EU 261';

  @override
  String get flightNumberPlaceholder => 'Número do voo (ex. LO123)';

  @override
  String get pleaseEnterFlightNumber => 'Por favor insira um número de voo';

  @override
  String get dateOptionalPlaceholder => 'Data do voo (opcional)';

  @override
  String get leaveDateEmptyForToday => 'Deixe em branco para a data de hoje';

  @override
  String get checkCompensationEligibility =>
      'Verificar Elegibilidade para Compensação';

  @override
  String get continueToAttachmentsButton => 'Continuar para Anexos';

  @override
  String get flightNotFoundError =>
      'Voo não encontrado. Por favor, verifique o número do voo e tente novamente.';

  @override
  String get invalidFlightNumberError =>
      'Formato de número de voo inválido. Por favor, insira um número de voo válido (ex. BA123, LH456).';

  @override
  String get networkTimeoutError =>
      'Tempo limite de conexão excedido. Por favor, verifique sua conexão com a internet e tente novamente.';

  @override
  String get serverError =>
      'Servidor temporariamente indisponível. Por favor, tente mais tarde.';

  @override
  String get rateLimitError =>
      'Muitas solicitações. Por favor, aguarde um momento e tente novamente.';

  @override
  String get generalFlightCheckError =>
      'Não foi possível verificar as informações do voo. Verifique os dados do voo e tente novamente.';

  @override
  String get receiveNotifications => 'Receber Notificações';

  @override
  String get getClaimUpdates => 'Receba atualizações sobre suas solicitações';

  @override
  String get saveProfile => 'Salvar Perfil';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Endereço';

  @override
  String get city => 'Cidade';

  @override
  String get country => 'País';

  @override
  String get postalCode => 'Código Postal';

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
  String get phoneNumber => 'Número de Telefone';

  @override
  String get passportNumber => 'Número do Passaporte';

  @override
  String get nationality => 'Nacionalidade';

  @override
  String get dateOfBirth => 'Data de Nascimento';

  @override
  String get dateFormat => 'DD/MM/AAAA';

  @override
  String get privacySettings => 'Configurações de Privacidade';

  @override
  String get consentToShareData => 'Consentimento para Compartilhar Dados';

  @override
  String get requiredForProcessing =>
      'Necessário para processar suas solicitações';

  @override
  String get claims => 'Reclamações';

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
  String get supportOurMission => 'Apoie Nossa Missão';

  @override
  String get helpKeepAppFree =>
      'Ajude-nos a manter este aplicativo gratuito e apoiar cuidados paliativos';

  @override
  String get yourContributionMakesDifference =>
      'Sua contribuição faz a diferença';

  @override
  String get hospiceFoundation => 'Hospice Foundation';

  @override
  String get appDevelopment => 'App Development';

  @override
  String get comfortCareForPatients => 'Comfort and care for patients';

  @override
  String get newFeaturesAndImprovements => 'Novos recursos e melhorias';

  @override
  String get chooseYourSupportAmount => 'Choose your support amount:';

  @override
  String get totalDonation => 'Total Donation';

  @override
  String get donationSummary => 'Donation Summary';

  @override
  String get choosePaymentMethod => 'Escolha o método de pagamento:';

  @override
  String get paymentMethod => 'Método de Pagamento';

  @override
  String get creditDebitCard => 'Cartão de Crédito/Débito';

  @override
  String get visaMastercardAmericanExpress =>
      'Visa, Mastercard, American Express';

  @override
  String get payWithPayPalAccount => 'Pagar com sua conta PayPal';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get notAvailableOnThisDevice => 'Not available on this device';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get quickAndSecure => 'Rápido e seguro';

  @override
  String get smallSupport => 'Pequeno Apoio';

  @override
  String get goodSupport => 'Bom Apoio';

  @override
  String get greatSupport => 'Grande Apoio';

  @override
  String yourAmountHelps(String amount) {
    return 'Seu $amount ajuda:';
  }

  @override
  String get hospicePatientCare => 'Cuidados com pacientes de hospício';

  @override
  String get appImprovements => 'Melhorias do aplicativo';

  @override
  String continueWithAmount(String amount) {
    return 'Continuar com $amount';
  }

  @override
  String get selectAnAmount => 'Select an amount';

  @override
  String get maybeLater => 'Talvez mais tarde';

  @override
  String get securePaymentInfo =>
      'Secure payment • No hidden fees • Tax receipt';

  @override
  String get learnMoreHospiceFoundation =>
      'Saiba mais sobre a Fundação Hospício: fundacja-hospicjum.org';

  @override
  String get touchIdOrFaceId => 'Touch ID ou Face ID';

  @override
  String get continueToPayment => 'Continuar para Pagamento';

  @override
  String get selectAPaymentMethod => 'Selecione um método de pagamento';

  @override
  String get securePayment => 'Pagamento Seguro';

  @override
  String get paymentSecurityInfo =>
      'Suas informações de pagamento são criptografadas e seguras. Não armazenamos os detalhes do seu pagamento.';

  @override
  String get taxReceiptEmail => 'O recibo fiscal será enviado para o seu email';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, American Express';

  @override
  String get notAvailableOnDevice => 'Não disponível neste dispositivo';

  @override
  String get comfortAndCareForPatients => 'Conforto e cuidado para pacientes';

  @override
  String get chooseSupportAmount => 'Escolha o valor do seu apoio:';

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
  String get predictingDelay => 'Prevendo atraso…';

  @override
  String get predictionUnavailable => 'Previsão indisponível';

  @override
  String delayRiskPercent(int risk) {
    return 'Risco de atraso $risk%';
  }

  @override
  String avgMinutesShort(int minutes) {
    return 'Méd. $minutes min';
  }

  @override
  String get attachmentGuidanceTitle => 'Attachments';

  @override
  String get emailPreviewAttachmentGuidance =>
      'Você poderá adicionar anexos no próximo passo. Por favor, lembre-se de incluir apenas ficheiros nos formatos JPG, PNG ou PDF.';
}
