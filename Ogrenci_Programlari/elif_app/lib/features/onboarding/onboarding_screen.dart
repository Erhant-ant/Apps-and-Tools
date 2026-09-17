import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.read<AppState>().completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: const [
                      _OnboardingSlide(
                        title: "Elif'in Sınav Koçu'na\nHoş Geldin! 🎉",
                        description: "Ben Sebo, senin kişisel sınav koçunum. Birlikte hedeflerine ulaşacağız!",
                        imageAsset: AppConstants.mascotImagePath,
                        isMascot: true,
                      ),
                      _OnboardingSlide(
                        title: "Hedefine Adım Adım 🎯",
                        description: "KPSS ve YKS için özel hazırlanmış çalışma programı ve geri sayım sayaçları ile her an motive kal.",
                        emoji: '⏳',
                      ),
                      _OnboardingSlide(
                        title: "Akıllı Tekrar Sistemi 🧠",
                        description: "Öğrendiklerini asla unutma! Aralıklı tekrar sistemi ile konuları en doğru zamanda tekrar et.",
                        emoji: '🔄',
                      ),
                      _OnboardingSlide(
                        title: "Biz Seninleyiz! 💪",
                        description: "\"Kızım iyi çalış sonuna kadar arkandayım.\" \n\n— Sabahattin Amca 😊",
                        emoji: '❤️',
                      ),
                    ],
                  ),
                ),
                
                // Alt kontroller
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingXl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Noktalar
                      Row(
                        children: List.generate(
                          4,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppTheme.primary
                                  : AppTheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      
                      // Buton
                      ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                          ),
                        ),
                        child: Text(
                          _currentPage == 3 ? 'Hadi Başlayalım!' : 'İleri',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final String? imageAsset;
  final String? emoji;
  final bool isMascot;

  const _OnboardingSlide({
    required this.title,
    required this.description,
    this.imageAsset,
    this.emoji,
    this.isMascot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  imageAsset!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (emoji != null)
            Text(
              emoji!,
              style: const TextStyle(fontSize: 100),
            ),
          
          const SizedBox(height: 48),
          
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.primary,
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
