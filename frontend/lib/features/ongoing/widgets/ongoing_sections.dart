import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/ongoing_models.dart';
import 'ongoing_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SentRequestsSection
// ─────────────────────────────────────────────────────────────────────────────

/// Displays the list of requests the current user has sent.
/// Empty state is shown when the list is empty.
class SentRequestsSection extends StatelessWidget {
  final List<SentRequest> requests;

  /// Called when user taps "Cancel" on a pending request.
  final void Function(SentRequest) onCancel;

  /// Called when user taps "View Session" on an accepted request.
  final void Function(SentRequest) onViewSession;

  const SentRequestsSection({
    super.key,
    required this.requests,
    required this.onCancel,
    required this.onViewSession,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const EmptyState(
        icon: Icons.send_outlined,
        message: 'No requests sent yet',
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: requests
            .map(
              (r) => _SentRequestCard(
            request: r,
            onCancel: () => onCancel(r),
            onViewSession: () => onViewSession(r),
          ),
        )
            .toList(),
      ),
    );
  }
}

class _SentRequestCard extends StatelessWidget {
  final SentRequest request;
  final VoidCallback onCancel;
  final VoidCallback onViewSession;

  const _SentRequestCard({
    required this.request,
    required this.onCancel,
    required this.onViewSession,
  });

  @override
  Widget build(BuildContext context) {
    return OngoingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Avatar + name + status ────────────────────────────────────────
          UserRow(
            name: request.userName,
            avatarInitials: request.avatarInitials,
            avatarColorIndex: request.avatarColorIndex,
            trailing: StatusBadge(status: request.status),
          ),
          const CardDivider(),

          // ── Skill + type ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(child: SkillRow(skill: request.skill)),
              const SizedBox(width: 8),
              TypeBadge(type: request.type),
            ],
          ),

          // ── Action button (conditional on status) ─────────────────────────
          if (request.status != RequestStatus.rejected) ...[
            const SizedBox(height: 14),
            _ActionButton(
              request: request,
              onCancel: onCancel,
              onViewSession: onViewSession,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shows "Cancel" for pending, "View Session" for accepted, nothing for rejected.
class _ActionButton extends StatelessWidget {
  final SentRequest request;
  final VoidCallback onCancel;
  final VoidCallback onViewSession;

  const _ActionButton({
    required this.request,
    required this.onCancel,
    required this.onViewSession,
  });

  @override
  Widget build(BuildContext context) {
    if (request.status == RequestStatus.pending) {
      return SizedBox(
        width: double.infinity,
        height: 38,
        child: OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFE11D48)),
            foregroundColor: const Color(0xFFE11D48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600),
          ),
          child: const Text('Cancel Request'),
        ),
      );
    }

    // Accepted
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton(
        onPressed: onViewSession,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          textStyle:
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('View Session'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ReceivedRequestsSection
// ─────────────────────────────────────────────────────────────────────────────

/// Displays incoming requests with Accept / Reject actions.
class ReceivedRequestsSection extends StatelessWidget {
  final List<ReceivedRequest> requests;
  final void Function(ReceivedRequest) onAccept;
  final void Function(ReceivedRequest) onReject;

  const ReceivedRequestsSection({
    super.key,
    required this.requests,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        message: 'No requests received yet',
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: requests
            .map(
              (r) => _ReceivedRequestCard(
            request: r,
            onAccept: () => onAccept(r),
            onReject: () => onReject(r),
          ),
        )
            .toList(),
      ),
    );
  }
}

class _ReceivedRequestCard extends StatelessWidget {
  final ReceivedRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _ReceivedRequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return OngoingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Avatar + name + type badge ────────────────────────────────────
          UserRow(
            name: request.userName,
            avatarInitials: request.avatarInitials,
            avatarColorIndex: request.avatarColorIndex,
            trailing: TypeBadge(type: request.type),
          ),
          const CardDivider(),

          // ── What they want from you ───────────────────────────────────────
          SkillRow(skill: request.skill, label: 'Wants:'),
          const SizedBox(height: 6),

          // ── What they offer in return ─────────────────────────────────────
          SkillRow(skill: request.offersSkill, label: 'Offers:'),
          const SizedBox(height: 14),

          // ── Accept + Reject buttons ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _OutlineBtn(
                  label: 'Reject',
                  color: const Color(0xFFE11D48),
                  onPressed: onReject,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ActiveSessionsSection
// ─────────────────────────────────────────────────────────────────────────────

/// Displays sessions that have been accepted and are now active.
class ActiveSessionsSection extends StatelessWidget {
  final List<ActiveSession> sessions;
  final void Function(ActiveSession) onContinue;

  const ActiveSessionsSection({
    super.key,
    required this.sessions,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const EmptyState(
        icon: Icons.bolt_outlined,
        message: 'No active sessions right now',
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: sessions
            .map(
              (s) => _ActiveSessionCard(
            session: s,
            onContinue: () => onContinue(s),
          ),
        )
            .toList(),
      ),
    );
  }
}

class _ActiveSessionCard extends StatelessWidget {
  final ActiveSession session;
  final VoidCallback onContinue;

  const _ActiveSessionCard({required this.session, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return OngoingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Avatar + name + type badge ────────────────────────────────────
          UserRow(
            name: session.userName,
            avatarInitials: session.avatarInitials,
            avatarColorIndex: session.avatarColorIndex,
            trailing: TypeBadge(type: session.sessionType),
          ),
          const CardDivider(),

          // ── Skill + scheduled time ────────────────────────────────────────
          Row(
            children: [
              Expanded(child: SkillRow(skill: session.skill)),
              const SizedBox(width: 8),
              // Scheduled time chip
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule_outlined,
                        size: 12, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      session.scheduledAt,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Continue button ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                // Slightly lighter blue for active sessions to differentiate
                backgroundColor: AppTheme.primary,
                minimumSize: Size.zero,
                textStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Continue Session'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared outlined button used within section cards
// ─────────────────────────────────────────────────────────────────────────────
class _OutlineBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _OutlineBtn({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          textStyle:
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}