import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String selectedCharacterId;
  final int tokenBalance;
  final List<String> completedLocations;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.selectedCharacterId,
    this.tokenBalance = 0,
    this.completedLocations = const [],
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      selectedCharacterId: data['selectedCharacterId'] ?? 'quartermaster',
      tokenBalance: data['tokenBalance'] ?? 0,
      completedLocations: List<String>.from(data['completedLocations'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'selectedCharacterId': selectedCharacterId,
      'tokenBalance': tokenBalance,
      'completedLocations': completedLocations,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? selectedCharacterId,
    int? tokenBalance,
    List<String>? completedLocations,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedCharacterId: selectedCharacterId ?? this.selectedCharacterId,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      completedLocations: completedLocations ?? this.completedLocations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

