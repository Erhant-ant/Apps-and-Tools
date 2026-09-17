import 'package:flutter/material.dart' hide Badge;
import '../../models/mock_exam.dart';
import '../../data/weekly_schedule.dart';
import '../../data/kpss_curriculum.dart';
import '../../data/tyt_curriculum.dart';
import '../../data/ayt_ea_curriculum.dart';
import '../../models/topic.dart';
import '../../models/badge.dart';
import '../../core/constants/app_constants.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

/// Ana uygulama state yönetimi
class AppState extends ChangeNotifier {
  // ─── Deneme Verileri ───────────────────────────────────────
  List<MockExam> _mockExams = [];
  List<MockExam> get mockExams => _mockExams;

  // ─── Günlük Program ────────────────────────────────────────
  DaySchedule _todaySchedule = WeeklySchedule.getTodaySchedule();
  DaySchedule get todaySchedule => _todaySchedule;

  // ─── Streak ────────────────────────────────────────────────
  int _streak = 0;
  int get streak => _streak;

  // ─── Bottom Nav ────────────────────────────────────────────
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // ─── Maskot ────────────────────────────────────────────────
  bool _showMascot = false;
  bool get showMascot => _showMascot;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isOnboardingComplete = false;
  bool get isOnboardingComplete => _isOnboardingComplete;

  Future<void> initialize() async {
    _isOnboardingComplete = await StorageService.isOnboardingComplete();
    await _loadMockExams();
    await _loadStreak();
    await _loadBadges();
    await _checkMascot();
    _todaySchedule = WeeklySchedule.getTodaySchedule();
    await evaluateBadges();
    // Seans tamamlanma durumlarını yükle
    await _loadSessionCompletions();
    await _loadReviews();

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> reloadAllData() async {
    // Her şeyi yeniden yükle (Yedeklemeden sonra kullanılır)
    _isOnboardingComplete = await StorageService.isOnboardingComplete();
    await _loadBadges();
    await _loadMockExams();
    await _loadStreak();
    await evaluateBadges();
    await _checkMascot();
    _todaySchedule = WeeklySchedule.getTodaySchedule();
    await _loadSessionCompletions();
    await _loadReviews();
    notifyListeners();
  }

  // ─── Oyunlaştırma (Rozetler) ──────────────────────────────
  List<Badge> _earnedBadges = [];
  List<Badge> get earnedBadges => _earnedBadges;

  Badge? _newlyEarnedBadge;
  Badge? get newlyEarnedBadge => _newlyEarnedBadge;

  void clearNewlyEarnedBadge() {
    _newlyEarnedBadge = null;
    notifyListeners();
  }

  Future<void> _loadBadges() async {
    List<Badge> loaded = [];
    for (var b in AppBadges.allBadges) {
      final date = await StorageService.getBadgeEarnedDate(b.id);
      if (date != null) {
        loaded.add(b.copyWith(earnedDate: date));
      } else {
        loaded.add(b);
      }
    }
    _earnedBadges = loaded;
  }

  Future<void> evaluateBadges() async {
    bool earnedNew = false;
    for (int i = 0; i < _earnedBadges.length; i++) {
      final b = _earnedBadges[i];
      if (b.isEarned) continue;

      bool conditionsMet = false;
      switch (b.id) {
        case 'streak_3':
          if (_streak >= 3) conditionsMet = true;
          break;
        case 'streak_7':
          if (_streak >= 7) conditionsMet = true;
          break;
        case 'mock_exam_50':
          if (_mockExams.any((e) => e.totalNet >= 50)) conditionsMet = true;
          break;
        case 'mock_exam_75':
          if (_mockExams.any((e) => e.totalNet >= 75)) conditionsMet = true;
          break;
      }

      if (conditionsMet) {
        await StorageService.saveEarnedBadge(b.id);
        _earnedBadges[i] = b.copyWith(earnedDate: DateTime.now());
        _newlyEarnedBadge = _earnedBadges[i];
        earnedNew = true;
      }
    }
    if (earnedNew) {
      notifyListeners();
    }
  }

  Future<void> awardBadge(String badgeId) async {
    final index = _earnedBadges.indexWhere((b) => b.id == badgeId);
    if (index >= 0 && !_earnedBadges[index].isEarned) {
      await StorageService.saveEarnedBadge(badgeId);
      _earnedBadges[index] = _earnedBadges[index].copyWith(
        earnedDate: DateTime.now(),
      );
      _newlyEarnedBadge = _earnedBadges[index];
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    await StorageService.setOnboardingComplete();
    _isOnboardingComplete = true;
    notifyListeners();
  }

  // ─── Aralıklı Tekrar ────────────────────────────────────────

  final List<Topic> _topicsToReviewToday = [];
  List<Topic> get topicsToReviewToday => _topicsToReviewToday;

  Future<void> _loadReviews() async {
    _topicsToReviewToday.clear();
    final allTopics = [
      ...KpssCurriculum.subjects.expand((s) => s.topics),
      ...TytCurriculum.subjects.expand((s) => s.topics),
      ...AytEaCurriculum.subjects.expand((s) => s.topics),
    ];

    final now = DateTime.now();
    final todayStr = now.toIso8601String().substring(0, 10);

    final dueTopics = await Future.wait(allTopics.map((topic) async {
      final reviewDate = await StorageService.getTopicReviewDate(topic.id);
      if (reviewDate != null) {
        final reviewDateStr = reviewDate.toIso8601String().substring(0, 10);
        if (reviewDateStr == todayStr || reviewDate.isBefore(now)) {
          topic.repetitionLevel = await StorageService.getTopicReviewLevel(
            topic.id,
          );
          return topic;
        }
      }
      return null;
    }));
    _topicsToReviewToday.addAll(dueTopics.whereType<Topic>());

    // Bildirimi planla
    await NotificationService().scheduleDailyReminder(
      _topicsToReviewToday.length,
    );
  }

  Future<void> completeTopicReview(Topic topic) async {
    final nextLevel = topic.repetitionLevel + 1;
    final maxLevel = AppConstants.spacedRepetitionIntervals.length - 1;
    final levelToUse = nextLevel > maxLevel ? maxLevel : nextLevel;

    final daysToAdd = AppConstants.spacedRepetitionIntervals[levelToUse];
    final nextDate = DateTime.now().add(Duration(days: daysToAdd));

    await StorageService.saveTopicReviewDate(topic.id, nextDate, levelToUse);
    _topicsToReviewToday.removeWhere((t) => t.id == topic.id);
    await awardBadge('first_review');
    notifyListeners();
  }

  Future<void> _loadMockExams() async {
    _mockExams = await StorageService.getMockExams();
  }

  Future<void> _loadStreak() async {
    _streak = await StorageService.getCurrentStreak();
  }

  Future<void> _checkMascot() async {
    final shown = await StorageService.wasMascotShownToday();
    _showMascot = !shown;
  }

  Future<void> _loadSessionCompletions() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    for (var i = 0; i < _todaySchedule.sessions.length; i++) {
      _todaySchedule.sessions[i].isCompleted =
          await StorageService.getSessionCompletion(today, i);
    }
  }

  // ─── Maskot Mesajını Gösterildi Olarak İşaretle ────────────

  Future<void> dismissMascot() async {
    _showMascot = false;
    await StorageService.markMascotShown();
    notifyListeners();
  }

  // ─── Seans Tamamlama ──────────────────────────────────────

  Future<void> toggleSession(int index) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _todaySchedule.sessions[index].isCompleted =
        !_todaySchedule.sessions[index].isCompleted;
    await StorageService.saveSessionCompletion(
      today,
      index,
      _todaySchedule.sessions[index].isCompleted,
    );

    // Eğer bir seans tamamlandıysa streak güncelle
    if (_todaySchedule.sessions[index].isCompleted) {
      _streak = await StorageService.recordStudyForToday();
      await evaluateBadges();
    }

    notifyListeners();
  }

