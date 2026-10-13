import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import '../../../../data/models/user_profile.dart';

// ── Avatar palette ────────────────────────────────────────────────────────────
const _avatarBg = [
  Color(0xFFDBEAFE), Color(0xFFD1FAE5), Color(0xFFFEF9C3),
  Color(0xFFFFE4E6), Color(0xFFEDE9FE),
];
const _avatarFg = [
  Color(0xFF1D4ED8), Color(0xFF065F46), Color(0xFF92400E),
  Color(0xFF9F1239), Color(0xFF4C1D95),
];

// ─────────────────────────────────────────────────────────────────────────────
// MyProfileHeader — banner with gradient, overlapping avatar, name, tagline
// ─────────────────────────────────────────────────────────────────────────────

class MyProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditTap;

  const MyProfileHeader({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final ci = profile.avatarColorIndex % _avatarBg.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [

        // ── Blue banner ───────────────────────────────────────────────────
        Container(
          height: 110,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // ── Edit button (top-right of banner) ─────────────────────────────
        Positioned(
          top: 14,
          right: 16,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.35)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_outlined, size: 13, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Content below banner ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: 68),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar overlapping the banner
                CircleAvatar(
                  radius: 40,
                  backgroundColor: _avatarBg[ci],
                  child: Text(
                    profile.avatarInitials,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: _avatarFg[ci],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),

                // College
                Text(
                  profile.college,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                Text(
                  profile.tagline,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppTheme.textPrimary,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Location row
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      profile.location,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// StatsRow — Sessions · Active Requests · Rating
// ─────────────────────────────────────────────────────────────────────────────

class MyProfileStatsRow extends StatelessWidget {
  final int sessionsCompleted;
  final int activeRequests;
  final double rating;

  const MyProfileStatsRow({
    super.key,
    required this.sessionsCompleted,
    required this.activeRequests,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            _StatCell(value: '$sessionsCompleted', label: 'Sessions'),
            _VerticalDivider(),
            _StatCell(value: '$activeRequests', label: 'Requests'),
            _VerticalDivider(),
            _StatCell(
              value: '$rating',
              label: 'Rating',
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFF59E0B),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const _StatCell({
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
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 3),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
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
              fontSize: 11.5,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 34, color: AppTheme.border);
}

// ─────────────────────────────────────────────────────────────────────────────
// SkillsSection — Offer chips (blue) + Want chips (green)
// ─────────────────────────────────────────────────────────────────────────────

class MyProfileSkillsSection extends StatelessWidget {
  final List<String> skillsOffer;
  final List<String> skillsWant;

  const MyProfileSkillsSection({
    super.key,
    required this.skillsOffer,
    required this.skillsWant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkillGroup(
            icon: Icons.emoji_objects_outlined,
            label: 'Skills I Offer',
            skills: skillsOffer,
            chipBg: AppTheme.primaryLight,
            chipFg: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          _SkillGroup(
            icon: Icons.school_outlined,
            label: 'Skills I Want',
            skills: skillsWant,
            chipBg: const Color(0xFFF0FDF4),
            chipFg: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }
}

class _SkillGroup extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> skills;
  final Color chipBg;
  final Color chipFg;

  const _SkillGroup({
    required this.icon,
    required this.label,
    required this.skills,
    required this.chipBg,
    required this.chipFg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: chipFg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: chipFg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (s) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                s,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: chipFg,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}