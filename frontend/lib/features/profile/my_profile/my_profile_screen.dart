import 'package:flutter/material.dart';
import 'package:skill_swap/core/services/api_service.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import 'package:skill_swap/data/models/user_profile.dart';
import 'package:skill_swap/features/profile/my_profile/widgets/my_profile_header.dart';
import 'package:skill_swap/features/profile/my_profile/widgets/my_profile_settings.dart';
import 'package:skill_swap/features/profile/my_profile/edit_my_profile_screen.dart';

/// MyProfileScreen — Fetches live PostgreSQL data for current user (ID: '1')
class MyProfileScreen extends StatefulWidget {
  final String userId;

  const MyProfileScreen({
    super.key,
    this.userId = '1', // Defaulting to User 1 (Manthan)
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    // 🚀 Load live User 1 profile from PostgreSQL on screen open
    _profileFuture = ApiService.fetchUserProfile(widget.userId);
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
              backgroundColor: const Color(0xFF1D4ED8),
              elevation: 0,
              title: const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              centerTitle: true,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }

        // ── B. Error State ──────────────────────────────────────────────────
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              backgroundColor: const Color(0xFF1D4ED8),
              elevation: 0,
              title: const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Could not load profile data.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _profileFuture = ApiService.fetchUserProfile(widget.userId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ── C. Success State (Live Data Ready) ──────────────────────────────
        final profile = snapshot.data!;

        return Scaffold(
          backgroundColor: AppTheme.background,

          // ── AppBar ─────────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: const Color(0xFF1D4ED8),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 20, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── 1. Header ───────────────────────────────────────────────
                MyProfileHeader(
                  profile: profile,
                  onEditTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfileScreen(userId: widget.userId)),
                    );
                    if(updated == true){
                      setState(() {
                        _profileFuture = ApiService.fetchUserProfile(widget.userId);
                      });
                    }
                  }
                ),

                // ── 2. Stats Row ────────────────────────────────────────────
                MyProfileStatsRow(
                  sessionsCompleted: profile.totalSwaps,
                  activeRequests: profile.activeRequests,
                  rating: profile.rating,
                ),

                _Gap(),

                // ── 3. Skills ───────────────────────────────────────────────
                _SectionHeader(title: 'My Skills'),
                MyProfileSkillsSection(
                  skillsOffer: profile.canTeach,     // Mapped to live canTeach array
                  skillsWant: profile.wantsToLearn,  // Mapped to live wantsToLearn array
                ),

                _Gap(),

                // ── 4. Settings ─────────────────────────────────────────────
                _SectionHeader(title: 'Settings'),
                MyProfileSettingsSection(
                  onEditProfile: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfileScreen(userId: widget.userId)),
                    );
                    if (updated == true) {
                      setState(() {
                        _profileFuture = ApiService.fetchUserProfile(widget.userId);
                      });
                    }
                  },
                  onChangePassword: () => _snack(context, 'Change password'),
                ),

                _Gap(),

                // ── 5. Logout ───────────────────────────────────────────────
                MyProfileLogoutButton(
                  onLogout: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Section header ─────────────────────────────────────────────────────────
  Widget _SectionHeader({required String title}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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

  Widget _Gap() => const SizedBox(height: 8);

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _snack(BuildContext context, String msg) {
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log out?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: const Text(
          'You will be signed out of your SkillSwap account.',
          style: TextStyle(fontSize: 13.5, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _snack(context, 'Logged out successfully'); // 👈 Fixed broken expression
            },
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Color(0xFFE11D48),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}