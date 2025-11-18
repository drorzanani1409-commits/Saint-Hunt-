import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/map/map_screen_3d.dart'; // NEW: Pokemon GO style 3D map
import 'utils/theme.dart';

// 🗺️ CHOOSE YOUR MAP STYLE:
// Set to true for 3D Pokemon GO style map (recommended!)
// Set to false for standard 2D map
const bool USE_3D_MAP = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase - Temporarily commented out
  // await Firebase.initializeApp();
  
  runApp(const SaintHuntApp());
}

class SaintHuntApp extends StatelessWidget {
  const SaintHuntApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saint Hunt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // User is logged in
        if (snapshot.hasData) {
          return USE_3D_MAP ? const MapScreen3D() : const MapScreen();
        }
        
        // User is not logged in
        return const LoginScreen();
      },
    );
  }
}

