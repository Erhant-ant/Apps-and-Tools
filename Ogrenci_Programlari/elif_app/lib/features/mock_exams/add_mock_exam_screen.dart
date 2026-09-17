import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/app_state.dart';
import '../../models/mock_exam.dart';

/// Deneme Ekleme Ekranı
class AddMockExamScreen extends StatefulWidget {
  const AddMockExamScreen({super.key});

  @override
  State<AddMockExamScreen> createState() => _AddMockExamScreenState();
}

class _AddMockExamScreenState extends State<AddMockExamScreen> {
  String _selectedType = 'tyt';
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Her sınav türü için ders listesi
  final Map<String, List<String>> _subjectsByType = {
    'kpss': [
      'Türkçe',
      'Matematik',
      'Tarih',
      'Coğrafya',
      'Vatandaşlık',
      'Güncel Bilgiler',
    ],
    'tyt': ['Türkçe', 'Matematik', 'Sosyal Bilimler', 'Fen Bilimleri'],
    'ayt': ['Matematik', 'Edebiyat', 'Tarih-1', 'Coğrafya-1'],
  };

  final Map<String, Map<String, int>> _questionCountsByType = {
    'kpss': {
      'Türkçe': 30,
      'Matematik': 30,
      'Tarih': 27,
      'Coğrafya': 18,
      'Vatandaşlık': 9,
      'Güncel Bilgiler': 6,
    },
    'tyt': {
      'Türkçe': 40,
      'Matematik': 40,
      'Sosyal Bilimler': 20,
      'Fen Bilimleri': 20,
    },
    'ayt': {
      'Matematik': 40,
      'Edebiyat': 24,
      'Tarih-1': 10,
      'Coğrafya-1': 6,
    },
  };

  // D/Y/B kontrolcüler
  final Map<String, TextEditingController> _correctControllers = {};
  final Map<String, TextEditingController> _wrongControllers = {};
  final Map<String, TextEditingController> _blankControllers = {};

  @override
  void initState() {
    super.initState();
    _titleController.text = 'Deneme #1';
    _initControllers();
  }

  void _initControllers() {
    _disposeSubjectControllers();
    _correctControllers.clear();
    _wrongControllers.clear();
    _blankControllers.clear();
    for (var subject in _subjectsByType[_selectedType]!) {
      _correctControllers[subject] = TextEditingController(text: '0');
      _wrongControllers[subject] = TextEditingController(text: '0');
      _blankControllers[subject] = TextEditingController(text: '0');
    }
  }

  void _disposeSubjectControllers() {
    for (final controller in _correctControllers.values) {
      controller.dispose();
    }
    for (final controller in _wrongControllers.values) {
      controller.dispose();
    }
    for (final controller in _blankControllers.values) {
      controller.dispose();
    }
  }

  double _calculateTotalNet() {
    double total = 0;
    for (var subject in _subjectsByType[_selectedType]!) {
      final d = int.tryParse(_correctControllers[subject]?.text ?? '0') ?? 0;
      final y = int.tryParse(_wrongControllers[subject]?.text ?? '0') ?? 0;
      total += d - (y / 4.0);
    }
    return total;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _disposeSubjectControllers();
    super.dispose();
  }

