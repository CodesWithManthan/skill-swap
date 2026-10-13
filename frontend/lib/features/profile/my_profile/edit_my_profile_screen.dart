import 'package:flutter/material.dart';
import 'package:skill_swap/core/services/api_service.dart';
import 'package:skill_swap/core/theme/app_theme.dart';
import 'package:skill_swap/data/models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({super.key, required this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Future<UserProfile?> _profileFuture;

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _collegeController = TextEditingController();
  final _locationController = TextEditingController();
  final _taglineController = TextEditingController();

  bool _isSaving = false;
  bool _loadedIntoFields = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = ApiService.fetchUserProfile(widget.userId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _collegeController.dispose();
    _locationController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  void _prefillFields(UserProfile profile) {
    if (_loadedIntoFields) return;
    _nameController.text = profile.name;
    _bioController.text = profile.about;
    _taglineController.text = profile.tagline ?? '';
    _collegeController.text = profile.college;
    _locationController.text = profile.location;
    _loadedIntoFields = true;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final success = await ApiService.updateUserProfile(
      userId: widget.userId,
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      college: _collegeController.text.trim(),
      location: _locationController.text.trim(),
      tagline: _taglineController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Profile updated!' : 'Failed to update profile'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: success ? AppTheme.primary : Colors.redAccent,
      ),
    );

    if (success) Navigator.pop(context, true); // true = tell caller to refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.textPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Could not load profile.'));
          }

          _prefillFields(snapshot.data!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field('Name', _nameController),
                const SizedBox(height: 16),
                _field('Tagline', _taglineController),
                const SizedBox(height: 16),
                _field('College', _collegeController),
                const SizedBox(height: 16),
                _field('Location', _locationController),
                const SizedBox(height: 16),
                _field('About / Bio', _bioController, maxLines: 4),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}