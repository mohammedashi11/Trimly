import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../core/widgets/skeleton.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/entities/service.dart';
import 'providers/shop_providers.dart';
import 'widgets/barber_tile.dart';
import 'widgets/shop_card.dart';

/// Home: greeting, live search, category filter and shop/barber rails.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final topRated = ref.watch(topRatedShopsProvider);
    final barbers = ref.watch(popularBarbersProvider);
    final category = ref.watch(selectedCategoryProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: Row(
                children: [
                  InitialsAvatar(
                    initials: user?.initials ?? 'T',
                    size: 48,
                    ringColor: AppColors.gold,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting, style: AppTextStyles.bodySm),
                        Text(
                          user?.firstName ?? 'Welcome',
                          style: AppTextStyles.headlineMd.copyWith(
                            color: AppColors.gold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You're all caught up — no new alerts."),
                      ),
                    ),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.gold,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceLow,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size(48, 48),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
              ),
              child: _HomeSearchBar(
                query: query,
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                ),
                itemCount: ServiceCategory.values.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final value = ServiceCategory.values[index];
                  return SelectableChip(
                    label: value.label,
                    selected: category == value,
                    onTap: () => ref
                        .read(selectedCategoryProvider.notifier)
                        .state = category == value ? null : value,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
              ),
              child: SectionHeader(
                title: 'Top Rated Near You',
                actionLabel: 'View all',
                onAction: () => context.push(AppRoutes.allShops),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 258,
              child: topRated.when(
                loading: () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenMargin,
                  ),
                  itemCount: 2,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (_, _) => const ShopCardSkeleton(width: 280),
                ),
                error: (e, _) => const _LoadFailure(),
                data: (shops) => shops.isEmpty
                    ? const _NoResults()
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenMargin,
                        ),
                        itemCount: shops.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final shop = shops[index];
                          return FadeSlideIn(
                            index: index,
                            child: ShopCard(
                              shop: shop,
                              width: 280,
                              onTap: () => context
                                  .push('${AppRoutes.shop}/${shop.id}'),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(title: 'Popular Barbers'),
                  const SizedBox(height: AppSpacing.md),
                  barbers.when(
                    loading: () => Column(
                      children: [
                        for (var i = 0; i < 3; i++) ...[
                          const TileSkeleton(),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    ),
                    error: (e, _) => const SizedBox(
                      height: 120,
                      child: _LoadFailure(),
                    ),
                    data: (list) => list.isEmpty
                        ? const SizedBox(height: 120, child: _NoResults())
                        : Column(
                            children: [
                              for (final (index, entry)
                                  in list.take(6).indexed) ...[
                                FadeSlideIn(
                                  index: index,
                                  child: BarberTile(
                                    barber: entry.barber,
                                    onTap: () => context.push(
                                      '${AppRoutes.shop}/${entry.shop.id}',
                                    ),
                                    onBook: () => context.push(
                                      '${AppRoutes.shop}/${entry.shop.id}',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar({required this.query, required this.onChanged});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: query,
      onChanged: onChanged,
      style: AppTextStyles.bodyMd,
      decoration: InputDecoration(
        hintText: 'Search for shops, barbers or services...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Couldn't load right now — pull to refresh.",
        style: AppTextStyles.bodySm,
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 32,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('No matches for that search.', style: AppTextStyles.bodySm),
        ],
      ),
    );
  }
}
