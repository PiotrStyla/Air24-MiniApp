import 'dart:async';
import 'dart:io';

import 'package:f35_flight_compensation/models/flight_document.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/services/auth_service.dart';
import 'package:f35_flight_compensation/viewmodels/document_viewmodel.dart';
import 'package:f35_flight_compensation/screens/document_management_screen.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';
import 'package:f35_flight_compensation/core/error/error_handler.dart';
import 'package:f35_flight_compensation/models/claim_status.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as auth_mocks;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// --- Mocks ---

class MockDocumentStorageService implements DocumentStorageService {
  List<FlightDocument> _documents = [];
  bool shouldThrowErrorOnFetch = false;
  bool shouldThrowErrorOnDelete = false;

  MockDocumentStorageService({List<FlightDocument>? initialDocs}) {
    _documents = initialDocs ?? [];
  }

  void setDocuments(List<FlightDocument> docs) {
    _documents = docs;
  }

  @override
  Stream<List<FlightDocument>> streamAllUserDocuments(String userId) {
    if (shouldThrowErrorOnFetch) {
      return Stream.error(Exception('Failed to fetch documents'));
    }
    // This stream is not actively used in the refactored tests, but we provide a valid implementation.
    return Stream.value(_documents);
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    if (shouldThrowErrorOnDelete) {
      throw Exception('Failed to delete document');
    }
    _documents.removeWhere((d) => d.id == document.id);
    setDocuments(_documents);
    return true;
  }

  @override
  Future<String?> uploadFile(File file, String flightNumber, FlightDocumentType type) async => 'mock_url';

  // --- Added missing methods ---
  @override
  Future<String?> createThumbnail(File file) async => null;

  @override
  Future<List<FlightDocument>> getAllUserDocuments() async => _documents;

  @override
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    return _documents.where((d) => d.flightNumber == flightNumber).toList();
  }

  @override
  Future<File?> pickImage(source) async => null;

  @override
  Future<File?> pickDocument() async => null;

  @override
  Future<FlightDocument?> saveDocument({
    required String flightNumber,
    required DateTime flightDate,
    required FlightDocumentType documentType,
    required String documentName,
    required String storageUrl,
    String? description,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final doc = FlightDocument(
      id: 'new_doc_id',
      userId: 'mock_user_id',
      flightNumber: flightNumber,
      flightDate: flightDate,
      documentType: documentType,
      documentName: documentName,
      storageUrl: storageUrl,
      uploadDate: DateTime.now(),
      description: description,
      thumbnailUrl: thumbnailUrl,
      metadata: metadata,
    );
    _documents.add(doc);
    setDocuments(_documents);
    return doc;
  }

  @override
  Stream<List<FlightDocument>> streamFlightDocuments(String flightNumber) {
    return Stream.value(_documents.where((d) => d.flightNumber == flightNumber).toList());
  }
}

class MockAuthService with ChangeNotifier implements AuthService {
  final auth_mocks.MockFirebaseAuth _auth;
  MockAuthService(this._auth);

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get userChanges => _auth.userChanges();

  @override
  String get userDisplayName => currentUser?.displayName ?? 'Mock User';

  @override
  Future<UserCredential> createUserWithEmail(String email, String password) => throw UnimplementedError();

  @override
  Future<void> resetPassword(String email) => throw UnimplementedError();

  @override
  Future<UserCredential> signInAnonymously() => throw UnimplementedError();

  @override
  Future<UserCredential> signInWithEmail(String email, String password) => throw UnimplementedError();

  @override
  Future<UserCredential?> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}

class MockLocalizationService with ChangeNotifier implements LocalizationService {
  Locale _locale = const Locale('en', 'US');

  @override
  Locale get currentLocale => _locale;

  @override
  Future<void> changeLanguage(Locale locale) async {
    _locale = locale;
    notifyListeners();
  }

  @override
  String getDisplayLanguage(String languageCode) => 'English';

  @override
  bool isSupported(Locale locale) => true;
}

class MockManualLocalizationService with ChangeNotifier implements ManualLocalizationService {
  @override
  bool get isReady => true;

  @override
  Locale get currentLocale => const Locale('en');

  final Map<String, String> _testStrings = {
    'noDocumentsYet': 'No documents attached yet',
    'errorLoadingDocuments': 'Error Loading Documents',
    'deleteDocumentTitle': 'Delete Document?',
    'delete': 'Delete',
  };

  @override
  String? getString(String key) {
    return _testStrings[key] ?? key;
  }

  @override
  String getLocalizedString(String key, [Map<String, String>? replacements, String? fallback]) {
    return _testStrings[key] ?? fallback ?? key;
  }

