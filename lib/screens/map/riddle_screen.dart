import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/location_model.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/parchment_background.dart';
import '../../widgets/parchment_text_field.dart';
import '../../widgets/ribbon_button.dart';
import '../../utils/constants.dart';

class RiddleScreen extends StatefulWidget {
  final LocationModel location;

  const RiddleScreen({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  State<RiddleScreen> createState() => _RiddleScreenState();
}

class _RiddleScreenState extends State<RiddleScreen> {
  final _answerController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _showHint = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = widget.location.answer.toLowerCase();

    if (userAnswer.isEmpty) {
      _showError('Please enter an answer');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (userAnswer == correctAnswer) {
        await _awardTokens();
        _showSuccessDialog();
      } else {
        _showError('Incorrect answer. Try again!');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _awardTokens() async {
    final user = _authService.currentUser;
    if (user == null) return;

    final batch = FirebaseFirestore.instance.batch();

    // Update user's token balance and completed locations
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    batch.update(userRef, {
      'tokenBalance': FieldValue.increment(widget.location.tokenReward),
      'completedLocations': FieldValue.arrayUnion([widget.location.id]),
    });

    // Create transaction record
    final transactionRef = FirebaseFirestore.instance.collection('transactions').doc();
    final transaction = TransactionModel(
      id: transactionRef.id,
      userId: user.uid,
      amount: widget.location.tokenReward,
      type: 'earn',
      description: 'Completed ${widget.location.name}',
      timestamp: DateTime.now(),
    );
    batch.set(transactionRef, transaction.toFirestore());

    await batch.commit();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.parchment,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppConstants.scrollworkBrown, width: 3),
        ),
        title: Text(
          'Congratulations!',
          style: TextStyle(
            fontFamily: AppConstants.headingFont,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.brownText,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppConstants.darkTeal,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'You earned ${widget.location.tokenReward} tokens!',
              style: TextStyle(
                fontFamily: AppConstants.bodyFont,
                fontSize: 18,
                color: AppConstants.brownText,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.location.historicalInfo != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.darkTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.location.historicalInfo!,
                  style: TextStyle(
                    fontFamily: AppConstants.bodyFont,
                    fontSize: 14,
                    color: AppConstants.brownText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to map
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.scrollworkBrown,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Continue Hunt',
                style: TextStyle(
                  fontFamily: AppConstants.bodyFont,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.gold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppConstants.gold),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.location.name,
                        style: TextStyle(
                          fontFamily: AppConstants.headingFont,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.gold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Location Icon
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppConstants.darkTeal,
                            border: Border.all(
                              color: AppConstants.gold,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 60,
                            color: AppConstants.gold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Description
                      if (widget.location.description.isNotEmpty) ...[
                        Text(
                          widget.location.description,
                          style: TextStyle(
                            fontFamily: AppConstants.bodyFont,
                            fontSize: 16,
                            color: AppConstants.brownText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                      ],

                      // Riddle Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppConstants.darkTeal.withOpacity(0.1),
                          border: Border.all(
                            color: AppConstants.scrollworkBrown,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Solve the Riddle',
                              style: TextStyle(
                                fontFamily: AppConstants.headingFont,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.brownText,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.location.riddle,
                              style: TextStyle(
                                fontFamily: AppConstants.bodyFont,
                                fontSize: 18,
                                color: AppConstants.brownText,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Token Reward Display
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppConstants.scrollworkBrown.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppConstants.gold,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reward: ${widget.location.tokenReward} Tokens',
                              style: TextStyle(
                                fontFamily: AppConstants.bodyFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.brownText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Answer Input
                      ParchmentTextField(
                        label: 'Your Answer',
                        controller: _answerController,
                        keyboardType: TextInputType.text,
                      ),

                      const SizedBox(height: 20),

                      // Hint Button
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _showHint = !_showHint);
                        },
                        icon: Icon(
                          _showHint ? Icons.visibility_off : Icons.visibility,
                          color: AppConstants.darkTeal,
                        ),
                        label: Text(
                          _showHint ? 'Hide Hint' : 'Show Hint',
                          style: TextStyle(
                            fontFamily: AppConstants.bodyFont,
                            fontSize: 14,
                            color: AppConstants.darkTeal,
                          ),
                        ),
                      ),

                      if (_showHint) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppConstants.gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppConstants.gold,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Hint: Look carefully at the landmarks around you...',
                            style: TextStyle(
                              fontFamily: AppConstants.bodyFont,
                              fontSize: 14,
                              color: AppConstants.brownText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Submit Button
                      RibbonButton(
                        text: 'SUBMIT ANSWER',
                        onPressed: _submitAnswer,
                        isLoading: _isLoading,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

