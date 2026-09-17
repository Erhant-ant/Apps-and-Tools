import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/timer_provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  void _showTimePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      '⏱️ Süre Seç',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hazır süre seç veya kronometre kullan',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 28),

                    // Quick time presets
                    _buildPresetSection(
                      'Deneme Süreleri',
                      [
                        _PresetTime('TYT', 165, const Color(0xFF0EA5E9)),
                        _PresetTime('AYT', 180, const Color(0xFF8B5CF6)),
                        _PresetTime('YDT', 120, const Color(0xFFF59E0B)),
                        _PresetTime('YDS', 180, const Color(0xFFEF4444)),
                        _PresetTime('KPSS', 130, const Color(0xFF10B981)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildPresetSection(
                      'Kısa Çalışma',
                      [
                        _PresetTime('15 dk', 15, AppTheme.primary),
                        _PresetTime('25 dk', 25, AppTheme.primary),
                        _PresetTime('30 dk', 30, AppTheme.primary),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildPresetSection(
                      'Uzun Çalışma',
                      [
                        _PresetTime('45 dk', 45, const Color(0xFFF59E0B)),
                        _PresetTime('60 dk', 60, const Color(0xFFF59E0B)),
                        _PresetTime('90 dk', 90, const Color(0xFFF59E0B)),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Stopwatch button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.read<TimerProvider>().startStopwatch(title: 'Serbest Çalışma');
                        },
                        icon: const Icon(Icons.speed_rounded),
                        label: const Text(
                          'Kronometre (İleri Sayım)',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPresetSection(String title, List<_PresetTime> presets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            // Subtract spacing from total width: 2 gaps of 10px = 20px
            // Divide by 3 to get width per item so exactly 3 items fit in a row
            final itemWidth = (constraints.maxWidth - 20) / 3;
            
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: presets.map((p) {
                return SizedBox(
                  width: itemWidth,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        context
                            .read<TimerProvider>()
                            .startCountdown(Duration(minutes: p.minutes), title: p.label);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: p.color.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: p.color.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              p.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: p.color,
                              ),
                            ),
                            if (p.minutes > 60) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${p.minutes} dk',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: p.color.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          final progress = timerProvider.progress;
          final isRunning = timerProvider.isRunning;
          final isIdle = !isRunning &&
              timerProvider.currentDuration == Duration.zero &&
              timerProvider.mode == TimerMode.countdown;
          final isCountdown = timerProvider.mode == TimerMode.countdown;
          final isLowTime = isCountdown &&
              timerProvider.currentDuration.inMinutes < 5 &&
              timerProvider.currentDuration > Duration.zero;

          final activeColor = isLowTime
              ? const Color(0xFFEF4444)
              : (isCountdown ? AppTheme.primary : const Color(0xFF10B981));

          return SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18),
                          onPressed: () => Navigator.pop(context),
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Zamanlayıcı',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune_rounded, size: 20),
                          onPressed: _showTimePickerSheet,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                // Timer Display
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect behind circle
                          if (isRunning)
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 280 + (_pulseController.value * 20),
                                  height: 280 + (_pulseController.value * 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: activeColor.withValues(
                                            alpha:
                                                0.15 - _pulseController.value * 0.05),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          // Circular progress
                          SizedBox(
                            width: 270,
                            height: 270,
                            child: CustomPaint(
                              painter: _TimerRingPainter(
                                progress: isIdle ? 0.0 : (isCountdown ? progress : 1.0),
                                color: activeColor,
                                bgColor: AppTheme.surfaceVariant,
                                strokeWidth: 10,
                              ),
                            ),
                          ),

                          // Inner circle
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color:
                                      activeColor.withValues(alpha: isRunning ? 0.08 : 0.0),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Mode label
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        activeColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    timerProvider.title != null 
                                        ? timerProvider.title!.toUpperCase() 
                                        : (isIdle
                                            ? 'HAZIR'
                                            : (isCountdown
                                                ? 'GERİ SAYIM'
                                                : 'KRONOMETRE')),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      color: activeColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Time display
                                Text(
                                  isIdle
                                      ? '00:00'
                                      : _formatDuration(
                                          timerProvider.currentDuration),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w700,
                                    color: isIdle
                                        ? AppTheme.textTertiary
                                        : AppTheme.textPrimary,
                                    letterSpacing: 2,
                                  ),
                                ),
                                if (!isIdle &&
                                    isCountdown &&
                                    timerProvider.totalDuration >
                                        Duration.zero) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Hedef: ${_formatDuration(timerProvider.totalDuration)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textTertiary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 100.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                  ),
                ),

                // Controls
                Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: isIdle
                      ? _buildIdleControls()
                      : _buildActiveControls(timerProvider, activeColor),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideY(begin: 0.2),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdleControls() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showTimePickerSheet,
            icon: const Icon(Icons.play_arrow_rounded, size: 28),
            label: const Text(
              'Zamanlayıcı Başlat',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Deneme süresi veya kronometre seç',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveControls(TimerProvider timerProvider, Color activeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reset
        _ControlButton(
          icon: Icons.stop_rounded,
          label: 'Sıfırla',
          color: AppTheme.textSecondary,
          onTap: () => timerProvider.stopAndReset(),
        ),

        // Play / Pause
        GestureDetector(
          onTap: () => timerProvider.toggleTimer(),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  activeColor,
                  activeColor.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              timerProvider.isRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),

        // Add time
        _ControlButton(
          icon: Icons.add_rounded,
          label: '+5 dk',
          color: timerProvider.mode == TimerMode.countdown
              ? activeColor
              : AppTheme.textTertiary,
          onTap: timerProvider.mode == TimerMode.countdown
              ? () => timerProvider.addMinutes(5)
              : null,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetTime {
  final String label;
  final int minutes;
  final Color color;
  const _PresetTime(this.label, this.minutes, this.color);
}

// Custom painter for the gradient ring
class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;
  final double strokeWidth;

  _TimerRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress <= 0) return;

    // Progress ring
    final sweepAngle = 2 * math.pi * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + sweepAngle,
        colors: [
          color.withValues(alpha: 0.6),
          color,
        ],
        stops: const [0.0, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2, // start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Dot at the end of progress
    if (progress > 0.01) {
      final dotAngle = -math.pi / 2 + sweepAngle;
      final dotX = center.dx + radius * math.cos(dotAngle);
      final dotY = center.dy + radius * math.sin(dotAngle);

      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), strokeWidth / 2 + 2, dotPaint);

      // Inner white dot
      final innerDotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), strokeWidth / 4, innerDotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
