import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../logic/providers/auth/auth_provider.dart';
import '../../../shared/widgets/fw_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _ageGroup;
  String _locale = 'en';
  bool _obscurePass = true;

  static const _ageGroups = [
    ('16–18', 'age16to18'),
    ('19–21', 'age19to21'),
    ('22–24', 'age22to24'),
    ('25+', 'age25plus'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signUpWithEmail(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          name: _nameCtrl.text.trim(),
          ageGroup: _ageGroup,
        );
    final state = ref.read(authControllerProvider);
    if (state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${state.error}')),
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
                const SizedBox(height: 24),

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

                const SizedBox(height: 24),

                Text('Create your account', style: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 4),
                Text('Start your MIL learning journey', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),

                const SizedBox(height: 28),

                // Full Name
                TextFormField(
                  controller: _nameCtrl,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline, size: 20)),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),

                const SizedBox(height: 14),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, size: 20)),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

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
                    if (v.length < 8) return 'Password must be at least 8 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Age Group
                DropdownButtonFormField<String>(
                  value: _ageGroup,
                  decoration: const InputDecoration(labelText: 'Age Group', prefixIcon: Icon(Icons.cake_outlined, size: 20)),
                  dropdownColor: AppColors.surfaceElevatedDark,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
                  items: _ageGroups.map((g) => DropdownMenuItem(value: g.$2, child: Text(g.$1))).toList(),
                  onChanged: (v) => setState(() => _ageGroup = v),
                ),

                const SizedBox(height: 14),

                // Language
                Row(
                  children: [
                    Text('Language:', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
                    const SizedBox(width: 12),
                    _LangChip(label: 'English', value: 'en', selected: _locale == 'en', onTap: () => setState(() => _locale = 'en')),
                    const SizedBox(width: 8),
                    _LangChip(label: 'नेपाली', value: 'ne', selected: _locale == 'ne', onTap: () => setState(() => _locale = 'ne')),
                  ],
                ),

                const SizedBox(height: 24),

                FWButton(label: 'Create Account', isFullWidth: true, isLoading: isLoading, onPressed: isLoading ? null : _submit),

                const SizedBox(height: 16),

                FWButton(
                  label: 'Try as Demo User',
                  variant: FWButtonVariant.outline,
                  isFullWidth: true,
                  icon: Icons.play_arrow_outlined,
                  onPressed: _demoLogin,
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                        children: [
                          TextSpan(text: 'Sign In', style: AppTypography.labelLarge.copyWith(color: AppColors.primary500)),
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

class _LangChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  const _LangChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary500.withOpacity(0.15) : Colors.transparent,
          border: Border.all(color: selected ? AppColors.primary500 : AppColors.borderDark, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(label, style: AppTypography.labelMedium.copyWith(
          color: selected ? AppColors.primary500 : AppColors.textSecondaryDark,
        )),
      ),
    );
  }
}
