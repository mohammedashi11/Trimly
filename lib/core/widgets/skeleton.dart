import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shimmering tonal block used while content loads.
///
/// Pulses between two surface tones instead of using a spinner, keeping
/// loading states inside the design language.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 12,
    this.shape = BoxShape.rectangle,
  });

  const Skeleton.circle({super.key, required double size})
      : width = size,
        height = size,
        radius = 0,
        shape = BoxShape.circle;

  final double width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<Color?> _color = ColorTween(
    begin: AppColors.surfaceLow,
    end: AppColors.surfaceHighest,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _color.value,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.circle
              ? null
              : BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Skeleton placeholder shaped like a [ShopCard].
class ShopCardSkeleton extends StatelessWidget {
  const ShopCardSkeleton({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Skeleton(height: 150, radius: 0),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(width: 160, height: 20),
                SizedBox(height: 10),
                Skeleton(width: 120, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton placeholder shaped like a list tile with a leading avatar.
class TileSkeleton extends StatelessWidget {
  const TileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Skeleton.circle(size: 56),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Skeleton(width: 140, height: 16),
                SizedBox(height: 8),
                Skeleton(width: 100, height: 12),
              ],
            ),
          ),
          const Skeleton(width: 72, height: 40, radius: 12),
        ],
      ),
    );
  }
}
