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
  final Future<void> Function()? _onRefreshToken;

  ApiClient({
    http.Client? client, 
    TokenStorage? tokenStorage,
    Future<void> Function()? onRefreshToken,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage,
        _onRefreshToken = onRefreshToken;

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

  Future<ApiResponse> get(String path, {bool authenticated = true}) async {
    return _request(() async {
      final headers = authenticated
          ? await _getHeaders()
          : Map<String, String>.from(ApiConfig.headers);
      return await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: headers,
      );
    });
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    return _request(() async {
      final headers = await _getHeaders();
      return await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: headers,
        body: jsonEncode(body),
      );
    });
  }

  Future<ApiResponse> put(String path, Map<String, dynamic> body) async {
    return _request(() async {
      final headers = await _getHeaders();
      return await _client.put(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: headers,
        body: jsonEncode(body),
      );
    });
  }

  Future<ApiResponse> _request(
    Future<http.Response> Function() requestFn, {
    int retryCount = 0,
  }) async {
    try {
      final response = await requestFn();
      final apiResponse = _processResponse(response);

      if (apiResponse.statusCode == 401 && retryCount < 1) {
        print('[AUTH_SYNC] 401 Unauthorized received, attempting retry...');
        if (_onRefreshToken != null) {
          try {
            await _onRefreshToken!();
          } catch (e) {
            print('[AUTH_SYNC] Failed to execute session refresh callback: $e');
          }
        }
        return await _request(requestFn, retryCount: retryCount + 1);
      }

      if (!apiResponse.isSuccess) {
        print(
            '[SYNC_DEBUG] Request failed status=${apiResponse.statusCode} error=${apiResponse.error}');
      }

      return apiResponse;
    } catch (e) {
      print('[SYNC_DEBUG] Request exception: $e');
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
