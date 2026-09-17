/// Haftalık Çalışma Programı Şablonu
/// Her sınavın kendi ders bloğu var, birleştirilip minimum günlük 4 saat garanti edilir.
/// Sınav sayısı arttıkça günlük çalışma süresi de artar.
class WeeklySchedule {
  WeeklySchedule._();

  /// Minimum günlük çalışma süresi (dakika)
  static const int _minDailyMinutes = 240; // 4 saat

  /// Sınav türlerine göre dinamik program oluştur
  static List<DaySchedule> getWeeklyPlan(List<String> examIds) {
    bool hasKpss = examIds.any((id) => id.contains('kpss'));
    bool hasTyt = examIds.contains('tyt_2027');
    bool hasAyt = examIds.contains('ayt_2027');
    bool hasYdt = examIds.contains('ydt_2027');
    bool hasYds = examIds.any((id) => id.startsWith('yds_'));
    bool hasDgs = examIds.any((id) => id.contains('dgs'));
    bool hasAles = examIds.any((id) => id.contains('ales'));
    bool hasTus = examIds.any((id) => id.contains('tus'));

    // Eğer hiçbir şey seçilmemişse varsayılan olarak hepsini gösterelim
    if (!hasKpss && !hasTyt && !hasAyt && !hasYdt && !hasYds && !hasDgs && !hasAles && !hasTus) {
      hasTyt = true;
      hasKpss = true;
    }

    return [
      _buildDay('Pazartesi', 'Pzt', 1, hasTyt, hasKpss, hasAyt, hasYdt, hasYds, hasDgs, hasAles, hasTus),
      _buildDay('Salı', 'Sal', 2, hasTyt, hasKpss, hasAyt, hasYdt, hasYds, hasDgs, hasAles, hasTus),
      _buildDay('Çarşamba', 'Çar', 3, hasTyt, hasKpss, hasAyt, hasYdt, hasYds, hasDgs, hasAles, hasTus),
      _buildDay('Perşembe', 'Per', 4, hasTyt, hasKpss, hasAyt, hasYdt, hasYds, hasDgs, hasAles, hasTus),
      _buildDay('Cuma', 'Cum', 5, hasTyt, hasKpss, hasAyt, hasYdt, hasYds, hasDgs, hasAles, hasTus),
      _buildSaturday(),
      _buildSunday(),
    ];
  }

