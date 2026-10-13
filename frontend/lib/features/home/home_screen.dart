import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import 'package:skill_swap/data/models/skill_listing_model.dart';
import 'package:skill_swap/features/profile/user_profile/user_profile_screen.dart';
import 'package:skill_swap/shared/widgets/skills_card.dart';
import 'package:skill_swap/core/services/api_service.dart';

const _categories = ['All', 'Coding', 'Design', 'Music', 'Fitness', 'Writing'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // 🚀 This holds the state of our active network connection call
  late Future<List<SkillListing>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the network request once when the screen mounts
    _skillsFuture = ApiService.fetchSkillsFeed();
  }

  // 🚀 Helper method to filter the LIVE database entries on the fly
  List<SkillListing> _applyFilters(List<SkillListing> liveListings) {
    return liveListings.where((l) {
      final matchesCategory =
          _selectedCategory == 'All' || l.category.toLowerCase() == _selectedCategory.toLowerCase();

      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          l.offers.toLowerCase().contains(q) ||
          l.wants.toLowerCase().contains(q) ||
          l.userName.toLowerCase().contains(q);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        // 🚀 FutureBuilder sits right at the top to orchestrate data states cleanly
        child: FutureBuilder<List<SkillListing>>(
          future: _skillsFuture,
          builder: (context, snapshot) {

            // ⏳ STATE 1: Waiting for Node.js server to finish loading rows
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              );
            }

            // ❌ STATE 2: System collapsed or network timed out
            if (snapshot.hasError) {
              return _buildErrorState();
            }

            // 📦 STATE 3: Success! Extract live data and run it through our filters
            final List<SkillListing> allLiveSkills = snapshot.data ?? [];
            final List<SkillListing> filteredLiveSkills = _applyFilters(allLiveSkills);

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _skillsFuture = ApiService.fetchSkillsFeed();
                });
              },
              child: CustomScrollView(
                slivers: [
                  // ── Sticky header: greeting + avatar ────────────────────────────
                  SliverToBoxAdapter(child: _buildHeader()),

                  // ── Search bar ──────────────────────────────────────────────────
                  SliverToBoxAdapter(child: _buildSearchBar()),

                  // ── Category chips (horizontal scroll) ──────────────────────────
                  SliverToBoxAdapter(child: _buildCategories()),

                  // ── Section title + count (passes filtered list size) ───────────
                  SliverToBoxAdapter(child: _buildSectionTitle(filteredLiveSkills.length)),

                  // ── Skill cards list ─────────────────────────────────────────────
                  filteredLiveSkills.isEmpty
                      ? const SliverFillRemaining(child: _EmptyState())
                      : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final currentSkill = filteredLiveSkills[index];
                          return SkillCard(
                            listing: currentSkill,
                            onAction: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfileScreen(userId: currentSkill.ownerId, skillId: currentSkill.id,),
                                ),
                              );
                            },
                          );
                        },
                        childCount: filteredLiveSkills.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Modified Builder Helpers ──────────────────────────────────────────────────

  Widget _buildSectionTitle(int currentCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: [
          const Text(
            'Available swaps',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$currentCount found', // Displays live matching database count dynamically
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Find your next skill swap 🤝',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.25), width: 1.5),
            ),
            child: const Icon(Icons.person_outline_rounded,
                color: AppTheme.primary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search skills, names…',
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppTheme.textSecondary, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppTheme.textSecondary, size: 18),
            onPressed: () => setState(() => _searchQuery = ''),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.border,
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
                    : [],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          const Text(
            'Server Connection Error',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _skillsFuture = ApiService.fetchSkillsFeed();
              });
            },
            child: const Text('Retry Connection'),
          )
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 🌤';
    if (hour < 17) return 'Good afternoon ☀️';
    return 'Good evening 🌙';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppTheme.border),
          SizedBox(height: 12),
          Text(
            'No swaps found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try a different category or search term',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}