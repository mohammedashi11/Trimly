import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/data/mock_auth_repository.dart';

/// Brand splash: the monogram fades in, then routes based on session state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<double> _scale = Tween<double>(begin: 0.92, end: 1)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1500), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final auth = ref.read(authRepositoryProvider);
    final user = await auth.getCurrentUser();
    final seenOnboarding = await auth.hasSeenOnboarding();
    if (!mounted) return;

    if (user != null) {
      context.go(AppRoutes.home);
    } else if (seenOnboarding) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Official brand mark, gold on charcoal — the asset's
                    // field blends seamlessly into the scaffold.
                    Image.asset(AppAssets.logo, width: 240),
                    // Soft ambient halo over the mark, per the design.
                    IgnorePointer(
                      child: Container(
                        width: 420,
                        height: 420,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [AppColors.goldGlow, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.92),
            child: FadeTransition(
              opacity: _fade,
              child: Container(
                width: 48,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.borderMuted,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
