import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../domain/entities/review.dart';

/// A customer review card with avatar, stars and comment.
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InitialsAvatar(initials: review.authorInitials, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.author, style: AppTextStyles.titleMd),
                    const SizedBox(height: 2),
                    RatingStars(rating: review.rating, size: 14),
                  ],
                ),
              ),
              Text(
                DateFormat.MMMd().format(review.date),
                style: AppTextStyles.labelSm,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.text,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
