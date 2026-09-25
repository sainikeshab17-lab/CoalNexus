import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    return 'http://10.70.44.164:8000/api';
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
