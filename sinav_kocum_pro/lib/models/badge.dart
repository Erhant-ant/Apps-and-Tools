class Badge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final DateTime? earnedDate;
  final int count;

  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.earnedDate,
    this.count = 0,
  });

  Badge copyWith({DateTime? earnedDate, int? count}) {
    return Badge(
      id: id,
      title: title,
      description: description,
      emoji: emoji,
      earnedDate: earnedDate ?? this.earnedDate,
      count: count ?? this.count,
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
    Badge(
      id: 'mock_exam_100',
      title: 'Şampiyonlar Ligi',
      description: 'İlk kez bir denemede 100 neti geçtin! İnanılmazsın.',
      emoji: '🏆',
    ),
    Badge(
      id: 'streak_30',
      title: 'Efsanevi İstikrar',
      description: 'Tam 30 gün üst üste çalıştın! Saygı duyuyoruz.',
      emoji: '👑',
    ),
    Badge(
      id: 'night_owl',
      title: 'Gece Kuşu',
      description: 'Gece geç saatlere kadar masadan kalkmadın.',
      emoji: '🦉',
    ),
    Badge(
      id: 'early_bird',
      title: 'Erkenci Kuş',
      description: 'Güne herkes uykudayken masanın başında başladın.',
      emoji: '🌅',
    ),
    Badge(
      id: 'focus_master',
      title: 'Odaklanma Ustası',
      description: 'Tek oturuşta 2 saat boyunca hiç kalkmadan çalıştın.',
      emoji: '⏳',
    ),
  ];
}
