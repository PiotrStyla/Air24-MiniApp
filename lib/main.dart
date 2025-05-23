import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/services/service_initializer.dart';
import 'services/auth_service.dart';
import 'services/document_storage_service.dart';
import 'services/firestore_service.dart';
import 'screens/main_navigation.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/auth_screen.dart'; // Using new auth screen
import 'screens/email_auth_screen.dart'; // Keep for backward compatibility
import 'screens/claim_submission_screen.dart';
import 'screens/flight_compensation_checker_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize services
  ServiceInitializer.init();
  
  runApp(const F35FlightCompensationApp());
}

class F35FlightCompensationApp extends StatelessWidget {
  const F35FlightCompensationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide global services
        Provider<AuthService>(
          create: (_) => ServiceInitializer.get<AuthService>(),
        ),
        Provider<DocumentStorageService>(
          create: (_) => ServiceInitializer.get<DocumentStorageService>(),
        ),
        Provider<FirestoreService>(
          create: (_) => ServiceInitializer.get<FirestoreService>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flight Compensation Assistant',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainNavigation(),
          // New improved auth screen
          '/auth': (context) => const AuthScreen(),
          // Keep old auth screen for backward compatibility
          '/email-auth': (context) => const EmailAuthScreen(),
          '/edit-profile': (context) => const ProfileEditScreen(),
          '/compensation-checker': (context) => const FlightCompensationCheckerScreen(),
          '/claim-submission': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            return ClaimSubmissionScreen(
              prefillFlightNumber: args?['prefillFlightNumber'],
              prefillDepartureAirport: args?['prefillDepartureAirport'],
              prefillArrivalAirport: args?['prefillArrivalAirport'],
              prefillFlightDate: args?['prefillFlightDate'],
            );
          },
        },
      ),
    );
  }
}