  @override
  String getDisplayLanguage(String languageCode) {
    return 'English';
  }

  @override
  Future<void> changeLocale(Locale locale) async {
    notifyListeners();
  }

  @override
  Future<void> ensureLanguageLoaded(String languageCode) async {}

  @override
  Future<void> forceReload(Locale locale) async {
    notifyListeners();
  }

  @override
  Locale getCurrentLocale() => const Locale('en');
}

class MockAccessibilityService with ChangeNotifier implements AccessibilityService {
  @override
  bool get highContrastMode => false;

  @override
  bool get largeTextMode => false;

  @override
  bool get screenReaderEmphasis => false;

  @override
  Future<void> initialize() async {}

  @override
  String semanticLabel(String shortLabel, String detailedLabel) => shortLabel;

  @override
  Future<void> toggleHighContrastMode() async {}

  @override
  Future<void> toggleLargeTextMode() async {}

  @override
  Future<void> toggleScreenReaderEmphasis() async {}

  @override
  ThemeData getThemeData(ThemeData baseTheme) => baseTheme;

  @override
  double getTextScaleFactor() => 1.0;
}

class MockNotificationService implements NotificationService {
  @override
  void dispose() {}

  @override
  Future<void> initialize() async {}

  @override
  Stream<String> get notificationTaps => Stream.empty();

  @override
  Future<void> saveDeviceToken() async {}

  @override
  Future<void> sendClaimStatusNotification(ClaimSummary claim) async {}

  @override
  Future<void> unsubscribeFromTopics() async {}
}

class MockErrorHandler implements ErrorHandler {
  @override
  void dispose() {}

  @override
  Stream<AppError> get errorStream => Stream.empty();

  @override
  Future<void> handleError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) async {}

  @override
  void showErrorUI(BuildContext context, AppError error) {}
}

// FIX: Mock the ViewModel to prevent null stream errors from the real implementation.
class MockDocumentViewModel extends ChangeNotifier implements DocumentViewModel {
  final MockDocumentStorageService _storageService;
  final _streamController = StreamController<List<FlightDocument>>.broadcast();
  List<FlightDocument> _currentDocs = [];

  MockDocumentViewModel(this._storageService);

  void addDocumentsToStream(List<FlightDocument> docs) {
    _currentDocs = docs;
    _streamController.add(docs);
  }

  void addErrorToStream(Object error) {
    _streamController.addError(error);
  }

  @override
  Stream<List<FlightDocument>> get documentsStream => _streamController.stream;

  @override
  Future<void> loadAllUserDocuments() async {
    // Simulate async network call to allow StreamBuilder to enter waiting state.
    await Future.delayed(Duration.zero);
    if (_storageService.shouldThrowErrorOnFetch) {
      _streamController.addError(Exception('Failed to fetch documents'));
      return;
    }
    final docs = await _storageService.getAllUserDocuments();
    addDocumentsToStream(docs);
  }

