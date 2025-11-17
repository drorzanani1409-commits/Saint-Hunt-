import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String? businessId;
  final String? businessName;
  final String? businessIcon;
  final int amount; // positive for earning, negative for spending
  final String type; // 'earn', 'redeem'
  final String? description;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.userId,
    this.businessId,
    this.businessName,
    this.businessIcon,
    required this.amount,
    required this.type,
    this.description,
    required this.timestamp,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      businessId: data['businessId'],
      businessName: data['businessName'],
      businessIcon: data['businessIcon'],
      amount: data['amount'] ?? 0,
      type: data['type'] ?? 'earn',
      description: data['description'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'businessId': businessId,
      'businessName': businessName,
      'businessIcon': businessIcon,
      'amount': amount,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Helper to get human-readable time ago
  String getTimeAgo() {
    final difference = DateTime.now().difference(timestamp);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Format for display in wallet
  String getDisplayText() {
    if (type == 'redeem') {
      return businessName ?? 'Unknown Business';
    } else {
      return description ?? 'Token earned';
    }
  }
}

