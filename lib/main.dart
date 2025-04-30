import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/main_navigation.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/email_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const F35FlightCompensationApp());
}

class F35FlightCompensationApp extends StatelessWidget {
  const F35FlightCompensationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Compensation Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/email-auth': (context) => const EmailAuthScreen(),
        '/edit-profile': (context) => const ProfileEditScreen(),
      },
    );
  }
}