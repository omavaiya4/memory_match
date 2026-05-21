class CardModel {
  final int id;
  final String emoji;
  final bool isFlipped;
  final bool isMatched;

  const CardModel({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardModel copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardModel(
      id: id,
      emoji: emoji,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
