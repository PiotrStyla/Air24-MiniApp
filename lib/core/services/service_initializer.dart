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

  /// Register all services and viewmodels
  static void init() {
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
}
