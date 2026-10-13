import 'package:flutter/material.dart';
import 'package:skill_swap/data/models/user_profile.dart';
import 'package:skill_swap/core/theme/app_theme.dart';

// ── Avatar colour palette (same logic as SkillCard) ──────────────────────────
const _avatarBg = [
  Color(0xFFDBEAFE),
  Color(0xFFD1FAE5),
  Color(0xFFFEF9C3),
  Color(0xFFFFE4E6),
  Color(0xFFEDE9FE),
];
const _avatarFg = [
  Color(0xFF1D4ED8),
  Color(0xFF065F46),
  Color(0xFF92400E),
  Color(0xFF9F1239),
  Color(0xFF4C1D95),
];

/// ProfileHeader — avatar, name, college, location, and three stat counters.
/// Intentionally kept as its own widget so it can be slotted into a
/// SliverAppBar or a regular Column without changes.
class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final ci = profile.avatarColorIndex % _avatarBg.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        children: [

          // ── Avatar + name + location row ─────────────────────────────────
          Row(
            children: [
              // Large avatar circle
              CircleAvatar(
                radius: 34,
                backgroundColor: _avatarBg[ci],
                child: Text(
                  profile.avatarInitials,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _avatarFg[ci],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name, college, location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      profile.college,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Location pill
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppTheme.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          profile.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ── Stats row: swaps · rating · reviews ──────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _StatItem(
                  value: '${profile.totalSwaps}',
                  label: 'Swaps done',
                ),
                _Divider(),
                _StatItem(
                  value: '${profile.rating}',
                  label: 'Rating',
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                ),
                _Divider(),
                _StatItem(
                  value: '${profile.reviewCount}',
                  label: 'Reviews',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const _StatItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: iconColor),
                const SizedBox(width: 3),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Thin vertical divider between stat items
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppTheme.border,
    );
  }
}