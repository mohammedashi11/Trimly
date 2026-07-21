import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/dashed_divider.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/primary_button.dart';
import '../domain/entities/booking.dart';

/// Receipt-style confirmation shown right after a booking is created.
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'TRIMLY',
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.gold,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go(AppRoutes.home),
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
            vertical: AppSpacing.lg,
          ),
          children: [
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldGlow,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 52,
                  color: AppColors.gold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Booking Confirmed',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineLg,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Your chair is ready. We've sent the details to your email.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ReceiptCard(booking: booking),
            const SizedBox(height: AppSpacing.xl),
            GhostButton(
              label: 'Add to Calendar',
              icon: Icons.edit_calendar_outlined,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to your calendar.'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'DONE',
              onPressed: () => context.go(AppRoutes.bookings),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Need to reschedule? Call (555) 012-3456',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      clipContent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.asset(
                booking.shopImage,
                height: 132,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE VENUE',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(booking.shopName, style: AppTextStyles.headlineMd),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ReceiptField(
                        label: 'BARBER',
                        value: booking.barber.name,
                      ),
                    ),
                    Expanded(
                      child: _ReceiptField(
                        label: 'SERVICE',
                        value: booking.services
                            .map((s) => s.name)
                            .join(' & '),
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _ReceiptField(
                        label: 'DATE',
                        value: DateFormat('EEEE, MMM d')
                            .format(booking.dateTime),
                      ),
                    ),
                    Expanded(
                      child: _ReceiptField(
                        label: 'TIME',
                        value: DateFormat('h:mm a').format(booking.dateTime),
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const DashedDivider(),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTextStyles.headlineSm),
                    Text(
                      '\$${booking.totalPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.headlineMd.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptField extends StatelessWidget {
  const _ReceiptField({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMd,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}
