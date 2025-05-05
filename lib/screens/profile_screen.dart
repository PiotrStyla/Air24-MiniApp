import 'package:flutter/material.dart';
import 'faq_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Tooltip(
            message: 'FAQ & Help',
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your profile contains your personal and contact information. This is used to process your flight compensation claims and keep you updated.',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const Text('Profile settings will appear here.'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tips & Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                SizedBox(height: 6),
                Text('• Keep your profile up to date for smooth claim processing.'),
                Text('• Your information is private and only used for compensation claims.'),
                Text('• Make sure your contact details are correct so we can reach you about your claim.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
