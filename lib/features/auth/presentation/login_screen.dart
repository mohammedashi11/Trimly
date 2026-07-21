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
import 'providers/auth_providers.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/google_glyph.dart';

/// Email validation shared by the auth forms.
final _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Please enter your email address.';
  if (!_emailPattern.hasMatch(email)) {
    return "That email doesn't look right — mind checking it?";
  }
  return null;
}

String? validatePassword(String? value) {
  final password = value ?? '';
  if (password.isEmpty) return 'Please enter your password.';
  if (password.length < 6) {
    return 'Passwords are at least 6 characters long.';
  }
  return null;
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authControllerProvider.notifier).signIn(
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

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("We've sent a reset link to your email."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
              vertical: AppSpacing.xl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: TrimlyLogo(size: 72)),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineLg,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sign in to your exclusive grooming lounge',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                    trailing: GestureDetector(
                      onTap: _forgotPassword,
                      child: Text(
                        'Forgot?',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: 'SIGN IN',
                    loading: isLoading,
                    onPressed: _signIn,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _OrDivider(),
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
                        "Don't have an account? ",
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.signup),
                        child: Text(
                          'Create account',
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

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('OR', style: AppTextStyles.labelSm),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
