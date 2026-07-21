import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../../core/widgets/skeleton.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../domain/entities/booking.dart';
import 'booking_screen.dart';
import 'providers/booking_providers.dart';
import 'widgets/booking_card.dart';

/// Upcoming and past appointments with reschedule/cancel/rate actions.
class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  int _tab = 0;

  Future<void> _cancelBooking(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: Text(
          '${booking.services.map((s) => s.name).join(' & ')} at '
          '${booking.shopName} on '
          '${DateFormat('MMM d').format(booking.dateTime)} at '
          '${DateFormat('h:mm a').format(booking.dateTime)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(bookingActionsProvider.notifier).cancel(booking.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);
    final user = ref.watch(authControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: AppTextStyles.headlineSm.copyWith(color: AppColors.gold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: InitialsAvatar(initials: user?.initials ?? 'T', size: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          _SegmentedTabs(
            current: _tab,
            onChanged: (tab) => setState(() => _tab = tab),
          ),
          Expanded(
            child: bookingsAsync.when(
              loading: () => ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, _) => const Skeleton(height: 196, radius: 16),
              ),
              error: (e, _) => Center(
                child: Text(
                  "Couldn't load your bookings.",
                  style: AppTextStyles.bodyMd,
                ),
              ),
              data: (bookings) {
                final upcoming = bookings
                    .where((b) =>
                        b.status == BookingStatus.confirmed &&
                        b.dateTime.isAfter(DateTime.now()))
                    .toList()
                  ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
                final past = bookings
                    .where((b) =>
                        b.status == BookingStatus.completed ||
                        b.status == BookingStatus.cancelled)
                    .toList();

                final visible = _tab == 0 ? upcoming : past;
                if (visible.isEmpty) {
                  return _EmptyBookings(isUpcoming: _tab == 0);
                }

                return RefreshIndicator(
                  color: AppColors.gold,
                  backgroundColor: AppColors.surfaceLow,
                  onRefresh: () => ref.refresh(bookingsProvider.future),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenMargin),
                    itemCount: visible.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final booking = visible[index];
                      final card = _tab == 0
                          ? BookingCard(
                              booking: booking,
                              onReschedule: () => context.push(
                                '${AppRoutes.shop}/${booking.shopId}/book',
                                extra: BookingFlowArgs(
                                  existingBooking: booking,
                                ),
                              ),
                              onCancel: () => _cancelBooking(booking),
                            )
                          : BookingCard(
                              booking: booking,
                              onBookAgain: () => context.push(
                                '${AppRoutes.shop}/${booking.shopId}/book',
                                extra: BookingFlowArgs(
                                  services: booking.services,
                                ),
                              ),
                              onRate: (stars) => ref
                                  .read(bookingActionsProvider.notifier)
                                  .rate(booking, stars),
                            );
                      return FadeSlideIn(index: index, child: card);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.current, required this.onChanged});

  final int current;
  final ValueChanged<int> onChanged;

  static const _labels = ['Upcoming', 'Past'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < _labels.length; i++)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: InkWell(
                onTap: () => onChanged(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        _labels[i],
                        style: AppTextStyles.titleMd.copyWith(
                          color: current == i
                              ? AppColors.gold
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 2,
                      width: current == i ? 56 : 0,
                      color: AppColors.gold,
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

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings({required this.isUpcoming});

  final bool isUpcoming;

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
              child: Icon(
                isUpcoming
                    ? Icons.event_available_outlined
                    : Icons.history_rounded,
                size: 36,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: AppTextStyles.headlineSm,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isUpcoming
                  ? 'When you book a chair, it will show up here.'
                  : 'Your booking history will appear here after your first visit.',
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
