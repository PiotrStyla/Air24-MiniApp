import 'package:get_it/get_it.dart';

import 'package:f35_flight_compensation/services/auth_service.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/services/local_document_storage_service.dart';

import 'package:f35_flight_compensation/services/aviation_stack_service.dart';
import 'package:f35_flight_compensation/services/document_ocr_service.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';
import 'package:f35_flight_compensation/services/flight_prediction_service.dart';
import 'package:f35_flight_compensation/services/claim_tracking_service.dart';
import 'package:f35_flight_compensation/services/firebase_claim_tracking_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/services/claim_submission_service.dart';
import 'package:f35_flight_compensation/services/claim_validation_service.dart';
import 'package:f35_flight_compensation/core/error/error_handler.dart';
import 'package:f35_flight_compensation/viewmodels/auth_viewmodel.dart';
import 'package:f35_flight_compensation/viewmodels/document_viewmodel.dart';
import 'package:f35_flight_compensation/viewmodels/document_scanner_viewmodel.dart';
import 'package:f35_flight_compensation/viewmodels/claim_dashboard_viewmodel.dart';

/// Service initializer for dependency injection
/// Following MVVM pattern with GetIt
class ServiceInitializer {
  static final GetIt _locator = GetIt.instance;
  static bool _isTestMode = false;

  /// Register all services and viewmodels asynchronously
  static Future<void> initAsync() async {
    print('[ServiceInitializer] initAsync() called.');
    if (_isTestMode) return;

    // Asynchronously register AuthService
    _locator.registerSingletonAsync<AuthService>(() => AuthService.create());

    // Register other services as lazy singletons
        _locator.registerLazySingleton<AviationStackService>(() => AviationStackService(baseUrl: 'http://api.aviationstack.com/v1'));
    _locator.registerLazySingleton<DocumentOcrService>(() => DocumentOcrService());
    _locator.registerLazySingleton<NotificationService>(() => NotificationService());
    _locator.registerLazySingleton<FlightPredictionService>(() => FlightPredictionService());
    _locator.registerLazySingleton<ErrorHandler>(() => ErrorHandler());
    _locator.registerLazySingleton<ClaimTrackingService>(() => FirebaseClaimTrackingService());
    _locator.registerLazySingleton<ClaimValidationService>(() => ClaimValidationService());
    _locator.registerLazySingleton<AccessibilityService>(() => AccessibilityService());

    // Register manual localization service and point the abstract service to it
    if (!_locator.isRegistered<ManualLocalizationService>()) {
      _locator.registerLazySingleton<ManualLocalizationService>(() => ManualLocalizationService());
    }
    _locator.registerLazySingleton<LocalizationService>(() => _locator<ManualLocalizationService>());

    // Initialize services that require it
    // ManualLocalizationService might not have an init method, if so, this line can be removed.
    // await _locator<ManualLocalizationService>().init(); 
    // print('[ServiceInitializer] ManualLocalizationService initialized.');

    // Ensure async singletons are ready before dependent services use them.
    await _locator.isReady<AuthService>();
    print('[ServiceInitializer] AuthService initialized.');

    // Register services that depend on AuthService
    // Register the new LocalDocumentStorageService
    _locator.registerLazySingleton<LocalDocumentStorageService>(() => LocalDocumentStorageService(_locator<AuthService>()));
    _locator.registerLazySingleton<DocumentStorageService>(() => _locator<LocalDocumentStorageService>());

    // Register services that depend on other services
    _locator.registerLazySingleton<ClaimSubmissionService>(() => ClaimSubmissionService(
        claimTrackingService: _locator<ClaimTrackingService>(),
        authService: _locator<AuthService>(),
    ));

    // Register viewmodels as factories
    _locator.registerFactory<AuthViewModel>(() => AuthViewModel(_locator<AuthService>()));
    _locator.registerFactory<DocumentViewModel>(() => DocumentViewModel(
      _locator<DocumentStorageService>(),
      _locator<LocalizationService>()
    ));
    _locator.registerFactory<DocumentScannerViewModel>(() => DocumentScannerViewModel(
      ocrService: _locator<DocumentOcrService>(),
      authService: _locator<AuthService>(),
    ));
    _locator.registerFactory<ClaimDashboardViewModel>(() => ClaimDashboardViewModel(
      trackingService: _locator<ClaimTrackingService>(),
      authService: _locator<AuthService>(),
    ));

    // Ensure all async and lazy singletons are ready before finishing.
    print('[ServiceInitializer] Waiting for all services to be ready...');
    await _locator.allReady();
    print('[ServiceInitializer] All services and viewmodels registered and ready.');
  }

  /// Deprecated synchronous initializer. Use initAsync() instead.
  @Deprecated('Use initAsync() instead for safe asynchronous initialization.')
  static void init() {
    // This method is deprecated and should not be used.
    // Calling the async init from here without awaiting it is a critical error.
    print('CRITICAL ERROR: Synchronous ServiceInitializer.init() was called. Use await ServiceInitializer.initAsync() instead.');
    // To prevent a crash, we do nothing. The app will likely fail later
    // if services are not initialized, but it won't be an immediate silent crash.
  }
  
