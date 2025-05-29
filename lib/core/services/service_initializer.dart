import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/document_storage_service.dart';
import '../../services/firestore_service.dart';
import '../../services/aviation_stack_service.dart';
import '../../services/document_ocr_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/document_viewmodel.dart';
import '../../viewmodels/document_scanner_viewmodel.dart';

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
    
    // Register viewmodels as factories
    _locator.registerFactory<AuthViewModel>(() => AuthViewModel(_locator<AuthService>()));
    _locator.registerFactory<DocumentViewModel>(() => DocumentViewModel(_locator<DocumentStorageService>()));
    _locator.registerFactory<DocumentScannerViewModel>(() => DocumentScannerViewModel(
      ocrService: _locator<DocumentOcrService>(),
      auth: FirebaseAuth.instance,
    ));
  }
  
  /// Get instance of registered service or viewmodel
  static T get<T extends Object>() => _locator<T>();
}
