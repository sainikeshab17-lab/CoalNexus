class ApiConfig {
  static String get baseUrl {
    return 'https://coalnexus-api.onrender.com/api';
  }

  static String get websocketUrl {
    return 'wss://coalnexus-api.onrender.com/ws/telemetry';
  }

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer demo-admin-id-111',
    };
  }
}
