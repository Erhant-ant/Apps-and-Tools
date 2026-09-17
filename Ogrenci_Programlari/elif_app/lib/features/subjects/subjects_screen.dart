import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/exam_dates.dart';
import '../../data/kpss_curriculum.dart';
import '../../data/tyt_curriculum.dart';
import '../../data/ayt_ea_curriculum.dart';
import '../../models/subject.dart';
import 'topics_screen.dart';

/// Dersler ekranı — Sınav seçimi + ders listesi
class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_ExamTab> _tabs = [
    _ExamTab('KPSS', ExamDates.kpssName, KpssCurriculum.subjects, AppTheme.kpssGradient),
    _ExamTab('TYT', ExamDates.tytName, TytCurriculum.subjects, AppTheme.tytGradient),
    _ExamTab('AYT EA', ExamDates.aytName, AytEaCurriculum.subjects, AppTheme.aytGradient),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Text(
                'Dersler 📚',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            // Tab seçimi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textSecondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: _tabs.map((t) => Tab(text: t.shortName)).toList(),
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingMd),

            // Ders listesi
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((tab) {
                  return _SubjectList(
                    subjects: tab.subjects,
                    examName: tab.fullName,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamTab {
  final String shortName;
  final String fullName;
  final List<Subject> subjects;
  final List<Color> gradient;

  _ExamTab(this.shortName, this.fullName, this.subjects, this.gradient);
}

/// Ders listesi
class _SubjectList extends StatelessWidget {
  final List<Subject> subjects;
  final String examName;

  const _SubjectList({
    required this.subjects,
    required this.examName,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return _SubjectCard(subject: subject);
      },
    );
  }
}

/// Ders kartı
class _SubjectCard extends StatelessWidget {
  final Subject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TopicsScreen(subject: subject),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              // Emoji + renk
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: subject.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Center(
                  child: Text(
                    subject.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),

              // İsim ve bilgi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.totalTopicCount} konu • ${subject.questionCount} soru',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    // İlerleme çubuğu
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: subject.progress,
                        backgroundColor: AppTheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),

              // Yüzde
              Column(
                children: [
                  Text(
                    '%${subject.progressPercent}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: subject.color,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
