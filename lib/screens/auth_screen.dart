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
                        
                        // Logo or app icon
                        Hero(
                          tag: 'appLogo',
                          child: Container(
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flight_takeoff,
                              size: 60,
                              color: Theme.of(context).colorScheme.primary,
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
                        
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: context.l10n.email,
                            hintText: context.l10n.emailHintExample,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: viewModel.setEmail,
                        ),
                        
                        if (!_isResetPassword) ...[
                          const SizedBox(height: 16),
                          
                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: context.l10n.password,
                              hintText: context.l10n.passwordPlaceholder,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.obscurePassword 
                                    ? Icons.visibility_outlined 
                                    : Icons.visibility_off_outlined,
                                ),
                                onPressed: viewModel.togglePasswordVisibility,
                              ),
                            ),
                            obscureText: viewModel.obscurePassword,
                            textInputAction: _isSignUp 
                              ? TextInputAction.next 
                              : TextInputAction.done,
                            onChanged: viewModel.setPassword,
                          ),
                        ],
                        
                        // Confirm password field (only for sign up)
                        if (_isSignUp) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: context.l10n.confirmPassword,
                              hintText: context.l10n.passwordPlaceholder,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.obscureConfirmPassword 
                                    ? Icons.visibility_outlined 
                                    : Icons.visibility_off_outlined,
                                ),
                                onPressed: viewModel.toggleConfirmPasswordVisibility,
                              ),
                            ),
                            obscureText: viewModel.obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            onChanged: viewModel.setConfirmPassword,
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Primary action button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: viewModel.isLoading 
                            ? null 
                            : () async {
                                bool success = false;
                                
                                if (_isResetPassword) {
                                  success = await viewModel.resetPassword();
                                  if (success) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(context.l10n.passwordResetEmailSentMessage),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      setState(() {
                                        _isResetPassword = false;
                                      });
                                    }
                                  }
                                } else if (_isSignUp) {
                                  success = await viewModel.signUp();
                                  // The Navigator.pop(context) was removed from here.
                                  // AuthGate handles navigation automatically on auth state change.
                                } else {
                                  success = await viewModel.signIn();
                                  // The Navigator.pop(context) was removed from here.
                                  // AuthGate handles navigation automatically on auth state change.
                                }
                              },
                          child: Text(
                            _isResetPassword 
                              ? context.l10n.resetPassword
                              : _isSignUp 
                                ? context.l10n.createAccount 
                                : context.l10n.signIn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Google sign in button
                        if (!_isResetPassword)
                          OutlinedButton.icon(
                            icon: const GoogleLogo(size: 24),
                            label: Text(
                              _isSignUp 
                                ? context.l10n.signUpWithGoogle 
                                : context.l10n.signInWithGoogle
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: viewModel.isLoading 
                              ? null 
                              : () async {
                                  print('🔴 AUTH_SCREEN: Google Sign-In button pressed!');
                                  print('🔴 AUTH_SCREEN: About to call viewModel.signInWithGoogle()');
                                  final success = await viewModel.signInWithGoogle();
                                  print('🔴 AUTH_SCREEN: viewModel.signInWithGoogle() returned: $success');
                                  // The Navigator.pop(context) was removed from here.
                                  // AuthGate handles navigation automatically on auth state change.
                                },
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Toggle between sign in and sign up
                        if (!_isResetPassword)
                          TextButton(
                            onPressed: viewModel.isLoading 
                              ? null 
                              : () {
                                  setState(() {
                                    _isSignUp = !_isSignUp;
                                    viewModel.clearError();
                                  });
                                },
                            child: Text(
                              _isSignUp 
                                ? context.l10n.alreadyHaveAccountSignInCta 
                                : context.l10n.dontHaveAccountSignUpCta
                            ),
                          ),
                        
                        // Forgot password
                        if (!_isSignUp && !_isResetPassword)
                          TextButton(
                            onPressed: viewModel.isLoading 
                              ? null 
                              : () {
                                  setState(() {
                                    _isResetPassword = true;
                                    viewModel.clearError();
                                  });
                                },
                            child: Text(context.l10n.forgotPasswordQuestion),
                          ),
                        
                        // Back to sign in
                        if (_isResetPassword)
                          TextButton(
                            onPressed: viewModel.isLoading 
                              ? null 
                              : () {
                                  setState(() {
                                    _isResetPassword = false;
                                    viewModel.clearError();
                                  });
                                },
                            child: Text(context.l10n.backToSignIn),
                          ),
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
