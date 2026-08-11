import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_button.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final provider = context.read<GameProvider>();
      provider.tickTimer();

      if (provider.answered && !provider.isGameOver) {
        _timer?.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            provider.nextQuestion();
            if (!provider.isGameOver) {
              _startTimer();
            }
          }
        });
      }

      if (provider.isGameOver) {
        _timer?.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ResultScreen()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final question = provider.currentQuestion;

    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showQuitDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.close, color: Colors.brown.shade700),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Score: ${provider.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${provider.currentIndex + 1}/${provider.questions.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade600,
                    ),
                  ),
                   if (provider.currentMode.toString().contains('speedRound'))
                    _buildTimer(provider.timeLeft),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: provider.progress,
                  backgroundColor: Colors.brown.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown.shade700),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),

              // Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade100,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border(
                    left: BorderSide(color: Colors.brown.shade700, width: 5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getModeColor(provider.currentMode).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            provider.getModeName(provider.currentMode),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getModeColor(provider.currentMode),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(provider.difficulty).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            provider.getDifficultyLabel(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(provider.difficulty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.question,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.brown.shade900,
                        fontFamily: 'Georgia',
                        fontStyle: question.mode.toString().contains('quoteChallenge')
                             ? FontStyle.italic
                             : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AnimatedGameButton(
                        text: question.options[index],
                        onTap: () => _handleAnswer(index),
                        isCorrect: provider.answered && index == question.correctAnswerIndex,
                        isWrong: provider.answered && 
                                 provider.selectedAnswer == index && 
                                 index != question.correctAnswerIndex,
                        isCorrectAnswer: provider.answered && 
                                         index == question.correctAnswerIndex &&
                                         provider.selectedAnswer != index,
                        disabled: provider.answered,
                      ),
                    );
                  },
                ),
              ),

              // Fun Fact (shown after answering)
              if (provider.answered && question.funFact != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          question.funFact!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.brown.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(int timeLeft) {
    final isLow = timeLeft <= 5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: isLow ? Colors.red : Colors.orange),
          const SizedBox(width: 4),
          Text(
            '$timeLeft',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isLow ? Colors.red : Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Color _getModeColor(dynamic mode) {
  final value = mode.toString();

  if (value.contains('bookTrivia')) {
    return Colors.blue;
  }
  if (value.contains('authorQuiz')) {
    return Colors.teal;
  }
  if (value.contains('quoteChallenge')) {
    return Colors.purple;
  }
  if (value.contains('speedRound')) {
    return Colors.amber.shade700;
  }

  return Colors.blueGrey;
}

Color _getDifficultyColor(dynamic diff) {
  final value = diff.toString();

  if (value.contains('easy')) {
    return Colors.green;
  }
  if (value.contains('medium')) {
    return Colors.orange;
  }
  if (value.contains('hard')) {
    return Colors.red;
  }

  return Colors.blueGrey;
}
    
  void _handleAnswer(int index) {
    final provider = context.read<GameProvider>();
    provider.answerQuestion(index);

    if (index != provider.currentQuestion!.correctAnswerIndex) {
      _shakeController.forward(from: 0);
    }
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Leave Game?'),
        content: const Text('Your progress will be lost. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}
