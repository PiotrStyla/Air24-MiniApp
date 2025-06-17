import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/document_storage_service.dart';
import '../../services/firestore_service.dart';
import '../../services/aviation_stack_service.dart';
import '../../services/document_ocr_service.dart';
import '../../services/notification_service.dart';
import '../../services/flight_prediction_service.dart';
import '../../services/claim_tracking_service.dart';
import '../../services/localization_service.dart';
import '../../services/manual_localization_service.dart';
import '../accessibility/accessibility_service.dart';
import '../../services/claim_submission_service.dart';
import '../error/error_handler.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/document_viewmodel.dart';
import '../../viewmodels/document_scanner_viewmodel.dart';
import '../../viewmodels/claim_dashboard_viewmodel.dart';

/// Service initializer for dependency injection
/// Following MVVM pattern with GetIt
class ServiceInitializer {
  static final GetIt _locator = GetIt.instance;
  static bool _isTestMode = false;

  /// Register all services and viewmodels
  static void init() {
    print('[ServiceInitializer] init() called. _isTestMode: $_isTestMode');
    // Skip initialization if in test mode with overrides
    if (_isTestMode) return;
    
    // Register services as singletons
    _locator.registerLazySingleton<AuthService>(() => AuthService());
    _locator.registerLazySingleton<DocumentStorageService>(() => DocumentStorageService());
    _locator.registerLazySingleton<FirestoreService>(() => FirestoreService());
    _locator.registerLazySingleton<AviationStackService>(() => AviationStackService(baseUrl: 'http://api.aviationstack.com/v1', pythonBackendUrl: 'YOUR_PYTHON_BACKEND_URL_HERE'));
    _locator.registerLazySingleton<DocumentOcrService>(() => DocumentOcrService());
    _locator.registerLazySingleton<NotificationService>(() => NotificationService());
    _locator.registerLazySingleton<FlightPredictionService>(() => FlightPredictionService());
    _locator.registerLazySingleton<ErrorHandler>(() => ErrorHandler());
    _locator.registerLazySingleton<ClaimTrackingService>(() => ClaimTrackingService());
    _locator.registerLazySingleton<AccessibilityService>(() => AccessibilityService());
    
    // Register localization service
    if (!_locator.isRegistered<LocalizationService>()) {
      LocalizationService.create().then((service) {
        if (!_locator.isRegistered<LocalizationService>()) {
          _locator.registerSingleton<LocalizationService>(service);
        }
      });
    }
    
    // Register manual localization service
    if (!_locator.isRegistered<ManualLocalizationService>()) {
      _locator.registerLazySingleton<ManualLocalizationService>(
        () => ManualLocalizationService()
      );
    }
    
    // Register viewmodels as factories
    _locator.registerFactory<AuthViewModel>(() => AuthViewModel(_locator<AuthService>()));
    _locator.registerFactory<DocumentViewModel>(() => DocumentViewModel(_locator<DocumentStorageService>()));
    _locator.registerFactory<DocumentScannerViewModel>(() => DocumentScannerViewModel(
      ocrService: _locator<DocumentOcrService>(),
      authService: _locator<AuthService>(),
    ));
    _locator.registerFactory<ClaimDashboardViewModel>(() => ClaimDashboardViewModel(
      firestoreService: _locator<FirestoreService>(),
      trackingService: _locator<ClaimTrackingService>(),
    ));
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
      switch (type) {
        case AviationStackService:
          _locator.registerSingleton<AviationStackService>(
              implementation as AviationStackService);
          break;
        case DocumentOcrService:
          _locator.registerSingleton<DocumentOcrService>(
              implementation as DocumentOcrService);
          break;
        case DocumentStorageService:
          _locator.registerSingleton<DocumentStorageService>(
              implementation as DocumentStorageService);
          break;
        case ClaimSubmissionService:
          _locator.registerSingleton<ClaimSubmissionService>(
              implementation as ClaimSubmissionService);
          break;
        case LocalizationService:
          _locator.registerSingleton<LocalizationService>(implementation as LocalizationService);
          break;
        case AccessibilityService:
          print('[ServiceInitializer] overrideForTesting: Matched case AccessibilityService.');
          _locator.registerSingleton<AccessibilityService>(implementation as AccessibilityService);
          print('[ServiceInitializer] overrideForTesting: Called _locator.registerSingleton for AccessibilityService with ${implementation.runtimeType}.');
          if (_locator.isRegistered<AccessibilityService>()) {
            print('[ServiceInitializer] overrideForTesting: VERIFIED - AccessibilityService IS registered in GetIt post-registration.');
          } else {
            print('[ServiceInitializer] overrideForTesting: CRITICAL FAILURE - AccessibilityService IS NOT registered in GetIt post-registration.');
          }
          break; // Corrected break for AccessibilityService
        case ManualLocalizationService:
          _locator.registerSingleton<ManualLocalizationService>(implementation as ManualLocalizationService);
          print('[ServiceInitializer] overrideForTesting: Registered ManualLocalizationService with ${implementation.runtimeType}.');
          break;
        case NotificationService:
          _locator.registerSingleton<NotificationService>(implementation as NotificationService);
          print('[ServiceInitializer] overrideForTesting: Registered NotificationService with ${implementation.runtimeType}.');
          break;
        case ErrorHandler:
          _locator.registerSingleton<ErrorHandler>(implementation as ErrorHandler);
          print('[ServiceInitializer] overrideForTesting: Registered ErrorHandler with ${implementation.runtimeType}.');
          break;
        case AuthService:
          _locator.registerSingleton<AuthService>(implementation as AuthService);
          break;
        case AuthViewModel:
          _locator.registerFactory<AuthViewModel>(() => implementation as AuthViewModel);
          break;
        case DocumentViewModel:
          _locator.registerFactory<DocumentViewModel>(() => implementation as DocumentViewModel);
          break;
        case DocumentScannerViewModel:
          _locator.registerFactory<DocumentScannerViewModel>(() => implementation as DocumentScannerViewModel);
          break;
        case ClaimDashboardViewModel:
          _locator.registerFactory<ClaimDashboardViewModel>(() => implementation as ClaimDashboardViewModel);
          break;
        default:
        print('[ServiceInitializer] overrideForTesting: Unknown service type encountered in switch: $type');
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
  
  /// Asynchronously initialize services that require async initialization
  static Future<void> initAsync() async {
    // Initialize any services that require async initialization
    if (!_locator.isRegistered<LocalizationService>()) {
      final localizationService = await LocalizationService.create();
      _locator.registerSingleton<LocalizationService>(localizationService);
    }
  }
  
  /// Get a mocked implementation in test mode
  static T getMock<T extends Object>() {
    if (!_isTestMode) {
      throw Exception('Cannot get mock outside of test mode');
    }
    return _locator.get<Object>(instanceName: T.toString()) as T;
  }
}
