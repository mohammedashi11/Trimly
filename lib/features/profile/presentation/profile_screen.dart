import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../auth/presentation/providers/auth_providers.dart';

/// Account hub: avatar, grouped settings and sign-out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _logOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text("You'll need to sign in again to book."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TRIMLY',
          style: AppTextStyles.headlineSm.copyWith(
            color: AppColors.gold,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Stack(
              children: [
                InitialsAvatar(
                  initials: user?.initials ?? 'T',
                  size: 128,
                  ringColor: AppColors.gold,
                  ringWidth: 3,
                ),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.editProfile),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 20,
                        color: AppColors.onGold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            user?.name ?? 'Guest',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMd.copyWith(color: AppColors.gold),
          ),
          const SizedBox(height: 4),
          Text(
            user == null || user.phone.isEmpty ? user?.email ?? '' : user.phone,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ACCOUNT SETTINGS',
                      style: AppTextStyles.labelSm,
                    ),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
                const Divider(indent: 20, endIndent: 20),
                _SettingsRow(
                  icon: Icons.credit_card_outlined,
                  label: 'Payment Methods',
                  onTap: () => _notify(
                    context,
                    'Payments are settled at the venue for now.',
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                _SettingsRow(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () => _notify(
                    context,
                    'Booking reminders are switched on.',
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                _SettingsRow(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  trailing: Text(
                    'English',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  onTap: () => _notify(
                    context,
                    'More languages are on the way.',
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                _SettingsRow(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  trailing: Switch(
                    value: true,
                    onChanged: (_) => _notify(
                      context,
                      'Trimly is tailored for the dark.',
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.help_outline_rounded,
                  label: 'Help',
                  onTap: () => _notify(
                    context,
                    'Reach us any time at support@trimly.app.',
                  ),
                ),
                const Divider(indent: 20, endIndent: 20),
                _SettingsRow(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  color: AppColors.error,
                  showChevron: false,
                  onTap: () => _logOut(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            'T R I M L Y   P R E C I S I O N',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.borderMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.color = AppColors.textPrimary,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color color;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: color == AppColors.textPrimary ? AppColors.gold : color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLg.copyWith(color: color),
              ),
            ),
            trailing ??
                (showChevron
                    ? const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
