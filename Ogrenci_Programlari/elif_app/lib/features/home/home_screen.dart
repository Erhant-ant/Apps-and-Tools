import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/exam_dates.dart';
import '../../core/constants/mascot_messages.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/app_state.dart';
import '../settings/settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Sayaç her saniye güncellenir
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final today = DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now());
    final dayName = DateFormat('EEEE', 'tr_TR').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Üst Başlık ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Merhaba ${AppConstants.studentName} 👋',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$today, $dayName',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (appState.streak > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '${appState.streak} gün',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => SettingsDialog.show(context),
                          icon: const Icon(Icons.settings_rounded, color: AppTheme.primary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // ─── Maskot Mesajı ─────────────────────────────
              if (appState.showMascot) _buildMascotCard(appState),

              // ─── Sınav Sayaçları ───────────────────────────
              const SizedBox(height: AppTheme.spacingMd),
              _buildCountdownCards(),

              // ─── Bugünün Programı ──────────────────────────
              const SizedBox(height: AppTheme.spacingLg),
              _buildDailyPlan(appState),

              // ─── Aralıklı Tekrar ───────────────────────────
              const SizedBox(height: AppTheme.spacingLg),
              _buildSpacedRepetition(appState),

              // ─── İlerleme Özeti ────────────────────────────
              const SizedBox(height: AppTheme.spacingLg),
              _buildProgressSummary(appState),

              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMascotCard(AppState appState) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withValues(alpha: 0.05),
            AppTheme.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Maskot resmi
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            child: Image.asset(
              AppConstants.mascotImagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          // Mesaj
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MascotMessages.getTodayMessage(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Kapat butonu
          IconButton(
            onPressed: () => appState.dismissMascot(),
            icon: Icon(
              Icons.close_rounded,
              color: AppTheme.textTertiary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCards() {
    return Row(
      children: [
        // KPSS Kartı
        Expanded(
          child: _CountdownCard(
            title: ExamDates.kpssName,
            date: ExamDates.kpssOrtaogretim,
            gradient: AppTheme.kpssGradient,
            emoji: '📋',
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        // YKS Kartı
        Expanded(
          child: _CountdownCard(
            title: ExamDates.yksName,
            date: ExamDates.yksTyt,
            gradient: AppTheme.yksGradient,
            emoji: '🎓',
          ),
        ),
      ],
    );
  }

  Widget _buildDailyPlan(AppState appState) {
    final schedule = appState.todaySchedule;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('📅', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Bugünün Programı',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Toplam: ${schedule.formattedDuration}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),

          // İlerleme çubuğu
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: appState.sessionProgress,
              backgroundColor: AppTheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                appState.sessionProgress >= 1.0
                    ? AppTheme.accent
                    : AppTheme.primary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${appState.completedSessionCount}/${appState.totalSessionCount} tamamlandı',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: AppTheme.spacingMd),

          // Seans listesi
          ...schedule.sessions.asMap().entries.map((entry) {
            final index = entry.key;
            final session = entry.value;
            return _SessionTile(
              session: session,
              onToggle: () => appState.toggleSession(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(AppState appState) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            emoji: '📊',
            title: 'Ortalama Net',
            value: appState.averageNet != null
                ? appState.averageNet!.toStringAsFixed(1)
                : '—',
            subtitle: appState.netChange != null
                ? '${appState.netChange! > 0 ? '+' : ''}${appState.netChange!.toStringAsFixed(1)}'
                : 'Deneme ekle',
            subtitleColor: appState.netChange != null
                ? (appState.netChange! >= 0 ? AppTheme.accent : AppTheme.error)
                : AppTheme.textTertiary,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _StatCard(
            emoji: '✅',
            title: 'Bugün',
            value: '${appState.completedSessionCount}/${appState.totalSessionCount}',
            subtitle: 'görev tamamlandı',
            subtitleColor: AppTheme.textTertiary,
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _StatCard(
            emoji: '🔥',
            title: 'Seri',
            value: '${appState.streak}',
            subtitle: 'gün üst üste',
            subtitleColor: AppTheme.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildSpacedRepetition(AppState appState) {
    final topics = appState.topicsToReviewToday;

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
              const Text('🔄', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Bugünün Tekrarları',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          if (topics.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: const Row(
                children: [
                  Text('🎉', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Harika! Bugün tekrar edilecek konu yok.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topics.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return Container(
                    width: 200,
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: AppTheme.surfaceVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => appState.completeTopicReview(topic),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: AppTheme.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Tekrar Ettim ✅', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Sayaç kartı
class _CountdownCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final List<Color> gradient;
  final String emoji;

  const _CountdownCard({
    required this.title,
    required this.date,
    required this.gradient,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = date.difference(DateTime.now());
    final days = remaining.isNegative ? 0 : remaining.inDays;
    final hours = remaining.isNegative ? 0 : remaining.inHours % 24;
    final minutes = remaining.isNegative ? 0 : remaining.inMinutes % 60;
    final seconds = remaining.isNegative ? 0 : remaining.inSeconds % 60;
    final dateStr = DateFormat('d MMM yyyy', 'tr_TR').format(date);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '📅 $dateStr',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$days',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 40,
              height: 1,
            ),
          ),
          const Text(
            'gün',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$hours sa $minutes dk $seconds sn',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Çalışma seansı satırı
class _SessionTile extends StatelessWidget {
  final dynamic session;
  final VoidCallback onToggle;

  const _SessionTile({
    required this.session,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: session.isCompleted
                ? AppTheme.accent.withValues(alpha: 0.06)
                : AppTheme.surfaceVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: session.isCompleted
                  ? AppTheme.accent.withValues(alpha: 0.2)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: session.isCompleted
                      ? AppTheme.accent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: session.isCompleted
                        ? AppTheme.accent
                        : AppTheme.textTertiary,
                    width: 2,
                  ),
                ),
                child: session.isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Emoji
              Text(session.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              // İsim
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: session.isCompleted
                            ? AppTheme.textTertiary
                            : AppTheme.textPrimary,
                        decoration: session.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    Text(
                      session.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              // Süre
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: session.isCompleted
                      ? AppTheme.accent.withValues(alpha: 0.1)
                      : AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  session.formattedDuration,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: session.isCompleted
                        ? AppTheme.accent
                        : AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// İstatistik kartı
class _StatCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  const _StatCard({
    required this.emoji,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
