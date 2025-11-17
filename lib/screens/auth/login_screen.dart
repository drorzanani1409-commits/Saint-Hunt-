import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/parchment_background.dart';
import '../../widgets/parchment_text_field.dart';
import '../../widgets/ribbon_button.dart';
import '../../utils/constants.dart';
import '../map/map_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        // Navigate to map screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MapScreen(),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8B0000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParchmentBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Title
                  Text(
                    'SAINT HUNT',
                    style: TextStyle(
                      fontFamily: AppConstants.headingFont,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.brownText,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Log In Banner
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    decoration: BoxDecoration(
                      color: AppConstants.scrollworkBrown,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppConstants.brownText, width: 2),
                    ),
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                        fontFamily: AppConstants.bodyFont,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.gold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Email Address
                  ParchmentTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Password
                  ParchmentTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppConstants.brownText,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                        _showForgotPasswordDialog();
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: AppConstants.bodyFont,
                          fontSize: 14,
                          color: AppConstants.brownText,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Log In Button
                  RibbonButton(
                    text: 'LOG IN',
                    onPressed: _login,
                    isLoading: _isLoading,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign Up Link
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(
                        fontFamily: AppConstants.bodyFont,
                        fontSize: 16,
                        color: AppConstants.brownText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: TextStyle(
            fontFamily: AppConstants.headingFont,
            color: AppConstants.brownText,
          ),
        ),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _authService.resetPassword(emailController.text.trim());
                Navigator.pop(context);
                _showSuccess('Password reset email sent');
              } catch (e) {
                _showError(e.toString());
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.darkTeal,
      ),
    );
  }
}