  Future<void> _saveExam() async {
    final results = <SubjectResult>[];
    for (var subject in _subjectsByType[_selectedType]!) {
      final d = int.tryParse(_correctControllers[subject]?.text.trim() ?? '');
      final y = int.tryParse(_wrongControllers[subject]?.text.trim() ?? '');
      final b = int.tryParse(_blankControllers[subject]?.text.trim() ?? '');
      if (d == null || y == null || b == null || d < 0 || y < 0 || b < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Doğru, yanlış ve boş alanlarına 0 veya daha büyük tam sayılar girin.',
            ),
          ),
        );
        return;
      }
      final questionCount = _questionCountsByType[_selectedType]![subject]!;
      if (d + y + b != questionCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$subject için doğru + yanlış + boş toplamı $questionCount olmalı.',
            ),
          ),
        );
        return;
      }
      results.add(
        SubjectResult(subjectName: subject, correct: d, wrong: y, blank: b),
      );
    }

    final exam = MockExam(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      examType: _selectedType,
      title: _titleController.text.isEmpty ? 'Deneme' : _titleController.text,
      date: _selectedDate,
      results: results,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    final messenger = ScaffoldMessenger.of(context);
    await context.read<AppState>().addMockExam(exam);
    if (!mounted) return;
    Navigator.pop(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Deneme kaydedildi! Toplam Net: ${exam.totalNet.toStringAsFixed(2)}',
        ),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deneme Ekle'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sınav türü seçimi
            Text('Sınav Türü', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTypeChip('TYT', 'tyt'),
                const SizedBox(width: 8),
                _buildTypeChip('AYT', 'ayt'),
                const SizedBox(width: 8),
                _buildTypeChip('KPSS', 'kpss'),
              ],
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Deneme adı
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Deneme Adı',
                hintText: 'Örn: TYT Deneme #3',
                prefixIcon: Icon(Icons.edit_rounded),
              ),
            ),

            OutlinedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null && mounted) {
                  setState(() => _selectedDate = date);
                }
              },
              icon: const Icon(Icons.calendar_today_rounded),
              label: Text(
                'Deneme tarihi: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Toplam net gösterimi
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.1),
                    AppTheme.accent.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Text(
                    'Toplam Net: ',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    _calculateTotalNet().toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Ders bazlı sonuçlar
            Text(
              'Ders Sonuçları',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMd),

            ...(_subjectsByType[_selectedType] ?? []).map((subject) {
              return _SubjectResultInput(
                subjectName: subject,
                correctController: _correctControllers[subject]!,
                wrongController: _wrongControllers[subject]!,
                blankController: _blankControllers[subject]!,
                questionCount: _questionCountsByType[_selectedType]![subject]!,
                onChanged: () => setState(() {}),
              );
            }),

            const SizedBox(height: AppTheme.spacingMd),

            // Not
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Not (isteğe bağlı)',
                hintText: 'Bu deneme hakkında notlarınız...',
                prefixIcon: Icon(Icons.note_rounded),
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),

            // Kaydet butonu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _saveExam,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Denemeyi Kaydet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, String value) {
    final isSelected = _selectedType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = value;
          _initControllers();
        });
      },
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
}

/// Ders sonucu giriş alanı
class _SubjectResultInput extends StatelessWidget {
  final String subjectName;
  final TextEditingController correctController;
  final TextEditingController wrongController;
  final TextEditingController blankController;
  final int questionCount;
  final VoidCallback onChanged;

  const _SubjectResultInput({
    required this.subjectName,
    required this.correctController,
    required this.wrongController,
    required this.blankController,
    required this.questionCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final d = int.tryParse(correctController.text) ?? 0;
    final y = int.tryParse(wrongController.text) ?? 0;
    final net = d - (y / 4.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '$subjectName ($questionCount soru)',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: net >= 0
                      ? AppTheme.accent.withValues(alpha: 0.1)
                      : AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Net: ${net.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: net >= 0 ? AppTheme.accent : AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniInput(
                label: 'D',
                controller: correctController,
                color: AppTheme.accent,
                onChanged: onChanged,
              ),
              const SizedBox(width: 10),
              _MiniInput(
                label: 'Y',
                controller: wrongController,
                color: AppTheme.error,
                onChanged: onChanged,
              ),
              const SizedBox(width: 10),
              _MiniInput(
                label: 'B',
                controller: blankController,
                color: AppTheme.textTertiary,
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color color;
  final VoidCallback onChanged;

  const _MiniInput({
    required this.label,
    required this.controller,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color, width: 2),
                ),
                fillColor: color.withValues(alpha: 0.05),
                filled: true,
              ),
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
