import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) {
              // Not signed in
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Not signed in'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.signInAnonymously();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signed in anonymously!')),
                      );
                    },
                    child: const Text('Sign In Anonymously'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/email-auth'),
                    child: const Text('Email Sign In/Up'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In with Google'),
                    onPressed: () async {
                      try {
                        await authService.signInWithGoogle();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed in with Google!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Google sign-in failed: $e')),
                        );
                      }
                    },
                  ),
                ],
              );
            }
            // Signed in - show profile info
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.photoURL != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                    radius: 40,
                  ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'No display name',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email ?? 'No email',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await authService.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed out!')),
                    );
                  },
                  child: const Text('Sign Out'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/email-auth'),
                  child: const Text('Email Sign In/Up'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}