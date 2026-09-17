import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/app_state.dart';
import '../../models/subject.dart';
import '../../models/topic.dart';
import '../../models/task.dart';

/// Konular ekranı — Bir dersteki tüm konular
class TopicsScreen extends StatelessWidget {
  final Subject subject;

  const TopicsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(subject.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(subject.name),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Column(
        children: [
          // Üst bilgi kartı
          Container(
            margin: const EdgeInsets.all(AppTheme.spacingMd),
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  subject.color.withValues(alpha: 0.1),
                  subject.color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoChip(
                  label: 'Toplam Konu',
                  value: '${subject.totalTopicCount}',
                  color: subject.color,
                ),
                _InfoChip(
                  label: 'Tamamlanan',
                  value: '${subject.completedTopicCount}',
                  color: AppTheme.accent,
                ),
                _InfoChip(
                  label: 'İlerleme',
                  value: '%${subject.progressPercent}',
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),

          // Konu listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
              ),
              itemCount: subject.topics.length,
              itemBuilder: (context, index) {
                return _TopicTile(
                  topic: subject.topics[index],
                  color: subject.color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Konu satırı
class _TopicTile extends StatefulWidget {
  final Topic topic;
  final Color color;

  const _TopicTile({required this.topic, required this.color});

  @override
  State<_TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<_TopicTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadTaskStates();
  }

  Future<void> _loadTaskStates() async {
    final appState = context.read<AppState>();
    for (var task in widget.topic.tasks) {
      task.isCompleted = await appState.getTaskCompletion(task.id);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.softShadow,
          border: widget.topic.isCompleted
              ? Border.all(color: AppTheme.accent.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          children: [
            // Konu başlığı
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Row(
                  children: [
                    // Sıra numarası
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.topic.isCompleted
                            ? AppTheme.accent
                            : widget.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: widget.topic.isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              )
                            : Text(
                                '${widget.topic.order}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: widget.color,
                                  fontSize: 13,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Konu adı
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.topic.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: widget.topic.isCompleted
                                  ? AppTheme.textTertiary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Mini ilerleme çubuğu
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: widget.topic.progress,
                                    backgroundColor: AppTheme.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.color,
                                    ),
                                    minHeight: 3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '%${widget.topic.progressPercent}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: widget.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Genişlet
                    AnimatedRotation(
                      turns: _isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Görev listesi (genişletilmiş)
            if (_isExpanded) _buildTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final phases = TaskPhase.values;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppTheme.spacingMd,
        right: AppTheme.spacingMd,
        bottom: AppTheme.spacingMd,
      ),
      child: Column(
        children: phases.map((phase) {
          final tasks = widget.topic.tasksByPhase(phase);
          if (tasks.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 1),
              const SizedBox(height: 8),
              // Aşama başlığı
              Row(
                children: [
                  Text(phase.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    phase.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  // Aşama ilerleme
                  Text(
                    '${tasks.where((t) => t.isCompleted).length}/${tasks.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Görevler
              ...tasks.map((task) => _TaskItem(
                task: task,
                color: widget.color,
                onToggle: () async {
                  final newState = !task.isCompleted;
                  task.isCompleted = newState;
                  await context.read<AppState>().toggleTaskCompletion(
                    widget.topic,
                    task.id,
                    newState,
                  );
                  setState(() {});
                },
              )),
              const SizedBox(height: 4),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Görev satırı
class _TaskItem extends StatelessWidget {
  final Task task;
  final Color color;
  final VoidCallback onToggle;

  const _TaskItem({
    required this.task,
    required this.color,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: task.isCompleted ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: task.isCompleted ? color : AppTheme.textTertiary,
                    width: 1.5,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 13,
                  color: task.isCompleted
                      ? AppTheme.textTertiary
                      : AppTheme.textPrimary,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