  @override
  Future<void> loadDocumentsForFlight(String flightNumber) async {
    // Simulate async network call.
    await Future.delayed(Duration.zero);
    if (_storageService.shouldThrowErrorOnFetch) {
      _streamController.addError(Exception('Failed to fetch documents'));
      return;
    }
    final docs = await _storageService.getFlightDocuments(flightNumber);
    addDocumentsToStream(docs);
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    final success = await _storageService.deleteDocument(document);
    if (success) {
      await loadAllUserDocuments();
    }
    return success;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
  
  // --- Unimplemented stubs --- 
  @override
  File? get selectedFile => null;
  @override
  bool get isUploading => false;
  @override
  String? get errorMessage => null;
  @override
  FlightDocumentType get selectedDocumentType => FlightDocumentType.other;
  @override
  String get documentName => '';
  @override
  String get description => '';
  @override
  bool get hasSelectedFile => false;
  @override
  String get flightNumber => '';
  @override
  DateTime get flightDate => DateTime.now();
  @override
  List<Map<String, dynamic>> get documentTypeOptions => [];
  @override
  void setFlightNumber(String value) {}
  @override
  void setFlightDate(DateTime value) {}
  @override
  void setDocumentType(FlightDocumentType type) {}
  @override
  void setDocumentName(String value) {}
  @override
  void setDescription(String value) {}
  @override
  void clearError() {}
  @override
  void clearSelectedFile() {}
  @override
  Future<bool> pickImage(source) async => false;
  @override
  Future<bool> pickDocument() async => false;
  @override
  Future<bool> uploadDocument() async => false;

  @override
  Future<bool> uploadSelectedFile() async => false;

  @override
  void loadDocuments(String? flightNumber) {
    if (flightNumber != null && flightNumber.isNotEmpty) {
      loadDocumentsForFlight(flightNumber);
    } else {
      loadAllUserDocuments();
    }
  }
}

void main() {
  late MockDocumentViewModel documentViewModel;
  late MockDocumentStorageService mockDocumentStorageService;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    ServiceInitializer.setTestMode(true);
  });

  setUp(() async {
    final mockAuth = auth_mocks.MockFirebaseAuth(signedIn: true, mockUser: auth_mocks.MockUser(uid: 'mock_user_id'));
    mockDocumentStorageService = MockDocumentStorageService();

    final mocks = <Type, Object>{
      AuthService: MockAuthService(mockAuth),
      DocumentStorageService: mockDocumentStorageService,
      LocalizationService: MockLocalizationService(),
      ManualLocalizationService: MockManualLocalizationService(),
      AccessibilityService: MockAccessibilityService(),
      NotificationService: MockNotificationService(),
      ErrorHandler: MockErrorHandler(),
    };

    await ServiceInitializer.overrideForTesting(mocks);

    mockDocumentStorageService = ServiceInitializer.get<DocumentStorageService>() as MockDocumentStorageService;
    documentViewModel = MockDocumentViewModel(mockDocumentStorageService);
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: ServiceInitializer.get<AuthService>()),
        ChangeNotifierProvider<LocalizationService>.value(value: ServiceInitializer.get<LocalizationService>()),
        ChangeNotifierProvider<ManualLocalizationService>.value(value: ServiceInitializer.get<ManualLocalizationService>()),
        ChangeNotifierProvider<AccessibilityService>.value(value: ServiceInitializer.get<AccessibilityService>()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  final testDocs = [
    FlightDocument(
      id: '1',
      userId: 'mock_user_id',
      flightNumber: 'f1',
      flightDate: DateTime.now(),
      documentType: FlightDocumentType.boardingPass,
      documentName: 'doc1.pdf',
      storageUrl: 'url1',
      uploadDate: DateTime.now(),
    ),
    FlightDocument(
      id: '2',
      userId: 'mock_user_id',
      flightNumber: 'f1',
      flightDate: DateTime.now(),
      documentType: FlightDocumentType.other,
      documentName: 'doc2.jpg',
      storageUrl: 'url2',
      uploadDate: DateTime.now(),
    ),
  ];

  testWidgets('Shows loading indicator then list of documents', (WidgetTester tester) async {
    mockDocumentStorageService.setDocuments(testDocs);

    await tester.pumpWidget(createTestWidget(DocumentManagementScreen(viewModel: documentViewModel)));
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('doc1.pdf'), findsOneWidget);
    expect(find.text('doc2.jpg'), findsOneWidget);
  });

  testWidgets('Shows empty state when no documents are available', (WidgetTester tester) async {
    mockDocumentStorageService.setDocuments([]);

    await tester.pumpWidget(createTestWidget(DocumentManagementScreen(viewModel: documentViewModel)));
    await tester.pumpAndSettle();

    expect(find.text('No documents attached yet'), findsOneWidget);
  });

  testWidgets('Shows error message if fetching documents fails', (WidgetTester tester) async {
    mockDocumentStorageService.shouldThrowErrorOnFetch = true;

    await tester.pumpWidget(createTestWidget(DocumentManagementScreen(viewModel: documentViewModel)));
    await tester.pumpAndSettle(); // Allow all scheduled frames to complete, including stream error

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Error Loading Documents'), findsOneWidget);
  });

  testWidgets('Tapping delete button shows confirmation dialog', (WidgetTester tester) async {
    mockDocumentStorageService.setDocuments([testDocs.first]);

    await tester.pumpWidget(createTestWidget(DocumentManagementScreen(viewModel: documentViewModel)));
    await tester.pumpAndSettle(); // Allow all scheduled frames to complete, including stream update

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle(); // Dialog animation

    expect(find.text('Delete Document?'), findsOneWidget);
  });

  testWidgets('Confirming deletion removes document from the list', (WidgetTester tester) async {
    final doc = testDocs.first;
    mockDocumentStorageService.setDocuments([doc]);

    await tester.pumpWidget(createTestWidget(DocumentManagementScreen(viewModel: documentViewModel)));
    await tester.pumpAndSettle(); // Allow all scheduled frames to complete, including stream update

    expect(find.text(doc.documentName), findsOneWidget);

    // Tap delete icon to show dialog
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle(); // Wait for dialog animation

    // Tap delete button in dialog
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle(); // Allow delete and subsequent stream update to complete

    // Check that the item is gone and the empty state is shown
    expect(find.text(doc.documentName), findsNothing);
    expect(find.text('No documents attached yet'), findsOneWidget);
  });
}
