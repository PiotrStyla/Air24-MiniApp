import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart' as app;
import 'localization_service.dart';

/// A manual localization service that loads strings directly from ARB files
/// without relying on Flutter's code generation.
/// 
/// This is a workaround for cases where Flutter's localization generation fails.
class ManualLocalizationService extends ChangeNotifier {
  static const String LANGUAGE_CODE = 'languageCode';
  static const String COUNTRY_CODE = 'countryCode';
  
  // Global key to force app rebuilds on locale changes
  static final ValueNotifier<int> rebuildNotifier = ValueNotifier<int>(0);
  
  /// Force global rebuild of all widgets listening to this notifier
  static void forceAppRebuild() {
    debugPrint('ManualLocalizationService: Forcing global app rebuild');
    rebuildNotifier.value++;
  }
  
  /// Ensure language is loaded without changing the current locale
  /// This is useful for preloading languages before they're needed
  Future<void> ensureLanguageLoaded(String languageCode) async {
    try {
      debugPrint('Ensuring language is loaded: $languageCode');
      
      // Skip if we've already loaded this language
      if (_allStrings.containsKey(languageCode) && 
          (_allStrings[languageCode]?.isNotEmpty ?? false)) {
        debugPrint('Language $languageCode already loaded with ${_allStrings[languageCode]?.length} keys');
        return;
      }
      
      // Load the language without changing the current locale
      await _loadStrings(languageCode);
      
      debugPrint('Successfully loaded language: $languageCode');
    } catch (e) {
      debugPrint('Error ensuring language loaded for $languageCode: $e');
    }
  }
  
