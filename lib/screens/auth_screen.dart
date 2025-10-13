import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_localizations_patch.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import '../widgets/google_logo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignUp = false;
  bool _isResetPassword = false;

  // Map raw ViewModel error messages to localized strings
  String _mapAuthError(BuildContext context, String message) {
    final m = message.trim();
    if (m == 'Please enter a valid email address') {
      return context.l10n.authInvalidEmail;
    } else if (m == 'Password must be at least 6 characters') {
      return context.l10n.authPasswordMinLength;
    } else if (m == 'Passwords do not match') {
      return context.l10n.authPasswordsDoNotMatch;
    } else if (m == 'Please enter your email') {
      return context.l10n.authEmailRequired;
    } else if (m == 'Please enter your password') {
      return context.l10n.authPasswordRequired;
    } else if (m == 'An unexpected error occurred. Please try again.') {
      return context.l10n.authUnexpectedError;
    } else if (m == 'Google sign-in failed. Please try again.') {
      return context.l10n.authGoogleSignInFailed;
    } else if (m == 'Password reset failed. Please try again.') {
      return context.l10n.authPasswordResetFailed;
    } else if (m == 'Sign out failed. Please try again.') {
      return context.l10n.authSignOutFailed;
    }
    // Fallback to the raw message for unknown errors
    return message;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(
        Provider.of<FirebaseAuthService>(context, listen: false),
      ),
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, _) {
          // Update controllers when viewModel changes
          if (_emailController.text != viewModel.email) {
            _emailController.text = viewModel.email;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(_isResetPassword 
                ? context.l10n.resetPassword
                : _isSignUp 
                  ? context.l10n.createAccount 
                  : context.l10n.signIn),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        
                        // Logo (no colored circle background)
                        Hero(
                          tag: 'appLogo',
                          child: SizedBox(
                            height: 120,
                            child: Center(
                              child: Image.asset(
                                'assets/icons/app_icon.png',
                                width: 84,
                                height: 84,
                                fit: BoxFit.contain,
                                semanticLabel: 'App logo',
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Title
                        Text(
                          _isResetPassword 
                            ? context.l10n.resetPasswordTitle
                            : _isSignUp 
                              ? context.l10n.createAccount 
                              : context.l10n.welcomeBack,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        Text(
                          _isResetPassword 
                            ? context.l10n.resetPasswordSubtitle
                            : _isSignUp 
                              ? context.l10n.signUpSubtitle 
                              : context.l10n.signInSubtitle,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Error message
                        if (viewModel.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red[700]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _mapAuthError(context, viewModel.errorMessage!),
                                    style: TextStyle(color: Colors.red[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        if (viewModel.errorMessage != null)
                          const SizedBox(height: 24),
                        
                        // MINIAPP VERSION: Email/Password fields removed
                        // Only MiniKit authentication per World App requirements
                        
                        // Info text about World ID
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Sign in securely with World ID to access AIR24 and claim your flight compensation.',
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // World ID sign in button - MINIAPP VERSION (ONLY AUTH METHOD)
                        if (!_isResetPassword)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.verified_user, size: 24),
                            label: Text(
                              _isSignUp 
                                ? 'Sign Up with World ID' 
                                : 'Sign In with World ID'
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: viewModel.isLoading 
                              ? null 
                              : () async {
                                  print('🌍 MINIAPP: World ID/MiniKit Sign-In button pressed!');
                                  print('🌍 MINIAPP: About to call viewModel.signInWithWorldID()');
                                  final success = await viewModel.signInWithWorldID();
                                  print('🌍 MINIAPP: viewModel.signInWithWorldID() returned: $success');
                                  // AuthGate handles navigation automatically on auth state change.
                                },
                          ),
                        
                        // MINIAPP VERSION: Google/Email removed per World App requirements
                        // Only MiniKit authentication is allowed in Mini Apps
                        // Sign-up/sign-in toggle and password reset removed (not applicable for World ID)
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                // Loading overlay
                if (viewModel.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
