import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/trimly_logo.dart';
import 'login_screen.dart';
import 'providers/auth_providers.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/google_glyph.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Please tell us your name.';
    if (name.length < 2) return 'Names are at least 2 characters long.';
    return null;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authControllerProvider.notifier).signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) context.go(AppRoutes.home);
  }

  Future<void> _signInWithGoogle() async {
    final success =
        await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (success && mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
              vertical: AppSpacing.lg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: TrimlyLogo(size: 64)),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Create account',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineLg,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Join the lounge — your chair is waiting',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AuthTextField(
                    label: 'Full name',
                    controller: _nameController,
                    hint: 'Jameson Reed',
                    suffixIcon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AuthTextField(
                    label: 'Email address',
                    controller: _emailController,
                    hint: 'jameson@example.com',
                    suffixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AuthTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: validatePassword,
                    onToggleObscure: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: 'CREATE ACCOUNT',
                    loading: isLoading,
                    onPressed: _signUp,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GhostButton(
                    label: 'Continue with Google',
                    leading: const GoogleGlyph(),
                    onPressed: isLoading ? null : _signInWithGoogle,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'Sign in',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
