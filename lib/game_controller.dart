import 'dart:async';
import 'package:flutter/foundation.dart';
import 'card_model.dart';

class GameController extends ChangeNotifier {
  final int columns;
  final int rows;

  List<CardModel> cards = [];
  int? firstFlippedIndex;
  int? secondFlippedIndex;
  bool isChecking = false;

  int moves = 0;
  int matches = 0;
  int seconds = 0;
  bool gameOver = false;

  Timer? _timer;

  // All available emojis (needs at least 10 unique)
  static const List<String> _allEmojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
    '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
    '🦄', '🐲', '🌸', '⭐',
  ];

  GameController({required this.columns, required this.rows}) {
    _initGame();
  }

  int get totalPairs => (columns * rows) ~/ 2;

  void _initGame() {
    gameOver = false;
    moves = 0;
    matches = 0;
    seconds = 0;
    firstFlippedIndex = null;
    secondFlippedIndex = null;
    isChecking = false;

    final emojis = _allEmojis.sublist(0, totalPairs);
    final paired = [...emojis, ...emojis];
    paired.shuffle();

    cards = List.generate(
      paired.length,
      (i) => CardModel(id: i, emoji: paired[i]),
    );

    _timer?.cancel();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!gameOver) {
        seconds++;
        notifyListeners();
      }
    });
  }

  void flipCard(int index) {
    if (isChecking) return;
    if (cards[index].isFlipped) return;
    if (cards[index].isMatched) return;
    if (secondFlippedIndex != null) return;

    cards[index] = cards[index].copyWith(isFlipped: true);

    if (firstFlippedIndex == null) {
      firstFlippedIndex = index;
    } else {
      secondFlippedIndex = index;
      moves++;
      isChecking = true;
      notifyListeners();
      _checkMatch();
      return;
    }
    notifyListeners();
  }

  void _checkMatch() {
    final i1 = firstFlippedIndex!;
    final i2 = secondFlippedIndex!;

    if (cards[i1].emoji == cards[i2].emoji) {
      // Matched!
      Future.delayed(const Duration(milliseconds: 500), () {
        cards[i1] = cards[i1].copyWith(isMatched: true);
        cards[i2] = cards[i2].copyWith(isMatched: true);
        matches++;
        _reset();
        if (matches == totalPairs) {
          gameOver = true;
          _timer?.cancel();
        }
        notifyListeners();
      });
    } else {
      // No match — flip back
      Future.delayed(const Duration(milliseconds: 900), () {
        cards[i1] = cards[i1].copyWith(isFlipped: false);
        cards[i2] = cards[i2].copyWith(isFlipped: false);
        _reset();
        notifyListeners();
      });
    }
  }

  void _reset() {
    firstFlippedIndex = null;
    secondFlippedIndex = null;
    isChecking = false;
  }

  void restart() {
    _timer?.cancel();
    _initGame();
  }

  String get formattedTime {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
