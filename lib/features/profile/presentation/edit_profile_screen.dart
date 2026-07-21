import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../auth/presentation/widgets/auth_text_field.dart';

/// Edits the persisted profile (name, email, phone).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).valueOrNull;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Please enter your name.';
    if (name.length < 2) return 'Names are at least 2 characters long.';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;

    final success =
        await ref.read(authControllerProvider.notifier).updateProfile(
              user.copyWith(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _phoneController.text.trim(),
              ),
            );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: InitialsAvatar(
                    initials: user?.initials ?? 'T',
                    size: 96,
                    ringColor: AppColors.gold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your initials follow your name.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSm,
                ),
                const SizedBox(height: AppSpacing.xl),
                AuthTextField(
                  label: 'Full name',
                  controller: _nameController,
                  suffixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthTextField(
                  label: 'Email address',
                  controller: _emailController,
                  suffixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                ),
                const SizedBox(height: AppSpacing.lg),
                AuthTextField(
                  label: 'Phone',
                  controller: _phoneController,
                  hint: '+1 (555) 000-1234',
                  suffixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'SAVE CHANGES',
                  loading: authState.isLoading,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
