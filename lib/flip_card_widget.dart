import 'dart:math';
import 'package:flutter/material.dart';
import 'card_model.dart';

class FlipCardWidget extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap;

  const FlipCardWidget({super.key, required this.card, required this.onTap});

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = false;

  // Distinct pastel back-colors per card index
  static const List<Color> _backColors = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43D9AD),
    Color(0xFFFFB347),
    Color(0xFF56CCF2),
    Color(0xFFBB6BD9),
  ];

  @override
  void initState() {
    super.initState();
    _showFront = widget.card.isFlipped || widget.card.isMatched;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_showFront) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(FlipCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldShow = widget.card.isFlipped || widget.card.isMatched;
    if (shouldShow && !_showFront) {
      _showFront = true;
      _controller.forward();
    } else if (!shouldShow && _showFront) {
      _showFront = false;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backColor = _backColors[widget.card.id % _backColors.length];

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          final angle = _animation.value * pi;
          final isFront = angle > pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildFront(),
                  )
                : _buildBack(backColor),
          );
        },
      ),
    );
  }

  Widget _buildBack(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text('?',
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFront() {
    final isMatched = widget.card.isMatched;
    return Container(
      decoration: BoxDecoration(
        color: isMatched ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMatched ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
          width: isMatched ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.card.emoji,
          style: const TextStyle(fontSize: 34),
        ),
      ),
    );
  }
}