  // All supported languages
  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
    const Locale('pt', 'BR'),
    const Locale('pl', 'PL'),
  ];
  
  /// Language names for the UI
  static final Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'pt': 'Português',
    'pl': 'Polski',
  };
  
  /// Maps to store localized strings for each supported locale
  final Map<String, Map<String, dynamic>> _allStrings = {
    'en': {},
    'pt': {},
  };
  
  /// Current active localization strings
  Map<String, dynamic> _strings = {};
  
  /// For placeholder replacements
  Map<String, String> _replacements = {};
  
  /// Default locale
  Locale _currentLocale = const Locale('en');
  
  /// Flag to track if we've loaded English and Portuguese
  bool _hasLoadedAllLanguages = false;
  
  /// Keep track of initialization state
  bool _isInitialized = false;
  
  /// Private constructor for singleton pattern
  ManualLocalizationService._() {
    // Initialize asynchronously
    _init();
  }
  
  /// Singleton instance
  static final ManualLocalizationService _instance = ManualLocalizationService._();
  
  /// Factory constructor to return the same instance
  factory ManualLocalizationService() => _instance;
  
  /// Check if service is ready to use
  bool get isReady => _isInitialized;
  
  /// Get the current locale for debugging
  Locale getCurrentLocale() => _currentLocale;
  
  /// Get the current locale
  Locale get currentLocale => _currentLocale;
  
  /// Get localized string for the given key
  String? getString(String key) {
    String? value = _strings[key] as String?;
    
    // If not found in current locale and it's not English, try English fallback
    if (value == null && _currentLocale.languageCode != 'en') {
      value = _allStrings['en']?[key] as String?;
    }
    
    return value;
  }
  
  /// Initialize the service by loading stored preferences and strings for both English and Portuguese
  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(LANGUAGE_CODE);
      final countryCode = prefs.getString(COUNTRY_CODE);
      
      // Set the current locale based on stored preferences
      if (languageCode != null) {
        _currentLocale = Locale(languageCode, countryCode);
      }
      
      // Load English strings (always as fallback)
      await _loadStrings('en');
      
      // Load Portuguese strings (our focus language)
      await _loadStrings('pt');
      
      // Finally load the current locale if it's different
      if (_currentLocale.languageCode != 'en' && _currentLocale.languageCode != 'pt') {
        await _loadStrings(_currentLocale.languageCode);
      }
      
      _hasLoadedAllLanguages = true;
      _isInitialized = true;
      
      // Set active strings to the current locale
      _strings = _allStrings[_currentLocale.languageCode] ?? _allStrings['en']!;
      
      notifyListeners();
      debugPrint('ManualLocalizationService initialized with locale: ${_currentLocale.languageCode}');
    } catch (e) {
      debugPrint('Error initializing ManualLocalizationService: $e');
      // Ensure we have at least empty maps to prevent null errors
      _allStrings['en'] ??= {};
      _allStrings['pt'] ??= {};
      _strings = _allStrings['en']!;
    }
  }
  
  /// Load localization strings from ARB file for a specific language
  /// Stores the strings in _allStrings[languageCode]
  Future<void> _loadStrings(String languageCode) async {
    try {
      debugPrint('Loading translation strings for language: $languageCode');
      
      // First try loading from ARB files
      try {
        // Load the ARB file for the requested language
        final String arbPath = 'lib/l10n/app_$languageCode.arb';
        debugPrint('Attempting to load ARB file: $arbPath');
        final String data = await rootBundle.loadString(arbPath);
        final parsedData = json.decode(data) as Map<String, dynamic>;
        
        // Store in our all strings map
        _allStrings[languageCode] = parsedData;
        
        // If this is the current language, update the active strings
        if (languageCode == _currentLocale.languageCode) {
          _strings = parsedData;
        }
        
        debugPrint('Successfully loaded ${parsedData.length} strings from ARB for $languageCode');
      } catch (e) {
        // ARB file loading failed, use hardcoded translations for testing
        debugPrint('Error loading ARB file for $languageCode: $e');
        debugPrint('Using hardcoded translations instead for $languageCode');
        
        // Use a hardcoded set of strings for each language for testing purposes
        final Map<String, dynamic> hardcodedStrings = _getHardcodedStrings(languageCode);
        
        // Store the hardcoded strings
        _allStrings[languageCode] = hardcodedStrings;
        
        // If this is the current language, update the active strings
        if (languageCode == _currentLocale.languageCode) {
          _strings = hardcodedStrings;
        }
        
        debugPrint('Successfully loaded ${hardcodedStrings.length} hardcoded strings for $languageCode');
      }
      
      // Diagnostic: Log some sample keys to verify content
      if (_allStrings[languageCode]?.isNotEmpty ?? false) {
        final sampleKeys = _allStrings[languageCode]!.keys.take(5).toList();
        debugPrint('Sample keys for $languageCode: $sampleKeys');
      }
      
      // Add some critical fallback translations if we're loading a non-English language
      // This ensures core functionality will work even if some translations are missing
      if (languageCode != 'en') {
        Map<String, dynamic>? englishStrings = _allStrings['en'];
        
        // Make sure we have English loaded as a fallback
        if (englishStrings == null || englishStrings.isEmpty) {
          debugPrint('Loading English as fallback for $languageCode');
          await _loadStrings('en'); // Recursively load English if needed
          englishStrings = _allStrings['en']; // Get the loaded English strings
        }
        
        // List of critical keys that must be present for the app to function
        final List<String> criticalKeys = [
          'euWideCompensation',
          'filterByAirline',
          'last72Hours', 
          'apiConnectionIssue',
          'returnToHome',
          'viewDetails',
          'euCompensationEligible'
        ];
        
        // Ensure all critical keys exist
        int missingCount = 0;
        for (final key in criticalKeys) {
          if (!_allStrings[languageCode]!.containsKey(key) && englishStrings!.containsKey(key)) {
            _allStrings[languageCode]![key] = englishStrings[key];
            missingCount++;
          }
        }
        
        if (missingCount > 0) {
          debugPrint('Added $missingCount missing critical keys to $languageCode using English fallbacks');
        }
      }
      
      // For Portuguese specifically, ensure we have all needed keys from hardcoded values
      if (languageCode == 'pt') {
        _addCriticalPortugueseStrings();
      }
      
      // Update active strings if this is the current language
      if (languageCode == _currentLocale.languageCode) {
        _strings = _allStrings[languageCode]!;
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error loading strings for $languageCode: $e');
      // Fall back to English if we can't load the requested language
      if (languageCode != 'en') {
        await _loadStrings('en');
      } else {
        // Create empty map to avoid null errors
        _strings = {};
        _allStrings[languageCode] = {};
      }
    }
  }
  
  /// Change the app locale and load strings for that locale
  Future<void> changeLocale(Locale locale) async {
    debugPrint('ManualLocalizationService.changeLocale called with locale: $locale');
    
    // Always proceed with loading, even if language codes match
    // This ensures translations are refreshed
    _currentLocale = locale;
    
    // Always force a reload of strings to ensure we have the most up-to-date translations
    debugPrint('Force loading strings for ${locale.languageCode}');
    await _loadStrings(locale.languageCode);
    
    // Make sure our active strings are updated
    _strings = _allStrings[locale.languageCode] ?? _allStrings['en'] ?? {};
    
    // Log some diagnostic info about loaded translations
    debugPrint('Loaded ${_strings.length} strings for ${locale.languageCode}');
    if (_strings.isNotEmpty) {
      // Log a sample of keys to verify content
      final sampleKeys = _strings.keys.take(5).join(', ');
      debugPrint('Sample keys: $sampleKeys');
    } else {
      debugPrint('WARNING: No strings loaded for ${locale.languageCode}');
    }
    
    // Persist the locale preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString(COUNTRY_CODE, locale.countryCode!);
    } else {
      await prefs.remove(COUNTRY_CODE);
    }
    
    // Notify listeners to trigger UI updates
    notifyListeners();
    debugPrint('ManualLocalizationService locale changed to: ${locale.languageCode}');
  }
  
  /// Force a complete reload of all translations for the given locale
  /// This is more aggressive than changeLocale and ensures everything is reset
  Future<void> forceReload(Locale locale) async {
    debugPrint('ManualLocalizationService: FORCE RELOADING translations for $locale');
    
    // Clear existing translations to force a complete reload
    _strings.clear();
    if (_allStrings.containsKey(locale.languageCode)) {
      _allStrings[locale.languageCode]?.clear();
    }
    
    // Update the locale
    _currentLocale = locale;
    
    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString(COUNTRY_CODE, locale.countryCode!);
    } else {
      await prefs.remove(COUNTRY_CODE);
    }
    
    // Force reload of English (fallback)
    await _loadStrings('en');
    
    // Then load the requested language
    if (locale.languageCode != 'en') {
      await _loadStrings(locale.languageCode);
    }
    
    // Always ensure critical Portuguese strings are available
    if (locale.languageCode == 'pt') {
      _addCriticalPortugueseStrings();
    }
    
    // Print diagnostic information about loaded strings
    _printSampleStrings();
    
    // Directly trigger the app-wide rebuild to ensure all UI updates
    debugPrint('==== TRIGGERING GLOBAL APP REBUILD FROM MANUAL LOCALIZATION SERVICE ====');
    // Small delay to ensure all async operations complete before rebuild
    await Future.delayed(const Duration(milliseconds: 100));
    // Trigger rebuild using our own method instead of non-existent app method
    forceAppRebuild();
    
    // Debug output to verify the reload was successful
    debugPrint('ManualLocalizationService: Force reload completed for $locale');
    debugPrint('ManualLocalizationService: Loaded ${_strings.length} strings');
    debugPrint('ManualLocalizationService: Sample of loaded strings:');
    _printSampleStrings();
    
    // Trigger global app rebuild via the notifier
    forceAppRebuild();
    
    // Notify any listeners to this service
    notifyListeners();
  }
  
  /// Print a sample of loaded strings for debugging
  void _printSampleStrings() {
    // Print a few sample strings to verify content
    final keys = _strings.keys.take(5).toList();
    if (keys.isNotEmpty) {
      debugPrint('===== SAMPLE TRANSLATION STRINGS =====');
      for (var key in keys) {
        debugPrint('  $key: ${_strings[key]}');
      }
      debugPrint('====================================');
    } else {
      debugPrint('WARNING: No translation strings loaded');
    }
  }
  Map<String, dynamic> _getHardcodedStrings(String languageCode) {
    // Basic set of translations for testing in different languages
    switch (languageCode) {
      case 'pt':
        return {
          'appTitle': 'Compensação de Voo',
          'home': 'Início',
          'claims': 'Reclamações',
          'settings': 'Configurações',
          'myFlights': 'Meus Voos',
          'profile': 'Perfil',
          'checkCompensationEligibility': 'Verificar elegibilidade para compensação',
          'euWideEligibleFlights': 'Voos elegíveis em toda a UE',
          'euWideCompensation': 'Compensação em toda a UE',
          'filterByAirline': 'Filtrar por companhia aérea',
          'last72Hours': 'Últimas 72 horas',
          'apiConnectionIssue': 'Problema de conexão com a API',
          'returnToHome': 'Voltar para o início',
          'viewDetails': 'Ver detalhes',
          'euCompensationEligible': 'Elegível para compensação UE',
          'flightNumber': 'Número do voo',
          'airline': 'Companhia aérea',
          'flightDate': 'Data do Voo',
          'departureAirport': 'Aeroporto de Partida',
          'arrivalAirport': 'Aeroporto de Chegada',
          'compensationClaimForm': 'Formulário de Pedido de Indenização',
          'flightDetails': 'Detalhes do Voo',
          'delayDuration': 'Duração do atraso',
          'compensationAmount': 'Valor da compensação',
          'languageSelection': 'Seleção de idioma',
          'back': 'Voltar',
          
          // Claims dashboard strings
          'myClaims': 'Minhas Reclamações',
          'active': 'Ativas',
          'actionRequired': 'Ação Necessária',
          'completed': 'Concluídas',
          'refreshDashboard': 'Atualizar Painel',
          'claimStats': 'Estatísticas de Reclamações',
          'totalClaims': 'Total de Reclamações',
          'pendingClaims': 'Reclamações Pendentes',
          'successfulClaims': 'Reclamações Bem-sucedidas',
          'totalCompensation': 'Compensação Total',
          'noClaims': 'Sem Reclamações',
          'startNewClaim': 'Iniciar Nova Reclamação',
          'boardingPass': 'Cartão de Embarque',
          'ticket': 'Bilhete',
          'luggageTag': 'Etiqueta de Bagagem',
          'delayConfirmation': 'Confirmação de Atraso',
          'hotelReceipt': 'Recibo de Hotel',
          'mealReceipt': 'Recibo de Refeição',
          'transportReceipt': 'Recibo de Transporte',
          'otherDocument': 'Outro Documento',
          'supportingDocuments': 'Documentos de Apoio',
          'supportingDocumentsHint': 'Adicione bilhetes, cartões de embarque ou outros documentos relevantes',
          'noDocumentsYet': 'Nenhum documento adicionado ainda',
          'submissionChecklist': 'Lista de Verificação de Envio',
          'submissionChecklistTitle': 'Lista de Verificação de Envio',
          'claimDetails': 'Detalhes da Reclamação',
          'status': 'Status',
          'submitted': 'Enviada',
          'inReview': 'Em Revisão',
          'additionalInfoNeeded': 'Informações Adicionais Necessárias',
          'rejected': 'Rejeitada',
          'successful': 'Bem-sucedida',
          'paid': 'Paga',
          'dateSubmitted': 'Data de Envio',
          'submitClaim': 'Enviar Reclamação',
          'accountSettings': 'Configurações da Conta',
          'profileInformation': 'Informações de Perfil',
          'editPersonalInfo': 'Edite suas informações pessoais',
          'editPersonalInfoDesc': 'Edite suas informações pessoais e de contato',
          'myDocuments': 'Meus Documentos',
          'accessibility': 'Acessibilidade',
          'accessibilityOptions': 'Opções de Acessibilidade',
          'accessibilityOptionsDesc': 'Configure alto contraste, texto grande e suporte a leitores de tela',
          'configureAccessibility': 'Configure opções de acessibilidade para o aplicativo',
          'notificationSettings': 'Configurações de Notificação',
          'configureNotifications': 'Configure preferências de notificação',
          'configureUpdatePreferences': 'Configure como você recebe atualizações de reclamações',
          'notificationSettingsComingSoon': 'Configurações de notificação em breve',
          'selectPreferredLanguage': 'Selecione seu idioma preferido',
          'useScannedInfo': 'Usar informações digitalizadas?',
          'scannedInfoFound': 'Encontramos informações úteis em seu documento digitalizado. Gostaria de preencher o formulário com esses dados?',
          'noButton': 'Não',
          'yesFillForm': 'Sim, preencher formulário',
          'scanDocument': 'Digitalizar documento',
          'scanDocumentHint': 'Use sua câmera para digitalizar um documento',
          'tipsAndReminders': 'Dicas e Lembretes',
          'tipProfileUpToDate': 'Mantenha seu perfil atualizado para um processamento suave de reclamações.',
          'tipDataPrivacy': 'Suas informações são privadas e usadas apenas para reclamações de compensação.',
          'tipContactDetails': 'Certifique-se de que seus detalhes de contato estão corretos para que possamos contatá-lo sobre sua reclamação.',
          'tipAccessibilitySettings': 'Verifique as Configurações de Acessibilidade para personalizar o aplicativo para suas necessidades.',
          
          // Profile Edit Screen
          'editProfile': 'Editar Perfil',
          'profileAccuracyInfo': 'Certifique-se de que as informações em seu perfil são precisas. Isso é essencial para processar reclamações e contactar você sobre sua compensação.',
          'keepProfileUpToDate': 'Mantenha seu perfil atualizado para garantir um processamento tranquilo de reclamações.',
          'profilePrivacy': 'Suas informações são privadas e usadas apenas para reclamações de compensação.',
          'correctContactDetails': 'Certifique-se de que seus dados de contato estão corretos para que possamos contatar você sobre sua reclamação.',
          'fullName': 'Nome Completo',
          'required': 'Obrigatório',
          'phoneNumber': 'Número de Telefone',
          'passportNumber': 'Número do Passaporte',
          'nationality': 'Nacionalidade',
          'dateOfBirth': 'Data de Nascimento',
          'dateFormat': 'AAAA-MM-DD',
          'address': 'Endereço',
          'city': 'Cidade',
          'postalCode': 'Código Postal',
          'country': 'País',
          'privacySettings': 'Configurações de Privacidade',
          'consentToShareData': 'Consentimento para Compartilhar Dados',
          'requiredForProcessing': 'Necessário para processar reclamações de compensação',
          'receiveNotifications': 'Receber Notificações',
          'getClaimUpdates': 'Receba atualizações sobre suas reclamações de compensação',
          'saveProfile': 'SALVAR PERFIL',
          'profileSaved': 'Perfil salvo!',
          'errorLoadingProfile': 'Erro ao carregar perfil: {0}',
          
          // Flight details strings
          'flightInfo': 'Informações do Voo',
          'airline': 'Companhia Aérea',
          'passengerInfo': 'Informações do Passageiro',
          'passengerDetails': 'Detalhes do Passageiro',
          'additionalInformation': 'Informações Adicionais',
          'passengerName': 'Nome do Passageiro',
          'email': 'E-mail',
          'bookingReference': 'Referência de Reserva',
          'problemType': 'Tipo de Problema',
          'delay': 'Atraso',
          'cancellation': 'Cancelamento',
          'overbooking': 'Reservas em Excesso',
          'missedConnection': 'Conexão Perdida',
          'search': 'Buscar',
          'noFlightsFound': 'Nenhum voo encontrado',
          'tryDifferentSearch': 'Tente uma busca diferente',
        };
      case 'es':
        return {
          'appTitle': 'Compensación de Vuelo',
          'home': 'Inicio',
          'claims': 'Reclamaciones',
          'settings': 'Ajustes',
          'myFlights': 'Mis Vuelos',
          'profile': 'Perfil',
          'checkCompensationEligibility': 'Verificar elegibilidad para compensación',
          'euWideEligibleFlights': 'Vuelos elegibles en toda la UE',
          'euWideCompensation': 'Compensación en toda la UE',
          'filterByAirline': 'Filtrar por aerolínea',
          'last72Hours': 'Últimas 72 horas',
          'apiConnectionIssue': 'Problema de conexión con la API',
          'returnToHome': 'Volver al inicio',
          'viewDetails': 'Ver detalles',
          'euCompensationEligible': 'Elegible para compensación UE',
          'flightNumber': 'Número de vuelo',
          'airline': 'Aerolínea',
          'flightDate': 'Fecha del Vuelo',
          'departureAirport': 'Aeropuerto de Salida',
          'arrivalAirport': 'Aeropuerto de Llegada',
          'compensationClaimForm': 'Formulario de Reclamación de Compensación',
          'flightDetails': 'Detalles del Vuelo',
          'delayDuration': 'Duración del retraso',
          'compensationAmount': 'Monto de compensación',
          'languageSelection': 'Selección de idioma',
          'back': 'Volver',
          
          // Claims dashboard strings
          'myClaims': 'Mis Reclamaciones',
          'active': 'Activas',
          'actionRequired': 'Acción Requerida',
          'completed': 'Completadas',
          'refreshDashboard': 'Actualizar Panel',
          'claimStats': 'Estadísticas de Reclamaciones',
          'totalClaims': 'Reclamaciones Totales',
          'pendingClaims': 'Reclamaciones Pendientes',
          'successfulClaims': 'Reclamaciones Exitosas',
          'totalCompensation': 'Compensación Total',
          'noClaims': 'Sin Reclamaciones',
          'startNewClaim': 'Iniciar Nueva Reclamación',
          'boardingPass': 'Tarjeta de Embarque',
          'ticket': 'Billete',
          'luggageTag': 'Etiqueta de Equipaje',
          'delayConfirmation': 'Confirmación de Retraso',
          'hotelReceipt': 'Recibo de Hotel',
          'mealReceipt': 'Recibo de Comida',
          'transportReceipt': 'Recibo de Transporte',
          'otherDocument': 'Otro Documento',
          'supportingDocuments': 'Documentos de Apoyo',
          'supportingDocumentsHint': 'Añada billetes, tarjetas de embarque u otros documentos relevantes',
          'noDocumentsYet': 'Aún no se han añadido documentos',
          'submissionChecklist': 'Lista de Verificación de Envío',
          
          // Profile Edit Screen
          'editProfile': 'Editar Perfil',
          'profileAccuracyInfo': 'Asegúrese de que la información en su perfil sea precisa. Esto es esencial para procesar reclamos y contactarlo sobre su compensación.',
          'keepProfileUpToDate': 'Mantenga su perfil actualizado para garantizar un procesamiento fluido de reclamaciones.',
          'profilePrivacy': 'Su información es privada y se utiliza solo para reclamaciones de compensación.',
          'correctContactDetails': 'Asegúrese de que sus datos de contacto sean correctos para que podamos comunicarnos con usted sobre su reclamación.',
          'fullName': 'Nombre Completo',
          'required': 'Obligatorio',
          'phoneNumber': 'Número de Teléfono',
          'passportNumber': 'Número de Pasaporte',
          'nationality': 'Nacionalidad',
          'dateOfBirth': 'Fecha de Nacimiento',
          'dateFormat': 'AAAA-MM-DD',
          'address': 'Dirección',
          'city': 'Ciudad',
          'postalCode': 'Código Postal',
          'country': 'País',
          'privacySettings': 'Configuración de Privacidad',
          'consentToShareData': 'Consentimiento para Compartir Datos',
          'requiredForProcessing': 'Necesario para procesar reclamaciones de compensación',
          'receiveNotifications': 'Recibir Notificaciones',
          'getClaimUpdates': 'Reciba actualizaciones sobre sus reclamaciones de compensación',
          'saveProfile': 'GUARDAR PERFIL',
          'profileSaved': '¡Perfil guardado!',
          'errorLoadingProfile': 'Error al cargar el perfil: {0}',
          'submissionChecklistTitle': 'Lista de Verificación de Envío',
          'claimDetails': 'Detalles de Reclamación',
          'status': 'Estado',
          'submitted': 'Enviada',
          'inReview': 'En Revisión',
          'additionalInfoNeeded': 'Información Adicional Requerida',
          'rejected': 'Rechazada',
          'successful': 'Exitosa',
          'paid': 'Pagada',
          'dateSubmitted': 'Fecha de Envío',
          'submitClaim': 'Enviar Reclamación',
          'accountSettings': 'Configuración de la Cuenta',
          'profileInformation': 'Información del Perfil',
          'editPersonalInfo': 'Edita tu información personal',
          'editPersonalInfoDesc': 'Edita tu información personal y de contacto',
          'myDocuments': 'Mis Documentos',
          'accessibility': 'Accesibilidad',
          'accessibilityOptions': 'Opciones de Accesibilidad',
          'accessibilityOptionsDesc': 'Configure alto contraste, texto grande y compatibilidad con lectores de pantalla',
          'configureAccessibility': 'Configure opciones de accesibilidad para la aplicación',
          'notificationSettings': 'Configuración de Notificaciones',
          'configureNotifications': 'Configure preferencias de notificación',
          'configureUpdatePreferences': 'Configure cómo recibe actualizaciones de reclamos',
          'notificationSettingsComingSoon': 'Configuración de notificaciones próximamente',
          'selectPreferredLanguage': 'Seleccione su idioma preferido',
          'useScannedInfo': '¿Usar información escaneada?',
          'scannedInfoFound': 'Encontramos información útil en su documento escaneado. ¿Le gustaría llenar el formulario con estos datos?',
          'noButton': 'No',
          'yesFillForm': 'Sí, llenar formulario',
          'scanDocument': 'Escanear documento',
          'scanDocumentHint': 'Use su cámara para escanear un documento',
          'tipsAndReminders': 'Consejos y Recordatorios',
          'tipProfileUpToDate': 'Mantenga su perfil actualizado para un procesamiento fluido de reclamos.',
          'tipDataPrivacy': 'Su información es privada y solo se utiliza para reclamaciones de compensación.',
          'tipContactDetails': 'Asegúrese de que sus datos de contacto sean correctos para que podamos comunicarnos sobre su reclamo.',
          'tipAccessibilitySettings': 'Consulte las Opciones de Accesibilidad para personalizar la aplicación según sus necesidades.',
          
          // Flight details strings
          'flightInfo': 'Información del Vuelo',
          'airline': 'Aerolínea',
          'passengerInfo': 'Información del Pasajero',
          'passengerDetails': 'Datos del Pasajero',
          'additionalInformation': 'Información Adicional',
          'passengerName': 'Nombre del Pasajero',
          'email': 'Correo Electrónico',
          'bookingReference': 'Referencia de Reserva',
          'problemType': 'Tipo de Problema',
          'delay': 'Retraso',
          'cancellation': 'Cancelación',
          'overbooking': 'Sobreventa',
          'missedConnection': 'Conexión Perdida',
          'search': 'Buscar',
          'noFlightsFound': 'No se encontraron vuelos',
          'tryDifferentSearch': 'Intente una búsqueda diferente',
        };
      case 'fr':
        return {
          'appTitle': 'Compensation de Vol',
          'home': 'Accueil',
          'claims': 'Réclamations',
          'settings': 'Paramètres',
          'myFlights': 'Mes Vols',
          'profile': 'Profil',
          'checkCompensationEligibility': 'Vérifier l\'éligibilité à la compensation',
          'euWideEligibleFlights': 'Vols éligibles dans toute l\'UE',
          'euWideCompensation': 'Compensation dans toute l\'UE',
          'filterByAirline': 'Filtrer par compagnie aérienne',
          'last72Hours': 'Dernières 72 heures',
          'apiConnectionIssue': 'Problème de connexion API',
          'returnToHome': 'Retour à l\'accueil',
          'viewDetails': 'Voir les détails',
          'euCompensationEligible': 'Éligible à la compensation UE',
          'flightNumber': 'Numéro de vol',
          'airline': 'Compagnie aérienne',
          'flightDate': 'Date du Vol',
          'departureAirport': 'Aéroport de Départ',
          'arrivalAirport': 'Aéroport d’Arrivée',
          'compensationClaimForm': 'Formulaire de Demande d’Indemnisation',
          'flightDetails': 'Détails du Vol',
          'delayDuration': 'Durée du retard',
          'compensationAmount': 'Montant de la compensation',
          'languageSelection': 'Sélection de langue',
          'back': 'Retour',
          
          // Claims dashboard strings
          'myClaims': 'Mes Réclamations',
          'active': 'Actives',
          'actionRequired': 'Action Requise',
          'completed': 'Terminées',
          'refreshDashboard': 'Actualiser le Tableau de Bord',
          'claimStats': 'Statistiques de Réclamations',
          'totalClaims': 'Réclamations Totales',
          'pendingClaims': 'Réclamations en Attente',
          'successfulClaims': 'Réclamations Réussies',
          'totalCompensation': 'Compensation Totale',
          'noClaims': 'Aucune Réclamation',
          'startNewClaim': 'Débuter une Nouvelle Réclamation',
          'claimDetails': 'Détails de la Réclamation',
          'status': 'Statut',
          'submissionChecklist': 'Liste de Vérification de Soumission',
          'email': 'Email',
          'bookingReference': 'Référence de Réservation',
          'boardingPass': 'Carte d\'Embarquement',
          'ticket': 'Billet',
          'luggageTag': 'Étiquette de Bagage',
          'delayConfirmation': 'Confirmation de Retard',
          'hotelReceipt': 'Reçu d\'Hôtel',
          'mealReceipt': 'Reçu de Repas',
          'transportReceipt': 'Reçu de Transport',
          'otherDocument': 'Autre Document',
          'supportingDocuments': 'Documents Justificatifs',
          'supportingDocumentsHint': 'Ajoutez des billets, cartes d\'embarquement ou autres documents pertinents',
          'noDocumentsYet': 'Aucun document ajouté pour l\'instant',
          'submissionChecklistTitle': 'Liste de Vérification de Soumission',
          'submitted': 'Soumise',
          
          // Profile Edit Screen
          'editProfile': 'Modifier le Profil',
          'profileAccuracyInfo': 'Assurez-vous que les informations de votre profil sont exactes. Ceci est essentiel pour traiter les réclamations et vous contacter concernant votre compensation.',
          'keepProfileUpToDate': 'Gardez votre profil à jour pour assurer un traitement fluide des réclamations.',
          'profilePrivacy': 'Vos informations sont privées et utilisées uniquement pour les réclamations de compensation.',
          'correctContactDetails': 'Assurez-vous que vos coordonnées sont correctes afin que nous puissions vous contacter au sujet de votre réclamation.',
          'fullName': 'Nom Complet',
          'required': 'Obligatoire',
          'phoneNumber': 'Numéro de Téléphone',
          'passportNumber': 'Numéro de Passeport',
          'nationality': 'Nationalité',
          'dateOfBirth': 'Date de Naissance',
          'dateFormat': 'AAAA-MM-JJ',
          'address': 'Adresse',
          'city': 'Ville',
          'postalCode': 'Code Postal',
          'country': 'Pays',
          'privacySettings': 'Paramètres de Confidentialité',
          'consentToShareData': 'Consentement pour Partager les Données',
          'requiredForProcessing': 'Nécessaire pour traiter les réclamations de compensation',
          'receiveNotifications': 'Recevoir des Notifications',
          'getClaimUpdates': 'Recevez des mises à jour sur vos réclamations de compensation',
          'saveProfile': 'ENREGISTRER LE PROFIL',
          'profileSaved': 'Profil enregistré !',
          'errorLoadingProfile': 'Erreur lors du chargement du profil: {0}',
          'inReview': 'En Révision',
          'additionalInfoNeeded': 'Informations Supplémentaires Requises',
          'rejected': 'Rejetée',
          'successful': 'Réussie',
          'paid': 'Payée',
          'dateSubmitted': 'Date de Soumission',
          'submitClaim': 'Soumettre la Réclamation',
          'accountSettings': 'Paramètres du Compte',
          'profileInformation': 'Informations de Profil',
          'editPersonalInfo': 'Modifier vos informations personnelles',
          'editPersonalInfoDesc': 'Modifier vos informations personnelles et de contact',
          'myDocuments': 'Mes Documents',
          'accessibility': 'Accessibilité',
          'accessibilityOptions': 'Options d\'Accessibilité',
          'accessibilityOptionsDesc': 'Configurer le contraste élevé, les grands textes et le support de lecteur d\'écran',
          'configureAccessibility': 'Configurer les options d\'accessibilité pour l\'application',
          'notificationSettings': 'Paramètres de Notification',
          'configureNotifications': 'Configurer les préférences de notification',
          'configureUpdatePreferences': 'Configurer comment vous recevez les mises à jour des réclamations',
          'notificationSettingsComingSoon': 'Paramètres de notification bientôt disponibles',
          'selectPreferredLanguage': 'Sélectionnez votre langue préférée',
          'useScannedInfo': 'Utiliser les informations scannées?',
          'scannedInfoFound': 'Nous avons trouvé des informations utiles dans votre document scanné. Souhaitez-vous remplir le formulaire avec ces données?',
          'noButton': 'Non',
          'yesFillForm': 'Oui, remplir le formulaire',
          'scanDocument': 'Scanner un document',
          'scanDocumentHint': 'Utilisez votre appareil photo pour scanner un document',
          'tipsAndReminders': 'Conseils et Rappels',
          'tipProfileUpToDate': 'Gardez votre profil à jour pour un traitement fluide des réclamations.',
          'tipDataPrivacy': 'Vos informations sont privées et uniquement utilisées pour les réclamations de compensation.',
          'tipContactDetails': 'Assurez-vous que vos coordonnées sont correctes pour que nous puissions vous contacter au sujet de votre réclamation.',
          'tipAccessibilitySettings': 'Consultez les Paramètres d\'Accessibilité pour personnaliser l\'application selon vos besoins.',
          
          // Flight details strings
          'flightInfo': 'Informations du Vol',
          'airline': 'Compagnie Aérienne',
          'passengerInfo': 'Informations du Passager',
          'passengerDetails': 'Détails du Passager',
          'additionalInformation': 'Informations Supplémentaires',
          'passengerName': 'Nom du Passager',
          'email': 'E-mail',
          'bookingReference': 'Référence de Réservation',
          'problemType': 'Type de Problème',
          'delay': 'Retard',
          'cancellation': 'Annulation',
          'overbooking': 'Surréservation',
          'missedConnection': 'Correspondance Manquée',
          'search': 'Rechercher',
          'noFlightsFound': 'Aucun vol trouvé',
          'tryDifferentSearch': 'Essayez une recherche différente',
        };
      case 'de':
        return {
          'appTitle': 'Flugentschädigung',
          'home': 'Startseite',
          'claims': 'Ansprüche',
          'settings': 'Einstellungen',
          'myFlights': 'Meine Flüge',
          'profile': 'Profil',
          'checkCompensationEligibility': 'Entschädigungsberechtigung prüfen',
          'euWideEligibleFlights': 'EU-weit berechtigte Flüge',
          'euWideCompensation': 'EU-weite Entschädigung',
          'filterByAirline': 'Nach Fluggesellschaft filtern',
          'last72Hours': 'Letzte 72 Stunden',
          'apiConnectionIssue': 'API-Verbindungsproblem',
          'returnToHome': 'Zurück zur Startseite',
          'viewDetails': 'Details anzeigen',
          'euCompensationEligible': 'EU-Entschädigung berechtigt',
          'flightNumber': 'Flugnummer',
          'airline': 'Fluggesellschaft',
          'flightDate': 'Flugdatum',
          'departureAirport': 'Abflughafen',
          'arrivalAirport': 'Ankunftsflughafen',
          'compensationClaimForm': 'Entschädigungsantragsformular',
          'flightDetails': 'Flugdetails',
          'delayDuration': 'Verzögerungsdauer',
          'compensationAmount': 'Entschädigungsbetrag',
          'languageSelection': 'Sprachauswahl',
          'back': 'Zurück',
          
          // Claims dashboard strings
          'myClaims': 'Meine Ansprüche',
          'active': 'Aktiv',
          'actionRequired': 'Handlungsbedarf',
          'completed': 'Abgeschlossen',
          'refreshDashboard': 'Dashboard aktualisieren',
          'claimStats': 'Anspruchsstatistiken',
          'totalClaims': 'Gesamtansprüche',
          'pendingClaims': 'Ausstehende Ansprüche',
          'successfulClaims': 'Erfolgreiche Ansprüche',
          'totalCompensation': 'Gesamtentschädigung',
          'noClaims': 'Keine Ansprüche',
          'startNewClaim': 'Neuen Anspruch starten',
          'claimDetails': 'Anspruchsdetails',
          'status': 'Status',
          'submitted': 'Eingereicht',
          'inReview': 'In Überprüfung',
          'additionalInfoNeeded': 'Zusätzliche Informationen benötigt',
          'boardingPass': 'Bordkarte',
          'ticket': 'Ticket',
          'luggageTag': 'Gepäckanhänger',
          'delayConfirmation': 'Verspätungsbestätigung',
          'hotelReceipt': 'Hotelquittung',
          'mealReceipt': 'Verpflegungsquittung',
          'transportReceipt': 'Transportquittung',
          'otherDocument': 'Anderes Dokument',
          'supportingDocuments': 'Begleitende Dokumente',
          'supportingDocumentsHint': 'Fügen Sie Tickets, Bordkarten oder andere relevante Dokumente hinzu',
          'noDocumentsYet': 'Noch keine Dokumente hinzugefügt',
          'submissionChecklist': 'Einreichungscheckliste',
          'submissionChecklistTitle': 'Einreichungscheckliste',
          
          // Profile Edit Screen
          'editProfile': 'Profil Bearbeiten',
          'profileAccuracyInfo': 'Stellen Sie sicher, dass die Informationen in Ihrem Profil korrekt sind. Dies ist wichtig für die Bearbeitung von Ansprüchen und die Kontaktaufnahme bezüglich Ihrer Entschädigung.',
          'keepProfileUpToDate': 'Halten Sie Ihr Profil aktuell, um eine reibungslose Bearbeitung der Ansprüche zu gewährleisten.',
          'profilePrivacy': 'Ihre Informationen sind privat und werden nur für Entschädigungsansprüche verwendet.',
          'correctContactDetails': 'Stellen Sie sicher, dass Ihre Kontaktdaten korrekt sind, damit wir Sie bezüglich Ihres Anspruchs kontaktieren können.',
          'fullName': 'Vollständiger Name',
          'required': 'Erforderlich',
          'phoneNumber': 'Telefonnummer',
          'passportNumber': 'Passnummer',
          'nationality': 'Nationalität',
          'dateOfBirth': 'Geburtsdatum',
          'dateFormat': 'JJJJ-MM-TT',
          'address': 'Adresse',
          'city': 'Stadt',
          'postalCode': 'Postleitzahl',
          'country': 'Land',
          'privacySettings': 'Datenschutzeinstellungen',
          'consentToShareData': 'Einwilligung zur Datenweitergabe',
          'requiredForProcessing': 'Erforderlich für die Bearbeitung von Entschädigungsansprüchen',
          'receiveNotifications': 'Benachrichtigungen erhalten',
          'getClaimUpdates': 'Erhalten Sie Updates zu Ihren Entschädigungsansprüchen',
          'saveProfile': 'PROFIL SPEICHERN',
          'profileSaved': 'Profil gespeichert!',
          'errorLoadingProfile': 'Fehler beim Laden des Profils: {0}',
          
          'rejected': 'Abgelehnt',
          'successful': 'Erfolgreich',
          'paid': 'Bezahlt',
          'dateSubmitted': 'Einreichungsdatum',
          'submitClaim': 'Anspruch einreichen',
          'accountSettings': 'Kontoeinstellungen',
          'profileInformation': 'Profilinformationen',
          'editPersonalInfo': 'Bearbeiten Sie Ihre persönlichen Informationen',
          'editPersonalInfoDesc': 'Bearbeiten Sie Ihre persönlichen Daten und Kontaktinformationen',
          'myDocuments': 'Meine Dokumente',
          'accessibility': 'Barrierefreiheit',
          'accessibilityOptions': 'Optionen für Barrierefreiheit',
          'accessibilityOptionsDesc': 'Konfigurieren Sie hohen Kontrast, großen Text und Bildschirmleser-Unterstützung',
          'configureAccessibility': 'Konfigurieren Sie Barrierefreiheitsoptionen für die App',
          'notificationSettings': 'Benachrichtigungseinstellungen',
          'configureNotifications': 'Benachrichtigungseinstellungen konfigurieren',
          'configureUpdatePreferences': 'Konfigurieren Sie, wie Sie Anspruchsaktualisierungen erhalten',
          'notificationSettingsComingSoon': 'Benachrichtigungseinstellungen folgen in Kürze',
          'selectPreferredLanguage': 'Wählen Sie Ihre bevorzugte Sprache',
          'useScannedInfo': 'Gescannte Informationen verwenden?',
          'scannedInfoFound': 'Wir haben nützliche Informationen in Ihrem gescannten Dokument gefunden. Möchten Sie das Formular mit diesen Daten ausfüllen?',
          'noButton': 'Nein',
          'yesFillForm': 'Ja, Formular ausfüllen',
          'scanDocument': 'Dokument scannen',
          'scanDocumentHint': 'Verwenden Sie Ihre Kamera, um ein Dokument zu scannen',
          'tipsAndReminders': 'Tipps & Erinnerungen',
          'tipProfileUpToDate': 'Halten Sie Ihr Profil aktuell, um eine reibungslose Anspruchsbearbeitung zu gewährleisten.',
          'tipDataPrivacy': 'Ihre Informationen sind privat und werden nur für Entschädigungsansprüche verwendet.',
          'tipContactDetails': 'Stellen Sie sicher, dass Ihre Kontaktdaten korrekt sind, damit wir Sie bezüglich Ihres Anspruchs kontaktieren können.',
          'tipAccessibilitySettings': 'Überprüfen Sie die Einstellungen zur Barrierefreiheit, um die App an Ihre Bedürfnisse anzupassen.',
          
          // Flight details strings
          'flightInfo': 'Fluginformationen',
          'airline': 'Fluggesellschaft',
          'passengerInfo': 'Passagierinformationen',
          'passengerDetails': 'Passagierdetails',
          'additionalInformation': 'Zusätzliche Informationen',
          'passengerName': 'Name des Passagiers',
          'email': 'E-Mail',
          'bookingReference': 'Buchungsreferenz',
          'problemType': 'Problemtyp',
          'delay': 'Verspätung',
          'cancellation': 'Stornierung',
          'overbooking': 'Überbuchung',
          'missedConnection': 'Verpasster Anschluss',
          'search': 'Suchen',
          'noFlightsFound': 'Keine Flüge gefunden',
          'tryDifferentSearch': 'Versuchen Sie eine andere Suche',
        };
      case 'pl':
        return {
          'appTitle': 'Odszkodowanie za Lot',
          'home': 'Strona główna',
          'claims': 'Roszczenia',
          'settings': 'Ustawienia',
          'myFlights': 'Moje Loty',
          'profile': 'Profil',
          'checkCompensationEligibility': 'Sprawdź kwalifikowalność do odszkodowania',
          'euWideEligibleFlights': 'Loty kwalifikujące się w całej UE',
          'euWideCompensation': 'Odszkodowanie w całej UE',
          'filterByAirline': 'Filtruj według linii lotniczej',
          'last72Hours': 'Ostatnie 72 godziny',
          'apiConnectionIssue': 'Problem z połączeniem API',
          'returnToHome': 'Powrót do strony głównej',
          'viewDetails': 'Zobacz szczegóły',
          'euCompensationEligible': 'Kwalifikuje się do odszkodowania UE',
          'flightNumber': 'Numer lotu',
          'airline': 'Linia lotnicza',
          'flightDate': 'Data lotu',
          'departureAirport': 'Lotnisko wylotu',
          'arrivalAirport': 'Lotnisko przylotu',
          'delayDuration': 'Czas opóźnienia',
          'compensationAmount': 'Kwota odszkodowania',
          'languageSelection': 'Wybór języka',
          'back': 'Powrót',
          
          // Claims dashboard strings
          'myClaims': 'Moje Roszczenia',
          'active': 'Aktywne',
          'actionRequired': 'Wymagane Działanie',
          'completed': 'Zakończone',
          'refreshDashboard': 'Odśwież Panel',
          'claimStats': 'Statystyki Roszczeń',
          'totalClaims': 'Wszystkie Roszczenia',
          'pendingClaims': 'Oczekujące Roszczenia',
          'successfulClaims': 'Udane Roszczenia',
          'totalCompensation': 'Całkowite Odszkodowanie',
          'noClaims': 'Brak Roszczeń',
          'startNewClaim': 'Rozpocznij Nowe Roszczenie',
          'claimDetails': 'Szczegóły Roszczenia',
          'status': 'Status',
          'submitted': 'Złożone',
          'inReview': 'W trakcie przeglądu',
          'additionalInfoNeeded': 'Wymagane dodatkowe informacje',
          'boardingPass': 'Karta pokładowa',
          'ticket': 'Bilet',
          'luggageTag': 'Etykieta bagażowa',
          'delayConfirmation': 'Potwierdzenie opóźnienia',
          'lostBaggageClaim': 'Roszczenie z tytułu zgubionego bagażu',
          'flightDelayedCompensation': 'Odszkodowanie za opóźniony lot',
          'compensationClaimForm': 'Formularz Roszczenia Odszkodowania',
          'flightDetails': 'Szczegóły Lotu',
          'hotelReceipt': 'Rachunek za hotel',
          'mealReceipt': 'Rachunek za posiłek',
          'transportReceipt': 'Rachunek za transport',
          'otherDocument': 'Inny dokument',
          'supportingDocuments': 'Dokumenty uzupełniające',
          'supportingDocumentsHint': 'Dodaj bilety, karty pokładowe lub inne istotne dokumenty',
          'noDocumentsYet': 'Nie dodano jeszcze żadnych dokumentów',
          'submissionChecklist': 'Lista kontrolna zgłoszenia',
          'submissionChecklistTitle': 'Lista kontrolna zgłoszenia',
          'rejected': 'Odrzucone',
          'successful': 'Udane',
          'paid': 'Zapłacone',
          'dateSubmitted': 'Data złożenia',
          'submitClaim': 'Złóż Roszczenie',
          'accountSettings': 'Ustawienia Konta',
          'profileInformation': 'Informacje o Profilu',
          'editPersonalInfo': 'Edytuj swoje dane osobowe',
          'editPersonalInfoDesc': 'Edytuj swoje dane osobowe i kontaktowe',
          'myDocuments': 'Moje Dokumenty',
          'accessibility': 'Dostępność',
          'accessibilityOptions': 'Opcje Dostępności',
          'accessibilityOptionsDesc': 'Skonfiguruj wysoki kontrast, duży tekst i wsparcie czytnika ekranu',
          'configureAccessibility': 'Skonfiguruj opcje dostępności dla aplikacji',
          'notificationSettings': 'Ustawienia Powiadomień',
          'configureNotifications': 'Konfiguruj preferencje powiadomień',
          'configureUpdatePreferences': 'Skonfiguruj sposób otrzymywania aktualizacji roszczeń',
          'notificationSettingsComingSoon': 'Ustawienia powiadomień wkrótce',
          'selectPreferredLanguage': 'Wybierz preferowany język',
          'useScannedInfo': 'Użyć zeskanowanych informacji?',
          'scannedInfoFound': 'Znaleźliśmy przydatne informacje w zeskanowanym dokumencie. Czy chcesz wypełnić formularz tymi danymi?',
          'noButton': 'Nie',
          'yesFillForm': 'Tak, wypełnij formularz',
          'scanDocument': 'Skanuj dokument',
          'scanDocumentHint': 'Użyj aparatu do skanowania dokumentu',
          'tipsAndReminders': 'Wskazówki i Przypomnienia',
          'tipProfileUpToDate': 'Utrzymuj swój profil aktualnym, aby zapewnić sprawne przetwarzanie roszczeń.',
          'tipDataPrivacy': 'Twoje informacje są prywatne i wykorzystywane wyłącznie do roszczeń o odszkodowanie.',
          'tipContactDetails': 'Upewnij się, że Twoje dane kontaktowe są poprawne, abyśmy mogli skontaktować się z Tobą w sprawie Twojego roszczenia.',
          'tipAccessibilitySettings': 'Sprawdź Ustawienia Dostępności, aby dostosować aplikację do swoich potrzeb.',
          
          // Flight details strings
          'flightInfo': 'Informacje o Locie',
          'airline': 'Linia Lotnicza',
          'passengerInfo': 'Informacje o Pasażerze',
          'passengerDetails': 'Dane Pasażera',
          'additionalInformation': 'Dodatkowe Informacje',
          'passengerName': 'Imię i Nazwisko',
          'email': 'Adres E-mail',
          'bookingReference': 'Numer Rezerwacji',
          'problemType': 'Typ Problemu',
          'delay': 'Opóźnienie',
          'cancellation': 'Anulowanie',
          'overbooking': 'Nadkomplet Rezerwacji',
          'missedConnection': 'Utracone Połączenie',
          'search': 'Szukaj',
          'noFlightsFound': 'Nie znaleziono lotów',
          'tryDifferentSearch': 'Spróbuj innego wyszukiwania',
        };
      case 'en':
      default:
        return {
          'appTitle': 'Flight Compensation',
          'home': 'Home',
          'claims': 'Claims',
          'settings': 'Settings',
          'myFlights': 'My Flights',
          'profile': 'Profile',
          'checkCompensationEligibility': 'Check compensation eligibility',
          'euWideEligibleFlights': 'EU-wide eligible flights',
          'euWideCompensation': 'EU-wide compensation',
          'filterByAirline': 'Filter by airline',
          'last72Hours': 'Last 72 hours',
          'apiConnectionIssue': 'API connection issue',
          'returnToHome': 'Return to home',
          'viewDetails': 'View details',
          'euCompensationEligible': 'EU compensation eligible',
          'flightNumber': 'Flight number',
          'airline': 'Airline',
          'flightDate': 'Flight date',
          'departureAirport': 'Departure airport',
          'arrivalAirport': 'Arrival airport',
          'delayDuration': 'Delay duration',
          'compensationAmount': 'Compensation amount',
          'languageSelection': 'Language Selection',
          'back': 'Back',
          
          // Claims dashboard strings
          'myClaims': 'My Claims',
          'active': 'Active',
          'actionRequired': 'Action Required',
          'completed': 'Completed',
          'refreshDashboard': 'Refresh Dashboard',
          'claimStats': 'Claim Statistics',
          'totalClaims': 'Total Claims',
          'pendingClaims': 'Pending Claims',
          'successfulClaims': 'Successful Claims',
          'totalCompensation': 'Total Compensation',
          'noClaims': 'No Claims',
          'startNewClaim': 'Start New Claim',
          'claimDetails': 'Claim Details',
          'status': 'Status',
          'submissionChecklist': 'Submission Checklist',
          'email': 'Email',
          'bookingReference': 'Booking Reference',
          'boardingPass': 'Boarding Pass',
          'ticket': 'Ticket',
          'luggageTag': 'Luggage Tag',
          'delayConfirmation': 'Delay Confirmation',
          'hotelReceipt': 'Hotel Receipt',
          'mealReceipt': 'Meal Receipt',
          'transportReceipt': 'Transport Receipt',
          'otherDocument': 'Other Document',
          'submissionChecklistTitle': 'Submission Checklist',
          'submitted': 'Submitted',
          'inReview': 'In Review',
          'additionalInfoNeeded': 'Additional Information Needed',
          'rejected': 'Rejected',
          'successful': 'Successful',
          'paid': 'Paid',
          'dateSubmitted': 'Date Submitted',
          'submitClaim': 'Submit Claim',
          
          // Flight details strings
          'flightInfo': 'Flight Information',
          'passengerInfo': 'Passenger Information',
          'problemType': 'Problem Type',
          'delay': 'Delay',
          'cancellation': 'Cancellation',
          'overbooking': 'Overbooking',
          'missedConnection': 'Missed Connection',
          'search': 'Search',
          'noFlightsFound': 'No flights found',
          'tryDifferentSearch': 'Try a different search',
        };
    }
  }
  
  /// Primary method to get a localized string with placeholder replacements
  /// Usage: getLocalizedString('welcomeMessage', {'name': 'John'}) 
  /// where welcomeMessage is "Hello {name}!"
  String getLocalizedString(String key, [Map<String, String>? replacements, String? fallback]) {
    // Get the raw string or fall back to English
    String? value = _strings[key] as String?;
    
    // If not found in current locale and it's not English, try English fallback
    if (value == null && _currentLocale.languageCode != 'en') {
      value = _allStrings['en']?[key] as String?;
    }
    
    // If still not found, use provided fallback or the key itself
    if (value == null) {
      value = fallback ?? key;
    }
    
    // Replace placeholders if provided
    if (replacements != null && replacements.isNotEmpty) {
      replacements.forEach((placeholder, replacement) {
        value = value!.replaceAll('{$placeholder}', replacement);
      });
    }
    
    return value!;
  }
  
  /// Get display name for a language
  String getDisplayLanguage(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
  
  // This method has been consolidated into the primary getLocalizedString method
  
  /// Add critical Portuguese translations to ensure app functionality
  void _addCriticalPortugueseStrings() {
    // These are the critical strings needed for the EU Eligible Flights screen in Portuguese
    final Map<String, dynamic> criticalPtStrings = {
      'euWideCompensation': 'Compensação de voos da UE',
      'filterByAirline': 'Filtrar por companhia aérea',
      'last72Hours': 'Últimas 72 horas',
      'last48Hours': 'Últimas 48 horas', 
      'last24Hours': 'Últimas 24 horas',
      'apiConnectionIssue': 'Problema de conexão API',
      'apiConnectionIssueMessage': 'Estamos tendo problemas para conectar ao serviço de dados de voo. Pode ser um problema temporário com a API AviationStack.',
      'retryConnection': 'Tentar reconectar',
      'returnToHome': 'Voltar para início',
      'noEligibleFlightsFound': 'Nenhum voo elegível encontrado',
      'noEligibleFlightsMessage': 'Verificamos voos em grandes aeroportos da UE nas últimas {hours} horas, mas nenhum voo atende aos critérios de compensação da UE261 no momento.',
      'noFlightsFound': 'Nenhum voo encontrado que corresponda ao filtro "{filter}".',
      'checkAgain': 'Verificar novamente',
      'euCompensation': 'Compensação UE:',
      'from': 'De:',
      'to': 'Para:',
      'scheduled': 'Agendado:',
      'statusLabelText': 'Status:',
      'euCompensationEligible': 'Elegível para UE261',
      'flightDelayed': 'Voo atrasado',
      'estimatedCompensation': 'Compensação estimada',
      'viewDetails': 'Ver detalhes',
      'preFillCompensationForm': 'Preencher formulário de compensação',
      // Add more critical translations here
    };
    
    // Only add keys that are missing from the loaded PT strings
    int addedCount = 0;
    criticalPtStrings.forEach((key, value) {
      if (!_allStrings['pt']!.containsKey(key)) {
        _allStrings['pt']![key] = value;
        addedCount++;
      }
    });
    
    if (addedCount > 0) {
      debugPrint('Added $addedCount critical Portuguese strings');
    }
  }
}
