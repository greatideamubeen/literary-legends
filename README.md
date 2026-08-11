# 📚 Literary Legends

A beautiful, feature-rich book trivia gaming app built with Flutter.

## Features

- **4 Game Modes:**
  - 📖 Book Trivia — Guess the book from the clue
  - ✍️ Author Quiz — Match authors to their works
  - 💬 Quote Challenge — Fill in missing words from famous quotes
  - ⚡ Speed Round — Fast-paced rapid-fire questions

- **60+ Questions** across all modes and difficulty levels
- **3 Difficulty Levels:** Easy, Medium, Hard
- **Local Leaderboard** with persistent high scores
- **Beautiful Book-Themed UI** with animations
- **Confetti Celebration** for high scores
- **Fun Facts** after every question

## Screenshots

[Add your screenshots here]

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio or VS Code
- Android SDK

### Installation

```bash
# Clone or copy the project
cd literary_legends

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── question.dart         # Data models
├── data/
│   └── questions_data.dart   # 60+ questions
├── providers/
│   └── game_provider.dart    # State management
├── screens/
│   ├── home_screen.dart      # Main menu
│   ├── game_screen.dart      # Gameplay
│   ├── result_screen.dart    # Results with confetti
│   └── leaderboard_screen.dart # High scores
└── widgets/
    └── animated_button.dart  # Custom UI components
```

## Dependencies

- `provider` — State management
- `shared_preferences` — Local storage for leaderboard
- `confetti` — Celebration animations
- `audioplayers` — Sound effects (optional)
- `google_fonts` — Custom fonts
- `flutter_animate` — UI animations

## Publishing

See [PUBLISHING_GUIDE.md](PUBLISHING_GUIDE.md) for complete Play Store publishing instructions.

## License

This project is open source. Feel free to modify and distribute.

---

Made with ❤️ for book lovers everywhere.
