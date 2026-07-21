import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/data/mock_auth_repository.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.image,
    required this.headline,
    required this.subtitle,
  });

  final String image;
  final String headline;
  final String subtitle;
}

const _pages = [
  _OnboardingPage(
    image: AppAssets.barberAtWork,
    headline: 'Book your next cut in seconds',
    subtitle:
        "Experience premium grooming with the city's finest barbers at your fingertips.",
  ),
  _OnboardingPage(
    image: AppAssets.barbershopInterior,
    headline: 'Choose your barber, own your style',
    subtitle:
        'Browse verified specialists with real reviews and live availability.',
  ),
  _OnboardingPage(
    image: AppAssets.barberAtWork,
    headline: 'Never wait in line again',
    subtitle:
        'Pick a slot that suits you and walk straight to the chair on arrival.',
  ),
];

/// Full-bleed onboarding carousel over moody barbershop photography.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _getStarted() async {
    await ref.read(authRepositoryProvider).markOnboardingSeen();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => _OnboardingImage(
              image: _pages[index].image,
            ),
          ),
          // Content overlays the carousel and ignores horizontal drags.
          IgnorePointer(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenMargin,
                  0,
                  AppSpacing.screenMargin,
                  208,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(_page),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pages[_page].headline,
                        style: AppTextStyles.headlineLg,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _pages[_page].subtitle,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                0,
                AppSpacing.screenMargin,
                40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PageDots(current: _page, count: _pages.length),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: 'Get Started',
                    icon: Icons.arrow_forward_rounded,
                    radius: 28,
                    onPressed: _getStarted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingImage extends StatelessWidget {
  const _OnboardingImage({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.45, 0.8],
                colors: [
                  Colors.transparent,
                  AppColors.scrim,
                  AppColors.background,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.current, required this.count});

  final int current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final selected = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(right: AppSpacing.sm),
          width: selected ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? AppColors.gold : AppColors.surfaceHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
