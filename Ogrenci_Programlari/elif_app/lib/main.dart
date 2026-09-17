import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/app_state.dart';
import 'features/home/home_screen.dart';
import 'features/study_plan/study_plan_screen.dart';
import 'features/subjects/subjects_screen.dart';
import 'features/mock_exams/mock_exam_list_screen.dart';
import 'features/statistics/statistics_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/gamification/badge_earned_dialog.dart';
import 'core/services/notification_service.dart';

import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  await initializeDateFormatting('tr_TR', null);
  runApp(const ElifSinavKocu());
}

class ElifSinavKocu extends StatelessWidget {
  const ElifSinavKocu({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: "Elif'in Sınav Koçu",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: !appState.isInitialized
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  )
                : (appState.isOnboardingComplete 
                    ? const MainNavigation() 
                    : const OnboardingScreen()),
          );
        },
      ),
    );
  }
}

/// Ana navigasyon çerçevesi — Bottom Navigation Bar
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  static const List<Widget> _pages = [
    HomeScreen(),
    StudyPlanScreen(),
    SubjectsScreen(),
    MockExamListScreen(),
    StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (appState.newlyEarnedBadge != null) {
            final badge = appState.newlyEarnedBadge!;
            appState.clearNewlyEarnedBadge();
            BadgeEarnedDialog.show(context, badge);
          }
        });

        return Scaffold(
          body: IndexedStack(
            index: appState.currentNavIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Ana Sayfa',
                      isSelected: appState.currentNavIndex == 0,
                      onTap: () => appState.setNavIndex(0),
                    ),
                    _NavItem(
                      icon: Icons.calendar_today_rounded,
                      label: 'Program',
                      isSelected: appState.currentNavIndex == 1,
                      onTap: () => appState.setNavIndex(1),
                    ),
                    _NavItem(
                      icon: Icons.menu_book_rounded,
                      label: 'Dersler',
                      isSelected: appState.currentNavIndex == 2,
                      onTap: () => appState.setNavIndex(2),
                    ),
                    _NavItem(
                      icon: Icons.quiz_rounded,
                      label: 'Denemeler',
                      isSelected: appState.currentNavIndex == 3,
                      onTap: () => appState.setNavIndex(3),
                    ),
                    _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'İstatistik',
                      isSelected: appState.currentNavIndex == 4,
                      onTap: () => appState.setNavIndex(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Alt navigasyon öğesi
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
