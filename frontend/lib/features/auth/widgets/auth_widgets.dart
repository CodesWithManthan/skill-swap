import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// /// App logo widget used in auth screens
// class AppLogo extends StatelessWidget {
//   const AppLogo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             color: const Color(0xFF1A1A2E),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'SkillSwap',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
//
// /// Google sign-in button (UI only for now)
// class GoogleButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onPressed;
//
//   const GoogleButton({
//     super.key,
//     required this.label,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       onPressed: onPressed,
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 50),
//       ),
//       child: Text(label),
//     );
//   }
// }
//
// /// Divider with text (e.g. OR)
// class DividerWithText extends StatelessWidget {
//   final String text;
//
//   const DividerWithText({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Expanded(child: Divider()),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Text(text),
//         ),
//         const Expanded(child: Divider()),
//       ],
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// Shared widgets used by both LoginScreen and SignupScreen
// ─────────────────────────────────────────────────────────────────────────────

/// App logo + name — placed at the top of both auth screens.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
          ),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: AppTheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'SkillSwap',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

/// Outlined Google sign-in / sign-up button.
class GoogleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const GoogleButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: AppTheme.border),
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: const Center(
              child: Text(
                'G',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4285F4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal rule with a centred label, e.g. "OR".
class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.border, thickness: 1)),
      ],
    );
  }
}