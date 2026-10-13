import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_swap/data/models/ongoing_models.dart';
import 'api_config.dart'; // Uses your project's ApiConfig

class OngoingDataBundle {
  final List<SentRequest> sent;
  final List<ReceivedRequest> received;
  final List<ActiveSession> active;

  OngoingDataBundle({
    required this.sent,
    required this.received,
    required this.active,
  });
}

class OngoingService {
  /// Fetch all three sections concurrently
  static Future<OngoingDataBundle> fetchOngoingData(String userId) async {
    final sentUri = Uri.parse('${ApiConfig.baseUrl}/requests/sent/$userId');
    final receivedUri = Uri.parse('${ApiConfig.baseUrl}/requests/incoming/$userId');
    final activeUri = Uri.parse('${ApiConfig.baseUrl}/requests/active/$userId');

    try {
      final results = await Future.wait([
        http.get(sentUri, headers: ApiConfig.headers).timeout(const Duration(seconds: 10)),
        http.get(receivedUri, headers: ApiConfig.headers).timeout(const Duration(seconds: 10)),
        http.get(activeUri, headers: ApiConfig.headers).timeout(const Duration(seconds: 10)),
      ]);

      List<SentRequest> sentList = [];
      List<ReceivedRequest> receivedList = [];
      List<ActiveSession> activeList = [];

      if (results[0].statusCode == 200) {
        final data = (json.decode(results[0].body)['data'] ?? []) as List;
        for (var item in data) {
          sentList.add(SentRequest.fromJson(item));
          if (item['status'] == 'accepted') {
            activeList.add(ActiveSession.fromJson(item, userId, isFromSent: true));
          }
        }
      } else {
        print('❌ Sent failed: ${results[0].statusCode} ${results[0].body}');
      }

      if (results[1].statusCode == 200) {
        final data = (json.decode(results[1].body)['data'] ?? []) as List;
        for (var item in data) {
          if (item['status'] == 'accepted') {
            activeList.add(ActiveSession.fromJson(item, userId, isFromSent: false));
          } else {
            receivedList.add(ReceivedRequest.fromJson(item));
          }
        }
      } else {
        print('❌ Received failed: ${results[1].statusCode} ${results[1].body}');
      }

      return OngoingDataBundle(
        sent: sentList,
        received: receivedList,
        active: activeList,
      );
    } catch (e) {
      print('❌ Error fetching ongoing data: $e');
      return OngoingDataBundle(sent: [], received: [], active: []);
    }
  }

  /// Update request status (Accept / Reject)
  static Future<bool> updateRequestStatus(String requestId, String status) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/requests/$requestId/status');
    try {
      final response = await http
          .patch(uri, headers: ApiConfig.headers, body: json.encode({'status': status})) // must be .patch, not .put
          .timeout(const Duration(seconds: 10));
        return response.statusCode == 200;
    } catch (e) {
      print('❌ Error updating request status: $e');
      return false;
    }
  }
}