  /// Her gün için bağımsız ders blokları oluştur ve birleştir
  static DaySchedule _buildDay(
    String day, String dayShort, int dayIndex,
    bool hasTyt, bool hasKpss, bool hasAyt, bool hasYdt, bool hasYds, bool hasDgs, bool hasAles, bool hasTus,
  ) {
    final List<StudySession> sessions = [];

    // ═══ Her sınavın kendi sabit ders blokları ═══
    // Sınav çıkınca kendi blokları kalkar, ama diğer sınavların blokları AYNEN kalır

    switch (dayIndex) {
      case 1: // Pazartesi
        if (hasTyt) {
          sessions.add(StudySession(subject: 'Türkçe (TYT)', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Matematik (TYT)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
        }
        if (hasKpss) {
          sessions.add(StudySession(subject: 'Türkçe (KPSS)', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Coğrafya (KPSS)', emoji: '🌍', durationMinutes: 60, type: SessionType.practice, description: 'Soru çözümü'));
        }
        if (hasAyt) {
          sessions.add(StudySession(subject: 'Matematik (AYT)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'İleri düzey konu çalışması'));
        }
        if (hasYdt) {
          sessions.add(StudySession(subject: 'İngilizce', emoji: '🇬🇧', durationMinutes: 90, type: SessionType.study, description: 'Kelime ve Çeviri'));
        }
        if (hasYds) {
          sessions.add(StudySession(subject: 'Kelime Ezberi (YDS)', emoji: '🧠', durationMinutes: 60, type: SessionType.study, description: 'Akademik kelime listeleri'));
          sessions.add(StudySession(subject: 'Makale Okuması', emoji: '📰', durationMinutes: 45, type: SessionType.practice, description: 'BBC News veya The Economist'));
        }
        if (hasDgs) {
          sessions.add(StudySession(subject: 'Matematik (DGS)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Türkçe (DGS)', emoji: '📚', durationMinutes: 60, type: SessionType.study, description: 'Sözel Mantık / Paragraf'));
        }
        if (hasAles) {
          sessions.add(StudySession(subject: 'Sayısal Mantık (ALES)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Sözel (ALES)', emoji: '📚', durationMinutes: 60, type: SessionType.study, description: 'Paragraf / Sözel Mantık'));
        }
        if (hasTus) {
          sessions.add(StudySession(subject: 'Temel Bilimler (TUS)', emoji: '🧬', durationMinutes: 210, type: SessionType.study, description: 'Anatomi / Biyokimya'));
          sessions.add(StudySession(subject: 'Klinik Bilimler (TUS)', emoji: '🩺', durationMinutes: 210, type: SessionType.study, description: 'Dahiliye Soru Çözümü'));
        }
        break;

      case 2: // Salı
        if (hasTyt) {
          sessions.add(StudySession(subject: 'Tarih (TYT)', emoji: '📜', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Coğrafya (TYT)', emoji: '🌍', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
        }
        if (hasKpss) {
          sessions.add(StudySession(subject: 'Tarih (KPSS)', emoji: '📜', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Coğrafya (KPSS)', emoji: '🌍', durationMinutes: 60, type: SessionType.study, description: 'Konu çalışması'));
        }
        if (hasAyt) {
          sessions.add(StudySession(subject: 'Edebiyat (AYT)', emoji: '📖', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Tarih (AYT)', emoji: '📜', durationMinutes: 60, type: SessionType.study, description: 'Konu çalışması'));
        }
        if (hasYdt) {
          sessions.add(StudySession(subject: 'İngilizce (Okuma)', emoji: '🇬🇧', durationMinutes: 60, type: SessionType.practice, description: 'Reading Comprehension'));
        }
        if (hasYds) {
          sessions.add(StudySession(subject: 'Paragraf Analizi', emoji: '🔍', durationMinutes: 90, type: SessionType.study, description: 'Paragraf tamamlama & detaylı çeviri'));
          sessions.add(StudySession(subject: 'Dinleme (Listening)', emoji: '🎧', durationMinutes: 30, type: SessionType.practice, description: 'İngilizce podcast veya TEDx'));
        }
        if (hasDgs) {
          sessions.add(StudySession(subject: 'Matematik (DGS)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Geometri / Sayısal Mantık'));
          sessions.add(StudySession(subject: 'Türkçe (DGS)', emoji: '📚', durationMinutes: 60, type: SessionType.study, description: 'Anlam Bilgisi'));
        }
        if (hasAles) {
          sessions.add(StudySession(subject: 'Matematik (ALES)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Geometri / Sayısal Mantık'));
          sessions.add(StudySession(subject: 'Sözel (ALES)', emoji: '📚', durationMinutes: 60, type: SessionType.study, description: 'Anlam Bilgisi'));
        }
        if (hasTus) {
          sessions.add(StudySession(subject: 'Klinik Bilimler (TUS)', emoji: '🩺', durationMinutes: 210, type: SessionType.study, description: 'Pediatri / Cerrahi'));
          sessions.add(StudySession(subject: 'TUS Soru Çözümü', emoji: '📝', durationMinutes: 180, type: SessionType.practice, description: 'Karma Klinik Soru Çözümü'));
        }
        break;

      case 3: // Çarşamba
        if (hasTyt) {
          sessions.add(StudySession(subject: 'Matematik (TYT)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Fen Bilimleri (TYT)', emoji: '🔬', durationMinutes: 60, type: SessionType.study, description: 'Fizik-Kimya-Biyoloji'));
        }
        if (hasKpss) {
          sessions.add(StudySession(subject: 'Matematik (KPSS)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Vatandaşlık (KPSS)', emoji: '⚖️', durationMinutes: 60, type: SessionType.study, description: 'Konu çalışması'));
        }
        if (hasAyt) {
          sessions.add(StudySession(subject: 'Edebiyat (AYT)', emoji: '📖', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Coğrafya (AYT)', emoji: '🌍', durationMinutes: 60, type: SessionType.study, description: 'Konu çalışması'));
        }
        if (hasYdt) {
          sessions.add(StudySession(subject: 'İngilizce (Gramer)', emoji: '🇬🇧', durationMinutes: 90, type: SessionType.study, description: 'Dilbilgisi'));
        }
        if (hasYds) {
          sessions.add(StudySession(subject: 'YDS Gramer', emoji: '📘', durationMinutes: 90, type: SessionType.study, description: 'Ağır dilbilgisi & Cloze Test'));
          sessions.add(StudySession(subject: 'Bilimsel Makale', emoji: '🧬', durationMinutes: 45, type: SessionType.practice, description: 'Scientific American veya Nature'));
        }
        if (hasDgs) {
          sessions.add(StudySession(subject: 'Matematik (DGS)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Problemler'));
          sessions.add(StudySession(subject: 'Matematik Soru Çözümü', emoji: '📝', durationMinutes: 60, type: SessionType.practice, description: 'Problemler Karışık Soru'));
        }
        if (hasAles) {
          sessions.add(StudySession(subject: 'Sayısal (ALES)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Problemler'));
          sessions.add(StudySession(subject: 'Sayısal Soru Çözümü', emoji: '📝', durationMinutes: 60, type: SessionType.practice, description: 'Problemler Karışık Soru'));
        }
        if (hasTus) {
          sessions.add(StudySession(subject: 'Temel Bilimler (TUS)', emoji: '🧬', durationMinutes: 210, type: SessionType.study, description: 'Farmakoloji / Patoloji'));
          sessions.add(StudySession(subject: 'TUS Tekrar', emoji: '🔁', durationMinutes: 180, type: SessionType.study, description: 'Hızlı Spot Tekrarı'));
        }
        break;

      case 4: // Perşembe
        if (hasTyt) {
          sessions.add(StudySession(subject: 'Tarih (TYT)', emoji: '📜', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Sosyal Bilimler (TYT)', emoji: '🏛️', durationMinutes: 60, type: SessionType.study, description: 'Felsefe-Din Kültürü'));
        }
        if (hasKpss) {
          sessions.add(StudySession(subject: 'Tarih (KPSS)', emoji: '📜', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Güncel Bilgiler (KPSS)', emoji: '📰', durationMinutes: 45, type: SessionType.study, description: 'Haber takibi'));
        }
        if (hasAyt) {
          sessions.add(StudySession(subject: 'Matematik (AYT)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Alan çalışması'));
          sessions.add(StudySession(subject: 'Edebiyat (AYT)', emoji: '📖', durationMinutes: 60, type: SessionType.practice, description: 'Soru çözümü'));
        }
        if (hasYdt) {
          sessions.add(StudySession(subject: 'İngilizce Soru Çözümü', emoji: '📝', durationMinutes: 60, type: SessionType.practice, description: 'Cloze Test & Çeviri'));
        }
        if (hasYds) {
          sessions.add(StudySession(subject: 'Cümle & Anlam', emoji: '🧩', durationMinutes: 90, type: SessionType.practice, description: 'Cümle tamamlama ve anlam bozan cümle'));
          sessions.add(StudySession(subject: 'İngilizce Film/Dizi', emoji: '🎬', durationMinutes: 60, type: SessionType.motivation, description: 'Altyazılı film veya dizi izleme'));
        }
        if (hasDgs) {
          sessions.add(StudySession(subject: 'Türkçe (DGS)', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Sözel Mantık İleri Seviye'));
          sessions.add(StudySession(subject: 'DGS Soru Çözümü', emoji: '📝', durationMinutes: 60, type: SessionType.practice, description: 'Sözel Mantık Soru Çözümü'));
        }
        if (hasAles) {
          sessions.add(StudySession(subject: 'Sözel (ALES)', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Sözel Mantık İleri Seviye'));
          sessions.add(StudySession(subject: 'ALES Soru Çözümü', emoji: '📝', durationMinutes: 60, type: SessionType.practice, description: 'Sözel Mantık Soru Çözümü'));
        }
        if (hasTus) {
          sessions.add(StudySession(subject: 'Klinik Bilimler (TUS)', emoji: '🩺', durationMinutes: 210, type: SessionType.study, description: 'Kadın Doğum / Küçük Stajlar'));
          sessions.add(StudySession(subject: 'TUS Denemesi (Yarım)', emoji: '📝', durationMinutes: 180, type: SessionType.practice, description: '50 Soruluk Deneme'));
        }
        break;

      case 5: // Cuma
        if (hasTyt) {
          sessions.add(StudySession(subject: 'Türkçe (TYT)', emoji: '📚', durationMinutes: 90, type: SessionType.study, description: 'Konu + Soru Çözümü'));
          sessions.add(StudySession(subject: 'Matematik (TYT)', emoji: '📐', durationMinutes: 60, type: SessionType.practice, description: 'Soru çözümü'));
        }
        if (hasKpss) {
          sessions.add(StudySession(subject: 'Türkçe (KPSS)', emoji: '📚', durationMinutes: 60, type: SessionType.practice, description: 'Soru çözümü'));
          sessions.add(StudySession(subject: 'Vatandaşlık (KPSS)', emoji: '⚖️', durationMinutes: 45, type: SessionType.practice, description: 'Soru çözümü'));
          sessions.add(StudySession(subject: 'Güncel Bilgiler (KPSS)', emoji: '📰', durationMinutes: 30, type: SessionType.study, description: 'Haber takibi'));
        }
        if (hasAyt) {
          sessions.add(StudySession(subject: 'Matematik (AYT)', emoji: '📐', durationMinutes: 90, type: SessionType.study, description: 'Konu çalışması'));
          sessions.add(StudySession(subject: 'Edebiyat (AYT)', emoji: '📖', durationMinutes: 60, type: SessionType.study, description: 'Konu çalışması'));
        }
        if (hasYdt) {
          sessions.add(StudySession(subject: 'İngilizce Deneme', emoji: '🇬🇧', durationMinutes: 120, type: SessionType.mockExam, description: 'Dil Sınavı Denemesi'));
        }
        if (hasYds) {
          sessions.add(StudySession(subject: 'YDS Branş Denemesi', emoji: '📝', durationMinutes: 180, type: SessionType.mockExam, description: '80 Soruluk Tam Deneme'));
        }
        if (hasDgs) {
          sessions.add(StudySession(subject: 'DGS Branş Denemesi', emoji: '📝', durationMinutes: 135, type: SessionType.mockExam, description: '100 Soruluk Matematik veya Türkçe'));
        }
        if (hasAles) {
          sessions.add(StudySession(subject: 'ALES Deneme/Branş', emoji: '📝', durationMinutes: 150, type: SessionType.mockExam, description: 'Sayısal veya Sözel Denemesi'));
        }
        if (hasTus) {
          sessions.add(StudySession(subject: 'TUS Denemesi', emoji: '📝', durationMinutes: 135, type: SessionType.mockExam, description: '100 Soruluk TTBT veya KTBT'));
        }
        break;
    }

    // ═══ Ortak seanslar (her zaman eklenir) ═══
    sessions.add(StudySession(subject: 'Tekrar', emoji: '🔄', durationMinutes: 30, type: SessionType.review, description: 'Aralıklı tekrar konuları'));
    sessions.add(StudySession(subject: 'Deneme Analizi', emoji: '📊', durationMinutes: 30, type: SessionType.analysis, description: 'Yanlış analizi'));

    // ═══ Minimum süre garantisi ═══
    _ensureMinimumDuration(sessions, dayIndex, hasTyt, hasKpss, hasAyt, hasYdt, hasYds, hasDgs, hasAles, hasTus);

    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);

    return DaySchedule(
      day: day,
      dayShort: dayShort,
      dayIndex: dayIndex,
      totalMinutes: totalMinutes,
      sessions: sessions,
    );
  }

  /// Günlük minimum 4 saat garanti et
  /// Eğer seçili sınav dersleri 4 saatten azsa, mevcut derslerin süresini artır
  static void _ensureMinimumDuration(
    List<StudySession> sessions, int dayIndex,
    bool hasTyt, bool hasKpss, bool hasAyt, bool hasYdt, bool hasYds, bool hasDgs, bool hasAles, bool hasTus,
  ) {
    int currentTotal = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);

    if (currentTotal >= _minDailyMinutes) return;

    int deficit = _minDailyMinutes - currentTotal;

    // Önce mevcut study ve practice seanslarının süresini artır
    final expandable = sessions.where(
      (s) => s.type == SessionType.study || s.type == SessionType.practice,
    ).toList();

    if (expandable.isNotEmpty) {
      // Her bir genişletilebilir seansa eşit miktarda süre ekle
      int perSession = deficit ~/ expandable.length;
      int remainder = deficit % expandable.length;

      for (int i = 0; i < expandable.length; i++) {
        int extra = perSession + (i < remainder ? 1 : 1);
        // 15 dakika birimlerle yuvarla
        extra = ((extra + 14) ~/ 15) * 15;
        expandable[i].addDuration(extra);
        deficit -= extra;
        if (deficit <= 0) break;
      }
    }

    // Hâlâ eksik varsa ek soru çözümü seansı ekle
    currentTotal = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    if (currentTotal < _minDailyMinutes) {
      final remaining = _minDailyMinutes - currentTotal;
      // Tekrar seansından önce ekle
      final reviewIndex = sessions.indexWhere((s) => s.type == SessionType.review);
      final insertAt = reviewIndex >= 0 ? reviewIndex : sessions.length;
      sessions.insert(insertAt, StudySession(
        subject: 'Genel Soru Çözümü',
        emoji: '✏️',
        durationMinutes: remaining,
        type: SessionType.practice,
        description: 'Karışık soru çözümü',
      ));
    }
  }

  /// Cumartesi — Deneme günü (sabit)
  static DaySchedule _buildSaturday() {
    final sessions = [
      StudySession(subject: 'Genel Deneme', emoji: '📝', durationMinutes: 165, type: SessionType.mockExam, description: 'Deneme sınavı'),
      StudySession(subject: 'Deneme Analizi', emoji: '📊', durationMinutes: 60, type: SessionType.analysis, description: 'Sonuç değerlendirme'),
      StudySession(subject: 'Yanlış Analizi', emoji: '❌', durationMinutes: 60, type: SessionType.analysis, description: 'Yanlışlardan ders çıkar'),
      StudySession(subject: 'Ders Notu', emoji: '📝', durationMinutes: 30, type: SessionType.study, description: 'Eksik not çıkarma'),
    ];
    return DaySchedule(
      day: 'Cumartesi', dayShort: 'Cmt', dayIndex: 6,
      totalMinutes: sessions.fold(0, (sum, s) => sum + s.durationMinutes),
      sessions: sessions,
    );
  }

  /// Pazar — Genel tekrar (sabit)
  static DaySchedule _buildSunday() {
    final sessions = [
      StudySession(subject: 'Haftalık Tekrar', emoji: '🔄', durationMinutes: 90, type: SessionType.review, description: 'Bu hafta öğrenilenleri tekrar'),
      StudySession(subject: 'Eksik Konular', emoji: '📋', durationMinutes: 60, type: SessionType.study, description: 'Tamamlanmamış konular'),
      StudySession(subject: 'Genel Soru Çözümü', emoji: '✏️', durationMinutes: 60, type: SessionType.practice, description: 'Karışık soru çözümü'),
      StudySession(subject: 'Motivasyon', emoji: '🧘', durationMinutes: 30, type: SessionType.motivation, description: 'Hedef değerlendirme ve motivasyon'),
    ];
    return DaySchedule(
      day: 'Pazar', dayShort: 'Paz', dayIndex: 7,
      totalMinutes: sessions.fold(0, (sum, s) => sum + s.durationMinutes),
      sessions: sessions,
    );
  }

  /// Bugünün programını getir
  static DaySchedule getTodaySchedule(List<String> examIds) {
    final weekday = DateTime.now().weekday; // 1 = Pazartesi
    final plan = getWeeklyPlan(examIds);
    return plan.firstWhere(
      (d) => d.dayIndex == weekday,
      orElse: () => plan.first,
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
  int _durationMinutes;
  final SessionType type;
  final String description;
  bool isCompleted;

  StudySession({
    required this.subject,
    required this.emoji,
    required int durationMinutes,
    required this.type,
    required this.description,
    this.isCompleted = false,
  }) : _durationMinutes = durationMinutes; // ignore: prefer_initializing_formals

  int get durationMinutes => _durationMinutes;

  /// Süre ekleme (minimum garanti için)
  void addDuration(int minutes) {
    _durationMinutes += minutes;
  }

  /// Dakika formatı
  String get formattedDuration {
    if (_durationMinutes >= 60) {
      final hours = _durationMinutes ~/ 60;
      final mins = _durationMinutes % 60;
      if (mins == 0) return '$hours sa';
      return '$hours sa $mins dk';
    }
    return '$_durationMinutes dk';
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
