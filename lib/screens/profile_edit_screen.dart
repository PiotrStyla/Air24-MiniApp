import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';


class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passportController;
  late TextEditingController _nationalityController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalController;
  late TextEditingController _countryController;
  bool _consentData = false;
  bool _consentNotifications = false;

  bool _loading = true;


  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final profile = await FirestoreService().getUserProfile(user.uid);
    setState(() {

      _nameController = TextEditingController(text: profile?.fullName ?? '');
      _phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
      _passportController = TextEditingController(text: profile?.passportNumber ?? '');
      _nationalityController = TextEditingController(text: profile?.nationality ?? '');
      _dobController = TextEditingController(text: profile?.dateOfBirth?.toIso8601String().split('T').first ?? '');
      _addressController = TextEditingController(text: profile?.addressLine ?? '');
      _cityController = TextEditingController(text: profile?.city ?? '');
      _postalController = TextEditingController(text: profile?.postalCode ?? '');
      _countryController = TextEditingController(text: profile?.country ?? '');
      _consentData = profile?.consentToShareData ?? false;
      _consentNotifications = profile?.consentToNotifications ?? false;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final profile = UserProfile(
      uid: user.uid,
      fullName: _nameController.text,
      email: user.email ?? '',
      phoneNumber: _phoneController.text,
      passportNumber: _passportController.text,
      nationality: _nationalityController.text,
      dateOfBirth: _dobController.text.isNotEmpty ? DateTime.tryParse(_dobController.text) : null,
      addressLine: _addressController.text,
      city: _cityController.text,
      postalCode: _postalController.text,
      country: _countryController.text,
      consentToShareData: _consentData,
      consentToNotifications: _consentNotifications,
    );
    await FirestoreService().setUserProfile(profile);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 16),
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
                      'Please ensure your profile information is accurate. This is needed for claim processing and to contact you about your compensation.',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tips & Reminders',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 6),
                  const Text('• Keep your profile up to date for smooth claim processing.'),
                  const Text('• Your information is private and only used for compensation claims.'),
                  const Text('• Make sure your contact details are correct so we can reach you about your claim.'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _passportController,
                    decoration: const InputDecoration(labelText: 'Passport Number'),
                  ),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: const InputDecoration(labelText: 'Nationality'),
                  ),
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  TextFormField(
                    controller: _postalController,
                    decoration: const InputDecoration(labelText: 'Postal Code'),
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                  SwitchListTile(
                    title: const Text('Consent to Share Data'),
                    value: _consentData,
                    onChanged: (v) => setState(() => _consentData = v),
                  ),
                  SwitchListTile(
                    title: const Text('Consent to Receive Notifications'),
                    value: _consentNotifications,
                    onChanged: (v) => setState(() => _consentNotifications = v),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
                ],
              ),
            ),
          ], // end children of Column
        ), // end child of SingleChildScrollView
      ), // end body of Scaffold
    ); // end Scaffold

  }
}
