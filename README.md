# 🧩 Memory Match — Flutter Game

> CS5450 Mobile Programming | Exercise 2 | Lakehead University

A classic card-flipping memory game built with Flutter and Dart. Flip cards to find matching emoji pairs — the game tracks your moves, matched pairs, and time elapsed.

---

## 📱 Screenshots


 !Home Screen]
<img width="724" height="1568" alt="image" src="https://github.com/user-attachments/assets/e9f04cb7-4e6c-448c-b7af-3355fc5fb664" />

  [Easy Mode]
 <img width="724" height="1568" alt="image" src="https://github.com/user-attachments/assets/e0dbf567-40f7-4ca9-91eb-7e16f33453fc" />
 
 [Medium Mode]
 <img width="724" height="1568" alt="image" src="https://github.com/user-attachments/assets/c5f5a5ad-91ab-4ddc-9a20-d6eab1d51e95" />
 

---

## ✨ Features

- **3 Difficulty Levels** — Easy (4×3, 6 pairs), Medium (4×4, 8 pairs), Hard (4×5, 10 pairs)
- **3D Card Flip Animation** — Smooth perspective flip using `AnimationController` and `Matrix4`, no external libraries
- **Live Stats Bar** — Tracks moves made, pairs found, and elapsed time (MM:SS)
- **Match Detection** — Unmatched cards flip back automatically; matched pairs show a green border
- **Win Dialog** — Shows total time and move count when all pairs are found
- **Restart Anytime** — Reset the board without leaving the game screen
- **Responsive Layout** — Card sizes calculated dynamically for any screen size
- **No Third-Party Game Libraries** — Built entirely with Flutter's core SDK

---

## 🗂️ Project Structure

```
memory_match/
├── lib/
│   ├── main.dart                 # Entry point; MaterialApp + HomeScreen
│   ├── game_screen.dart          # Main game UI (grid, stats bar, restart button)
│   ├── game_controller.dart      # All game logic, timer, match detection
│   ├── flip_card_widget.dart     # 3D flip animation widget
│   └── card_model.dart           # Data class: emoji, isFlipped, isMatched
├── android/
│   ├── app/
│   │   ├── build.gradle          # App-level Gradle config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/.../MainActivity.kt
│   │       └── res/              # Drawables, styles
│   ├── build.gradle              # Project-level Gradle config
│   ├── settings.gradle
│   ├── gradle.properties
│   └── gradle/wrapper/
│       └── gradle-wrapper.properties   # Gradle version (8.9)
├── test/
│   └── widget_test.dart          # Basic smoke test
├── pubspec.yaml                  # Flutter dependencies
├── analysis_options.yaml         # Lint rules
└── README.md                     # This file
```

---

## 🛠️ Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | 3.10 or higher |
| Dart SDK | 3.0.0 or higher (bundled with Flutter) |
| Android Studio | Hedgehog 2023.1.1 or newer |
| Android SDK | API 21+ (API 33 or 34 recommended) |
| Java | 21 (bundled with Android Studio) |

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/memory_match.git
cd memory_match
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Fix Gradle Version (Required)

Open `android/gradle/wrapper/gradle-wrapper.properties` and make sure this line reads:

```
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip
```

> **Why?** Flutter uses Java 21 internally, which requires Gradle 8.5 or higher.

### 4. Run the App

```bash
flutter run
```

Or open the project in Android Studio, select your emulator from the device dropdown, and press **Shift + F10**.

---

## 🏗️ Architecture

The app follows a simple **ChangeNotifier (MVVM-lite)** pattern:

| Layer | File | Responsibility |
|-------|------|----------------|
| Model | `card_model.dart` | Holds card state — emoji, isFlipped, isMatched |
| Controller | `game_controller.dart` | Game logic, timer, match detection, `notifyListeners()` |
| View | `game_screen.dart` | Listens to controller, rebuilds grid on state change |
| Widget | `flip_card_widget.dart` | Stateful widget with 3D flip animation |

---

## 🎮 How to Play

1. Launch the app and choose a difficulty — **Easy**, **Medium**, or **Hard**
2. Tap any card to flip it face-up and reveal the emoji
3. Tap a second card — if both cards show the same emoji, they stay face-up (matched!)
4. If they don't match, both cards flip back after a short delay
5. Keep going until all pairs are found
6. Try to finish in as few moves and as little time as possible!

---

## 🔧 Troubleshooting

**Gradle incompatible with Java**
> Change the Gradle version to `8.9` in `android/gradle/wrapper/gradle-wrapper.properties` as shown in Step 3 above.

**`flutter` command not found**
> Add Flutter's `bin` folder to your system PATH (e.g. `C:\flutter\bin` on Windows) and restart your terminal.

**`flutter pub get` fails**
> Check your internet connection and confirm `pubspec.yaml` is in the root of the project folder.

**Emulator not in device dropdown**
> Open **Tools → Device Manager** in Android Studio and press the Play button to start the emulator manually.

**App crashes on launch**
> Run `flutter clean` then `flutter pub get`, and try `flutter run` again.

---

## 📋 Grading Criteria (CS5450 Exercise 2)

| Category | Description |
|----------|-------------|
| Programming (Flutter/Dart) | Clean Dart code, proper state management, no third-party game libs |
| Functionalities | All game features working on Android emulator |
| App Design & Responsive Design | Adaptive layout, smooth animations, colour-coded cards |

---

## 📄 License

This project was created for academic purposes as part of CS5450 Mobile Programming at Lakehead University.

---

*Built with Flutter 3.24.5 · Dart 3.5.4 · Android Studio 2025.3.4*
