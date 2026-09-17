import 'package:flutter/material.dart';
import '../../models/badge.dart' as model;
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class BadgeEarnedDialog extends StatefulWidget {
  final model.Badge badge;

  const BadgeEarnedDialog({super.key, required this.badge});

  static Future<void> show(BuildContext context, model.Badge badge) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BadgeEarnedDialog(badge: badge),
    );
  }

  @override
  State<BadgeEarnedDialog> createState() => _BadgeEarnedDialogState();
}

class _BadgeEarnedDialogState extends State<BadgeEarnedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Konfeti ve rozet ikonu
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Arka plan parlaması
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    Text(
                      widget.badge.emoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'YENİ ROZET!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.badge.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.badge.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
                // Sebo mesajı
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                        backgroundImage: const AssetImage(AppConstants.mascotImagePath),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '"Tebrikler Elif! Harika gidiyorsun, aynen böyle devam!"',
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                    ),
                    child: const Text(
                      'Teşekkürler Sebo!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
