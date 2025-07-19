import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
// Firebase options import is now conditional

import 'core/services/service_initializer.dart';
import 'core/accessibility/accessibility_service.dart';
import 'services/auth_service.dart';
import 'services/document_storage_service.dart';

import 'services/localization_service.dart';
import 'utils/translation_initializer.dart';
import 'screens/main_navigation.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/auth_screen.dart'; // Using new auth screen
import 'screens/email_auth_screen.dart'; // Keep for backward compatibility
import 'screens/claim_submission_screen.dart';
import 'screens/flight_compensation_checker_screen.dart';
import 'screens/accessibility_settings_screen.dart';
import 'screens/language_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  
  // Initialize Firebase if possible, otherwise continue in development mode
  try {
    // Only import firebase_options.dart if it exists
    // This will throw an error in development if the file doesn't exist
    try {
      // We use dynamic import to conditionally load the firebase options
      // Note: This is a workaround for development purposes only
      await Firebase.initializeApp();
      debugPrint('Firebase initialized with default options');
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      debugPrint('Continuing in development mode without Firebase');
    }
  } catch (e) {
    debugPrint('Firebase not available: $e');
    if (kDebugMode) {
      debugPrint('Running in development mode without Firebase');
    } else {
      // In production, Firebase is required
      throw Exception('Firebase configuration is required for production');
    }
  }

  // Initialize services asynchronously
  await ServiceInitializer.initAsync();
  
  // Ensure all translations are properly loaded at startup
  TranslationInitializer.ensureAllTranslations();
  
  runApp(const F35FlightCompensationApp());
}

class F35FlightCompensationApp extends StatelessWidget {
  const F35FlightCompensationApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get service instances
    final accessibilityService = ServiceInitializer.get<AccessibilityService>();
    final localizationService = ServiceInitializer.get<LocalizationService>();
    
    return MultiProvider(
      providers: [
        // Provide global services
        ChangeNotifierProvider<AuthService>(
          create: (_) => ServiceInitializer.get<AuthService>(),
        ),
        Provider<DocumentStorageService>(
          create: (_) => ServiceInitializer.get<DocumentStorageService>(),
        ),

        // Provide localization service with change notifier
        ChangeNotifierProvider<LocalizationService>.value(
          value: localizationService,
        ),
        // Provide accessibility service
        ChangeNotifierProvider<AccessibilityService>.value(
          value: accessibilityService,
        ),
      ],
      child: Consumer<AccessibilityService>(
        builder: (context, accessibilityService, _) {
          // Initialize accessibility service
          accessibilityService.initialize();
          
          // Get base theme
          final baseTheme = ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          );
          
          // Apply accessibility settings to theme
          final theme = accessibilityService.getThemeData(baseTheme);
          
          return Consumer<LocalizationService>(
            builder: (context, localizationService, _) {
              // Key ensures full app rebuild when localization changes
              return MaterialApp(
                key: ValueKey(localizationService.currentLocale.toString()),
                title: 'Flight Compensation Assistant',
                theme: theme,
                // Add localization support
                locale: localizationService.currentLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: LocalizationService.supportedLocales,
                // Support system text scaling preferences
                builder: (context, child) {
                  if (child == null) return Container();
                  
                  // Apply text scaling safely based on accessibility settings
                  final MediaQueryData mediaQueryData = MediaQuery.of(context);
                  final double textScaleFactor = accessibilityService.largeTextMode ? 1.3 : 1.0;
                  
                  // Use the fixed textScaler to avoid assertion errors
                  return MediaQuery(
                    data: mediaQueryData.copyWith(
                      // Use LinearTextScaler instead of directly specifying textScaler
                      // This avoids assertion errors with fontSize
                      textScaler: TextScaler.linear(textScaleFactor),
                    ),
                    child: child,
                  );
                },
                home: const AuthGate(),
                routes: {
                  // The '/' route is now handled by the AuthGate
                  // It is no longer needed here

                  // New improved auth screen
                  '/auth': (context) => const AuthScreen(),
                  // Keep old auth screen for backward compatibility
                  '/email-auth': (context) => const EmailAuthScreen(),
                  '/edit-profile': (context) => const ProfileEditScreen(),
                  '/compensation-checker': (context) => const FlightCompensationCheckerScreen(),
                  '/accessibility-settings': (context) => const AccessibilitySettingsScreen(),
                  '/language-selection': (context) => const LanguageSelectionScreen(),
                  '/claim-submission': (context) => const ClaimSubmissionScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    // The authService now uses ChangeNotifier. We watch it for changes
    // and rebuild the UI accordingly.
    if (authService.currentUser != null) {
      return const MainNavigation();
    } else {
      return const AuthScreen();
    }
  }
}