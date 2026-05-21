import 'package:flutter/material.dart';
import 'game_controller.dart';
import 'flip_card_widget.dart';

class GameScreen extends StatefulWidget {
  final int columns;
  final int rows;

  const GameScreen({super.key, required this.columns, required this.rows});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        GameController(columns: widget.columns, rows: widget.rows);
    _controller.addListener(_onUpdate);
  }

  void _onUpdate() {
    if (mounted) setState(() {});
    if (_controller.gameOver) {
      Future.delayed(const Duration(milliseconds: 300), _showWinDialog);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _showWinDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Text('🎉', style: TextStyle(fontSize: 50)),
            SizedBox(height: 8),
            Text('You Win!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statRow('⏱ Time', _controller.formattedTime),
            const SizedBox(height: 8),
            _statRow('🔄 Moves', '${_controller.moves}'),
            const SizedBox(height: 8),
            _statRow('✅ Pairs', '${_controller.matches}'),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _controller.restart();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Play Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('Menu'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6C63FF),
              side: const BorderSide(color: Color(0xFF6C63FF)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const padding = 16.0;
    const cardSpacing = 8.0;

    final cardWidth =
        (screenWidth - padding * 2 - cardSpacing * (widget.columns - 1)) /
            widget.columns;
    final maxGridHeight = screenHeight * 0.60;
    final cardHeight =
        ((maxGridHeight - cardSpacing * (widget.rows - 1)) / widget.rows)
            .clamp(60.0, 100.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        title: const Text('Memory Match',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            color: const Color(0xFF6C63FF),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statChip(Icons.swap_horiz, 'Moves', '${_controller.moves}'),
                _statChip(Icons.check_circle_outline, 'Pairs',
                    '${_controller.matches}/${_controller.totalPairs}'),
                _statChip(Icons.timer_outlined, 'Time',
                    _controller.formattedTime),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Card grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                  crossAxisSpacing: cardSpacing,
                  mainAxisSpacing: cardSpacing,
                  childAspectRatio: cardWidth / cardHeight,
                ),
                itemCount: _controller.cards.length,
                itemBuilder: (context, index) {
                  final card = _controller.cards[index];
                  return FlipCardWidget(
                    key: ValueKey(card.id),
                    card: card,
                    onTap: () => _controller.flipCard(index),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Restart button
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: ElevatedButton.icon(
              onPressed: _controller.restart,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(label,
                style:
                    const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
