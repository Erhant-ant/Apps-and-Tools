import 'task.dart';

/// Konu modeli — Bir dersteki tek bir konu
class Topic {
  final String id;
  final String name;
  final int order;
  final List<Task> tasks;
  DateTime? lastStudied;
  int repetitionLevel; // Aralıklı tekrar seviyesi (0-4)

  Topic({
    required this.id,
    required this.name,
    required this.order,
    List<Task>? tasks,
    this.lastStudied,
    this.repetitionLevel = 0,
  }) : tasks = tasks ?? _generateDefaultTasks(id);

  /// Varsayılan görevleri oluştur
  static List<Task> _generateDefaultTasks(String topicId) {
    return [
      // Öğrenme
      Task(id: '${topicId}_learn_1', title: 'Konu çalış', phase: TaskPhase.learning),
      Task(id: '${topicId}_learn_2', title: '50 soru çöz', phase: TaskPhase.learning),
      Task(id: '${topicId}_learn_3', title: 'Yanlışları incele', phase: TaskPhase.learning),
      // Pekiştirme
      Task(id: '${topicId}_reinf_1', title: '20 soru çöz', phase: TaskPhase.reinforcement),
      Task(id: '${topicId}_reinf_2', title: 'Mini test', phase: TaskPhase.reinforcement),
      Task(id: '${topicId}_reinf_3', title: 'Konu tekrarı', phase: TaskPhase.reinforcement),
      // Kontrol
      Task(id: '${topicId}_ctrl_1', title: 'Konu denemesi', phase: TaskPhase.control),
    ];
  }

  /// Tamamlanan görev sayısı
  int get completedTaskCount => tasks.where((t) => t.isCompleted).length;

  /// Toplam görev sayısı
  int get totalTaskCount => tasks.length;

  /// İlerleme yüzdesi (0.0 - 1.0)
  double get progress {
    if (totalTaskCount == 0) return 0.0;
    return completedTaskCount / totalTaskCount;
  }

  /// İlerleme yüzdesi (0 - 100)
  int get progressPercent => (progress * 100).round();

  /// Tamamlandı mı?
  bool get isCompleted => completedTaskCount == totalTaskCount;

  /// Belirli bir aşamadaki görevler
  List<Task> tasksByPhase(TaskPhase phase) =>
      tasks.where((t) => t.phase == phase).toList();

  /// Aşama ilerleme yüzdesi
  double phaseProgress(TaskPhase phase) {
    final phaseTasks = tasksByPhase(phase);
    if (phaseTasks.isEmpty) return 0.0;
    return phaseTasks.where((t) => t.isCompleted).length / phaseTasks.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'order': order,
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'lastStudied': lastStudied?.toIso8601String(),
    'repetitionLevel': repetitionLevel,
  };

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'] as String,
    name: json['name'] as String,
    order: json['order'] as int,
    tasks: (json['tasks'] as List)
        .map((t) => Task.fromJson(t as Map<String, dynamic>))
        .toList(),
    lastStudied: json['lastStudied'] != null
        ? DateTime.parse(json['lastStudied'] as String)
        : null,
    repetitionLevel: json['repetitionLevel'] as int? ?? 0,
  );
}
