import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/parchment_background.dart';
import '../../utils/constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    return Scaffold(
      body: ParchmentBackground(
        showScrollwork: false,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppConstants.darkTeal,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppConstants.gold),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Saint Hunt',
                        style: TextStyle(
                          fontFamily: AppConstants.headingFont,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.gold,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.darkTeal,
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('User data not found'));
                  }

                  final user = UserModel.fromFirestore(snapshot.data!);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Wallet Header
                        Center(
                          child: Text(
                            'Wallet',
                            style: TextStyle(
                              fontFamily: AppConstants.headingFont,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.brownText,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Token Balance Display
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppConstants.scrollworkBrown,
                                  border: Border.all(
                                    color: AppConstants.gold,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppConstants.gold,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${user.tokenBalance} Tokens',
                                style: TextStyle(
                                  fontFamily: AppConstants.headingFont,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.brownText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Token Balance Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppConstants.parchment,
                            border: Border.all(
                              color: AppConstants.scrollworkBrown,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Token Balance',
                                style: TextStyle(
                                  fontFamily: AppConstants.bodyFont,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.brownText,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppConstants.scrollworkBrown,
                                      border: Border.all(
                                        color: AppConstants.gold,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: AppConstants.gold,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${user.tokenBalance}',
                                    style: TextStyle(
                                      fontFamily: AppConstants.headingFont,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.brownText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Recent Redemptions
                        Text(
                          'Recent Redemptions',
                          style: TextStyle(
                            fontFamily: AppConstants.headingFont,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.brownText,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Transactions List
                        _buildTransactionsList(currentUser.uid),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'redeem')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppConstants.darkTeal,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppConstants.parchment.withOpacity(0.5),
              border: Border.all(
                color: AppConstants.scrollworkBrown,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No redemptions yet',
                style: TextStyle(
                  fontFamily: AppConstants.bodyFont,
                  fontSize: 16,
                  color: AppConstants.brownText.withOpacity(0.6),
                ),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: AppConstants.parchment.withOpacity(0.5),
            border: Border.all(
              color: AppConstants.scrollworkBrown,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => Divider(
              color: AppConstants.scrollworkBrown,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final transaction = TransactionModel.fromFirestore(
                snapshot.data!.docs[index],
              );

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.scrollworkBrown,
                    border: Border.all(
                      color: AppConstants.brownText,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.store,
                    color: AppConstants.gold,
                    size: 24,
                  ),
                ),
                title: Text(
                  transaction.getDisplayText(),
                  style: TextStyle(
                    fontFamily: AppConstants.bodyFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.brownText,
                  ),
                ),
                subtitle: Text(
                  transaction.getTimeAgo(),
                  style: TextStyle(
                    fontFamily: AppConstants.bodyFont,
                    fontSize: 12,
                    color: AppConstants.brownText.withOpacity(0.6),
                  ),
                ),
                trailing: Text(
                  '${transaction.amount}',
                  style: TextStyle(
                    fontFamily: AppConstants.bodyFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B0000),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