  /// Tamamlanan seans sayısı
  int get completedSessionCount =>
      _todaySchedule.sessions.where((s) => s.isCompleted).length;

  /// Toplam seans sayısı
  int get totalSessionCount => _todaySchedule.sessions.length;

  /// Tamamlanma yüzdesi
  double get sessionProgress {
    if (totalSessionCount == 0) return 0;
    return completedSessionCount / totalSessionCount;
  }

  // ─── Deneme Ekleme ────────────────────────────────────────

  Future<void> addMockExam(MockExam exam) async {
    await StorageService.saveMockExam(exam);
    await _loadMockExams();
    await evaluateBadges();
    notifyListeners();
  }

  Future<void> deleteMockExam(String examId) async {
    await StorageService.deleteMockExam(examId);
    await _loadMockExams();
    notifyListeners();
  }

  /// Belirli türdeki denemeler
  List<MockExam> mockExamsByType(String type) =>
      _mockExams.where((e) => e.examType == type).toList();

  /// Belirli bir ders için tüm denemelerden netleri getir
  List<double> netsForSubject(String subjectName, {String? examType}) {
    var exams = examType != null ? mockExamsByType(examType) : _mockExams;
    exams.sort((a, b) => a.date.compareTo(b.date));
    return exams
        .map((e) => e.netForSubject(subjectName))
        .where((n) => n != 0.0)
        .toList();
  }

  /// Son denemenin toplam neti
  double? get lastMockExamNet {
    if (_mockExams.isEmpty) return null;
    final sorted = List<MockExam>.from(_mockExams)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first.totalNet;
  }

  /// Son 5 denemenin net ortalaması
  double? get averageNet {
    if (_mockExams.isEmpty) return null;
    final sorted = List<MockExam>.from(_mockExams)
      ..sort((a, b) => b.date.compareTo(a.date));
    final last5 = sorted.take(5).toList();
    return last5.fold<double>(0.0, (sum, e) => sum + e.totalNet) / last5.length;
  }

  /// Net değişimi (son 2 deneme arası)
  double? get netChange {
    if (_mockExams.length < 2) return null;
    final sorted = List<MockExam>.from(_mockExams)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted[0].totalNet - sorted[1].totalNet;
  }

  // ─── Görev Tamamlama ──────────────────────────────────────

  Future<void> toggleTaskCompletion(
    Topic topic,
    String taskId,
    bool isCompleted,
  ) async {
    await StorageService.saveTaskCompletion(taskId, isCompleted);

    // Eğer konu %100 bittiyse ve daha önce tekrar tarihi atanmadıysa ilk tekrarı planla
    if (topic.isCompleted) {
      final existingDate = await StorageService.getTopicReviewDate(topic.id);
      if (existingDate == null) {
        // İlk tekrar 1 gün sonra
        final nextDate = DateTime.now().add(const Duration(days: 1));
        await StorageService.saveTopicReviewDate(topic.id, nextDate, 0);
        await _loadReviews(); // Tekrarları güncelle (testler için gerekebilir)
        await awardBadge('first_topic');
      }
    }

    notifyListeners();
  }

  Future<bool> getTaskCompletion(String taskId) async {
    return StorageService.getTaskCompletion(taskId);
  }
}
