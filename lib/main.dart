import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const MemoryMatchApp());
}

class MemoryMatchApp extends StatelessWidget {
  const MemoryMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF3B37C8)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.extension, size: 90, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Memory Match',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Flip cards and find all pairs!',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 60),
              _DifficultyButton(
                label: 'Easy  (4 × 3)',
                subtitle: '6 pairs',
                color: const Color(0xFF4CAF50),
                onTap: () => _startGame(context, 4, 3),
              ),
              const SizedBox(height: 16),
              _DifficultyButton(
                label: 'Medium  (4 × 4)',
                subtitle: '8 pairs',
                color: const Color(0xFFFF9800),
                onTap: () => _startGame(context, 4, 4),
              ),
              const SizedBox(height: 16),
              _DifficultyButton(
                label: 'Hard  (4 × 5)',
                subtitle: '10 pairs',
                color: const Color(0xFFF44336),
                onTap: () => _startGame(context, 4, 5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, int cols, int rows) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(columns: cols, rows: rows),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
        ),
        child: Column(
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
