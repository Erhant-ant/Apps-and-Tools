import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/app_state.dart';
import '../../models/mock_exam.dart';
import 'add_mock_exam_screen.dart';

/// Deneme Listesi Ekranı
class MockExamListScreen extends StatelessWidget {
  const MockExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final exams = List<MockExam>.from(appState.mockExams)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Denemeler 📝',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  // Deneme ekle butonu
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddMockExamScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Ekle'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Özet kartları
            if (exams.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Toplam Deneme',
                        value: '${exams.length}',
                        emoji: '📋',
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Ortalama Net',
                        value: appState.averageNet?.toStringAsFixed(1) ?? '—',
                        emoji: '📊',
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Son Net',
                        value: appState.lastMockExamNet?.toStringAsFixed(1) ?? '—',
                        emoji: '🎯',
                        color: AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppTheme.spacingMd),

            // Deneme listesi
            Expanded(
              child: exams.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('📝', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          Text(
                            'Henüz deneme eklenmedi',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'İlk denemeni ekleyerek\nilerlemenizi takip et!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddMockExamScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('İlk Denemeyi Ekle'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                      ),
                      itemCount: exams.length,
                      itemBuilder: (context, index) {
                        return _MockExamCard(
                          exam: exams[index],
                          onDelete: () {
                            appState.deleteMockExam(exams[index].id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String emoji;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Deneme kartı
class _MockExamCard extends StatelessWidget {
  final MockExam exam;
  final VoidCallback onDelete;

  const _MockExamCard({
    required this.exam,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy', 'tr_TR').format(exam.date);
    final examTypeLabel = exam.examType == 'kpss'
        ? 'KPSS'
        : exam.examType == 'tyt'
            ? 'TYT'
            : 'AYT';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık satırı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              examTypeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            exam.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Toplam net
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      exam.totalNet.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      'toplam net',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Ders bazlı sonuçlar
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: exam.results.map((r) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        r.subjectName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        r.net.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: r.net >= 0 ? AppTheme.accent : AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Silme butonu
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Denemeyi Sil'),
                      content: const Text('Bu denemeyi silmek istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete();
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            'Sil',
                            style: TextStyle(color: AppTheme.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
