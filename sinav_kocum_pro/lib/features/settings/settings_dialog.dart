import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/app_state.dart';
import '../../data/exam_database.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final TextEditingController _importController = TextEditingController();
  bool _isImporting = false;
  bool _isEditingExams = false;
  late List<String> _editingExamIds;
  bool _examsDirty = false;

  @override
  void initState() {
    super.initState();
    _editingExamIds = List<String>.from(
      context.read<AppState>().selectedExamIds,
    );
  }

  Future<void> _exportData() async {
    try {
      final jsonStr = await StorageService.exportData();
      await Clipboard.setData(ClipboardData(text: jsonStr));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yedek kodu panoya kopyalandı! Bir yere kaydedin.'),
          backgroundColor: AppTheme.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yedekleme sırasında bir hata oluştu.'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  Future<void> _importData() async {
    final text = _importController.text.trim();
    if (text.isEmpty) return;

    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mevcut veriler değişecek'),
        content: const Text(
          'Bu işlem mevcut deneme ve ilerleme verilerini yedekteki verilerle değiştirir. Devam etmek istiyor musun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yükle'),
          ),
        ],
      ),
    );
    if (shouldImport != true || !mounted) return;

    try {
      await StorageService.importData(text);
      if (!mounted) return;
      await context.read<AppState>().reloadAllData();
      if (!mounted) return;
      
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veriler başarıyla yüklendi!'),
          backgroundColor: AppTheme.accent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçersiz yedek kodu. Lütfen kontrol edin.'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _toggleExam(String examId) {
    setState(() {
      if (_editingExamIds.contains(examId)) {
        // En az 1 sınav seçili kalmalı
        if (_editingExamIds.length <= 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('En az bir sınav seçili olmalıdır! 🎯'),
              backgroundColor: AppTheme.warning,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        _editingExamIds.remove(examId);
      } else {
        _editingExamIds.add(examId);
      }
      // Mevcut durumla karşılaştır
      final currentIds = context.read<AppState>().selectedExamIds;
      _examsDirty = !_listEquals(currentIds, _editingExamIds);
    });
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = List<String>.from(a)..sort();
    final sortedB = List<String>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

  Future<void> _saveExamChanges() async {
    await context.read<AppState>().updateSelectedExams(
      List<String>.from(_editingExamIds),
    );
    if (!mounted) return;
    setState(() {
      _examsDirty = false;
      _isEditingExams = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sınav tercihleriniz güncellendi! ✅'),
        backgroundColor: AppTheme.accent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Başlık ─────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.settings_rounded, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Ayarlar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              // ─── İçerik (kaydırılabilir) ─────────────────────
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ═══ SINAV SEÇİMİ BÖLÜMÜ ═══════════════
                      _buildExamSection(),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      // ═══ YEDEKLEME BÖLÜMÜ ═══════════════════
                      if (!_isImporting) ...[
                        const Text(
                          'Uygulama verilerini kaybetmemek için düzenli olarak yedek almayı unutmayın.',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _exportData,
                          icon: const Icon(Icons.copy_rounded),
                          label:
                              const Text('Verileri Yedekle (Kodu Kopyala)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () =>
                              setState(() => _isImporting = true),
                          icon: const Icon(Icons.download_rounded),
                          label:
                              const Text('Yedek Kodu ile Verileri Yükle'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            side:
                                const BorderSide(color: AppTheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg),
                            ),
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Daha önce kopyaladığınız yedek kodunu buraya yapıştırın. (Dikkat: Mevcut veriler silinecektir!)',
                          style:
                              TextStyle(color: AppTheme.error, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _importController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Yedek kodunu buraya yapıştırın...',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    setState(() => _isImporting = false),
                                child: const Text('İptal'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: _importData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Verileri Yükle'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Sınav Seçimi Bölümü ──────────────────────────────────────
  Widget _buildExamSection() {
    final currentExamIds = context.watch<AppState>().selectedExamIds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Başlık satırı
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: AppTheme.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sınavlarım',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${currentExamIds.length} sınav seçili',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Düzenle / Kapat butonu
            TextButton.icon(
              onPressed: () {
                setState(() {
                  if (_isEditingExams) {
                    // İptal: değişiklikleri geri al
                    _editingExamIds = List<String>.from(currentExamIds);
                    _examsDirty = false;
                  }
                  _isEditingExams = !_isEditingExams;
                });
              },
              icon: Icon(
                _isEditingExams ? Icons.close_rounded : Icons.edit_rounded,
                size: 18,
              ),
              label: Text(_isEditingExams ? 'İptal' : 'Düzenle'),
              style: TextButton.styleFrom(
                foregroundColor:
                    _isEditingExams ? AppTheme.textSecondary : AppTheme.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Seçili sınavların önizlemesi veya düzenleme kartları
        if (!_isEditingExams)
          // ─── Önizleme: seçili sınavlar ─────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: currentExamIds.map((id) {
              final exam = ExamDatabase.getExamById(id);
              if (exam == null) return const SizedBox();
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.1),
                      AppTheme.secondary.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      exam.shortName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        else
          // ─── Düzenleme: toggle kartları ─────────────
          Column(
            children: [
              ...ExamDatabase.allExams.map((exam) {
                final isSelected = _editingExamIds.contains(exam.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withValues(alpha: 0.08)
                          : AppTheme.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary.withValues(alpha: 0.4)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleExam(exam.id),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              // Sınav bilgileri
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exam.shortName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppTheme.primary
                                            : AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      exam.description,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textTertiary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Toggle ikonu
                              AnimatedSwitcher(
                                duration:
                                    const Duration(milliseconds: 200),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        key: ValueKey('checked'),
                                        color: AppTheme.primary,
                                        size: 26,
                                      )
                                    : Icon(
                                        Icons.radio_button_unchecked,
                                        key: const ValueKey('unchecked'),
                                        color: AppTheme.textTertiary
                                            .withValues(alpha: 0.5),
                                        size: 26,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Kaydet butonu
              if (_examsDirty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveExamChanges,
                    icon: const Icon(Icons.save_rounded, size: 20),
                    label: const Text('Değişiklikleri Kaydet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusLg),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}
