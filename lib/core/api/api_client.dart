import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coalnexus/core/api/api_config.dart';

class ApiResponse {
  final int statusCode;
  final dynamic data;
  final String? error;

  ApiResponse({required this.statusCode, this.data, this.error});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<ApiResponse> get(String path) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: ApiConfig.headers,
      );
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  ApiResponse _processResponse(http.Response response) {
    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(statusCode: response.statusCode, data: data);
    } else {
      return ApiResponse(
        statusCode: response.statusCode,
        data: data,
        error: data is Map ? data['detail'] ?? 'Unknown error' : 'Server error',
      );
    }
  }
}
