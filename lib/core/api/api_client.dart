import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coalnexus/core/api/api_config.dart';
import 'package:coalnexus/core/storage/token_storage.dart';

class ApiResponse {
  final int statusCode;
  final dynamic data;
  final String? error;

  ApiResponse({required this.statusCode, this.data, this.error});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiClient {
  final http.Client _client;
  final TokenStorage? _tokenStorage;

  ApiClient({http.Client? client, TokenStorage? tokenStorage})
      : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage;

  Future<Map<String, String>> _getHeaders() async {
    final headers = Map<String, String>.from(ApiConfig.headers);
    if (_tokenStorage != null) {
      final token = await _tokenStorage!.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<ApiResponse> get(String path) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> put(String path, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: headers,
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
      String? errorMessage;
      if (data is Map) {
        final detail = data['detail'];
        if (detail is List) {
          errorMessage = detail.map((e) => e.toString()).join(', ');
        } else {
          errorMessage = detail?.toString() ?? 'Unknown error';
        }
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
      }

      return ApiResponse(
        statusCode: response.statusCode,
        data: data,
        error: errorMessage,
      );
    }
  }
}
