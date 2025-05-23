import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/auth_service.dart';
import '../widgets/google_logo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignUp = false;
  bool _isResetPassword = false;

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
        Provider.of<AuthService>(context, listen: false),
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
                ? 'Reset Password'
                : _isSignUp 
                  ? 'Create Account' 
                  : 'Sign In'),
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
                            ? 'Reset your password'
                            : _isSignUp 
                              ? 'Create your account' 
                              : 'Welcome back',
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
                            ? 'Enter your email to receive a password reset link'
                            : _isSignUp 
                              ? 'Sign up to track your flight compensation claims' 
                              : 'Sign in to access your flight compensation claims',
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
                                    viewModel.errorMessage!,
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
                            labelText: 'Email',
                            hintText: 'your.email@example.com',
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
                              labelText: 'Password',
                              hintText: '********',
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
                              labelText: 'Confirm Password',
                              hintText: '********',
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
                                        const SnackBar(
                                          content: Text('Password reset email sent! Check your inbox.'),
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
                                  if (success && mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  success = await viewModel.signIn();
                                  if (success && mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                          child: Text(
                            _isResetPassword 
                              ? 'Reset Password'
                              : _isSignUp 
                                ? 'Create Account' 
                                : 'Sign In',
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
                                ? 'Sign up with Google' 
                                : 'Sign in with Google'
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
                                  final success = await viewModel.signInWithGoogle();
                                  if (success && mounted) {
                                    Navigator.pop(context);
                                  }
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
                                ? 'Already have an account? Sign In' 
                                : 'Don\'t have an account? Sign Up'
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
                            child: const Text('Forgot Password?'),
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
                            child: const Text('Back to Sign In'),
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
