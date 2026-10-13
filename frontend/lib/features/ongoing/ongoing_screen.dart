import 'package:flutter/material.dart';
import 'package:skill_swap/core/navigation/main_navigation_screen.dart';
import 'package:skill_swap/core/services/ongoing_service.dart';
import '../../../core/theme/app_theme.dart';
import 'package:skill_swap/data/models/ongoing_models.dart';
import 'package:skill_swap/features/ongoing/widgets/ongoing_card.dart';
import 'package:skill_swap/features/ongoing/widgets/ongoing_sections.dart';

/// OngoingScreen — three-section view connected to live API: Sent, Received, Active Sessions.
class OngoingScreen extends StatefulWidget {
  final String currentUserId; // User ID passed from authentication/session state

  const OngoingScreen({super.key, required this.currentUserId});

  @override
  State<OngoingScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool _isLoading = true;
  List<SentRequest> _sentRequests = [];
  List<ReceivedRequest> _receivedRequests = [];
  List<ActiveSession> _activeSessions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Network Fetcher ────────────────────────────────────────────────────────

  Future<void> _fetchData() async {
    // Only show full-screen loader if lists are empty initially
    if (_sentRequests.isEmpty && _receivedRequests.isEmpty && _activeSessions.isEmpty) {
      setState(() => _isLoading = true);
    }

    try {
      final bundle = await OngoingService.fetchOngoingData(widget.currentUserId);

      if (mounted) {
        setState(() {
          _sentRequests = bundle.sent;
          _receivedRequests = bundle.received;
          _activeSessions = bundle.active;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ── Action Handlers ────────────────────────────────────────────────────────

  Future<void> _cancelRequest(SentRequest r) async {
    final success = await OngoingService.updateRequestStatus(r.id, 'rejected');
    if (success) {
      _snack('Request to ${r.userName} cancelled');
      _fetchData();
    } else {
      _snack('Failed to cancel request');
    }
  }

  void _viewSession(SentRequest r) {
    _snack('Opening session with ${r.userName}…');
  }

  Future<void> _acceptRequest(ReceivedRequest r) async {
    final success = await OngoingService.updateRequestStatus(r.id, 'accepted');
    if (success) {
      _snack('Accepted request from ${r.userName}!');
      _fetchData();
    } else {
      _snack('Failed to accept request');
    }
  }

  Future<void> _rejectRequest(ReceivedRequest r) async {
    final success = await OngoingService.updateRequestStatus(r.id, 'rejected');
    if (success) {
      _snack('Request from ${r.userName} rejected');
      _fetchData();
    } else {
      _snack('Failed to reject request');
    }
  }

  void _continueSession(ActiveSession s) {
    _snack('Joining session with ${s.userName}…');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppTheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // ── AppBar with integrated TabBar ─────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainNavigationScreen()),
          ),
        ),
        title: const Text(
          'Ongoing',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: Column(
            children: [
              const Divider(height: 1, color: AppTheme.border),
              _StyledTabBar(
                controller: _tabController,
                sentCount: _sentRequests.length,
                receivedCount: _receivedRequests.length,
                activeCount: _activeSessions.length,
              ),
            ],
          ),
        ),
      ),

      // ── Tab views ─────────────────────────────────────────────────────────
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          // 1. Sent
          _SectionScrollView(
            onRefresh: _fetchData,
            children: [
              OngoingSectionHeader(
                  title: 'Requests Sent', count: _sentRequests.length),
              SentRequestsSection(
                requests: _sentRequests,
                onCancel: _cancelRequest,
                onViewSession: _viewSession,
              ),
              const SizedBox(height: 24),
            ],
          ),

          // 2. Received
          _SectionScrollView(
            onRefresh: _fetchData,
            children: [
              OngoingSectionHeader(
                  title: 'Requests Received',
                  count: _receivedRequests.length),
              ReceivedRequestsSection(
                requests: _receivedRequests,
                onAccept: _acceptRequest,
                onReject: _rejectRequest,
              ),
              const SizedBox(height: 24),
            ],
          ),

          // 3. Active Sessions
          _SectionScrollView(
            onRefresh: _fetchData,
            children: [
              OngoingSectionHeader(
                  title: 'Active Sessions',
                  count: _activeSessions.length),
              ActiveSessionsSection(
                sessions: _activeSessions,
                onContinue: _continueSession,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StyledTabBar — custom tab bar matching the app's clean aesthetic
// ─────────────────────────────────────────────────────────────────────────────

class _StyledTabBar extends StatelessWidget {
  final TabController controller;
  final int sentCount;
  final int receivedCount;
  final int activeCount;

  const _StyledTabBar({
    required this.controller,
    required this.sentCount,
    required this.receivedCount,
    required this.activeCount,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: AppTheme.primary,
      unselectedLabelColor: AppTheme.textSecondary,
      indicatorColor: AppTheme.primary,
      indicatorWeight: 2.5,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
      const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      tabs: [
        _TabItem(label: 'Sent', count: sentCount),
        _TabItem(label: 'Received', count: receivedCount),
        _TabItem(label: 'Active', count: activeCount),
      ],
    );
  }
}

/// Tab label + live count dot.
class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  const _TabItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 5),
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionScrollView — Wraps direct scroll view in RefreshIndicator per tab
// ─────────────────────────────────────────────────────────────────────────────
class _SectionScrollView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  const _SectionScrollView({
    required this.onRefresh,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}