import 'package:flutter/cupertino.dart';

enum SkillStatus { active, quickSession, busy }

class SkillListing {
  final String id;
  final String ownerId;
  final String userName;
  final String college;
  final String avatarInitials;
  final int avatarColorIndex;
  final String offers;           // maps to backend 'title'
  final String wants;            // maps to backend 'wants_text'
  final String description;
  final SkillStatus status;
  final String category;

  const SkillListing({
    required this.id,
    required this.ownerId,
    required this.userName,
    required this.college,
    required this.avatarInitials,
    required this.avatarColorIndex,
    required this.offers,
    required this.wants,
    required this.description,
    required this.status,
    required this.category,
  });

  // 🚀 THE NEW BRIDGE CONSTRUCTOR: Maps Node.js/PostgreSQL JSON directly into your UI structure
  factory SkillListing.fromJson(Map<String, dynamic> json) {
    final String rawName = json['userName'] ?? json['user_name'] ?? json['name'] ?? 'Member';

    // Generate initials dynamically from whatever name comes from the database
    final String initials = rawName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return SkillListing(
      // 1. Database IDs are often ints, stringify it securely to match your UI 'id' type
      id: json['id']?.toString() ?? UniqueKey().toString(),
      ownerId: json['ownerId']?.toString() ?? '', //

      // 2. Map database fields directly into your existing UI variable parameters
      userName: rawName,
      college: json['college'] as String? ?? 'Parul University',

      // 3. Compute structural UI data dynamically from database fields
      avatarInitials: initials.isEmpty ? 'U' : initials,
      avatarColorIndex: (int.tryParse(json['id']?.toString() ?? '') ?? 0) % 5, // Pure math logic to keep avatars colorful but consistent per post!

      // 4. Align backend domain language to UI naming paradigms
      offers: json['title'] as String? ?? 'Untitled Offer',
      wants: json['wantsText'] as String? ?? json['wants_text'] as String? ?? 'Open Discussion',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',

      // 5. Default status flag until real-time availability features are implemented
      status: SkillStatus.active,
    );
  }
}