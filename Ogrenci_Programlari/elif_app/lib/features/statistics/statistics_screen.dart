import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/app_state.dart';
import '../../models/mock_exam.dart';

/// İstatistik Ekranı — Grafikler ve analizler
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedExamType = 'tyt';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final exams = appState.mockExamsByType(_selectedExamType);
    exams.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'İstatistikler 📊',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              
              _buildBadges(appState),
              const SizedBox(height: AppTheme.spacingLg),

              // Sınav türü seçimi
              Row(
                children: [
                  _buildFilterChip('TYT', 'tyt'),
                  const SizedBox(width: 8),
                  _buildFilterChip('AYT', 'ayt'),
                  const SizedBox(width: 8),
                  _buildFilterChip('KPSS', 'kpss'),
                ],
              ),

              const SizedBox(height: AppTheme.spacingLg),

              if (exams.isEmpty)
                _buildEmptyState()
              else ...[
                // Toplam net trendi
                _buildNetTrendChart(exams),
                const SizedBox(height: AppTheme.spacingLg),

                // Ders bazlı analiz
                _buildSubjectAnalysis(appState, exams),
                const SizedBox(height: AppTheme.spacingLg),

                // Zayıf alan analizi
                _buildWeaknessAnalysis(exams),
                const SizedBox(height: AppTheme.spacingLg),

                // Performans yorumu
                _buildPerformanceComment(exams),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedExamType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedExamType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Text('📊', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Henüz deneme verisi yok',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Deneme ekledikçe grafik ve\nanalizler burada görünecek',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetTrendChart(List<MockExam> exams) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📈', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Toplam Net Trendi',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppTheme.surfaceVariant,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= exams.length) return const Text('');
                        return Text(
                          '#${idx + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: exams.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.totalNet);
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // İlerleme yorumu
          if (exams.length >= 2) ...[
            const SizedBox(height: 12),
            _buildTrendComment(exams),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendComment(List<MockExam> exams) {
    final first = exams.first.totalNet;
    final last = exams.last.totalNet;
    final diff = last - first;
    final isPositive = diff >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPositive
            ? AppTheme.accent.withValues(alpha: 0.08)
            : AppTheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Text(
            isPositive ? '🚀' : '⚠️',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isPositive
                  ? 'Son ${exams.length} denemede +${diff.toStringAsFixed(1)} net ilerleme! Harika gidiyorsun!'
                  : 'Son ${exams.length} denemede ${diff.toStringAsFixed(1)} net düşüş. Zayıf alanlarına odaklan!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPositive ? AppTheme.accent : AppTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectAnalysis(AppState appState, List<MockExam> exams) {
    // Ders isimlerini al
    if (exams.isEmpty) return const SizedBox.shrink();
    final subjectNames = exams.first.results.map((r) => r.subjectName).toList();

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📚', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Ders Bazlı Analiz',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          ...subjectNames.map((name) {
            final nets = appState.netsForSubject(name, examType: _selectedExamType);
            if (nets.isEmpty) return const SizedBox.shrink();

            final avg = nets.reduce((a, b) => a + b) / nets.length;
            final lastNet = nets.last;
            final trend = nets.length >= 2 ? nets.last - nets[nets.length - 2] : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Ort: ${avg.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    lastNet.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (trend != 0.0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: trend > 0
                            ? AppTheme.accent.withValues(alpha: 0.1)
                            : AppTheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${trend > 0 ? '+' : ''}${trend.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: trend > 0 ? AppTheme.accent : AppTheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeaknessAnalysis(List<MockExam> exams) {
    if (exams.isEmpty) return const SizedBox.shrink();

    // Son denemenin ders bazlı başarılarını analiz et
    final lastExam = exams.last;
    final sortedResults = List<SubjectResult>.from(lastExam.results)
      ..sort((a, b) => a.successRate.compareTo(b.successRate));

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Alan Analizi',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          ...sortedResults.map((r) {
            final level = r.successRate >= 70
                ? _Level.good
                : r.successRate >= 50
                    ? _Level.medium
                    : _Level.weak;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    level.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.subjectName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: r.successRate / 100,
                            backgroundColor: AppTheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(level.color),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '%${r.successRate.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: level.color,
                        ),
                      ),
                      Text(
                        level.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: level.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerformanceComment(List<MockExam> exams) {
    if (exams.isEmpty) return const SizedBox.shrink();

    final lastExam = exams.last;
    final weakSubjects = lastExam.results
        .where((r) => r.successRate < 50)
        .map((r) => r.subjectName)
        .toList();

    if (weakSubjects.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accent.withValues(alpha: 0.1),
              AppTheme.primary.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        child: Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Harika gidiyorsun! Tüm derslerde %50 üzerinde başarı oranın var. Böyle devam et!',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Öneri',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bu hafta şu derlere ekstra çalışma öneriyoruz:',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...weakSubjects.map((name) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.arrow_right_rounded, color: AppTheme.warning, size: 20),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppTheme.warning,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBadges(AppState appState) {
    if (appState.earnedBadges.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rozetlerim 🏆',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.spacingMd),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: appState.earnedBadges.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final badge = appState.earnedBadges[index];
              final isEarned = badge.isEarned;

              return Opacity(
                opacity: isEarned ? 1.0 : 0.4,
                child: Container(
                  width: 90,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEarned 
                        ? AppTheme.primary.withValues(alpha: 0.1)
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(
                      color: isEarned 
                          ? AppTheme.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(badge.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text(
                        badge.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isEarned ? AppTheme.primary : AppTheme.textTertiary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

enum _Level { good, medium, weak }

extension _LevelExtension on _Level {
  String get emoji {
    switch (this) {
      case _Level.good: return '🟢';
      case _Level.medium: return '🟡';
      case _Level.weak: return '🔴';
    }
  }
  String get label {
    switch (this) {
      case _Level.good: return 'İyi';
      case _Level.medium: return 'Orta';
      case _Level.weak: return 'Geliştirilmeli';
    }
  }
  Color get color {
    switch (this) {
      case _Level.good: return AppTheme.accent;
      case _Level.medium: return AppTheme.warning;
      case _Level.weak: return AppTheme.error;
    }
  }
}
