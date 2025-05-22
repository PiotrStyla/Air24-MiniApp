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
    // Initialize controllers with empty values
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _passportController = TextEditingController();
    _nationalityController = TextEditingController();
    _dobController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalController = TextEditingController();
    _countryController = TextEditingController();
    
    // Then load profile data
    _loadProfile();
  }
  
  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _nationalityController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _countryController.dispose();
    super.dispose();
  }
  
  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _loading = false);
        return;
      }
      
      // Pre-fill email from Firebase Auth
      String userEmail = user.email ?? '';
      
      final profile = await FirestoreService().getUserProfile(user.uid);
      if (mounted) {
        setState(() {
          // If profile exists, use it
          if (profile != null) {
            _nameController.text = profile.fullName;
            _phoneController.text = profile.phoneNumber ?? '';
            _passportController.text = profile.passportNumber ?? '';
            _nationalityController.text = profile.nationality ?? '';
            _dobController.text = profile.dateOfBirth?.toIso8601String().split('T').first ?? '';
            _addressController.text = profile.addressLine ?? '';
            _cityController.text = profile.city ?? '';
            _postalController.text = profile.postalCode ?? '';
            _countryController.text = profile.country ?? '';
            _consentData = profile.consentToShareData;
            _consentNotifications = profile.consentToNotifications;
          } else {
            // If no profile yet, use what we know from Auth
            _nameController.text = user.displayName ?? '';
          }
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e'))
        );
      }
    }
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
                  // Date of Birth with date picker
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'YYYY-MM-DD',
                    ),
                    readOnly: true, // Prevent keyboard from appearing
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dobController.text.isNotEmpty
                            ? DateTime.tryParse(_dobController.text) ?? DateTime.now().subtract(const Duration(days: 365 * 18))
                            : DateTime.now().subtract(const Duration(days: 365 * 18)),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                      
                      if (pickedDate != null) {
                        setState(() {
                          _dobController.text = pickedDate.toIso8601String().split('T').first;
                        });
                      }
                    },
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
                  const SizedBox(height: 16),
                  
                  // Privacy and consent section with better styling
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16, top: 12),
                          child: Text(
                            'Privacy Settings',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SwitchListTile(
                          title: const Text('Consent to Share Data'),
                          subtitle: const Text('Required for processing compensation claims'),
                          value: _consentData,
                          onChanged: (v) => setState(() => _consentData = v),
                        ),
                        SwitchListTile(
                          title: const Text('Receive Notifications'),
                          subtitle: const Text('Get updates about your compensation claims'),
                          value: _consentNotifications,
                          onChanged: (v) => setState(() => _consentNotifications = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      label: const Text('SAVE PROFILE', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ], // end children of Column
        ), // end child of SingleChildScrollView
      ), // end body of Scaffold
    ); // end Scaffold

  }
}
