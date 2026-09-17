import 'subject.dart';

/// Sınav modeli — KPSS, TYT, AYT
class Exam {
  final String id;
  final String name;
  final String fullName;
  final DateTime examDate;
  final int totalQuestions;
  final int durationMinutes;
  final List<Subject> subjects;
  final List<String> gradientColors; // Hex renk kodları

  const Exam({
    required this.id,
    required this.name,
    required this.fullName,
    required this.examDate,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.subjects,
    this.gradientColors = const ['#4A6CF7', '#818CF8'],
  });

  /// Kalan gün
  int get daysRemaining {
    final remaining = examDate.difference(DateTime.now());
    return remaining.isNegative ? 0 : remaining.inDays;
  }

  /// Kalan süre
  Duration get remainingDuration => examDate.difference(DateTime.now());

  /// Sınav geçmiş mi?
  bool get isPast => examDate.isBefore(DateTime.now());

  /// Genel ilerleme
  double get progress {
    if (subjects.isEmpty) return 0.0;
    return subjects.fold<double>(0.0, (sum, s) => sum + s.progress) /
        subjects.length;
  }

  /// İlerleme yüzdesi (0-100)
  int get progressPercent => (progress * 100).round();
}

/// Sınav tipi
enum ExamType {
  kpss,
  tyt,
  ayt,
}

extension ExamTypeExtension on ExamType {
  String get displayName {
    switch (this) {
      case ExamType.kpss:
        return 'KPSS Ortaöğretim';
      case ExamType.tyt:
        return 'TYT';
      case ExamType.ayt:
        return 'AYT';
    }
  }
}
