import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SettingsSection — account settings, toggles, and preferences
// ─────────────────────────────────────────────────────────────────────────────

/// All callbacks are UI-only for now. Wire to navigation / API later.
class MyProfileSettingsSection extends StatefulWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  const MyProfileSettingsSection({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
  });

  @override
  State<MyProfileSettingsSection> createState() =>
      _MyProfileSettingsSectionState();
}

class _MyProfileSettingsSectionState extends State<MyProfileSettingsSection> {
  // Toggle states — connect to user preferences later
  bool _notificationsEnabled = true;
  bool _emailDigestEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [

          // ── Account group ─────────────────────────────────────────────────
          _SettingsGroup(
            label: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                label: 'Edit Profile',
                onTap: widget.onEditProfile,
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                label: 'Change Password',
                onTap: widget.onChangePassword,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Notifications group ───────────────────────────────────────────
          _SettingsGroup(
            label: 'Notifications',
            children: [
              _SettingsToggle(
                icon: Icons.notifications_outlined,
                label: 'Push Notifications',
                value: _notificationsEnabled,
                onChanged: (v) =>
                    setState(() => _notificationsEnabled = v),
              ),
              _SettingsDivider(),
              _SettingsToggle(
                icon: Icons.mail_outline_rounded,
                label: 'Weekly Email Digest',
                value: _emailDigestEnabled,
                onChanged: (v) =>
                    setState(() => _emailDigestEnabled = v),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── More group ────────────────────────────────────────────────────
          _SettingsGroup(
            label: 'More',
            children: [
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                onTap: () {},
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                label: 'App Version',
                trailing: const Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                showArrow: false,
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── _SettingsGroup — rounded container with a label ──────────────────────────

class _SettingsGroup extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _SettingsGroup({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

// ── _SettingsTile — tappable row ──────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            trailing ??
                (showArrow
                    ? const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppTheme.textSecondary)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

// ── _SettingsToggle — toggle row ──────────────────────────────────────────────

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Thin divider between settings tiles ───────────────────────────────────────
class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
    height: 1,
    indent: 48,
    color: AppTheme.border,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// LogoutButton — prominent but not aggressive
// ─────────────────────────────────────────────────────────────────────────────

class MyProfileLogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const MyProfileLogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Log out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE11D48),
            side: const BorderSide(color: Color(0xFFFFE4E6), width: 1.5),
            backgroundColor: const Color(0xFFFFF1F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}