import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/ongoing_models.dart';

// ── Avatar palette (consistent with SkillCard & ProfileHeader) ────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// OngoingSectionHeader
// ─────────────────────────────────────────────────────────────────────────────

/// Consistent section title with an optional item count badge.
class OngoingSectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const OngoingSectionHeader({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 8),
          // Count pill — hidden when zero
          if (count > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OngoingCard — base card shell used by all three section cards
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps any card content in consistent shadow, radius, and margin.
class OngoingCard extends StatelessWidget {
  final Widget child;
  const OngoingCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF94A3B8).withOpacity(0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UserRow — avatar + name + subtitle, reused across all cards
// ─────────────────────────────────────────────────────────────────────────────

class UserRow extends StatelessWidget {
  final String name;
  final String avatarInitials;
  final int avatarColorIndex;
  final Widget trailing; // badge, status, or empty

  const UserRow({
    super.key,
    required this.name,
    required this.avatarInitials,
    required this.avatarColorIndex,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final ci = avatarColorIndex % _avatarBg.length;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: _avatarBg[ci],
          child: Text(
            avatarInitials,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _avatarFg[ci],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        trailing,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TypeBadge — Swap / Quick Session / Paid pill
// ─────────────────────────────────────────────────────────────────────────────

class TypeBadge extends StatelessWidget {
  final RequestType type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final config = switch (type) {
      RequestType.swap         => ('Swap', const Color(0xFFEFF6FF), AppTheme.primary),
      RequestType.quickSession => ('Quick', const Color(0xFFFFFBEB), const Color(0xFFD97706)),
      RequestType.paid         => ('Paid', const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: config.$2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.$3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// StatusBadge — Pending / Accepted / Rejected
// ─────────────────────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final RequestStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      RequestStatus.pending  => ('Pending',  const Color(0xFFFFFBEB), const Color(0xFFD97706)),
      RequestStatus.accepted => ('Accepted', const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
      RequestStatus.rejected => ('Rejected', const Color(0xFFFFF1F2), const Color(0xFFE11D48)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: config.$2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: config.$3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SkillRow — icon + skill label
// ─────────────────────────────────────────────────────────────────────────────

class SkillRow extends StatelessWidget {
  final String skill;
  final String? label; // optional prefix like "Wants:" or "Offers:"
  const SkillRow({super.key, required this.skill, this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome_outlined,
            size: 13, color: AppTheme.textSecondary),
        const SizedBox(width: 6),
        if (label != null) ...[
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 12.5,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
        Expanded(
          child: Text(
            skill,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EmptyState — shown when a section list is empty
// ─────────────────────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: AppTheme.border),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Thin divider used inside cards
// ─────────────────────────────────────────────────────────────────────────────
class CardDivider extends StatelessWidget {
  const CardDivider({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Divider(height: 1, color: AppTheme.border),
  );
}