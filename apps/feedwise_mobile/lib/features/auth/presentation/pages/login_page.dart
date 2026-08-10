import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/logic/providers/auth/auth_provider.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signInWithEmail(
          _emailCtrl.text.trim(),
          _passCtrl.text,
        );
    final state = ref.read(authControllerProvider);
    if (state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${state.error}')),
      );
    } else if (!state.hasError && mounted) {
      context.go('/home');
    }
  }

  void _demoLogin() {
    ref.read(authControllerProvider.notifier).signInDemo();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: Text('FW', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800))),
                  ),
                ),

                const SizedBox(height: 32),

                Text('Welcome back', style: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 4),
                Text('Sign in to continue your MIL journey', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),

                const SizedBox(height: 32),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot password?', style: AppTypography.labelMedium.copyWith(color: AppColors.primary500)),
                  ),
                ),

                const SizedBox(height: 16),

                FWButton(label: 'Sign In', isFullWidth: true, isLoading: isLoading, onPressed: isLoading ? null : _submit),

                const SizedBox(height: 16),

                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                  ),
                  const Expanded(child: Divider()),
                ]),

                const SizedBox(height: 16),

                FWButton(
                  label: 'Continue as Demo User',
                  variant: FWButtonVariant.outline,
                  isFullWidth: true,
                  icon: Icons.play_arrow_outlined,
                  onPressed: _demoLogin,
                ),

                const SizedBox(height: 24),

                Center(
                  child: TextButton(
                    onPressed: () => context.go('/register'),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.primary500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
