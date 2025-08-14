import 'package:flutter/material.dart';
import 'auth_screen.dart';

class EmailAuthScreen extends StatelessWidget {
  const EmailAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Legacy email auth screen now delegates to the centralized AuthScreen,
    // which uses AuthViewModel and FirebaseAuthService for all flows.
    return const AuthScreen();
  }
}