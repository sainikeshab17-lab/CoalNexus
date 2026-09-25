import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    // Port 8000 for FastAPI backend
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://127.0.0.1:8000/api/v1';
  }

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Placeholder for authentication token as required by Milestone 7 instructions
      'Authorization': 'Bearer SECRET_TOKEN_FOR_PROTOTYPE',
    };
  }
}
