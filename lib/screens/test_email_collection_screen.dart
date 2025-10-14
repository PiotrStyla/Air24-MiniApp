import 'package:flutter/material.dart';
import '../widgets/email_collection_dialog.dart';
import 'package:f35_flight_compensation/services/user_service.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:get_it/get_it.dart';

/// Test screen to manually trigger email collection dialog
class TestEmailCollectionScreen extends StatelessWidget {
  const TestEmailCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Email Collection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Test Email Collection Dialog',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Show Email Collection Dialog'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () async {
                final email = await showDialog<String>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const EmailCollectionDialog(),
                );

                if (email != null && email.isNotEmpty) {
                  // Save to Firestore
                  try {
                    final authService = GetIt.instance<FirebaseAuthService>();
                    final userId = authService.currentUser?.uid;
                    
                    if (userId != null) {
                      final userService = GetIt.instance<UserService>();
                      await userService.updateUserProfile(email: email);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✅ Email saved: $email'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ Email collection cancelled'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'This simulates what World ID users will see\nwhen submitting their first claim',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
