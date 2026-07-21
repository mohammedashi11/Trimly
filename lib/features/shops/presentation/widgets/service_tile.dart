import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/service.dart';

/// Selectable service row: name, duration, price and a plus/check toggle.
class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.service,
    required this.selected,
    required this.onToggle,
  });

  final Service service;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onToggle,
      borderColor: selected ? AppColors.gold : AppColors.border,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text('${service.durationMin} min',
                        style: AppTextStyles.bodySm),
                    const SizedBox(width: 12),
                    Text(
                      '\$${service.price.toStringAsFixed(0)}',
                      style: AppTextStyles.headlineSm.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.gold : Colors.transparent,
              border: Border.all(
                color: selected ? AppColors.gold : AppColors.borderMuted,
              ),
            ),
            child: Icon(
              selected ? Icons.check_rounded : Icons.add_rounded,
              size: 22,
              color: selected ? AppColors.onGold : AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}
