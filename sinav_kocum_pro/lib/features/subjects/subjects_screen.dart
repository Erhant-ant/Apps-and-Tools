import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../data/kpss_curriculum.dart';
import '../../data/tyt_curriculum.dart';
import '../../data/ayt_ea_curriculum.dart';
import '../../data/ydt_curriculum.dart';
import '../../data/yds_curriculum.dart';
import '../../data/dgs_curriculum.dart';
import '../../data/ales_curriculum.dart';
import '../../data/tus_curriculum.dart';
import '../../models/subject.dart';
import 'topics_screen.dart';

/// Dersler ekranı — Sınav seçimi + ders listesi
class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<_ExamTab> _tabs = [];
  Set<String> _currentExamIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.watch<AppState>();
    
    // Set-based karşılaştırma (sıralama farkını yok sayar)
    final newExamIds = Set<String>.from(appState.selectedExamIds);
    if (!_setEquals(_currentExamIds, newExamIds)) {
      _currentExamIds = newExamIds;
      _updateTabs(appState.selectedExamIds);
    }
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  void _updateTabs(List<String> examIds) {
    // Eski controller'ı temizle
    _tabController?.dispose();

    _tabs.clear();

    for (final examId in examIds) {
      if (examId == 'tyt_2027') {
        if (!_tabs.any((t) => t.shortName == 'TYT')) {
          _tabs.add(_ExamTab('TYT', 'Temel Yeterlilik Testi', TytCurriculum.subjects, AppTheme.tytGradient));
        }
      } else if (examId == 'ayt_2027') {
        if (!_tabs.any((t) => t.shortName == 'AYT')) {
          _tabs.add(_ExamTab('AYT', 'Alan Yeterlilik Testi', AytEaCurriculum.subjects, AppTheme.aytGradient));
        }
      } else if (examId == 'ydt_2027') {
        if (!_tabs.any((t) => t.shortName == 'YDT')) {
          _tabs.add(_ExamTab('YDT', 'Yabancı Dil Testi', YdtCurriculum.subjects, AppTheme.aytGradient));
        }
      } else if (examId == 'kpss_lisans_2027' || examId == 'ekpss_2027') {
        if (!_tabs.any((t) => t.shortName == 'KPSS')) {
          _tabs.add(_ExamTab('KPSS', 'Kamu Personeli Seçme Sınavı', KpssCurriculum.subjects, AppTheme.kpssGradient));
        }
      } else if (examId.startsWith('yds_')) {
        if (!_tabs.any((t) => t.shortName == 'YDS')) {
          _tabs.add(_ExamTab('YDS', 'Yabancı Dil Bilgisi Seviye Tespit Sınavı', YdsCurriculum.subjects, AppTheme.ydsGradient));
        }
      } else if (examId == 'dgs_2027') {
        if (!_tabs.any((t) => t.shortName == 'DGS')) {
          _tabs.add(_ExamTab('DGS', 'Dikey Geçiş Sınavı', DgsCurriculum.subjects, AppTheme.primaryGradient));
        }
      } else if (examId == 'ales_2027') {
        if (!_tabs.any((t) => t.shortName == 'ALES')) {
          _tabs.add(_ExamTab('ALES', 'Akademik Personel ve Lisansüstü Eğitimi Giriş Sınavı', AlesCurriculum.subjects, AppTheme.primaryGradient));
        }
      } else if (examId == 'tus_2027') {
        if (!_tabs.any((t) => t.shortName == 'TUS')) {
          _tabs.add(_ExamTab('TUS', 'Tıpta Uzmanlık Eğitimi Giriş Sınavı', TusCurriculum.subjects, AppTheme.aytGradient));
        }
      }
    }

    if (_tabs.isEmpty) {
      _tabs = [
        _ExamTab('Dersler', 'Dersler', KpssCurriculum.subjects, AppTheme.primaryGradient), // Default
      ];
    }

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

            // Tab seçimi (Eğer tek sekme yoksa göster)
            if (_tabs.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: TabBar(
                    controller: _tabController!,
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

            if (_tabs.length > 1) const SizedBox(height: AppTheme.spacingMd),

            // Ders listesi
            Expanded(
              child: TabBarView(
                controller: _tabController!,
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
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.border),
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
