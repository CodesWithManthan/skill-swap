import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_swap/features/home/home_screen.dart';
import 'package:skill_swap/features/ongoing/ongoing_screen.dart';
import 'package:skill_swap/features/profile/my_profile/my_profile_screen.dart';
import '../../../core/theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. Fetch current UID on build so it stays fresh
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // 2. Define tabs list
    final List<Widget> screens = [
      const HomeScreen(),
      OngoingScreen(currentUserId: '1'),
      const MyProfileScreen(),
    ];

    double tabWidth = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      // IndexedStack preserves state across tab changes (doesn't reload tabs on switch)
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Stack(
          children: [
            // ── The Sliding Pill Indicator ──────────────────────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic, // Standard smooth physics curve
              left: _currentIndex * tabWidth + (tabWidth * 0.15),
              top: 12,
              child: Container(
                width: tabWidth * 0.7,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            // ── The Navigation Items ────────────────────────────────────────
            Row(
              children: [
                _buildNavItem(0, Icons.home_rounded, "Home"),
                _buildNavItem(1, Icons.play_circle_filled_rounded, "Ongoing"),
                _buildNavItem(2, Icons.person_rounded, "Profile"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}