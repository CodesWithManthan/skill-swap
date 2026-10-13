import 'package:flutter/foundation.dart';

class ApiConfig {
  // 1. Paste your exact generated localtunnel link here
  static const String _tunnelUrl = 'https://reflections-modems-academic-cornwall.trycloudflare.com';

  // 2. The magic base URL mapping switcher
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    } else {
      // Both real Android and iOS devices use the cloud tunnel link globally
      return '$_tunnelUrl/api/v1';
    }
  }

  // 3. Special configuration parameters required by the cloud tunnel
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/ json',
    'Bypass-Tunnel-Reminder': 'true',
    'User-Agent': 'SkillSwapApp/1.0',
  };
}