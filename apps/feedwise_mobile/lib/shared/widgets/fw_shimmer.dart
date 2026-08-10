import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/theme/theme.dart';

class FWShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const FWShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.sm,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevatedDark,
      highlightColor: AppColors.borderDark,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class FeedCardSkeleton extends StatelessWidget {
  const FeedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCardDark,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderDark),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FWShimmer(width: 36, height: 36, borderRadius: 18),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    FWShimmer(width: 120, height: 12),
                    SizedBox(height: 4),
                    FWShimmer(width: 80, height: 10),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const FWShimmer(width: double.infinity, height: 14),
            const SizedBox(height: 6),
            const FWShimmer(width: 200, height: 14),
            const SizedBox(height: 12),
            const FWShimmer(width: double.infinity, height: 160),
          ],
        ),
      ),
    );
  }
}

class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, __) => const FeedCardSkeleton(),
    );
  }
}
