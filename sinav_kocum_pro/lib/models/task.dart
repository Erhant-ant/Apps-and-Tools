/// Görev modeli — Bir konudaki tek bir görev
class Task {
  final String id;
  final String title;
  final TaskPhase phase;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.phase,
    this.isCompleted = false,
  });

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      phase: phase,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'phase': phase.name,
    'isCompleted': isCompleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    phase: TaskPhase.values.byName(json['phase'] as String),
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}

/// Görev aşaması
enum TaskPhase {
  learning,       // Öğrenme
  reinforcement,  // Pekiştirme
  control,        // Kontrol
}

extension TaskPhaseExtension on TaskPhase {
  String get displayName {
    switch (this) {
      case TaskPhase.learning:
        return 'Öğrenme';
      case TaskPhase.reinforcement:
        return 'Pekiştirme';
      case TaskPhase.control:
        return 'Kontrol';
    }
  }

  String get emoji {
    switch (this) {
      case TaskPhase.learning:
        return '📖';
      case TaskPhase.reinforcement:
        return '🔁';
      case TaskPhase.control:
        return '🎯';
    }
  }
}
