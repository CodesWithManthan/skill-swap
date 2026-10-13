import 'package:flutter/foundation.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum RequestType { swap, quickSession, paid }

enum RequestStatus { pending, accepted, rejected }



// Helper parsing utilities
RequestType _parseType(String? val) {
  switch (val?.toLowerCase()) {
    case 'quick':
    case 'quicksession':
      return RequestType.quickSession;
    case 'paid':
      return RequestType.paid;
    case 'swap':
    default:
      return RequestType.swap;
  }
}

RequestStatus _parseStatus(String? val) {
  switch (val?.toLowerCase()) {
    case 'accepted':
      return RequestStatus.accepted;
    case 'rejected':
      return RequestStatus.rejected;
    case 'pending':
    default:
      return RequestStatus.pending;
  }
}

// ── Models ────────────────────────────────────────────────────────────────────

class SentRequest {
  final String id;
  final String userName;
  final String avatarInitials;
  final int avatarColorIndex;
  final String skill;
  final RequestType type;
  final RequestStatus status;

  const SentRequest({
    required this.id,
    required this.userName,
    required this.avatarInitials,
    required this.avatarColorIndex,
    required this.skill,
    required this.type,
    required this.status,
  });

  factory SentRequest.fromJson(Map<String, dynamic> json) {
    final name = json['receiverName']?.toString() ?? 'SkillSwap Member';
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return SentRequest(
      id: json['id']?.toString() ?? '',
      userName: name,
      avatarInitials: initials.isEmpty ? 'SS' : initials,
      avatarColorIndex: 0,
      skill: json['skillTitle']?.toString() ?? 'Skill Swap',
      type: _parseType(json['sessionType']?.toString()),
      status: _parseStatus(json['status']?.toString()),
    );
  }
}

class ReceivedRequest {
  final String id;
  final String userName;
  final String avatarInitials;
  final int avatarColorIndex;
  final String skill;       // Skill they want from you
  final String offersSkill; // Skill they offer in return
  final RequestType type;

  const ReceivedRequest({
    required this.id,
    required this.userName,
    required this.avatarInitials,
    required this.avatarColorIndex,
    required this.skill,
    required this.offersSkill,
    required this.type,
  });

  factory ReceivedRequest.fromJson(Map<String, dynamic> json) {
    final name = json['senderName']?.toString() ?? 'SkillSwap Member';
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return ReceivedRequest(
      id: json['id']?.toString() ?? '',
      userName: name,
      avatarInitials: initials.isEmpty ? 'SS' : initials,
      avatarColorIndex: 1,
      skill: json['skillTitle']?.toString() ?? 'Skill Swap',
      offersSkill: json['proposedText']?.toString() ?? 'Direct Exchange',
      type: _parseType(json['sessionType']?.toString()),
    );
  }
}

class ActiveSession {
  final String id;
  final String userName;
  final String avatarInitials;
  final int avatarColorIndex;
  final String skill;
  final RequestType sessionType;
  final String scheduledAt;

  const ActiveSession({
    required this.id,
    required this.userName,
    required this.avatarInitials,
    required this.avatarColorIndex,
    required this.skill,
    required this.sessionType,
    required this.scheduledAt,
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json, String currentUserId, {required bool isFromSent}) {
    final otherName = isFromSent
        ? (json['receiverName']?.toString() ?? 'SkillSwap Member')
        : (json['senderName']?.toString() ?? 'SkillSwap Member');
    final initials = otherName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return ActiveSession(
      id: json['id']?.toString() ?? '',
      userName: otherName,
      avatarInitials: initials.isEmpty ? 'SS' : initials,
      avatarColorIndex: 2,
      skill: json['skillTitle']?.toString() ?? 'Active Exchange',
      sessionType: _parseType(json['sessionType']?.toString()),
      scheduledAt: 'Active Now',
    );
  }
}