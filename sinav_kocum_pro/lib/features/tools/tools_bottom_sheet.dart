import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'timer_screen.dart';

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => const ToolsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color: AppTheme.border,
              width: 1.5,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ).animate().fadeIn(duration: 200.ms).scaleX(begin: 0.5),
                  const SizedBox(height: 28),

                  // Title Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                        ),
                        child: const Icon(
                          Icons.build_circle_rounded,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Araçlar',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Sınav hazırlığını kolaylaştıran araçlar',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                  const SizedBox(height: 28),

                  // Tools
                  _ToolCard(
                    title: 'Zamanlayıcı',
                    subtitle: 'Deneme ve çalışma süreni takip et',
                    icon: Icons.timer_outlined,
                    gradientColors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)],
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              const TimerScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.05),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 350.ms, delay: 100.ms).slideY(begin: 0.15),

                  const SizedBox(height: 12),

                  _ToolCard(
                    title: 'Hesap Makinesi',
                    subtitle: 'Puan hesaplama ve temel işlemler',
                    icon: Icons.calculate_outlined,
                    gradientColors: [AppTheme.secondary, AppTheme.secondary.withValues(alpha: 0.8)],
                    isComingSoon: true,
                    onTap: null,
                  ).animate().fadeIn(duration: 350.ms, delay: 200.ms).slideY(begin: 0.15),

                  const SizedBox(height: 12),

                  _ToolCard(
                    title: 'Puan Hesaplama',
                    subtitle: 'TYT / AYT / KPSS puan tahminleme',
                    icon: Icons.analytics_outlined,
                    gradientColors: [AppTheme.accent, AppTheme.accent.withValues(alpha: 0.8)],
                    isComingSoon: true,
                    onTap: null,
                  ).animate().fadeIn(duration: 350.ms, delay: 300.ms).slideY(begin: 0.15),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isComingSoon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.55,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isEnabled
                    ? gradientColors[0].withValues(alpha: 0.15)
                    : AppTheme.surfaceVariant,
                width: 1.5,
              ),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: gradientColors[0].withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isEnabled ? gradientColors[0] : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isEnabled ? gradientColors[0].withValues(alpha: 0.5) : AppTheme.border,
                    ),
                    boxShadow: isEnabled
                        ? [
                            BoxShadow(
                              color: gradientColors[0].withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Yakında',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: gradientColors[0].withValues(alpha: 0.6),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
