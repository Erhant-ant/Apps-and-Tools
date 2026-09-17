class ExamModel {
  final String id;
  final String name;
  final String shortName;
  final DateTime? examDate;
  final String description;

  const ExamModel({
    required this.id,
    required this.name,
    required this.shortName,
    this.examDate,
    required this.description,
  });

  /// Gün hesaplaması
  int? get daysUntilExam {
    if (examDate == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(examDate!.year, examDate!.month, examDate!.day);
    return target.difference(today).inDays;
  }
}
