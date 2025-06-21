import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Keep for User type, but not for instance
import 'package:get_it/get_it.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/user_profile.dart';
// import '../services/firestore_service.dart'; // Temporarily disabled
import '../utils/translation_helper.dart';
import '../utils/translation_initializer.dart';


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
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = GetIt.I<AuthViewModel>();
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
    
    // Ensure all translations are properly loaded
    TranslationInitializer.ensureAllTranslations();
    
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
      final user = _authViewModel.currentUser; // Use AuthViewModel
      if (user == null) {
        setState(() => _loading = false);
        return;
      }

      // TODO: Re-implement profile loading with the new service architecture
      if (mounted) {
        setState(() {
          // For now, just use the display name from the auth provider
          _nameController.text = user.displayName ?? '';
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(TranslationHelper.getString(
            context, 
            'errorLoadingProfile', 
            fallback: 'Error loading profile: $e'
          )))
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final user = _authViewModel.currentUser; // Use AuthViewModel
    if (user == null) return;

    // TODO: Re-implement profile saving with the new service architecture
    // final profile = UserProfile(...);
    // await NewProfileService().setUserProfile(profile);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(TranslationHelper.getString(context, 'profileSaved', fallback: 'Profile saved! (Feature temporarily disabled)'))
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(TranslationHelper.getString(context, 'editProfile', fallback: 'Edit Profile'))),
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
                      TranslationHelper.getString(
                        context, 
                        'profileAccuracyInfo', 
                        fallback: 'Please ensure your profile information is accurate. This is needed for claim processing and to contact you about your compensation.'
                      ),
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
                  Text(
                    TranslationHelper.getString(context, 'tipsAndReminders', fallback: 'Tips & Reminders'),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 6),
                  Text('• ${TranslationHelper.getString(context, 'keepProfileUpToDate', fallback: 'Keep your profile up to date for smooth claim processing.')}'),
                  Text('• ${TranslationHelper.getString(context, 'profilePrivacy', fallback: 'Your information is private and only used for compensation claims.')}'),
                  Text('• ${TranslationHelper.getString(context, 'correctContactDetails', fallback: 'Make sure your contact details are correct so we can reach you about your claim.')}'),
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
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'fullName', fallback: 'Full Name')),
                    validator: (v) => v == null || v.isEmpty ? TranslationHelper.getString(context, 'required', fallback: 'Required') : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'phoneNumber', fallback: 'Phone Number')),
                    validator: (v) => v == null || v.isEmpty ? TranslationHelper.getString(context, 'required', fallback: 'Required') : null,
                  ),
                  TextFormField(
                    controller: _passportController,
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'passportNumber', fallback: 'Passport Number')),
                  ),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'nationality', fallback: 'Nationality')),
                  ),
                  // Date of Birth with date picker
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: TranslationHelper.getString(context, 'dateOfBirth', fallback: 'Date of Birth'),
                      prefixIcon: const Icon(Icons.calendar_today),
                      hintText: TranslationHelper.getString(context, 'dateFormat', fallback: 'YYYY-MM-DD'),
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
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'address', fallback: 'Address')),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'city', fallback: 'City')),
                  ),
                  TextFormField(
                    controller: _postalController,
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'postalCode', fallback: 'Postal Code')),
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: TranslationHelper.getString(context, 'country', fallback: 'Country')),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 12),
                          child: Text(
                            TranslationHelper.getString(context, 'privacySettings', fallback: 'Privacy Settings'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SwitchListTile(
                          title: Text(TranslationHelper.getString(context, 'consentToShareData', fallback: 'Consent to Share Data')),
                          subtitle: Text(TranslationHelper.getString(context, 'requiredForProcessing', fallback: 'Required for processing compensation claims')),
                          value: _consentData,
                          onChanged: (v) => setState(() => _consentData = v),
                        ),
                        SwitchListTile(
                          title: Text(TranslationHelper.getString(context, 'receiveNotifications', fallback: 'Receive Notifications')),
                          subtitle: Text(TranslationHelper.getString(context, 'getClaimUpdates', fallback: 'Get updates about your compensation claims')),
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
                      label: Text(
                        TranslationHelper.getString(context, 'saveProfile', fallback: 'SAVE PROFILE'),
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
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
