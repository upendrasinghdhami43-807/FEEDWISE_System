import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../shared/widgets/fw_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _OnboardingSlide(
      emoji: '📱',
      title: 'See Everything',
      subtitle: 'Your feed is full of information.\nSome real. Some not.',
      gradient: [Color(0xFF6C5CE7), Color(0xFF8B5CF6)],
    ),
    _OnboardingSlide(
      emoji: '🔎',
      title: 'Think Before You Share',
      subtitle: 'Learn to investigate sources, evidence,\nand context before acting.',
      gradient: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
    ),
    _OnboardingSlide(
      emoji: '🏆',
      title: 'Play Your Part',
      subtitle: 'Build real Media & Information\nLiteracy skills that matter.',
      gradient: [Color(0xFFFF6B6B), Color(0xFFFFA94D)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text('Skip', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark)),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _currentPage ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentPage ? AppColors.primary500 : AppColors.borderDark,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              )),
            ),

            const SizedBox(height: 32),

            // CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _currentPage < _slides.length - 1
                  ? FWButton(
                      label: 'Next',
                      isFullWidth: true,
                      onPressed: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    )
                  : FWButton(
                      label: 'Get Started',
                      isFullWidth: true,
                      onPressed: () => context.go('/register'),
                    ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => context.go('/login'),
              child: Text('Already have an account? Sign In',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.primary500)),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _OnboardingSlide slide;
  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: slide.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: slide.gradient.first.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
              ],
            ),
            child: Center(child: Text(slide.emoji, style: const TextStyle(fontSize: 72))),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.9, 0.9), duration: 400.ms),

          const SizedBox(height: 40),

          Text(slide.title, style: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryDark), textAlign: TextAlign.center)
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 16),

          Text(slide.subtitle, style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondaryDark, height: 1.6),
              textAlign: TextAlign.center)
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  const _OnboardingSlide({required this.emoji, required this.title, required this.subtitle, required this.gradient});
}
