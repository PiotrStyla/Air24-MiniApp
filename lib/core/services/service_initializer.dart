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
import '../accessibility/accessibility_service.dart';
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
    // Skip initialization if in test mode with overrides
    if (_isTestMode) return;
    
    // Register services as singletons
    _locator.registerLazySingleton<AuthService>(() => AuthService());
    _locator.registerLazySingleton<DocumentStorageService>(() => DocumentStorageService());
    _locator.registerLazySingleton<FirestoreService>(() => FirestoreService());
    _locator.registerLazySingleton<AviationStackService>(() => AviationStackService());
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
    
    // Register viewmodels as factories
    _locator.registerFactory<AuthViewModel>(() => AuthViewModel(_locator<AuthService>()));
    _locator.registerFactory<DocumentViewModel>(() => DocumentViewModel(_locator<DocumentStorageService>()));
    _locator.registerFactory<DocumentScannerViewModel>(() => DocumentScannerViewModel(
      ocrService: _locator<DocumentOcrService>(),
      auth: FirebaseAuth.instance,
    ));
    _locator.registerFactory<ClaimDashboardViewModel>(() => ClaimDashboardViewModel(
      firestoreService: _locator<FirestoreService>(),
      trackingService: _locator<ClaimTrackingService>(),
    ));
  }
  
  /// Get instance of registered service or viewmodel
  static T get<T extends Object>() => _locator<T>();
  
  /// Override services for testing
  /// @param mocks Map of service types and their mock implementations
  static void overrideForTesting(Map<Type, Object> mocks) {
    _isTestMode = true;
    
    // Reset any existing registrations first
    resetForTesting();
    
    // Register each mock service
    mocks.forEach((type, implementation) {
      if (_locator.isRegistered<Object>(instanceName: type.toString())) {
        _locator.unregister(instanceName: type.toString());
      }
      _locator.registerSingleton(implementation, instanceName: type.toString());
    });
  }
  
  /// Reset all service registrations for testing
  static void resetForTesting() {
    _locator.reset();
    _isTestMode = false;
  }
  
  /// Set test mode
  static void setTestMode(bool isTest) {
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
