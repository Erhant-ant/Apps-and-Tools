/// Genel Uygulama Sabitleri
class AppConstants {
  AppConstants._();

  /// Uygulama bilgileri
  static const String appName = "Elif'in Sınav Koçu";
  static const String appSlogan = 'Hedefine Birlikte 💜';
  static const String studentName = 'Elif';
  static const String mascotImagePath = 'assets/images/mascot.jpg';

  /// Günlük çalışma hedefi (dakika)
  static const int dailyStudyTargetMinutes = 270; // 4.5 saat
  static const int minDailyStudyMinutes = 240;     // 4 saat
  static const int maxDailyStudyMinutes = 360;     // 6 saat

  /// Deneme net hesaplama
  static double calculateNet(int correct, int wrong) {
    return correct - (wrong / 4.0);
  }

  /// Aralıklı tekrar aralıkları (gün)
  static const List<int> spacedRepetitionIntervals = [1, 3, 7, 14, 30];

  /// Konu görev tipleri
  static const List<String> learningTasks = [
    'Konu çalış',
    '50 soru çöz',
    'Yanlışları incele',
  ];
  static const List<String> reinforcementTasks = [
    '20 soru çöz',
    'Mini test',
    'Konu tekrarı',
  ];
  static const List<String> controlTasks = [
    'Konu denemesi',
  ];

  /// Performans seviyeleri
  static const double goodThreshold = 70.0;
  static const double mediumThreshold = 50.0;

  /// SharedPreferences anahtarları
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefLastMascotDate = 'last_mascot_date';
  static const String prefStreak = 'study_streak';
  static const String prefLastStudyDate = 'last_study_date';
}
