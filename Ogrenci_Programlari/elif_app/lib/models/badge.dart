class Badge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final DateTime? earnedDate;

  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.earnedDate,
  });

  Badge copyWith({DateTime? earnedDate}) {
    return Badge(
      id: id,
      title: title,
      description: description,
      emoji: emoji,
      earnedDate: earnedDate ?? this.earnedDate,
    );
  }

  bool get isEarned => earnedDate != null;
}

class AppBadges {
  static const List<Badge> allBadges = [
    Badge(
      id: 'first_topic',
      title: 'İlk Adım',
      description: 'İlk defa bir konuyu %100 tamamladın.',
      emoji: '🌱',
    ),
    Badge(
      id: 'streak_3',
      title: 'Isınma Turu',
      description: '3 gün üst üste çalıştın.',
      emoji: '🔥',
    ),
    Badge(
      id: 'streak_7',
      title: 'İstikrarlı Öğrenci',
      description: 'Tam 7 gün üst üste çalıştın! Harikasın.',
      emoji: '⚡',
    ),
    Badge(
      id: 'first_review',
      title: 'Hafıza Ustası',
      description: 'Aralıklı tekrar sistemindeki ilk konunu tekrar ettin.',
      emoji: '🧠',
    ),
    Badge(
      id: 'mock_exam_50',
      title: 'Barajı Aşan',
      description: 'İlk kez bir denemede 50 neti geçtin.',
      emoji: '🚀',
    ),
    Badge(
      id: 'mock_exam_75',
      title: 'Zirveye Doğru',
      description: 'İlk kez bir denemede 75 neti geçtin.',
      emoji: '🏔️',
    ),
  ];
}
