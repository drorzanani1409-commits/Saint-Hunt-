import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/parchment_background.dart';
import '../../widgets/parchment_text_field.dart';
import '../../widgets/ribbon_button.dart';
import '../../utils/constants.dart';
import '../character_selection_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      _showError('Please agree to the Terms of Use & Privacy Policy');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      if (userCredential != null && mounted) {
        // Navigate to character selection
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CharacterSelectionScreen(),
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
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'SAINT HUNT',
                    style: TextStyle(
                      fontFamily: AppConstants.headingFont,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.brownText,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sign Up Banner
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      color: AppConstants.scrollworkBrown,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppConstants.brownText, width: 2),
                    ),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: AppConstants.bodyFont,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.gold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Full Name
                  ParchmentTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
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
                  
                  const SizedBox(height: 20),
                  
                  // Phone Number
                  ParchmentTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password
                  ParchmentTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
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
                  
                  const SizedBox(height: 20),
                  
                  // Confirm Password
                  ParchmentTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: AppConstants.brownText,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Terms & Conditions Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() => _agreeToTerms = value ?? false);
                        },
                        activeColor: AppConstants.darkTeal,
                        checkColor: AppConstants.gold,
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the Terms of Use & Privacy Policy',
                          style: TextStyle(
                            fontFamily: AppConstants.bodyFont,
                            fontSize: 14,
                            color: AppConstants.brownText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign Up Button
                  RibbonButton(
                    text: 'SIGN UP',
                    onPressed: _signUp,
                    isLoading: _isLoading,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Log In Link
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        fontFamily: AppConstants.bodyFont,
                        fontSize: 16,
                        color: AppConstants.brownText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

