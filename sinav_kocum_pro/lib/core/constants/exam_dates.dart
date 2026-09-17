/// Sınav Tarihleri — Tek yerden değiştirilebilir
/// ÖSYM resmi tarihler açıklandığında sadece burayı güncelle
class ExamDates {
  ExamDates._();

  /// KPSS Ortaöğretim — 25 Ekim 2026 (ÖSYM Resmi Takvim)
  static final DateTime kpssOrtaogretim = DateTime(2026, 10, 25, 10, 0);

  /// YKS 2027 — TYT (Örnek tarih, ÖSYM henüz açıklamadı)
  static final DateTime yksTyt = DateTime(2027, 6, 19, 10, 15);

  /// YKS 2027 — AYT (Örnek tarih, ÖSYM henüz açıklamadı)
  static final DateTime yksAyt = DateTime(2027, 6, 20, 10, 15);

  /// Sınav adları
  static const String kpssName = 'KPSS Ortaöğretim';
  static const String kpssFullName = 'Kamu Personeli Seçme Sınavı — Ortaöğretim';
  static const String yksName = 'YKS 2027';
  static const String yksFullName = 'Yükseköğretim Kurumları Sınavı';
  static const String tytName = 'TYT';
  static const String tytFullName = 'Temel Yeterlilik Testi';
  static const String aytName = 'AYT';
  static const String aytFullName = 'Alan Yeterlilik Testi';

  /// Kalan süreyi hesapla
  static Duration remainingTo(DateTime examDate) {
    return examDate.difference(DateTime.now());
  }

  /// Kalan gün sayısı
  static int daysRemainingTo(DateTime examDate) {
    return remainingTo(examDate).inDays;
  }

  /// Kalan süreyi formatla
  static String formatRemaining(DateTime examDate) {
    final remaining = remainingTo(examDate);
    if (remaining.isNegative) return 'Sınav geçti';

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    return '$days gün $hours saat $minutes dakika $seconds saniye';
  }

  /// Kısa format
  static String formatRemainingShort(DateTime examDate) {
    final remaining = remainingTo(examDate);
    if (remaining.isNegative) return 'Geçti';

    final days = remaining.inDays;
    if (days > 30) {
      final months = days ~/ 30;
      final remainingDays = days % 30;
      return '$months ay $remainingDays gün';
    }
    return '$days gün';
  }
}
