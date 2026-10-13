import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_swap/data/models/skill_listing_model.dart';
import '../../data/models/user_profile.dart';
import 'api_config.dart';

class ApiService {
  static Future<bool> sendRequest({
    required String senderId,
    required String skillId,
    required String sessionType,
    required String proposedText,
}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/requests');
    try {
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'sender_id': senderId,
          'skill_id': skillId,
          'session_type': sessionType,
          'proposed_text': proposedText,
            }),
      ).timeout(const Duration(seconds: 10));
      return response.statusCode == 201;
    }
    catch (e) {
      print('❌ Error sending request: $e');
      return false;
    }
  }

  static Future<bool> updateUserProfile({
    required String userId,
    String? name,
    String? bio,
    String? college,
    String? location,
    String? tagline,
}) async{
    final url = Uri.parse('${ApiConfig.baseUrl}/users/$userId');
    try{
      final response = await http.
        patch(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'name': name,
          'bio': bio,
          'college': college,
          'location': location,
          'tagline': tagline,
        }),
      ).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  static Future<List<SkillListing>> fetchSkillsFeed() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/skills');

    print('🚀 Dispatching HTTP GET request to: $url');

    try {
      final response = await http
          .get(url, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode the outer JSON wrapper envelope
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the nested raw data list array from the 'data' block
        final List<dynamic> rawSkillsList =
        responseData['data'] as List<dynamic>;

        // The Processing Engine: Loop over each raw item and map it through our factory
        final List<SkillListing> structuredSkills = rawSkillsList.map((item) {
          return SkillListing.fromJson(item as Map<String, dynamic>);
        }).toList();

        print(
            '🎉 Successfully compiled ${structuredSkills.length} live skill records!');
        return structuredSkills; // Pass the strong-typed array out to the UI layer
      } else {
        print(
            '❌ Server returned non-200 error channel status: ${response.statusCode}');
        return []; // Return an empty array placeholder so the UI layer doesn't crash
      }
    } catch (e) {
      print('❌ FAILED COMPILATION: Error during API serialization parsing.');
      print('Error trace details: $e');
      return []; // Return clean empty list backup on complete line collapse
    }
  }



  static Future<UserProfile?> fetchUserProfile(String userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/$userId');

    print('🚀 Fetching user profile for ID: $userId');

    try {
      final response = await http
          .get(url, headers: ApiConfig.headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // 🚀 Clean single-line mapping straight to your UserProfile.fromJson factory
        return UserProfile.fromJson(responseData['data']);
      } else {
        print(
            '❌ Failed to fetch profile. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }
}