import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessModel {
  final String id;
  final String name;
  final String description;
  final LatLng coordinates;
  final String category; // 'restaurant', 'shop', 'attraction', 'cafe'
  final String iconPath;
  final List<TokenOffer> offers;
  final Map<String, String> operatingHours; // day -> hours string
  final String? phoneNumber;
  final String? website;
  final String? address;
  final bool isActive;

  BusinessModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.category,
    required this.iconPath,
    this.offers = const [],
    this.operatingHours = const {},
    this.phoneNumber,
    this.website,
    this.address,
    this.isActive = true,
  });

  factory BusinessModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BusinessModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coordinates: LatLng(
        data['latitude'] ?? 0.0,
        data['longitude'] ?? 0.0,
      ),
      category: data['category'] ?? 'shop',
      iconPath: data['iconPath'] ?? 'assets/images/tokens/default.png',
      offers: (data['offers'] as List<dynamic>?)
              ?.map((offer) => TokenOffer.fromJson(offer as Map<String, dynamic>))
              .toList() ??
          [],
      operatingHours: Map<String, String>.from(data['operatingHours'] ?? {}),
      phoneNumber: data['phoneNumber'],
      website: data['website'],
      address: data['address'],
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'category': category,
      'iconPath': iconPath,
      'offers': offers.map((offer) => offer.toJson()).toList(),
      'operatingHours': operatingHours,
      'phoneNumber': phoneNumber,
      'website': website,
      'address': address,
      'isActive': isActive,
    };
  }
}

class TokenOffer {
  final String id;
  final String title;
  final String description;
  final int tokenCost;
  final String? imageUrl;
  final bool isActive;

  TokenOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.tokenCost,
    this.imageUrl,
    this.isActive = true,
  });

  factory TokenOffer.fromJson(Map<String, dynamic> json) {
    return TokenOffer(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tokenCost: json['tokenCost'] ?? 0,
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tokenCost': tokenCost,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }
}

