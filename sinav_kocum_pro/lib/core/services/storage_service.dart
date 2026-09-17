import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/mock_exam.dart';

/// Yerel veri kaydetme servisi
/// SharedPreferences + JSON ile basit ve etkili depolama
class StorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ─── Görev İlerleme Kaydetme ───────────────────────────────

  /// Görev tamamlanma durumunu kaydet
  static Future<void> saveTaskCompletion(
    String taskId,
    bool isCompleted,
  ) async {
    final p = await prefs;
    await p.setBool('task_$taskId', isCompleted);
  }

  /// Görev tamamlanma durumunu oku
  static Future<bool> getTaskCompletion(String taskId) async {
    final p = await prefs;
    return p.getBool('task_$taskId') ?? false;
  }

  // ─── Deneme Kaydetme ──────────────────────────────────────

  /// Deneme kaydet
  static Future<void> saveMockExam(MockExam exam) async {
    final p = await prefs;
    final exams = await getMockExams();
    exams.add(exam);
    final jsonList = exams.map((e) => e.toJson()).toList();
    await p.setString('mock_exams', jsonEncode(jsonList));
  }

  /// Tüm denemeleri getir
  static Future<List<MockExam>> getMockExams() async {
    final p = await prefs;
    final jsonStr = p.getString('mock_exams');
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList
        .map((j) => MockExam.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Belirli türdeki denemeleri getir
  static Future<List<MockExam>> getMockExamsByType(String examType) async {
    final allExams = await getMockExams();
    return allExams.where((e) => e.examType == examType).toList();
  }

  /// Deneme sil
  static Future<void> deleteMockExam(String examId) async {
    final p = await prefs;
    final exams = await getMockExams();
    exams.removeWhere((e) => e.id == examId);
    final jsonList = exams.map((e) => e.toJson()).toList();
    await p.setString('mock_exams', jsonEncode(jsonList));
  }

  // ─── Günlük Seans Takibi ──────────────────────────────────

  /// Günlük seans tamamlanma durumu
  static Future<void> saveSessionCompletion(
    String date,
    int sessionIndex,
    bool isCompleted,
  ) async {
    final p = await prefs;
    await p.setBool('session_${date}_$sessionIndex', isCompleted);
  }

  static Future<bool> getSessionCompletion(
    String date,
    int sessionIndex,
  ) async {
    final p = await prefs;
    return p.getBool('session_${date}_$sessionIndex') ?? false;
  }

  // ─── Streak Takibi ────────────────────────────────────────

  /// Streak güncelle
  static Future<int> recordStudyForToday() async {
    final p = await prefs;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = p.getString('last_study_date');
    var streak = p.getInt('study_streak') ?? 0;

    if (lastDate == null) {
      streak = 1;
    } else if (lastDate == today) {
      // Bugün zaten çalışılmış
      return streak;
    } else {
      final last = DateTime.parse(lastDate);
      final diff = DateTime.now().difference(last).inDays;
      if (diff == 1) {
        streak += 1;
      } else {
        streak = 1; // Seri kırıldı
      }
    }

    await p.setString('last_study_date', today);
    await p.setInt('study_streak', streak);
    return streak;
  }

  /// Bugün için geçerli seriyi oku; bu işlem veri yazmaz.
  static Future<int> getCurrentStreak() async {
    final p = await prefs;
    final lastDate = p.getString('last_study_date');
    if (lastDate == null) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = DateTime.parse(lastDate);
    final lastStudyDay = DateTime(last.year, last.month, last.day);
    final difference = today.difference(lastStudyDay).inDays;

    return difference <= 1 ? (p.getInt('study_streak') ?? 0) : 0;
  }

  // ─── Maskot Mesajı ────────────────────────────────────────

  /// Bugün maskot mesajı gösterildi mi?
  static Future<bool> wasMascotShownToday() async {
    final p = await prefs;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastShown = p.getString('last_mascot_date');
    return lastShown == today;
  }

  /// Maskot mesajını gösterildi olarak işaretle
  static Future<void> markMascotShown() async {
    final p = await prefs;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await p.setString('last_mascot_date', today);
  }

  // ─── Onboarding ───────────────────────────────────────────

  static Future<bool> isOnboardingComplete() async {
    final p = await prefs;
    return p.getBool('onboarding_complete') ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    final p = await prefs;
    await p.setBool('onboarding_complete', true);
  }

  // ─── Kullanıcı Profili (İsim ve Sınav) ─────────────────────

  static Future<String?> getUserName() async {
    final p = await prefs;
    return p.getString('user_name');
  }

  static Future<void> setUserName(String name) async {
    final p = await prefs;
    await p.setString('user_name', name);
  }

  static Future<List<String>> getSelectedExamIds() async {
    final p = await prefs;
    return p.getStringList('selected_exam_ids') ?? [];
  }

  static Future<void> setSelectedExamIds(List<String> examIds) async {
    final p = await prefs;
    await p.setStringList('selected_exam_ids', examIds);
  }

  // ─── Aralıklı Tekrar ──────────────────────────────────────

  /// Konu tekrar tarihini kaydet
  static Future<void> saveTopicReviewDate(
    String topicId,
    DateTime date,
    int level,
  ) async {
    final p = await prefs;
    await p.setString('review_date_$topicId', date.toIso8601String());
    await p.setInt('review_level_$topicId', level);
  }

  /// Konu tekrar tarihini oku
  static Future<DateTime?> getTopicReviewDate(String topicId) async {
    final p = await prefs;
    final dateStr = p.getString('review_date_$topicId');
    if (dateStr == null) return null;
    return DateTime.parse(dateStr);
  }

  /// Konu tekrar seviyesini oku
  static Future<int> getTopicReviewLevel(String topicId) async {
    final p = await prefs;
    return p.getInt('review_level_$topicId') ?? 0;
  }

  // ─── Oyunlaştırma (Rozetler) ──────────────────────────────
  static Future<void> saveEarnedBadge(String badgeId) async {
    final p = await prefs;
    final dateKey = 'badge_$badgeId';
    if (!p.containsKey(dateKey)) {
      await p.setString(dateKey, DateTime.now().toIso8601String());
    }
    
    final countKey = 'badge_count_$badgeId';
    final currentCount = p.getInt(countKey) ?? 0;
    await p.setInt(countKey, currentCount + 1);
  }

  static Future<DateTime?> getBadgeEarnedDate(String badgeId) async {
    final p = await prefs;
    final dateStr = p.getString('badge_$badgeId');
    if (dateStr == null) return null;
    return DateTime.parse(dateStr);
  }

  static Future<int> getBadgeEarnedCount(String badgeId) async {
    final p = await prefs;
    final count = p.getInt('badge_count_$badgeId');
    if (count != null) return count;
    
    // Geriye dönük uyumluluk: Eğer tarih var ama sayı yoksa, 1 kere alınmış demektir
    final dateStr = p.getString('badge_$badgeId');
    return dateStr != null ? 1 : 0;
  }

  // ─── Veri Yedekleme (Dışa/İçe Aktar) ─────────────────────────

  static Future<String> exportData() async {
    final p = await prefs;
    final keys = p.getKeys();
    final Map<String, dynamic> data = {};
    for (String key in keys) {
      data[key] = p.get(key);
    }
    return jsonEncode(data);
  }

  static Future<void> importData(String jsonString) async {
    final p = await prefs;
    final Map<String, dynamic> data = jsonDecode(jsonString);
    await p.clear(); // Mevcut veriyi temizle
    for (String key in data.keys) {
      final value = data[key];
      if (value is String) {
        await p.setString(key, value);
      } else if (value is int) {
        await p.setInt(key, value);
      } else if (value is double) {
        await p.setDouble(key, value);
      } else if (value is bool) {
        await p.setBool(key, value);
      } else if (value is List) {
        await p.setStringList(key, value.map((e) => e.toString()).toList());
      }
    }
  }
}
