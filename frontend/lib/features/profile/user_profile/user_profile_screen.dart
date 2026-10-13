import 'package:flutter/material.dart';
import 'package:skill_swap/core/services/api_service.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import 'package:skill_swap/features/profile/user_profile/widgets/user_profile_action_bar.dart';
import 'package:skill_swap/features/profile/user_profile/widgets/user_profile_header.dart';
import 'package:skill_swap/features/profile/user_profile/widgets/user_profile_sections.dart';
import '../../../data/models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String skillId;


  const ProfileScreen({
    super.key,
    required this.userId,
    required this.skillId
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Set<String> _sentSessionTypes = {};
  late Future<UserProfile?> _profileFuture;

  final TextEditingController _proposedTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 1. Trigger the PostgreSQL API request on open
    _profileFuture = ApiService.fetchUserProfile(widget.userId);
  }

  @override
  void dispose(){
    _proposedTextController.dispose();
    super.dispose();
  }
  Future<String?> _askForMessage(String actionLabel) {
    _proposedTextController.clear();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(actionLabel),
        content: TextField(
          controller: _proposedTextController,
          maxLines: 3,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Say something...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _proposedTextController.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendRequest(String sessionType, String dialogTitle) async {
    if(_sentSessionTypes.contains(sessionType)) return;
    final text = await _askForMessage(dialogTitle);
    if (text == null || text.trim().isEmpty) return;

    _showSnack(context, 'Sending request... ⏳');

    final success = await ApiService.sendRequest(
      senderId: '1', // hardcoded until auth
      skillId: widget.skillId,
      sessionType: sessionType,
      proposedText: text,
    );

    if (!mounted) return;
    if(success){
      setState(() => _sentSessionTypes.add(sessionType));
    }
    _showSnack(context, success ? 'Request sent!' : 'Failed to send request');
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        // ── A. Loading State ────────────────────────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: AppTheme.textPrimary),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }

        // ── B. Error / Null State ───────────────────────────────────────────
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: AppTheme.textPrimary),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Could not load profile.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _profileFuture =
                            ApiService.fetchUserProfile(widget.userId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ── C. Success State (Live PostgreSQL Profile) ──────────────────────
        final profile = snapshot.data!;

        return Scaffold(
          backgroundColor: AppTheme.background,

          // ── AppBar ────────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppTheme.textPrimary),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Text(
              profile.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.ios_share_outlined,
                    size: 20, color: AppTheme.textSecondary),
                onPressed: () {},
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, color: AppTheme.border),
            ),
          ),

          // ── Fixed bottom bar ──────────────────────────────────────────────
          bottomNavigationBar: ProfileActionBar(
            onBookSession: _sentSessionTypes.contains('paid') ? null : () => _sendRequest('paid', 'Book a Session'),
            onRequestSwap: _sentSessionTypes.contains('fullSwap') ? null : () => _sendRequest('fullSwap', 'Request a Swap'),
            onQuickSession: _sentSessionTypes.contains('quickSession') ? null : () => _sendRequest('quickSession', 'Request Quick Session'),
            bookSessionSent: _sentSessionTypes.contains('paid'),
            requestSwapSent: _sentSessionTypes.contains('fullSwap'),
            quickSessionSent: _sentSessionTypes.contains('quickSession'),
          ),

          // ── Scrollable body ───────────────────────────────────────────────
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── 1. Avatar, name, stats ─────────────────────────────────
                ProfileHeader(profile: profile),
                _Spacer(),

                // ── 2. Skills ──────────────────────────────────────────────
                const SectionHeader(title: 'Skills'),
                SkillsSection(
                  canTeach: profile.canTeach,
                  wantsToLearn: profile.wantsToLearn,
                ),
                _Spacer(),

                // ── 3. About ───────────────────────────────────────────────
                const SectionHeader(title: 'About'),
                AboutSection(about: profile.about),
                _Spacer(),

                // ── 4. Experience & achievements ───────────────────────────
                if (profile.experiences.isNotEmpty) ...[
                  const SectionHeader(title: 'Experience & Achievements'),
                  ExperienceSection(experiences: profile.experiences),
                  _Spacer(),
                ],

                // ── 5. What I can help you with ────────────────────────────
                if (profile.helpTopics.isNotEmpty) ...[
                  const SectionHeader(title: 'What I can help you with'),
                  HelpTopicsSection(topics: profile.helpTopics),
                ],

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _Spacer() => const SizedBox(height: 10);

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppTheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}