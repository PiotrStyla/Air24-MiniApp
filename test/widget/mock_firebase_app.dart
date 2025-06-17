import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

// A mock implementation of FirebasePlatform.
// This is used to bypass the native Firebase initialization in tests.
class FakeFirebaseCore extends Fake implements FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _mockApp(name: name, options: options);
  }

  @override
  List<FirebaseAppPlatform> get apps => [_mockApp()];

  @override
  FirebaseAppPlatform app([String name = '[DEFAULT]']) {
    return _mockApp(name: name);
  }

  FirebaseAppPlatform _mockApp({String? name, FirebaseOptions? options}) {
    return MockFirebaseApp(
      name: name ?? '[DEFAULT]',
      options: options ??
          const FirebaseOptions(
            apiKey: 'mock-api-key',
            appId: 'mock-app-id',
            messagingSenderId: 'mock-sender-id',
            projectId: 'mock-project-id',
            storageBucket: 'mock-bucket.appspot.com',
          ),
    );
  }
}

// A mock implementation of FirebaseAppPlatform.
class MockFirebaseApp extends FirebaseAppPlatform {
  MockFirebaseApp({required String name, required FirebaseOptions options})
      : super(name, options);
}