  /// Get instance of registered service or viewmodel
  static T get<T extends Object>() {
    if (!_locator.isRegistered<T>()) {
      print('[ServiceInitializer] get<$T>: CRITICAL - _locator.isRegistered<$T>() is FALSE right before attempting _locator<T>(). Registered types might have been reset or lost.');
    } else {
      print('[ServiceInitializer] get<$T>: INFO - _locator.isRegistered<$T>() is TRUE right before attempting _locator<T>().');
    }
    final instance = _locator<T>();
    print('[ServiceInitializer] get<$T>() returning instance of type: ${instance.runtimeType}');
    return instance;
  }
  
  /// Override services for testing
  /// @param mocks Map of service types and their mock implementations
  static Future<void> overrideForTesting(Map<Type, Object> mocks) async {
    print('[ServiceInitializer] overrideForTesting() called. Setting _isTestMode = true.');
    _isTestMode = true;
    await _locator.reset(); // Reset all registrations before applying mocks

    // Register each mock service with its specific type
    mocks.forEach((type, implementation) {
      print('[ServiceInitializer] overrideForTesting: Processing type: $type with impl: ${implementation.runtimeType}');
      
      if (type == AuthService) {
        _locator.registerSingleton<AuthService>(implementation as AuthService);
        print('[ServiceInitializer] overrideForTesting: Registered AuthService with ${implementation.runtimeType}.');
      } else if (type == AccessibilityService) {
        _locator.registerSingleton<AccessibilityService>(implementation as AccessibilityService);
        print('[ServiceInitializer] overrideForTesting: Registered AccessibilityService with ${implementation.runtimeType}.');
      } else if (type == NotificationService) {
        _locator.registerSingleton<NotificationService>(implementation as NotificationService);
        print('[ServiceInitializer] overrideForTesting: Registered NotificationService with ${implementation.runtimeType}.');
      } else if (type == AviationStackService) {
        _locator.registerSingleton<AviationStackService>(implementation as AviationStackService);
      } else if (type == DocumentOcrService) {
        _locator.registerSingleton<DocumentOcrService>(implementation as DocumentOcrService);
      } else if (type == DocumentStorageService) {
        _locator.registerSingleton<DocumentStorageService>(implementation as DocumentStorageService);
      
      } else if (type == ClaimSubmissionService) {
        _locator.registerSingleton<ClaimSubmissionService>(implementation as ClaimSubmissionService);
      } else if (type == LocalizationService) {
        _locator.registerSingleton<LocalizationService>(implementation as LocalizationService);
      } else if (type == AccessibilityService) {
        _locator.registerSingleton<AccessibilityService>(implementation as AccessibilityService);
        print('[ServiceInitializer] overrideForTesting: Registered AccessibilityService with ${implementation.runtimeType}.');
      } else if (type == ManualLocalizationService) {
        _locator.registerSingleton<ManualLocalizationService>(implementation as ManualLocalizationService);
        print('[ServiceInitializer] overrideForTesting: Registered ManualLocalizationService with ${implementation.runtimeType}.');
      } else if (type == AviationStackService) {
        _locator.registerSingleton<AviationStackService>(implementation as AviationStackService);
        print('[ServiceInitializer] overrideForTesting: Registered AviationStackService with ${implementation.runtimeType}.');
      } else if (type == AccessibilityService) {
        _locator.registerSingleton<AccessibilityService>(implementation as AccessibilityService);
        print('[ServiceInitializer] overrideForTesting: Registered AccessibilityService with ${implementation.runtimeType}.');
      } else if (type == ErrorHandler) {
        _locator.registerSingleton<ErrorHandler>(implementation as ErrorHandler);
        print('[ServiceInitializer] overrideForTesting: Registered ErrorHandler with ${implementation.runtimeType}.');
      } else if (type == AuthViewModel) {
        _locator.registerFactory<AuthViewModel>(() => implementation as AuthViewModel);
      } else if (type == DocumentViewModel) {
        _locator.registerFactory<DocumentViewModel>(() => implementation as DocumentViewModel);
      } else if (type == DocumentScannerViewModel) {
        _locator.registerFactory<DocumentScannerViewModel>(() => implementation as DocumentScannerViewModel);
      } else if (type == ClaimDashboardViewModel) {
        _locator.registerFactory<ClaimDashboardViewModel>(() => implementation as ClaimDashboardViewModel);
      } else {
        print('[ServiceInitializer] overrideForTesting: Unknown service type encountered: $type');
        throw Exception('Attempted to mock an unknown service type: $type');
      }
    });
  }
  
  /// Reset all service registrations for testing
  static Future<void> resetForTesting() async {
    print('[ServiceInitializer] resetForTesting() called. Setting _isTestMode = false.');
    // Do not reset the locator here. It will be reset by the next test's call
    // to overrideForTesting(). This prevents race conditions during widget disposal.
    _isTestMode = false;
  }
  
  /// Set test mode
  static void setTestMode(bool isTest) {
    print('[ServiceInitializer] setTestMode() called. Setting _isTestMode to: $isTest');
    _isTestMode = isTest;
  }
  

  
  /// Get a mocked implementation in test mode
  static T getMock<T extends Object>() {
    if (!_isTestMode) {
      throw Exception('Cannot get mock outside of test mode');
    }
    return _locator.get<Object>(instanceName: T.toString()) as T;
  }
}
