import 'package:flutter/foundation.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String tagline;
  final String college;
  final String avatarInitials;
  final int avatarColorIndex;
  final String location;
  final int totalSwaps;
  final int activeRequests;
  final double rating;
  final int reviewCount;
  final List<String> canTeach;
  final List<String> wantsToLearn;
  final String about;
  final List<Experience> experiences;
  final List<String> helpTopics;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.college,
    required this.tagline,
    required this.avatarInitials,
    required this.avatarColorIndex,
    required this.location,
    required this.totalSwaps,
    required this.activeRequests,
    required this.rating,
    required this.reviewCount,
    required this.canTeach,
    required this.wantsToLearn,
    required this.about,
    required this.experiences,
    required this.helpTopics,
  });


  /// Helper methods for parse safety
  static double _parseDouble(dynamic value, double fallback) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  static int _parseInt(dynamic value, int fallback) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  /// Factory to parse JSON directly from Node.js / PostgreSQL response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'SkillSwap Member',
      email: json['email']?.toString() ?? '',
      tagline: json['tagline'] ?? '',
      college: json['college']?.toString() ?? 'Parul University',
      avatarInitials: json['avatarInitials']?.toString() ?? 'SS',
      activeRequests: json['activeRequests'] ?? 0,


      avatarColorIndex: _parseInt(json['avatarColorIndex'], 0),
      totalSwaps: _parseInt(json['totalSwaps'], 0),
      reviewCount: _parseInt(json['reviewCount'] ?? json['review_couont'], 0), // Keeps compatibility with SQL typo
      rating: _parseDouble(json['rating'], 5.0),

      location: json['location']?.toString() ?? 'Vadodara, India',
      canTeach: json['offers'] != null ? [json['offers'].toString()] : [],
      wantsToLearn: json['wants'] != null ? [json['wants'].toString()] : [],
      about: json['bio']?.toString() ?? 'No bio provided yet.',

      // Safe list parsing
      experiences: json['experiences'] is List
          ? (json['experiences'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => Experience.fromJson(e))
          .toList()
          : const [],
      helpTopics: json['offers'] != null
          ? [json['offers'].toString(), 'Peer Mentorship']
          : const ['Peer Mentorship'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'college': college,
      'avatarInitials': avatarInitials,
      'avatarColorIndex': avatarColorIndex,
      'location': location,
      'totalSwaps': totalSwaps,
      'rating': rating,
      'reviewCount': reviewCount,
      'canTeach': canTeach,
      'wantsToLearn': wantsToLearn,
      'about': about,
      'helpTopics': helpTopics,
    };
  }
}

class Experience {
  final String id;
  final String title;
  final String organization;
  final String duration;
  final ExperienceType type;

  const Experience({
    required this.id,
    required this.title,
    required this.organization,
    required this.duration,
    required this.type,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      organization: json['organization'] ?? '',
      duration: json['duration'] ?? '',
      type: ExperienceType.project, // Default fallback
    );
  }
}

enum ExperienceType { award, certification, project, competition }