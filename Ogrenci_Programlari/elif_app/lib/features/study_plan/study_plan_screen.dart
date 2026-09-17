import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/weekly_schedule.dart';

/// Haftalık Çalışma Programı Ekranı
class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weeklyPlan = WeeklySchedule.weeklyPlan;
    final today = DateTime.now().weekday;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Çalışma Programı 📅',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Eşit Ağırlık + KPSS haftalık plan',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Haftalık özet kartları
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                ),
                itemCount: weeklyPlan.length,
                itemBuilder: (context, index) {
                  final day = weeklyPlan[index];
                  final isToday = day.dayIndex == today;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        gradient: isToday
                            ? const LinearGradient(
                                colors: [AppTheme.primary, AppTheme.primaryLight],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                        color: isToday ? null : AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        boxShadow: isToday ? AppTheme.cardShadow : AppTheme.softShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.dayShort,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isToday ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.totalMinutes ~/ 60}sa',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isToday ? Colors.white : AppTheme.primary,
                            ),
                          ),
                          Text(
                            '${day.sessions.length} seans',
                            style: TextStyle(
                              fontSize: 10,
                              color: isToday
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppTheme.spacingMd),

            // Detaylı günlük planlar
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                ),
                itemCount: weeklyPlan.length,
                itemBuilder: (context, index) {
                  final day = weeklyPlan[index];
                  final isToday = day.dayIndex == today;
                  return _DayPlanCard(day: day, isToday: isToday);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Günlük plan kartı
class _DayPlanCard extends StatelessWidget {
  final DaySchedule day;
  final bool isToday;

  const _DayPlanCard({required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.softShadow,
          border: isToday
              ? Border.all(color: AppTheme.primary.withValues(alpha: 0.3), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'BUGÜN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    Text(
                      day.day,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Text(
                  day.formattedDuration,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Seanslar
            ...day.sessions.map((session) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(session.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      session.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    session.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      session.formattedDuration,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
