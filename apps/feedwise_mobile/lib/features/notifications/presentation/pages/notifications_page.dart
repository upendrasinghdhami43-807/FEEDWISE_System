import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Notifications', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Mark all read', style: AppTypography.labelSmall.copyWith(color: AppColors.primary500)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => _NotificationTile(notif: _notifications[i]),
      ),
    );
  }

  static final _notifications = [
    (emoji: '🏅', title: 'Achievement Unlocked!', body: 'You earned the "Source Checker" badge', time: '2h ago', isRead: false),
    (emoji: '🔥', title: 'Streak Reminder', body: 'Don\'t break your 5-day streak! Play today.', time: '5h ago', isRead: false),
    (emoji: '✨', title: 'New Scenario Available', body: 'A new AI deepfake scenario was added', time: '1d ago', isRead: true),
    (emoji: '📊', title: 'Weekly Progress', body: 'Your MIL score improved by 5 points this week!', time: '2d ago', isRead: true),
  ];
}

class _NotificationTile extends StatelessWidget {
  final dynamic notif;
  const _NotificationTile({required this.notif});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(notif.emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(notif.title, style: AppTypography.titleSmall.copyWith(
                      color: notif.isRead ? AppColors.textSecondaryDark : AppColors.textPrimaryDark,
                    ))),
                    if (!notif.isRead)
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary500, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(notif.body, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                const SizedBox(height: 4),
                Text(notif.time, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
