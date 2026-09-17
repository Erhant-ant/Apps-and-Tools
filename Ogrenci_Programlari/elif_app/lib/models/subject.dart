import 'package:flutter/material.dart';
import 'topic.dart';

/// Ders modeli — Bir sınavdaki tek bir ders
class Subject {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final int questionCount; // Sınavdaki soru sayısı
  final List<Topic> topics;

  const Subject({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.questionCount,
    required this.topics,
  });

  /// Tamamlanan konu sayısı
  int get completedTopicCount => topics.where((t) => t.isCompleted).length;

  /// Toplam konu sayısı
  int get totalTopicCount => topics.length;

  /// Genel ilerleme yüzdesi (0.0 - 1.0)
  double get progress {
    if (topics.isEmpty) return 0.0;
    final totalTasks = topics.fold<int>(0, (sum, t) => sum + t.totalTaskCount);
    final completedTasks = topics.fold<int>(0, (sum, t) => sum + t.completedTaskCount);
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  /// İlerleme yüzdesi (0 - 100)
  int get progressPercent => (progress * 100).round();
}
