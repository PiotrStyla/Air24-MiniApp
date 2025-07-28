import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/auth_service_firebase.dart';
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
      // Load profile data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      
      if (mounted) {
        setState(() {
          // Load all saved profile data
          _nameController.text = prefs.getString('profile_displayName') ?? '';
          _phoneController.text = prefs.getString('profile_phone') ?? '';
          _passportController.text = prefs.getString('profile_passport') ?? '';
          _nationalityController.text = prefs.getString('profile_nationality') ?? '';
          _dobController.text = prefs.getString('profile_dateOfBirth') ?? '';
          _addressController.text = prefs.getString('profile_address') ?? '';
          _cityController.text = prefs.getString('profile_city') ?? '';
          _postalController.text = prefs.getString('profile_postalCode') ?? '';
          _countryController.text = prefs.getString('profile_country') ?? '';
          _consentData = prefs.getBool('profile_consentData') ?? false;
          _consentNotifications = prefs.getBool('profile_consentNotifications') ?? false;
          
          _loading = false;
        });
        
        print('Profile data loaded from SharedPreferences:');
        print('- Display Name: ${_nameController.text}');
        print('- Phone: ${_phoneController.text}');
        print('- All fields loaded successfully');
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorLoadingProfile))
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Text('Saving profile...'),
            ],
          ),
          duration: const Duration(seconds: 1),
        ),
      );
      
      // Save profile data using SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      
      // Save each field to SharedPreferences
      await prefs.setString('profile_displayName', _nameController.text.trim());
      await prefs.setString('profile_phone', _phoneController.text.trim());
      await prefs.setString('profile_passport', _passportController.text.trim());
      await prefs.setString('profile_nationality', _nationalityController.text.trim());
      await prefs.setString('profile_dateOfBirth', _dobController.text.trim());
      await prefs.setString('profile_address', _addressController.text.trim());
      await prefs.setString('profile_city', _cityController.text.trim());
      await prefs.setString('profile_postalCode', _postalController.text.trim());
      await prefs.setString('profile_country', _countryController.text.trim());
      await prefs.setBool('profile_consentData', _consentData);
      await prefs.setBool('profile_consentNotifications', _consentNotifications);
      
      print('Profile data saved to SharedPreferences:');
      print('- Display Name: ${_nameController.text.trim()}');
      print('- Phone: ${_phoneController.text.trim()}');
      print('- All fields saved successfully');
      
      // Also try to update AuthService display name if possible
      try {
        final authService = GetIt.instance<FirebaseAuthService>();
        if (authService.currentUser != null) {
          // Try to update Firebase user display name if available
          await authService.currentUser!.updateDisplayName(_nameController.text.trim());
          print('Firebase display name updated successfully');
        }
      } catch (e) {
        print('Could not update Firebase display name (this is OK in dev mode): $e');
      }
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileSaved),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Navigate back to profile screen
      Navigator.of(context).pop();
      
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editProfile)),
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
                      context.l10n.profileAccuracyInfo,
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
                    context.l10n.tipsAndReminders,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 6),
                  Text('• ${context.l10n.keepProfileUpToDate}'),
                  Text('• ${context.l10n.profilePrivacy}'),
                  Text('• ${context.l10n.correctContactDetails}'),
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
                    decoration: InputDecoration(labelText: context.l10n.fullName),
                    validator: (v) => v == null || v.isEmpty ? context.l10n.required : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: context.l10n.phoneNumber),
                    validator: (v) => v == null || v.isEmpty ? context.l10n.required : null,
                  ),
                  TextFormField(
                    controller: _passportController,
                    decoration: InputDecoration(labelText: context.l10n.passportNumber),
                  ),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: InputDecoration(labelText: context.l10n.nationality),
                  ),
                  // Date of Birth with date picker
                  TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: context.l10n.dateOfBirth,
                      prefixIcon: const Icon(Icons.calendar_today),
                      hintText: context.l10n.dateFormat,
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
                    decoration: InputDecoration(labelText: context.l10n.address),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: context.l10n.city),
                  ),
                  TextFormField(
                    controller: _postalController,
                    decoration: InputDecoration(labelText: context.l10n.postalCode),
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: context.l10n.country),
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
                            context.l10n.privacySettings,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SwitchListTile(
                          title: Text(context.l10n.consentToShareData),
                          subtitle: Text(context.l10n.requiredForProcessing),
                          value: _consentData,
                          onChanged: (v) => setState(() => _consentData = v),
                        ),
                        SwitchListTile(
                          title: Text(context.l10n.receiveNotifications),
                          subtitle: Text(context.l10n.getClaimUpdates),
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
                        context.l10n.saveProfile,
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
