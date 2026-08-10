import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../logic/providers/settings/settings_provider.dart';
import '../../../logic/providers/auth/auth_provider.dart';
import '../../../shared/widgets/fw_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Settings', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SectionHeader('APPEARANCE'),
          _ToggleSetting(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            value: isDark,
            onChanged: (v) => ref.read(settingsControllerProvider.notifier).setDarkMode(v),
          ),

          const SizedBox(height: 16),
          _SectionHeader('LANGUAGE'),
          _OptionSetting(
            icon: Icons.language_outlined,
            label: 'App Language',
            value: locale == 'ne' ? 'नेपाली' : 'English',
            onTap: () => _showLanguagePicker(context, ref),
          ),

          const SizedBox(height: 16),
          _SectionHeader('NOTIFICATIONS'),
          _ToggleSetting(
            icon: Icons.notifications_outlined,
            label: 'Push Notifications',
            value: true,
            onChanged: (_) {},
          ),
          _ToggleSetting(
            icon: Icons.emoji_events_outlined,
            label: 'Achievement Alerts',
            value: true,
            onChanged: (_) {},
          ),

          const SizedBox(height: 16),
          _SectionHeader('ACCESSIBILITY'),
          _OptionSetting(
            icon: Icons.text_fields_outlined,
            label: 'Text Size',
            value: 'Normal',
            onTap: () {},
          ),
          _ToggleSetting(
            icon: Icons.animation_outlined,
            label: 'Reduce Animations',
            value: false,
            onChanged: (_) {},
          ),
          _ToggleSetting(
            icon: Icons.contrast,
            label: 'High Contrast',
            value: false,
            onChanged: (_) {},
          ),

          const SizedBox(height: 16),
          _SectionHeader('ACCOUNT'),
          _LinkSetting(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
          _LinkSetting(icon: Icons.description_outlined, label: 'Terms of Service', onTap: () {}),
          _LinkSetting(icon: Icons.info_outline, label: 'About FeedWise', onTap: () {}),

          const SizedBox(height: 16),
          FWCard(
            onTap: () => ref.read(authControllerProvider.notifier).signOut()
                .then((_) => context.go('/login')),
            child: Row(
              children: [
                const Icon(Icons.logout, color: AppColors.evidenceMissing, size: 20),
                const SizedBox(width: 12),
                Text('Sign Out', style: AppTypography.titleSmall.copyWith(color: AppColors.evidenceMissing)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Language', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('English'),
              onTap: () { ref.read(localeProvider.notifier).state = 'en'; Navigator.pop(context); },
            ),
            ListTile(
              title: const Text('नेपाली (Nepali)'),
              onTap: () { ref.read(localeProvider.notifier).state = 'ne'; Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleSetting({required this.icon, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FWCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondaryDark),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark))),
            Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary500),
          ],
        ),
      ),
    );
  }
}

class _OptionSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _OptionSetting({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FWCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondaryDark),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark))),
            Text(value, style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiaryDark),
          ],
        ),
      ),
    );
  }
}

class _LinkSetting extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LinkSetting({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FWCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondaryDark),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark))),
            const Icon(Icons.open_in_new, size: 14, color: AppColors.textTertiaryDark),
          ],
        ),
      ),
    );
  }
}
