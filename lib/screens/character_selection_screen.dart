import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/auth_service.dart';
import '../widgets/parchment_background.dart';
import '../widgets/ribbon_button.dart';
import '../utils/constants.dart';
import 'map/map_screen.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({Key? key}) : super(key: key);

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final _authService = AuthService();
  final List<Character> _characters = Character.getDefaultCharacters();
  Character? _selectedCharacter;
  bool _isLoading = false;

  Future<void> _confirmSelection() async {
    if (_selectedCharacter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a character'),
          backgroundColor: Color(0xFF8B0000),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user != null) {
        await _authService.updateCharacterSelection(
          user.uid,
          _selectedCharacter!.id,
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MapScreen(),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFF8B0000),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParchmentBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Title
              Text(
                'CHOOSE YOUR PIRATE',
                style: TextStyle(
                  fontFamily: AppConstants.headingFont,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.brownText,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // Character Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _characters.length,
                  itemBuilder: (context, index) {
                    final character = _characters[index];
                    final isSelected = _selectedCharacter?.id == character.id;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCharacter = character);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppConstants.parchment,
                          border: Border.all(
                            color: isSelected
                                ? AppConstants.darkTeal
                                : AppConstants.scrollworkBrown,
                            width: isSelected ? 4 : 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppConstants.darkTeal.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppConstants.darkTeal.withOpacity(0.1),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: AppConstants.darkTeal,
                                  ),
                                  // TODO: Replace with actual character image
                                  // Image.asset(
                                  //   character.imagePath,
                                  //   fit: BoxFit.contain,
                                  // ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      character.name,
                                      style: TextStyle(
                                        fontFamily: AppConstants.bodyFont,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.brownText,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      character.description,
                                      style: TextStyle(
                                        fontFamily: AppConstants.bodyFont,
                                        fontSize: 10,
                                        color: AppConstants.brownText.withOpacity(0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Confirm Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: RibbonButton(
                  text: 'START HUNT',
                  onPressed: _confirmSelection,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

