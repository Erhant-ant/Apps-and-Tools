/// Öğrenci Profil Modeli
class Student {
  final String name;
  final String examTarget; // 'KPSS' veya 'YKS'
  final String? field; // 'Eşit Ağırlık', 'Sayısal', 'Sözel' vb.
  final String? dreamUniversity;
  final String? dreamDepartment;
  final int dailyStudyGoalMinutes;
  final List<String> strongSubjects;
  final List<String> weakSubjects;
  final DateTime? kpssExamDate;
  final DateTime? yksTytDate;
  final DateTime? yksAytDate;

  const Student({
    required this.name,
    this.examTarget = 'YKS',
    this.field,
    this.dreamUniversity,
    this.dreamDepartment,
    this.dailyStudyGoalMinutes = 300, // 5 saat
    this.strongSubjects = const [],
    this.weakSubjects = const [],
    this.kpssExamDate,
    this.yksTytDate,
    this.yksAytDate,
  });

  int get dailyStudyGoalHours => dailyStudyGoalMinutes ~/ 60;
  int get dailyStudyGoalRemainingMinutes => dailyStudyGoalMinutes % 60;

  String get formattedStudyGoal {
    if (dailyStudyGoalRemainingMinutes == 0) {
      return '$dailyStudyGoalHours saat';
    }
    return '$dailyStudyGoalHours sa $dailyStudyGoalRemainingMinutes dk';
  }

  Student copyWith({
    String? name,
    String? examTarget,
    String? field,
    String? dreamUniversity,
    String? dreamDepartment,
    int? dailyStudyGoalMinutes,
    List<String>? strongSubjects,
    List<String>? weakSubjects,
    DateTime? kpssExamDate,
    DateTime? yksTytDate,
    DateTime? yksAytDate,
  }) {
    return Student(
      name: name ?? this.name,
      examTarget: examTarget ?? this.examTarget,
      field: field ?? this.field,
      dreamUniversity: dreamUniversity ?? this.dreamUniversity,
      dreamDepartment: dreamDepartment ?? this.dreamDepartment,
      dailyStudyGoalMinutes:
          dailyStudyGoalMinutes ?? this.dailyStudyGoalMinutes,
      strongSubjects: strongSubjects ?? this.strongSubjects,
      weakSubjects: weakSubjects ?? this.weakSubjects,
      kpssExamDate: kpssExamDate ?? this.kpssExamDate,
      yksTytDate: yksTytDate ?? this.yksTytDate,
      yksAytDate: yksAytDate ?? this.yksAytDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'examTarget': examTarget,
    'field': field,
    'dreamUniversity': dreamUniversity,
    'dreamDepartment': dreamDepartment,
    'dailyStudyGoalMinutes': dailyStudyGoalMinutes,
    'strongSubjects': strongSubjects,
    'weakSubjects': weakSubjects,
    'kpssExamDate': kpssExamDate?.toIso8601String(),
    'yksTytDate': yksTytDate?.toIso8601String(),
    'yksAytDate': yksAytDate?.toIso8601String(),
  };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    name: json['name'] ?? 'Elif',
    examTarget: json['examTarget'] ?? 'YKS',
    field: json['field'],
    dreamUniversity: json['dreamUniversity'],
    dreamDepartment: json['dreamDepartment'],
    dailyStudyGoalMinutes: json['dailyStudyGoalMinutes'] ?? 300,
    strongSubjects: List<String>.from(json['strongSubjects'] ?? []),
    weakSubjects: List<String>.from(json['weakSubjects'] ?? []),
    kpssExamDate: json['kpssExamDate'] != null
        ? DateTime.parse(json['kpssExamDate'])
        : null,
    yksTytDate: json['yksTytDate'] != null
        ? DateTime.parse(json['yksTytDate'])
        : null,
    yksAytDate: json['yksAytDate'] != null
        ? DateTime.parse(json['yksAytDate'])
        : null,
  );
}
