import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Keep for User type, but not for instance
import 'package:get_it/get_it.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
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
          SnackBar(content: Text(AppLocalizations.of(context)!.errorLoadingProfile))
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
      content: Text(AppLocalizations.of(context)!.profileSaved)
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editProfile)),
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
                      AppLocalizations.of(context)!.profileAccuracyInfo,
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
                    AppLocalizations.of(context)!.tipsAndReminders,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 6),
                  Text('• ${AppLocalizations.of(context)!.keepProfileUpToDate}'),
                  Text('• ${AppLocalizations.of(context)!.profilePrivacy}'),
                  Text('• ${AppLocalizations.of(context)!.correctContactDetails}'),
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
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.fullName),
                    validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.required : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.phoneNumber),
                    validator: (v) => v == null || v.isEmpty ? AppLocalizations.of(context)!.required : null,
                  ),
                  TextFormField(
                    controller: _passportController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.passportNumber),
                  ),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.nationality),
                  ),
                  // Date of Birth with date picker
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.dateOfBirth,
                      prefixIcon: const Icon(Icons.calendar_today),
                      hintText: AppLocalizations.of(context)!.dateFormat,
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
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.address),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.city),
                  ),
                  TextFormField(
                    controller: _postalController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.postalCode),
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.country),
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
                            AppLocalizations.of(context)!.privacySettings,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SwitchListTile(
                          title: Text(AppLocalizations.of(context)!.consentToShareData),
                          subtitle: Text(AppLocalizations.of(context)!.requiredForProcessing),
                          value: _consentData,
                          onChanged: (v) => setState(() => _consentData = v),
                        ),
                        SwitchListTile(
                          title: Text(AppLocalizations.of(context)!.receiveNotifications),
                          subtitle: Text(AppLocalizations.of(context)!.getClaimUpdates),
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
                        AppLocalizations.of(context)!.saveProfile,
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
