import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Feature flags
  bool _aiGenerationEnabled  = true;
  bool _communitySubmissions = true;
  bool _multiLanguage        = true;
  bool _leaderboard          = false;
  bool _parentalControls     = true;

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Settings',
      actions: [
        FWButton(label: 'Save Changes', icon: Icons.save_outlined, onPressed: _save, size: FWButtonSize.small),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─ AI Config
              _SettingsSection(
                title: 'AI Configuration',
                icon: Icons.auto_awesome,
                iconColor: AppColors.primary400,
                children: [
                  _SettingRow(
                    label: 'AI Model',
                    description: 'Select the AI model for scenario generation',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevatedDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: DropdownButton<String>(
                        value: 'gemini-1.5-pro',
                        underline: const SizedBox(),
                        dropdownColor: AppColors.surfaceElevatedDark,
                        style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
                        items: ['gemini-1.5-pro', 'gemini-1.5-flash', 'gemini-2.0'].map((m) =>
                          DropdownMenuItem(value: m, child: Text(m))
                        ).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  _SettingRow(
                    label: 'AI Scenario Generation',
                    description: 'Allow AI to suggest new scenarios automatically',
                    child: _Toggle(value: _aiGenerationEnabled, onChanged: (v) => setState(() => _aiGenerationEnabled = v)),
                  ),
                  _SettingRow(
                    label: 'Temperature',
                    description: 'AI creativity level (0.0 = strict, 1.0 = creative)',
                    child: SizedBox(
                      width: 200,
                      child: Slider(
                        value: 0.7,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: AppColors.primary500,
                        inactiveColor: AppColors.borderDark,
                        label: '0.7',
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ─ Feature Flags
              _SettingsSection(
                title: 'Feature Flags',
                icon: Icons.flag_outlined,
                iconColor: AppColors.tertiary400,
                children: [
                  _SettingRow(
                    label: 'Community Submissions',
                    description: 'Allow users to submit their own scenarios for review',
                    child: _Toggle(value: _communitySubmissions, onChanged: (v) => setState(() => _communitySubmissions = v)),
                  ),
                  _SettingRow(
                    label: 'Multi-Language Support',
                    description: 'Enable content in multiple languages (Nepali, Hindi, etc.)',
                    child: _Toggle(value: _multiLanguage, onChanged: (v) => setState(() => _multiLanguage = v)),
                  ),
                  _SettingRow(
                    label: 'Leaderboard',
                    description: 'Show competitive rankings between users',
                    child: _Toggle(value: _leaderboard, onChanged: (v) => setState(() => _leaderboard = v)),
                  ),
                  _SettingRow(
                    label: 'Parental Controls',
                    description: 'Filter mature content for younger users',
                    child: _Toggle(value: _parentalControls, onChanged: (v) => setState(() => _parentalControls = v)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ─ Language Management
              _SettingsSection(
                title: 'Language Management',
                icon: Icons.language,
                iconColor: AppColors.warning,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _LangCard(code: 'en', name: 'English',  active: true),
                        _LangCard(code: 'ne', name: 'Nepali',   active: true),
                        _LangCard(code: 'hi', name: 'Hindi',    active: false),
                        _LangCard(code: 'bn', name: 'Bengali',  active: false),
                        _LangCard(code: 'ur', name: 'Urdu',     active: false),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ─ Platform Info
              _SettingsSection(
                title: 'Platform Information',
                icon: Icons.info_outline,
                iconColor: AppColors.info,
                children: [
                  _InfoRow(label: 'Version',     value: '1.0.0'),
                  _InfoRow(label: 'Build',       value: '2026.08.11'),
                  _InfoRow(label: 'Environment', value: 'Production'),
                  _InfoRow(label: 'Region',      value: 'Asia-South (Mumbai)'),
                ],
              ),

              const SizedBox(height: 20),

              // Danger zone
              FWCard(
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_rounded, color: AppColors.error, size: 20),
                        const SizedBox(width: 10),
                        Text('Danger Zone', style: AppTypography.titleLarge(AppColors.error)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SettingRow(
                      label: 'Clear All Cache',
                      description: 'This will remove all cached data and force re-fetch from the server.',
                      child: FWButton(label: 'Clear Cache', variant: FWButtonVariant.danger, onPressed: () {}, size: FWButtonSize.small),
                    ),
                    _SettingRow(
                      label: 'Reset Platform Settings',
                      description: 'Reset all settings to their default values. This cannot be undone.',
                      child: FWButton(label: 'Reset', variant: FWButtonVariant.danger, onPressed: () {}, size: FWButtonSize.small),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Settings saved successfully'),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.icon, required this.iconColor, required this.children});

  @override
  Widget build(BuildContext context) => FWCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Text(title, style: AppTypography.titleLarge(AppColors.textPrimaryDark)),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.borderDark, height: 1),
        const SizedBox(height: 8),
        ...children,
      ],
    ),
  );
}

class _SettingRow extends StatelessWidget {
  final String label, description;
  final Widget child;
  const _SettingRow({required this.label, required this.description, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.titleSmall(AppColors.textPrimaryDark)),
              const SizedBox(height: 2),
              Text(description, style: AppTypography.bodySmall(AppColors.textTertiaryDark)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        child,
      ],
    ),
  );
}

class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Switch(
    value: value,
    onChanged: onChanged,
    activeColor: AppColors.primary500,
    trackColor: WidgetStatePropertyAll(value ? AppColors.primary500.withOpacity(0.3) : AppColors.borderDark),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: AppTypography.labelMedium(AppColors.textTertiaryDark))),
        Text(value, style: AppTypography.bodyMedium(AppColors.textPrimaryDark)),
      ],
    ),
  );
}

class _LangCard extends StatefulWidget {
  final String code, name;
  final bool active;
  const _LangCard({required this.code, required this.name, required this.active});

  @override
  State<_LangCard> createState() => _LangCardState();
}

class _LangCardState extends State<_LangCard> {
  late bool _active;

  @override
  void initState() {
    super.initState();
    _active = widget.active;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _active = !_active),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _active ? AppColors.primary500.withOpacity(0.1) : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _active ? AppColors.primary500.withOpacity(0.4) : AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceCardDark,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(widget.code.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondaryDark)),
          ),
          const SizedBox(width: 8),
          Text(widget.name, style: TextStyle(color: _active ? AppColors.primary400 : AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Icon(_active ? Icons.check_circle : Icons.circle_outlined, size: 14, color: _active ? AppColors.primary400 : AppColors.textTertiaryDark),
        ],
      ),
    ),
  );
}
