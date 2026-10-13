import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import 'package:skill_swap/data/models/skill_listing_model.dart';

// ── Avatar palette — each user gets one of these tinted circles ─────────────
const _avatarPalette = [
  Color(0xFFDBEAFE), // blue-100
  Color(0xFFD1FAE5), // green-100
  Color(0xFFFEF9C3), // yellow-100
  Color(0xFFFFE4E6), // rose-100
  Color(0xFFEDE9FE), // violet-100
];
const _avatarTextPalette = [
  Color(0xFF1D4ED8), // blue-700
  Color(0xFF065F46), // green-800
  Color(0xFF92400E), // amber-800
  Color(0xFF9F1239), // rose-800
  Color(0xFF4C1D95), // violet-900
];

/// SkillCard — displays one user's swap listing.
/// Kept as a standalone StatelessWidget so it's easy to test and reuse.
class SkillCard extends StatelessWidget {
  final SkillListing listing;
  final VoidCallback onAction; // called when the CTA button is tapped

  const SkillCard({
    super.key,
    required this.listing,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colorIdx = listing.avatarColorIndex % _avatarPalette.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF94A3B8).withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Row 1: Avatar + name/college + status badge ────────────────
            Row(
              children: [
                // Coloured initials avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _avatarPalette[colorIdx],
                  child: Text(
                    listing.avatarInitials,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _avatarTextPalette[colorIdx],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + college
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.userName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        listing.college,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                _StatusBadge(status: listing.status),
              ],
            ),
            const SizedBox(height: 14),

            // ── Row 2: Offers / Wants chips ────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _SkillChip(
                    icon: Icons.emoji_objects_outlined,
                    label: 'Offers',
                    value: listing.offers,
                    bg: AppTheme.primaryLight,
                    fg: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SkillChip(
                    icon: Icons.school_outlined,
                    label: 'Wants',
                    value: listing.wants,
                    bg: const Color(0xFFF0FDF4), // green-50
                    fg: const Color(0xFF16A34A), // green-600
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Row 3: Short description ───────────────────────────────────
            Text(
              listing.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),

            // ── Row 4: Action button ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  // Busy users get a muted grey CTA
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size.zero,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Explore More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets used only inside SkillCard ────────────────────────────────────

/// Coloured pill showing "Offers: X" or "Wants: Y".
class _SkillChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color bg;
  final Color fg;

  const _SkillChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: fg.withOpacity(0.75),
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small status dot + label in the top-right of the card.
class _StatusBadge extends StatelessWidget {
  final SkillStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      SkillStatus.active => (const Color(0xFF22C55E), 'Active'),
      _ => (const Color(0xFFCBD5E1), 'Inactive'),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: config.$1,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          config.$2,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: config.$1,
          ),
        ),
      ],
    );
  }
}