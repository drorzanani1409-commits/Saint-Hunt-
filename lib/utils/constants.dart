import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  // Geographic Configuration
  static const LatLng centerPoint = LatLng(29.8947, -81.3124); // 32 Saint George Street, St. Augustine, FL 32084
  static const double radiusMiles = 2.0;
  static const double radiusMeters = 3218.69; // 2 miles in meters
  
  // Location Trigger Distance (in meters)
  static const double locationTriggerRadius = 50.0;
  
  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 12.0;
  static const double maxMapZoom = 18.0;
  
  // Token Values
  static const int easyRiddleTokens = 5;
  static const int mediumRiddleTokens = 10;
  static const int hardRiddleTokens = 25;
  static const int bonusTokens = 50;
  
  // App Colors
  static const Color darkTeal = Color(0xFF1A3A3A);
  static const Color lightTeal = Color(0xFF2E5A5A);
  static const Color parchment = Color(0xFFF5E6D3);
  static const Color darkParchment = Color(0xFFD4A574);
  static const Color gold = Color(0xFFD4A574);
  static const Color darkGold = Color(0xFFB8935F);
  static const Color brownText = Color(0xFF3D2817);
  static const Color scrollworkBrown = Color(0xFF5C4033);
  
  // Text Styles
  static const String headingFont = 'CinzelDecorative';
  static const String bodyFont = 'Cinzel';
  
  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration longDuration = Duration(milliseconds: 600);
  
  // API Keys (To be added)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // App Info
  static const String appName = 'Saint Hunt';
  static const String appVersion = '1.0.0';
}

