import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../data/questions_data.dart';

class GameProvider extends ChangeNotifier {
  GameMode _currentMode = GameMode.bookTrivia;
  Difficulty _difficulty = Difficulty.easy;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;
  int _timeLeft = 15;
  bool _isGameOver = false;
  String _playerName = 'Player';
  List<LeaderboardEntry> _leaderboard = [];

  GameMode get currentMode => _currentMode;
  Difficulty get difficulty => _difficulty;
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get answered => _answered;
  int? get selectedAnswer => _selectedAnswer;
  int get timeLeft => _timeLeft;
  bool get isGameOver => _isGameOver;
  String get playerName => _playerName;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  Question? get currentQuestion => _questions.isNotEmpty && _currentIndex < _questions.length ? _questions[_currentIndex] : null;
  double get progress => _questions.isNotEmpty ? (_currentIndex + 1) / _questions.length : 0;

  GameProvider() {
    _loadLeaderboard();
  }

  void setMode(GameMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setDifficulty(Difficulty diff) {
    _difficulty = diff;
    notifyListeners();
  }

  void setPlayerName(String name) {
    _playerName = name.isNotEmpty ? name : 'Player';
    notifyListeners();
  }

  void startGame() {
    var allModeQuestions = getQuestionsByMode(_currentMode);

    // Filter by difficulty if not speed round
    if (_currentMode != GameMode.speedRound) {
      allModeQuestions = allModeQuestions.where((q) => q.difficulty == _difficulty).toList();
    }

    // Take 10 questions (or all if less than 10)
    _questions = allModeQuestions.take(10).toList();

    // If not enough questions for the difficulty, fill with others
    if (_questions.length < 10) {
      var remaining = getQuestionsByMode(_currentMode).where((q) => !_questions.contains(q)).toList();
      remaining.shuffle();
      _questions.addAll(remaining.take(10 - _questions.length));
    }

    _currentIndex = 0;
    _score = 0;
    _answered = false;
    _selectedAnswer = null;
    _timeLeft = _currentMode == GameMode.speedRound ? 10 : 15;
    _isGameOver = false;
    notifyListeners();
  }

  void answerQuestion(int index) {
    if (_answered || _isGameOver) return;

    _answered = true;
    _selectedAnswer = index;

    if (index == currentQuestion!.correctAnswerIndex) {
      _score++;
      // Bonus points for speed
      if (_currentMode == GameMode.speedRound) {
        _score += (_timeLeft ~/ 3);
      }
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _answered = false;
      _selectedAnswer = null;
      _timeLeft = _currentMode == GameMode.speedRound ? 10 : 15;
      notifyListeners();
    } else {
      _endGame();
    }
  }

  void tickTimer() {
    if (_answered || _isGameOver) return;

    _timeLeft--;
    if (_timeLeft <= 0) {
      _answered = true;
      _selectedAnswer = -1;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void _endGame() {
    _isGameOver = true;
    _saveScore();
    notifyListeners();
  }

  Future<void> _saveScore() async {
    final entry = LeaderboardEntry(
      playerName: _playerName,
      score: _score,
      totalQuestions: _questions.length,
      mode: _currentMode,
      date: DateTime.now(),
    );
    _leaderboard.add(entry);
    _leaderboard.sort((a, b) => b.score.compareTo(a.score));
    if (_leaderboard.length > 50) _leaderboard = _leaderboard.sublist(0, 50);

    final prefs = await SharedPreferences.getInstance();
    final data = _leaderboard.map((e) => e.toJson()).toList();
    await prefs.setString('leaderboard', jsonEncode(data));
    notifyListeners();
  }

  Future<void> _loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('leaderboard');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _leaderboard = list.map((e) => LeaderboardEntry.fromJson(e)).toList();
      notifyListeners();
    }
  }

  void clearLeaderboard() async {
    _leaderboard.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('leaderboard');
    notifyListeners();
  }

  String getModeName(GameMode mode) {
    switch (mode) {
      case GameMode.bookTrivia: return 'Book Trivia';
      case GameMode.authorQuiz: return 'Author Quiz';
      case GameMode.quoteChallenge: return 'Quote Challenge';
      case GameMode.speedRound: return 'Speed Round';
    }
  }

  String getModeDescription(GameMode mode) {
    switch (mode) {
      case GameMode.bookTrivia: return 'Guess the book from the clue';
      case GameMode.authorQuiz: return 'Match authors to their works';
      case GameMode.quoteChallenge: return 'Fill in the missing words';
      case GameMode.speedRound: return 'Fast-paced rapid fire!';
    }
  }

  String getModeEmoji(GameMode mode) {
    switch (mode) {
      case GameMode.bookTrivia: return '📖';
      case GameMode.authorQuiz: return '✍️';
      case GameMode.quoteChallenge: return '💬';
      case GameMode.speedRound: return '⚡';
    }
  }

  String getDifficultyLabel() {
    switch (_difficulty) {
      case Difficulty.easy: return 'Easy';
      case Difficulty.medium: return 'Medium';
      case Difficulty.hard: return 'Hard';
    }
  }
}
