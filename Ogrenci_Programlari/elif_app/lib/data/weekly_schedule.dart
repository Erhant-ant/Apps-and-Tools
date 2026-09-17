/// Haftalık Çalışma Programı Şablonu
/// Eşit ağırlık + KPSS profili için günlük 4-6 saat hedef
class WeeklySchedule {
  WeeklySchedule._();

  static List<DaySchedule> get weeklyPlan => [
    DaySchedule(
      day: 'Pazartesi',
      dayShort: 'Pzt',
      dayIndex: 1,
      totalMinutes: 300,
      sessions: [
        StudySession(subject: 'Türkçe', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'),
        StudySession(subject: 'Matematik', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'),
        StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 30, type: SessionType.review, description: 'Aralıklı tekrar konuları'),
        StudySession(subject: 'Coğrafya', emoji: '🌍', durationMinutes: 60, type: SessionType.practice, description: 'Soru çözümü'),
        StudySession(subject: 'Deneme Analizi', emoji: '📊', durationMinutes: 30, type: SessionType.analysis, description: 'Yanlış analizi'),
      ],
    ),
    DaySchedule(
      day: 'Salı',
      dayShort: 'Sal',
      dayIndex: 2,
      totalMinutes: 270,
      sessions: [
        StudySession(subject: 'Tarih', emoji: '📜', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'),
        StudySession(subject: 'Coğrafya', emoji: '🌍', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'),
        StudySession(subject: 'Türkçe', emoji: '📚', durationMinutes: 30, type: SessionType.practice, description: 'Paragraf denemesi'),
        StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 30, type: SessionType.review, description: 'Aralıklı tekrar'),
        StudySession(subject: 'Matematik', emoji: '📐', durationMinutes: 30, type: SessionType.practice, description: 'Soru çözümü'),
      ],
    ),
    DaySchedule(
      day: 'Çarşamba',
      dayShort: 'Çar',
      dayIndex: 3,
      totalMinutes: 300,
      sessions: [
        StudySession(subject: 'Matematik', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'),
        StudySession(subject: 'Edebiyat', emoji: '📖', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'),
        StudySession(subject: 'Vatandaşlık', emoji: '⚖️', durationMinutes: 45, type: SessionType.study, description: 'Konu çalışması'),
        StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 30, type: SessionType.review, description: 'Aralıklı tekrar'),
        StudySession(subject: 'Tarih', emoji: '📜', durationMinutes: 45, type: SessionType.practice, description: 'Soru çözümü'),
      ],
    ),
    DaySchedule(
      day: 'Perşembe',
      dayShort: 'Per',
      dayIndex: 4,
      totalMinutes: 285,
      sessions: [
        StudySession(subject: 'Tarih', emoji: '📜', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'),
        StudySession(subject: 'Coğrafya', emoji: '🌍', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'),
        StudySession(subject: 'Matematik', emoji: '📐', durationMinutes: 45, type: SessionType.practice, description: 'Soru çözümü'),
        StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 30, type: SessionType.review, description: 'Aralıklı tekrar'),
        StudySession(subject: 'Edebiyat', emoji: '📖', durationMinutes: 30, type: SessionType.practice, description: 'Soru çözümü'),
      ],
    ),
    DaySchedule(
      day: 'Cuma',
      dayShort: 'Cum',
      dayIndex: 5,
      totalMinutes: 300,
      sessions: [
        StudySession(subject: 'Türkçe', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'),
        StudySession(subject: 'Matematik', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'),
        StudySession(subject: 'Güncel Bilgiler', emoji: '📰', durationMinutes: 30, type: SessionType.study, description: 'Haber takibi'),
        StudySession(subject: 'Vatandaşlık', emoji: '⚖️', durationMinutes: 30, type: SessionType.practice, description: 'Soru çözümü'),
        StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 30, type: SessionType.review, description: 'Aralıklı tekrar'),
        StudySession(subject: 'Deneme Analizi', emoji: '📊', durationMinutes: 30, type: SessionType.analysis, description: 'Yanlış analizi'),
      ],
    ),
    DaySchedule(
      day: 'Cumartesi',
      dayShort: 'Cmt',
      dayIndex: 6,
      totalMinutes: 360,
      sessions: [
        StudySession(subject: 'Genel Deneme', emoji: '📝', durationMinutes: 165, type: SessionType.mockExam, description: 'TYT veya KPSS denemesi'),
        StudySession(subject: 'Deneme Analizi', emoji: '📊', durationMinutes: 60, type: SessionType.analysis, description: 'Sonuç değerlendirme'),
        StudySession(subject: 'Yanlış Analizi', emoji: '❌', durationMinutes: 60, type: SessionType.analysis, description: 'Yanlışlardan ders çıkar'),
        StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 45, type: SessionType.review, description: 'Zayıf konuları gözden geçir'),
        StudySession(subject: 'Ders Notu', emoji: '📝', durationMinutes: 30, type: SessionType.study, description: 'Eksik not çıkarma'),
      ],
    ),
    DaySchedule(
      day: 'Pazar',
      dayShort: 'Paz',
      dayIndex: 7,
      totalMinutes: 180,
      sessions: [
        StudySession(subject: 'Haftalık Tekrar', emoji: '🔄', durationMinutes: 90, type: SessionType.review, description: 'Bu hafta öğrenilenleri tekrar'),
        StudySession(subject: 'Eksik Konular', emoji: '📋', durationMinutes: 60, type: SessionType.study, description: 'Tamamlanmamış konular'),
        StudySession(subject: 'Motivasyon', emoji: '🧘', durationMinutes: 30, type: SessionType.motivation, description: 'Hedef değerlendirme ve motivasyon'),
      ],
    ),
  ];

  /// Bugünün programını getir
  static DaySchedule getTodaySchedule() {
    final weekday = DateTime.now().weekday; // 1 = Pazartesi
    return weeklyPlan.firstWhere(
      (d) => d.dayIndex == weekday,
      orElse: () => weeklyPlan.first,
    );
  }
}

/// Günlük Program
class DaySchedule {
  final String day;
  final String dayShort;
  final int dayIndex; // 1=Pazartesi, 7=Pazar
  final int totalMinutes;
  final List<StudySession> sessions;

  const DaySchedule({
    required this.day,
    required this.dayShort,
    required this.dayIndex,
    required this.totalMinutes,
    required this.sessions,
  });

  /// Saat ve dakika formatı
  String get formattedDuration {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (minutes == 0) return '$hours saat';
    return '$hours saat $minutes dakika';
  }
}

/// Çalışma Seansı
class StudySession {
  final String subject;
  final String emoji;
  final int durationMinutes;
  final SessionType type;
  final String description;
  bool isCompleted;

  StudySession({
    required this.subject,
    required this.emoji,
    required this.durationMinutes,
    required this.type,
    required this.description,
    this.isCompleted = false,
  });

  /// Dakika formatı
  String get formattedDuration {
    if (durationMinutes >= 60) {
      final hours = durationMinutes ~/ 60;
      final mins = durationMinutes % 60;
      if (mins == 0) return '$hours sa';
      return '$hours sa $mins dk';
    }
    return '$durationMinutes dk';
  }
}

/// Seans tipi
enum SessionType {
  study,       // Konu çalışma
  practice,    // Soru çözümü
  review,      // Tekrar
  mockExam,    // Deneme sınavı
  analysis,    // Analiz
  motivation,  // Motivasyon
}

extension SessionTypeExtension on SessionType {
  String get displayName {
    switch (this) {
      case SessionType.study:
        return 'Konu Çalışma';
      case SessionType.practice:
        return 'Soru Çözümü';
      case SessionType.review:
        return 'Tekrar';
      case SessionType.mockExam:
        return 'Deneme Sınavı';
      case SessionType.analysis:
        return 'Analiz';
      case SessionType.motivation:
        return 'Motivasyon';
    }
  }
}
