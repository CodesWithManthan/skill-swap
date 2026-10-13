import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
class ProfileActionBar extends StatelessWidget {
  final VoidCallback? onBookSession;
  final VoidCallback? onRequestSwap;
  final VoidCallback? onQuickSession;

  final bool bookSessionSent;
  final bool requestSwapSent;
  final bool quickSessionSent;

  const ProfileActionBar({
    super.key,
    required this.onBookSession,
    required this.onRequestSwap,
    required this.onQuickSession,
    this.bookSessionSent = false,
    this.requestSwapSent = false,
    this.quickSessionSent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        // Respect system bottom padding (home bar on iOS, nav bar on Android)
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Secondary row: Request Swap + Quick Session ─────────────────
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: requestSwapSent ? 'Requested ✓' : 'Request Swap',
                  icon: Icons.swap_horiz_rounded,
                  onPressed: onRequestSwap,
                  isSent: requestSwapSent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SecondaryButton(
                  label: quickSessionSent ? 'Requested ✓' : '⚡ Quick Session',
                  icon: null,
                  onPressed: onQuickSession,
                  isSent: quickSessionSent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Primary CTA: Book Session ────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onBookSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: bookSessionSent ? AppTheme.border : null, // null = default theme color
                foregroundColor: bookSessionSent ? AppTheme.textSecondary : null,
              ),
              child: Text(bookSessionSent ? 'Booked ✓' : 'Book Session'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Outlined secondary button — shared style for Swap and Quick Session.
class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isSent;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isSent = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isSent ? AppTheme.border : AppTheme.primary),
          foregroundColor: isSent ? AppTheme.textSecondary : AppTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 5),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}