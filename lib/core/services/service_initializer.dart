import 'package:get_it/get_it.dart';
import '../../services/auth_service.dart';
import '../../viewmodels/auth_viewmodel.dart';

/// Service initializer for dependency injection
/// Following MVVM pattern with GetIt
class ServiceInitializer {
  static final GetIt _locator = GetIt.instance;

  /// Register all services and viewmodels
  static void init() {
    // Register services as singletons
    _locator.registerLazySingleton<AuthService>(() => AuthService());
    
    // Register viewmodels as factories
    _locator.registerFactory<AuthViewModel>(() => AuthViewModel(_locator<AuthService>()));
  }
  
  /// Get instance of registered service or viewmodel
  static T get<T extends Object>() => _locator<T>();
}
