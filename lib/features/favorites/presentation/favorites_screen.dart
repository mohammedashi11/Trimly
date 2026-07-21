import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/skeleton.dart';
import '../../shops/presentation/widgets/shop_card.dart';
import 'providers/favorites_providers.dart';

/// Favorited shops, powered by the persisted favorites set.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteShopsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, _) => const ShopCardSkeleton(),
        ),
        error: (e, _) => const Center(child: Text('Something went wrong.')),
        data: (shops) => shops.isEmpty
            ? const _EmptyFavorites()
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                itemCount: shops.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return FadeSlideIn(
                    index: index,
                    child: ShopCard(
                      shop: shop,
                      onTap: () =>
                          context.push('${AppRoutes.shop}/${shop.id}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceLow,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.favorite_outline_rounded,
                size: 36,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('No favorites yet', style: AppTextStyles.headlineSm),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the heart on any barbershop to keep it here for quick booking.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
