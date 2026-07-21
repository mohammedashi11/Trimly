import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../domain/entities/booking.dart';

/// Appointment card for the My Bookings lists.
///
/// Upcoming bookings expose Reschedule/Cancel; past ones expose
/// Book Again and a tappable star rating.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onReschedule,
    this.onCancel,
    this.onBookAgain,
    this.onRate,
  });

  final Booking booking;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onBookAgain;
  final ValueChanged<int>? onRate;

  bool get _isPast => onBookAgain != null;

  @override
  Widget build(BuildContext context) {
    final serviceNames = booking.services.map((s) => s.name).join(' & ');

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  booking.shopImage,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            serviceNames,
                            style: AppTextStyles.headlineSm,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(status: booking.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Barber: ${booking.barber.name}',
                      style: AppTextStyles.bodySm,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${DateFormat('MMM d, y').format(booking.dateTime)}'
                            '  •  '
                            '${DateFormat('h:mm a').format(booking.dateTime)}',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          if (!_isPast)
            Row(
              children: [
                _CardAction(
                  icon: Icons.edit_calendar_outlined,
                  label: 'Reschedule',
                  onTap: onReschedule,
                ),
                const SizedBox(width: 28),
                _CardAction(
                  icon: Icons.cancel_outlined,
                  label: 'Cancel',
                  onTap: onCancel,
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (booking.status == BookingStatus.completed)
                  RatingStars(
                    rating: (booking.userRating ?? 0).toDouble(),
                    size: 22,
                    onRate: onRate,
                  )
                else
                  Text(
                    'Cancelled',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                _CardAction(
                  icon: Icons.replay_rounded,
                  label: 'Book Again',
                  color: AppColors.gold,
                  onTap: onBookAgain,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BookingStatus.confirmed => AppColors.gold,
      BookingStatus.completed => AppColors.textSecondary,
      BookingStatus.cancelled => AppColors.error,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSm.copyWith(color: color),
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
