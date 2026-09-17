/// Deneme sınav sonucu — Tek bir ders için doğru/yanlış/boş
class SubjectResult {
  final String subjectName;
  final int correct;
  final int wrong;
  final int blank;

  const SubjectResult({
    required this.subjectName,
    required this.correct,
    required this.wrong,
    required this.blank,
  });

  /// Net hesaplama: Doğru - (Yanlış / 4)
  double get net => correct - (wrong / 4.0);

  /// Toplam soru
  int get totalQuestions => correct + wrong + blank;

  /// Başarı yüzdesi
  double get successRate {
    if (totalQuestions == 0) return 0.0;
    return (correct / totalQuestions) * 100;
  }

  Map<String, dynamic> toJson() => {
    'subjectName': subjectName,
    'correct': correct,
    'wrong': wrong,
    'blank': blank,
  };

  factory SubjectResult.fromJson(Map<String, dynamic> json) => SubjectResult(
    subjectName: json['subjectName'] as String,
    correct: json['correct'] as int,
    wrong: json['wrong'] as int,
    blank: json['blank'] as int,
  );
}

/// Deneme sınav modeli — Tam bir deneme sonucu
class MockExam {
  final String id;
  final String examType; // 'kpss', 'tyt', 'ayt'
  final String title;
  final DateTime date;
  final List<SubjectResult> results;
  final String? note; // Öğrenci notu

  MockExam({
    required this.id,
    required this.examType,
    required this.title,
    required this.date,
    required this.results,
    this.note,
  });

  /// Toplam net
  double get totalNet =>
      results.fold<double>(0.0, (sum, r) => sum + r.net);

  /// Toplam doğru
  int get totalCorrect =>
      results.fold<int>(0, (sum, r) => sum + r.correct);

  /// Toplam yanlış
  int get totalWrong =>
      results.fold<int>(0, (sum, r) => sum + r.wrong);

  /// Toplam boş
  int get totalBlank =>
      results.fold<int>(0, (sum, r) => sum + r.blank);

  /// Belirli bir dersin netini getir
  double netForSubject(String subjectName) {
    final result = results.where((r) => r.subjectName == subjectName);
    if (result.isEmpty) return 0.0;
    return result.first.net;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examType': examType,
    'title': title,
    'date': date.toIso8601String(),
    'results': results.map((r) => r.toJson()).toList(),
    'note': note,
  };

  factory MockExam.fromJson(Map<String, dynamic> json) => MockExam(
    id: json['id'] as String,
    examType: json['examType'] as String,
    title: json['title'] as String,
    date: DateTime.parse(json['date'] as String),
    results: (json['results'] as List)
        .map((r) => SubjectResult.fromJson(r as Map<String, dynamic>))
        .toList(),
    note: json['note'] as String?,
  );
}
