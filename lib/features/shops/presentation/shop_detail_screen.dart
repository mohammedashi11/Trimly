import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../bookings/domain/entities/booking.dart';
import '../../bookings/presentation/booking_screen.dart';
import '../../favorites/presentation/providers/favorites_providers.dart';
import '../domain/entities/barbershop.dart';
import '../domain/entities/service.dart';
import 'providers/shop_providers.dart';
import 'widgets/review_tile.dart';
import 'widgets/service_tile.dart';

/// Services the user has ticked on a shop's detail screen.
final selectedServicesProvider = StateProvider.autoDispose
    .family<Set<Service>, String>((ref, shopId) => <Service>{});

/// Shop detail: hero photo, info card with tabs, selectable services and
/// a sticky booking bar.
class ShopDetailScreen extends ConsumerStatefulWidget {
  const ShopDetailScreen({super.key, required this.shopId});

  final String shopId;

  @override
  ConsumerState<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends ConsumerState<ShopDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final shopAsync = ref.watch(shopProvider(widget.shopId));

    return Scaffold(
      body: shopAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text("We couldn't find that shop.",
              style: AppTextStyles.bodyMd),
        ),
        data: (shop) => _ShopDetailBody(
          shop: shop,
          tab: _tab,
          onTabChanged: (tab) => setState(() => _tab = tab),
        ),
      ),
      bottomNavigationBar: shopAsync.valueOrNull == null
          ? null
          : _BookingBar(shop: shopAsync.valueOrNull!),
    );
  }
}

class _ShopDetailBody extends ConsumerWidget {
  const _ShopDetailBody({
    required this.shop,
    required this.tab,
    required this.onTabChanged,
  });

  final Barbershop shop;
  final int tab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedServicesProvider(shop.id));

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _HeroHeader(shop: shop),
        Container(
          transform: Matrix4.translationValues(0, -48, 0),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoCard(shop: shop, tab: tab, onTabChanged: onTabChanged),
              const SizedBox(height: AppSpacing.lg),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: switch (tab) {
                  0 => Column(
                      key: const ValueKey('services'),
                      children: [
                        for (final service in shop.services) ...[
                          ServiceTile(
                            service: service,
                            selected: selected.contains(service),
                            onToggle: () {
                              final notifier = ref.read(
                                selectedServicesProvider(shop.id).notifier,
                              );
                              final next = {...notifier.state};
                              if (!next.remove(service)) next.add(service);
                              notifier.state = next;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    ),
                  1 => _GalleryGrid(
                      key: const ValueKey('gallery'),
                      images: shop.gallery,
                    ),
                  _ => Column(
                      key: const ValueKey('reviews'),
                      children: [
                        for (final review in shop.reviews) ...[
                          ReviewTile(review: review),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    ),
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroHeader extends ConsumerWidget {
  const _HeroHeader({required this.shop});

  final Barbershop shop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref
            .watch(favoritesControllerProvider)
            .valueOrNull
            ?.contains(shop.id) ??
        false;

    return SizedBox(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'shop-image-${shop.id}',
            child: Image.asset(shop.image, fit: BoxFit.cover),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.55, 1],
                colors: [Colors.transparent, AppColors.background],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleAction(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                  ),
                  _CircleAction(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: isFavorite ? AppColors.gold : AppColors.textPrimary,
                    onTap: () => ref
                        .read(favoritesControllerProvider.notifier)
                        .toggle(shop.id),
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

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.scrim,
        minimumSize: const Size(48, 48),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.shop,
    required this.tab,
    required this.onTabChanged,
  });

  final Barbershop shop;
  final int tab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surfaceLow,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(shop.name, style: AppTextStyles.headlineMd),
              ),
              const SizedBox(width: 12),
              _OpenBadge(isOpen: shop.isOpen),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(
                shop.rating.toStringAsFixed(1),
                style: AppTextStyles.titleMd,
              ),
              const SizedBox(width: 8),
              Text(
                '(${shop.reviewCount} reviews)',
                style: AppTextStyles.bodySm,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  shop.address,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailTabs(current: tab, onChanged: onTabChanged),
        ],
      ),
    );
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? AppColors.gold : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        isOpen ? 'OPEN NOW' : 'CLOSED',
        style: AppTextStyles.labelSm.copyWith(color: color),
      ),
    );
  }
}

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.current, required this.onChanged});

  final int current;
  final ValueChanged<int> onChanged;

  static const _labels = ['Services', 'Gallery', 'Reviews'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _labels.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: InkWell(
              onTap: () => onChanged(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      _labels[i],
                      style: AppTextStyles.labelMd.copyWith(
                        color: current == i
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2,
                    width: current == i ? 48 : 0,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid({super.key, required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: [
        for (final image in images)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
      ],
    );
  }
}

class _BookingBar extends ConsumerWidget {
  const _BookingBar({required this.shop});

  final Barbershop shop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedServicesProvider(shop.id));
    final total = Booking.totalPriceOf(selected);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('SELECTED SERVICES', style: AppTextStyles.labelSm),
                    const SizedBox(height: 4),
                    Text(
                      'Total: \$${total.toStringAsFixed(0)}',
                      style: AppTextStyles.headlineMd.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PrimaryButton(
                label: 'Book Now',
                expanded: false,
                onPressed: selected.isEmpty
                    ? null
                    : () => context.push(
                          '${AppRoutes.shop}/${shop.id}/book',
                          extra: BookingFlowArgs(services: selected.toList()),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
