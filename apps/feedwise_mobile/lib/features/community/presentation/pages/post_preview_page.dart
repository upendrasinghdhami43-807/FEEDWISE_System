import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';

class PostPreviewPage extends StatelessWidget {
  const PostPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Post Preview', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.evidenceUncertain.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.evidenceUncertain.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.evidenceUncertain),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('This is how your post will look to others after it is reviewed and approved.', 
                      style: AppTypography.bodySmall.copyWith(color: AppColors.evidenceUncertain)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Mock Post Card
            FWCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary500,
                          child: Text('U', style: AppTypography.titleMedium.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Student User', style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
                              Text('Submitted 2 mins ago • Science', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_vert, color: AppColors.textSecondaryDark),
                      ],
                    ),
                  ),
                  
                  // Note/Claim
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'I found this claim on Facebook saying that a new study proves eating chocolate every day cures colds. Is this actually true? It seems suspicious.',
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Source Link Box
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevatedDark,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: AppColors.primary400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Source Platform: Facebook', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                              Text('Account: HealthNewsDaily', style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.borderDark, height: 1),
                  
                  // Action Bar (Like, Comment, Save)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(Icons.favorite_border, 'Like'),
                        _buildActionButton(Icons.chat_bubble_outline, 'Comment'),
                        _buildActionButton(Icons.bookmark_border, 'Save'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: FWButton(
                label: 'Submit for Review',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post submitted for review!')),
                  );
                  context.pop(); // Pop preview
                  context.pop(); // Pop create form
                },
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondaryDark, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondaryDark)),
          ],
        ),
      ),
    );
  }
}
