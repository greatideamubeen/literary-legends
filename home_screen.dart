import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/question.dart';
import '../widgets/animated_button.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown.shade50, Colors.orange.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      const Text('📚', style: TextStyle(fontSize: 56)),
                      const SizedBox(height: 8),
                      Text(
                        'Literary Legends',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                          fontFamily: 'Georgia',
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Test your bookish knowledge',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.brown.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Player Name Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.shade100,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Name',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: provider.setPlayerName,
                        decoration: InputDecoration(
                          hintText: 'Enter your name...',
                          hintStyle: TextStyle(color: Colors.brown.shade300),
                          filled: true,
                          fillColor: Colors.brown.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Difficulty Selector
                Text(
                  'SELECT DIFFICULTY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade500,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _difficultyChip(context, 'Easy', Difficulty.easy, Colors.green),
                    const SizedBox(width: 8),
                    _difficultyChip(context, 'Medium', Difficulty.medium, Colors.orange),
                    const SizedBox(width: 8),
                    _difficultyChip(context, 'Hard', Difficulty.hard, Colors.red),
                  ],
                ),
                const SizedBox(height: 28),

                // Game Modes
                Text(
                  'CHOOSE GAME MODE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade500,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                ModeCard(
                  emoji: '📖',
                  title: 'Book Trivia',
                  description: 'Guess the book from the clue',
                  color: Colors.brown,
                  onTap: () => _startGame(context, GameMode.bookTrivia),
                ),
                ModeCard(
                  emoji: '✍️',
                  title: 'Author Quiz',
                  description: 'Match authors to their works',
                  color: Colors.teal,
                  onTap: () => _startGame(context, GameMode.authorQuiz),
                ),
                ModeCard(
                  emoji: '💬',
                  title: 'Quote Challenge',
                  description: 'Fill in the missing words',
                  color: Colors.purple,
                  onTap: () => _startGame(context, GameMode.quoteChallenge),
                ),
                ModeCard(
                  emoji: '⚡',
                  title: 'Speed Round',
                  description: 'Fast-paced rapid fire!',
                  color: Colors.amber.shade700,
                  onTap: () => _startGame(context, GameMode.speedRound),
                ),
                const SizedBox(height: 20),

                // Leaderboard Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                    ),
                    icon: const Icon(Icons.emoji_events, color: Colors.amber),
                    label: const Text(
                      'View Leaderboard',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade800,
                      foregroundColor: Colors.amber.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _difficultyChip(BuildContext context, String label, Difficulty diff, Color color) {
    final provider = context.watch<GameProvider>();
    final isSelected = provider.difficulty == diff;

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setDifficulty(diff),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, GameMode mode) {
    final provider = context.read<GameProvider>();
    provider.setMode(mode);
    provider.startGame();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }
}
