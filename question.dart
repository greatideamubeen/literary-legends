enum GameMode { bookTrivia, authorQuiz, quoteChallenge, speedRound }

enum Difficulty { easy, medium, hard }

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final GameMode mode;
  final Difficulty difficulty;
  final String? bookTitle;
  final String? funFact;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.mode,
    required this.difficulty,
    this.bookTitle,
    this.funFact,
  });
}

class LeaderboardEntry {
  final String playerName;
  final int score;
  final int totalQuestions;
  final GameMode mode;
  final DateTime date;

  LeaderboardEntry({
    required this.playerName,
    required this.score,
    required this.totalQuestions,
    required this.mode,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'score': score,
    'totalQuestions': totalQuestions,
    'mode': mode.index,
    'date': date.toIso8601String(),
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
    playerName: json['playerName'],
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    mode: GameMode.values[json['mode']],
    date: DateTime.parse(json['date']),
  );
}
