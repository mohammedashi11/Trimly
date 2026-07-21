import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/skeleton.dart';
import 'providers/shop_providers.dart';
import 'widgets/shop_card.dart';

/// "View all" list of every shop, ranked by rating.
class AllShopsScreen extends ConsumerWidget {
  const AllShopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(topRatedShopsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Near You')),
      body: shops.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, _) => const ShopCardSkeleton(),
        ),
        error: (e, _) => const Center(child: Text('Something went wrong.')),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final shop = list[index];
            return FadeSlideIn(
              index: index,
              child: ShopCard(
                shop: shop,
                onTap: () => context.push('${AppRoutes.shop}/${shop.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
