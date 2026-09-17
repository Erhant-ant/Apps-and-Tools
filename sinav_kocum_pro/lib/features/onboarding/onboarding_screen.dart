import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/app_state.dart';
import '../../data/exam_database.dart';
import '../../models/exam_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final TextEditingController _nameController = TextEditingController();
  final List<ExamModel> _selectedExams = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    // Validasyonlar
    if (_currentPage == 1 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen adınızı girin 🥺')),
      );
      return;
    }

    if (_currentPage < 2) {
      FocusScope.of(context).unfocus();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (_selectedExams.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen hedefinizi seçin 🎯')),
        );
        return;
      }
      
      // Tamamla
      context.read<AppState>().completeOnboarding(
        _nameController.text.trim(),
        _selectedExams.map((e) => e.id).toList(),
      );
    }
  }

  void _toggleExam(ExamModel exam) {
    setState(() {
      if (_selectedExams.any((e) => e.id == exam.id)) {
        _selectedExams.removeWhere((e) => e.id == exam.id);
      } else {
        _selectedExams.add(exam);
      }
    });
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
                colors: [Color(0xFFF7F3EA), Color(0xFFF1EBDD)],
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
                    physics: const NeverScrollableScrollPhysics(), // Sadece butonla geçilsin
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // Slide 1: Karşılama
                      _OnboardingSlide(
                        title: "Sınav Koçu'na\nHoş Geldin! 🎉",
                        description: "Ben Sebo, senin kişisel sınav koçunum. Hedeflerine birlikte ulaşacağız!",
                        imageAsset: AppConstants.mascotImagePath,
                      ),
                      
                      // Slide 2: İsim Alma
                      Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingXl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '✍️',
                              style: TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              "Sana nasıl hitap etmeliyim?",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppTheme.primary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Adınız',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppTheme.cardBackground,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                              ),
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      // Slide 3: Sınav Seçimi
                      Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingXl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              '🎯',
                              style: TextStyle(fontSize: 60),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Hedeflerini Seç",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppTheme.primary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Birden fazla sınav seçebilirsin.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Expanded(
                              child: ListView.builder(
                                itemCount: ExamDatabase.allExams.length,
                                itemBuilder: (context, index) {
                                  final exam = ExamDatabase.allExams[index];
                                  final isSelected = _selectedExams.any((e) => e.id == exam.id);
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: InkWell(
                                      onTap: () => _toggleExam(exam),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppTheme.primary : AppTheme.cardBackground,
                                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF8A7D6B).withValues(alpha: 0.06),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: isSelected ? AppTheme.primary : AppTheme.border,
                                            width: isSelected ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    exam.shortName,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    exam.name,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: isSelected ? Colors.white.withValues(alpha: 0.9) : AppTheme.textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (isSelected)
                                              const Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            if (!isSelected)
                                              Icon(
                                                Icons.radio_button_unchecked,
                                                color: AppTheme.textTertiary.withValues(alpha: 0.5),
                                                size: 28,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                          3,
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
                          _currentPage == 2 ? 'Maceraya Başla!' : 'İleri',
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

  const _OnboardingSlide({
    required this.title,
    required this.description,
    this.imageAsset,
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
