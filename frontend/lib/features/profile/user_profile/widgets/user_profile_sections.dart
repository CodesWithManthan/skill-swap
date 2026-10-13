import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import 'package:skill_swap/data/models/user_profile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Section header — consistent title style used across all sections
// ─────────────────────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SkillsSection — "Can Teach" chips (blue) + "Wants to Learn" chips (green)
// ─────────────────────────────────────────────────────────────────────────────
class SkillsSection extends StatelessWidget {
  final List<String> canTeach;
  final List<String> wantsToLearn;

  const SkillsSection({
    super.key,
    required this.canTeach,
    required this.wantsToLearn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Can Teach block
          _SkillGroup(
            icon: Icons.emoji_objects_outlined,
            label: 'Can Teach',
            skills: canTeach,
            chipBg: AppTheme.primaryLight,
            chipFg: AppTheme.primary,
          ),
          const SizedBox(height: 14),

          // Wants to Learn block
          _SkillGroup(
            icon: Icons.school_outlined,
            label: 'Wants to Learn',
            skills: wantsToLearn,
            chipBg: const Color(0xFFF0FDF4), // green-50
            chipFg: const Color(0xFF16A34A), // green-600
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
        // Row label with icon
        Row(
          children: [
            Icon(icon, size: 15, color: chipFg),
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

        // Wrap of skill chips
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

// ─────────────────────────────────────────────────────────────────────────────
// AboutSection — plain readable bio text
// ─────────────────────────────────────────────────────────────────────────────
class AboutSection extends StatelessWidget {
  final String about;
  const AboutSection({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Text(
        about,
        style: const TextStyle(
          fontSize: 13.5,
          color: AppTheme.textSecondary,
          height: 1.65,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ExperienceSection — timeline-style list of achievements / certs / projects
// ─────────────────────────────────────────────────────────────────────────────
class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;
  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: experiences
            .map((e) => _ExperienceTile(experience: e))
            .toList(),
      ),
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  final Experience experience;
  const _ExperienceTile({required this.experience});

  @override
  Widget build(BuildContext context) {
    final config = _iconConfig(experience.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Icon badge
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: config.$2, // background tint
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(config.$1, size: 18, color: config.$3),
          ),
          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 1),
                Text(
                  experience.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  experience.organization,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Year badge
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              experience.duration,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns (icon, bgColor, iconColor) for each ExperienceType.
  (IconData, Color, Color) _iconConfig(ExperienceType type) {
    return switch (type) {
      ExperienceType.award =>
      (Icons.emoji_events_outlined, const Color(0xFFFEF9C3), const Color(0xFFB45309)),
      ExperienceType.certification =>
      (Icons.verified_outlined, const Color(0xFFDBEAFE), AppTheme.primary),
      ExperienceType.project =>
      (Icons.folder_outlined, const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      ExperienceType.competition =>
      (Icons.leaderboard_outlined, const Color(0xFFFFE4E6), const Color(0xFF9F1239)),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HelpTopicsSection — "What I can help you with" numbered list
// ─────────────────────────────────────────────────────────────────────────────
class HelpTopicsSection extends StatelessWidget {
  final List<String> topics;
  const HelpTopicsSection({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: topics.asMap().entries.map((entry) {
          final index = entry.key;
          final topic = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Index number circle
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Topic text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}