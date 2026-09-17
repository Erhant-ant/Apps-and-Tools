import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/app_state.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            const Divider(height: 32),
            if (!_isImporting) ...[
              const Text(
                'Uygulama verilerini kaybetmemek için düzenli olarak yedek almayı unutmayın.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _exportData,
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Verileri Yedekle (Kodu Kopyala)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => setState(() => _isImporting = true),
                icon: const Icon(Icons.download_rounded),
                label: const Text('Yedek Kodu ile Verileri Yükle'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
            ] else ...[
              const Text(
                'Daha önce kopyaladığınız yedek kodunu buraya yapıştırın. (Dikkat: Mevcut veriler silinecektir!)',
                style: TextStyle(color: AppTheme.error, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _importController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Yedek kodunu buraya yapıştırın...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _isImporting = false),
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
    );
  }
}
