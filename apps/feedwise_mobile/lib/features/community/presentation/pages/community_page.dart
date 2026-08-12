import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for "My Posts" list
    final List<Map<String, String>> myPosts = [
      {
        'title': 'Chocolate cures cold?',
        'platform': 'Facebook',
        'status': 'Pending Review',
        'date': 'Oct 12, 2026',
        'topic': 'Health'
      },
      {
        'title': 'New Mars Rover Images Fake?',
        'platform': 'Website',
        'status': 'Approved',
        'date': 'Sep 28, 2026',
        'topic': 'Science'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('My Posts', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('createPost'),
        backgroundColor: AppColors.primary500,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Create Post', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
      ),
      body: myPosts.isEmpty 
        ? _buildEmptyState(context) 
        : _buildPostList(myPosts),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.post_add, size: 64, color: AppColors.textTertiaryDark),
            const SizedBox(height: 16),
            Text('No Posts Yet', style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
            const SizedBox(height: 8),
            Text('You haven\'t submitted any claims for review. Tap "Create Post" to start.', 
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(List<Map<String, String>> posts) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80), // bottom padding for FAB
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final isApproved = post['status'] == 'Approved';
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FWCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isApproved ? AppColors.evidenceSupported.withOpacity(0.1) : AppColors.evidenceUncertain.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        post['status']!,
                        style: AppTypography.labelSmall.copyWith(
                          color: isApproved ? AppColors.evidenceSupported : AppColors.evidenceUncertain,
                        ),
                      ),
                    ),
                    Text(post['date']!, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post['title']!, style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.category, size: 16, color: AppColors.textSecondaryDark),
                    const SizedBox(width: 4),
                    Text(post['topic']!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                    const SizedBox(width: 16),
                    Icon(Icons.link, size: 16, color: AppColors.textSecondaryDark),
                    const SizedBox(width: 4),
                    Text(post['platform']!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
