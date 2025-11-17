import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String id;
  final String name;
  final String description;
  final LatLng coordinates;
  final String riddle;
  final String answer;
  final int tokenReward;
  final double triggerRadius; // in meters
  final String category; // 'landmark', 'historical', 'ghost_tour', etc.
  final String iconType; // 'ship', 'ghost', 'fort', 'cannon', etc.
  final String? historicalInfo;
  final bool isActive;

  LocationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.riddle,
    required this.answer,
    required this.tokenReward,
    this.triggerRadius = 50.0,
    required this.category,
    required this.iconType,
    this.historicalInfo,
    this.isActive = true,
  });

  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coordinates: LatLng(
        data['latitude'] ?? 0.0,
        data['longitude'] ?? 0.0,
      ),
      riddle: data['riddle'] ?? '',
      answer: data['answer'] ?? '',
      tokenReward: data['tokenReward'] ?? 5,
      triggerRadius: (data['triggerRadius'] ?? 50.0).toDouble(),
      category: data['category'] ?? 'landmark',
      iconType: data['iconType'] ?? 'default',
      historicalInfo: data['historicalInfo'],
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'riddle': riddle,
      'answer': answer,
      'tokenReward': tokenReward,
      'triggerRadius': triggerRadius,
      'category': category,
      'iconType': iconType,
      'historicalInfo': historicalInfo,
      'isActive': isActive,
    };
  }

  // Helper method to check if user is within trigger radius
  bool isWithinRange(LatLng userLocation) {
    return _calculateDistance(userLocation, coordinates) <= triggerRadius;
  }

  // Haversine formula to calculate distance between two coordinates
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    const double earthRadius = 6371000; // meters
    double lat1Rad = pos1.latitude * (3.14159265359 / 180);
    double lat2Rad = pos2.latitude * (3.14159265359 / 180);
    double deltaLat = (pos2.latitude - pos1.latitude) * (3.14159265359 / 180);
    double deltaLng = (pos2.longitude - pos1.longitude) * (3.14159265359 / 180);

    double a = (deltaLat / 2).abs() * (deltaLat / 2).abs() +
        lat1Rad.abs() * lat2Rad.abs() * (deltaLng / 2).abs() * (deltaLng / 2).abs();
    double c = 2 * (a.abs().clamp(0, 1));

    return earthRadius * c;
  }
}

