import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/question.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final entries = provider.leaderboard;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
        ),
        actions: [
          if (entries.isNotEmpty)
            IconButton(
              onPressed: () => _showClearDialog(context, provider),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear Leaderboard',
            ),
        ],
      ),
      body: entries.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final isTop3 = index < 3;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isTop3 ? _getPodiumColor(index) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.shade50,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: isTop3
                        ? Border.all(color: _getPodiumBorder(index), width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Rank
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isTop3 ? _getPodiumBorder(index) : Colors.brown.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isTop3 ? Colors.white : Colors.brown.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.playerName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  provider.getModeName(entry.mode),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.brown.shade500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '•',
                                  style: TextStyle(color: Colors.brown.shade300),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(entry.date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.brown.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Score
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${entry.score} pts',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'No scores yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Play a game to see your scores here.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPodiumColor(int index) {
    switch (index) {
      case 0: return Colors.amber.shade50;
      case 1: return Colors.grey.shade50;
      case 2: return Colors.orange.shade50;
      default: return Colors.white;
    }
  }

  Color _getPodiumBorder(int index) {
    switch (index) {
      case 0: return Colors.amber;
      case 1: return Colors.grey.shade500;
      case 2: return Colors.orange;
      default: return Colors.brown.shade200;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showClearDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Leaderboard?'),
        content: const Text('This will permanently delete all saved scores.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearLeaderboard();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
