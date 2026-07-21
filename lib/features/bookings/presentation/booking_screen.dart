import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../shops/domain/entities/barber.dart';
import '../../shops/domain/entities/barbershop.dart';
import '../../shops/domain/entities/service.dart';
import '../../shops/presentation/providers/shop_providers.dart';
import '../domain/entities/booking.dart';
import '../domain/time_slots.dart';
import 'providers/booking_providers.dart';

/// Arguments for the booking flow route.
///
/// Either a fresh booking for [services], or a reschedule of
/// [existingBooking] (whose services are reused).
class BookingFlowArgs {
  const BookingFlowArgs({this.services = const [], this.existingBooking});

  final List<Service> services;
  final Booking? existingBooking;

  List<Service> get effectiveServices =>
      existingBooking?.services ?? services;
}

/// Barber, date and time selection for one appointment.
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key, required this.shopId, required this.args});

  final String shopId;
  final BookingFlowArgs args;

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  Barber? _barber;
  late DateTime _day;
  DateTime? _slot;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.args.existingBooking;
    _day = _dateOnly(existing?.dateTime ?? DateTime.now());
    if (_day.isBefore(_dateOnly(DateTime.now()))) {
      _day = _dateOnly(DateTime.now());
    }
  }

  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  void _prefillFromShop(Barbershop shop) {
    if (_prefilled) return;
    _prefilled = true;
    final existing = widget.args.existingBooking;
    _barber = existing == null
        ? shop.barbers.first
        : shop.barbers.firstWhere(
            (b) => b.id == existing.barber.id,
            orElse: () => shop.barbers.first,
          );
  }

  Future<void> _confirm(Barbershop shop) async {
    final barber = _barber;
    final slot = _slot;
    if (barber == null || slot == null) return;

    final actions = ref.read(bookingActionsProvider.notifier);
    final existing = widget.args.existingBooking;

    final Booking? result;
    if (existing != null) {
      result = await actions.reschedule(
        existing.copyWith(
          barber: barber,
          dateTime: slot,
          status: BookingStatus.confirmed,
        ),
      );
    } else {
      result = await actions.create(
        Booking(
          id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
          shopId: shop.id,
          shopName: shop.name,
          shopImage: shop.image,
          barber: barber,
          services: widget.args.effectiveServices,
          dateTime: slot,
          status: BookingStatus.confirmed,
        ),
      );
    }

    if (result != null && mounted) {
      context.pushReplacement(AppRoutes.bookingConfirmation, extra: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopAsync = ref.watch(shopProvider(widget.shopId));
    final user = ref.watch(authControllerProvider).valueOrNull;
    final submitting = ref.watch(bookingActionsProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(
          'TRIMLY',
          style: AppTextStyles.headlineSm.copyWith(
            color: AppColors.gold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: InitialsAvatar(initials: user?.initials ?? 'T', size: 40),
          ),
        ],
      ),
      body: shopAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text("We couldn't load this shop.",
              style: AppTextStyles.bodyMd),
        ),
        data: (shop) {
          _prefillFromShop(shop);
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
              vertical: AppSpacing.lg,
            ),
            children: [
              _StepIndicator(currentStep: _slot == null ? 1 : 2),
              const SizedBox(height: AppSpacing.xl),
              Text('Select Barber', style: AppTextStyles.headlineMd),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 132,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: shop.barbers.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    final barber = shop.barbers[index];
                    final selected = barber == _barber;
                    return _BarberChoice(
                      barber: barber,
                      selected: selected,
                      onTap: () => setState(() {
                        _barber = barber;
                        _slot = null;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Date', style: AppTextStyles.headlineMd),
                  Text(
                    DateFormat.yMMMM().format(_day),
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.sm + 4),
                  itemBuilder: (context, index) {
                    final day = _dateOnly(
                      DateTime.now().add(Duration(days: index)),
                    );
                    final selected = day == _day;
                    return _DayChip(
                      day: day,
                      selected: selected,
                      onTap: () => setState(() {
                        _day = day;
                        _slot = null;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Available Times', style: AppTextStyles.headlineMd),
              const SizedBox(height: AppSpacing.md),
              if (_barber != null)
                _TimeSlotGrid(
                  shopId: shop.id,
                  barber: _barber!,
                  day: _day,
                  selected: _slot,
                  onSelect: (slot) => setState(() => _slot = slot),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
      bottomNavigationBar: shopAsync.valueOrNull == null
          ? null
          : _SummaryBar(
              services: widget.args.effectiveServices,
              enabled: _slot != null && !submitting,
              submitting: submitting,
              isReschedule: widget.args.existingBooking != null,
              onContinue: () => _confirm(shopAsync.valueOrNull!),
            ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  /// 0 = Service, 1 = Barber, 2 = Time.
  final int currentStep;

  static const _labels = ['Service', 'Barber', 'Time'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _labels.length; i++) ...[
          if (i > 0)
            Container(
              width: 32,
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              color: AppColors.borderMuted,
            ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= currentStep
                      ? (i == currentStep
                          ? AppColors.gold
                          : AppColors.textMuted)
                      : AppColors.surfaceHighest,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _labels[i],
                style: AppTextStyles.labelMd.copyWith(
                  color: i == currentStep
                      ? AppColors.gold
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _BarberChoice extends StatelessWidget {
  const _BarberChoice({
    required this.barber,
    required this.selected,
    required this.onTap,
  });

  final Barber barber;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.gold : Colors.transparent,
                width: 2,
              ),
            ),
            child: InitialsAvatar(
              initials: barber.initials,
              size: 84,
              ringColor:
                  selected ? AppColors.goldDim : AppColors.border,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _shortName(barber.name),
            style: AppTextStyles.labelMd.copyWith(
              color: selected ? AppColors.gold : AppColors.textMuted,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  static String _shortName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    return '${parts.first} ${parts.last[0]}.';
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 72,
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.E().format(day),
              style: AppTextStyles.bodySm.copyWith(
                color: selected ? AppColors.onGold : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${day.day}',
              style: AppTextStyles.headlineMd.copyWith(
                color: selected ? AppColors.onGold : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  const _TimeSlotGrid({
    required this.shopId,
    required this.barber,
    required this.day,
    required this.selected,
    required this.onSelect,
  });

  final String shopId;
  final Barber barber;
  final DateTime day;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final slots = TimeSlots.forDay(
      shopId: shopId,
      barberId: barber.id,
      day: day,
    );

    if (slots.every((s) => !s.available)) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Fully booked this day — try another date.',
          style: AppTextStyles.bodySm,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: 52,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot.dateTime == selected;
        final chip = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.gold : AppColors.border,
            ),
          ),
          child: Text(
            DateFormat('hh:mm a').format(slot.dateTime),
            style: AppTextStyles.labelMd.copyWith(
              color: isSelected ? AppColors.onGold : AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        );

        if (!slot.available) return Opacity(opacity: 0.3, child: chip);

        return GestureDetector(
          onTap: () => onSelect(slot.dateTime),
          child: chip,
        );
      },
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.services,
    required this.enabled,
    required this.submitting,
    required this.isReschedule,
    required this.onContinue,
  });

  final List<Service> services;
  final bool enabled;
  final bool submitting;
  final bool isReschedule;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final names = services.map((s) => s.name).join(' + ');
    final total = Booking.totalPriceOf(services);

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
                    Text(
                      isReschedule ? 'RESCHEDULING' : 'SUMMARY',
                      style: AppTextStyles.labelSm,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      names,
                      style: AppTextStyles.headlineSm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${total.toStringAsFixed(0)}',
                      style: AppTextStyles.headlineSm.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PrimaryButton(
                label: 'CONTINUE',
                icon: Icons.arrow_forward_rounded,
                expanded: false,
                loading: submitting,
                onPressed: enabled ? onContinue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
