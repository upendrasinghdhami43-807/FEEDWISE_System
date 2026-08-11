import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/user_model.dart';
import '../../shared/widgets/fw_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController(text: 'admin@feedwise.app');
  final _passCtrl  = TextEditingController(text: 'password123');
  bool _obscure = true;
  String? _error;
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _error = null);
    final success = await ref.read(authProvider.notifier).login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
    if (success && mounted) {
      final role = ref.read(currentUserProvider)?.role;
      if (role == UserRole.admin || role == UserRole.moderator) {
        context.go('/dashboard');
      } else {
        context.go('/teacher');
      }
    } else if (mounted) {
      setState(() => _error = ref.read(authProvider).error);
    }
  }

  void _quickLogin(bool isAdmin) {
    if (isAdmin) {
      ref.read(authProvider.notifier).loginAsAdmin();
      context.go('/dashboard');
    } else {
      ref.read(authProvider.notifier).loginAsTeacher();
      context.go('/teacher');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    final rightPanel = Container(
      width: isWide ? 440 : double.infinity,
      color: AppColors.surfaceCardDark,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isWide) ...[
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: AppColors.heroGradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text('FEEDWISE', style: AppTypography.wordmark(AppColors.textPrimaryDark)),
                  ],
                ),
                const SizedBox(height: 32),
              ],

              Text('Welcome back', style: AppTypography.headlineLarge(AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              Text('Sign in to FeedWise Studio', style: AppTypography.bodyMedium(AppColors.textSecondaryDark)),
              const SizedBox(height: 36),

              // Email
              const _FormLabel('Email address'),
              const SizedBox(height: 6),
              _StyledInput(
                controller: _emailCtrl,
                hint: 'you@feedwise.app',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),

              // Password
              const _FormLabel('Password'),
              const SizedBox(height: 6),
              _StyledInput(
                controller: _passCtrl,
                hint: '••••••••',
                icon: Icons.lock_outline,
                obscure: _obscure,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 20, color: AppColors.textTertiaryDark,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: AppTypography.labelMedium(AppColors.primary400),
                ),
              ),
              const SizedBox(height: 24),

              // Error
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 16),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_error!, style: AppTypography.bodySmall(AppColors.error))),
                    ],
                  ),
                ),

              // Login button
              FWButton(
                label: 'Sign In',
                onPressed: _login,
                isLoading: isLoading,
                isFullWidth: true,
                variant: FWButtonVariant.primary,
                size: FWButtonSize.large,
              ),
              const SizedBox(height: 24),

              // Divider
              Row(children: [
                const Expanded(child: Divider(color: AppColors.borderDark)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Quick Access (Demo)', style: AppTypography.labelSmall(AppColors.textTertiaryDark)),
                ),
                const Expanded(child: Divider(color: AppColors.borderDark)),
              ]),
              const SizedBox(height: 20),

              // Quick login buttons
              Row(
                children: [
                  Expanded(
                    child: _QuickLoginBtn(
                      label: 'Admin Demo',
                      icon: Icons.admin_panel_settings,
                      color: AppColors.primary500,
                      onTap: () => _quickLogin(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickLoginBtn(
                      label: 'Teacher Demo',
                      icon: Icons.school,
                      color: AppColors.tertiary500,
                      onTap: () => _quickLogin(false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Center(
                child: Text(
                  'FeedWise Studio v1.0 · © 2026 FeedWise',
                  style: AppTypography.labelSmall(AppColors.textTertiaryDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: isWide
          ? Row(
              children: [
                // ─ Left panel (hero) — only on wide screens
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A0F3C), Color(0xFF0F1117)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        ...List.generate(6, (i) => Positioned(
                          top: (i * 120.0) % size.height,
                          left: (i * 180.0) % (size.width * 0.5),
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primary500.withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        )),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: AppColors.heroGradientColors,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('FEEDWISE', style: AppTypography.wordmark(Colors.white)),
                                      Text('Studio', style: AppTypography.labelMedium(AppColors.primary400)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 64),
                              // Headline
                              Text(
                                'Manage the future\nof media literacy.',
                                style: AppTypography.displayMedium(Colors.white),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'The professional portal for admins and teachers to create content, monitor student progress, and analyze learning outcomes.',
                                style: AppTypography.bodyLarge(AppColors.textSecondaryDark),
                              ),
                              const SizedBox(height: 48),
                              // Feature chips
                              const Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _FeatureChip(icon: Icons.article_outlined, label: 'Scenario CMS'),
                                  _FeatureChip(icon: Icons.people_outline, label: 'Class Management'),
                                  _FeatureChip(icon: Icons.bar_chart, label: 'Analytics'),
                                  _FeatureChip(icon: Icons.shield_outlined, label: 'Moderation'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                rightPanel,
              ],
            )
          : rightPanel,
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textSecondaryDark,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  );
}

class _StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;

  const _StyledInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textTertiaryDark),
        prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiaryDark),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.primary500.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primary500.withValues(alpha: 0.25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary400),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.primary400, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

class _QuickLoginBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickLoginBtn({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}
