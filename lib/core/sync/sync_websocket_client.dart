import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/api/api_config.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/corrective_action_providers.dart';

class SyncWebSocketClient {
  final Ref _ref;
  WebSocket? _socket;
  bool _isDisposed = false;
  bool _isConnecting = false;
  int _retryDelaySeconds = 2;
  final int _maxRetryDelaySeconds = 60;

  SyncWebSocketClient(this._ref);

  void connect() async {
    if (_isDisposed || _isConnecting || _socket != null) return;
    _isConnecting = true;
    
    try {
      _socket = await WebSocket.connect(ApiConfig.websocketUrl).timeout(const Duration(seconds: 10));
      _retryDelaySeconds = 2; // reset backoff on successful connection
      _isConnecting = false;
      
      _socket?.listen(
        (data) => _handleMessage(data),
        onDone: () => _handleDisconnect(),
        onError: (e) => _handleDisconnect(),
        cancelOnError: true,
      );
      print('WebSocket connected to ${ApiConfig.websocketUrl}');
    } catch (e) {
      print('WebSocket connection failed: $e');
      _isConnecting = false;
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _socket?.close();
    _socket = null;
    _reconnect();
  }

  void _handleMessage(dynamic data) {
    try {
      final payload = jsonDecode(data.toString());
      final String? event = payload['event'];
      final String? entityTypeField = payload['entity_type'];
      
      String? targetEntity;
      
      if (entityTypeField != null) {
        targetEntity = entityTypeField;
      } else if (event != null) {
        if (event.contains('.')) {
          targetEntity = event.split('.').first;
        } else if (event == 'telemetry.updated') {
          targetEntity = 'telemetry';
        }
      }

      _refreshData(targetEntity);
    } catch (e) {
      print('Error handling WebSocket message: $e');
    }
  }

  void _refreshData(String? entityType) {
    try {
      if (entityType == 'mine' || entityType == 'telemetry' || entityType == null) {
        _ref.read(mineRepositoryProvider).refreshMines();
      }
      if (entityType == 'inspection' || entityType == null) {
        _ref.read(inspectionRepositoryProvider).refreshInspections();
      }
      if (entityType == 'violation' || entityType == null) {
        _ref.read(violationRepositoryProvider).refreshViolations();
      }
      if (entityType == 'finding' || entityType == null) {
        _ref.read(inspectionRepositoryProvider).refreshFindings();
      }
      if (entityType == 'corrective_action' || entityType == null) {
        _ref.read(correctiveActionRepositoryProvider).refreshActions();
      }
      if (entityType == 'alert' || entityType == null) {
        _ref.read(alertRepositoryProvider).refreshAlerts();
      }
    } catch (e) {
      print('Error refreshing data from WebSocket trigger: $e');
    }
  }

  void _reconnect() {
    if (_isDisposed || _isConnecting) return;
    print('WebSocket reconnecting in $_retryDelaySeconds seconds...');
    Future.delayed(Duration(seconds: _retryDelaySeconds), () {
      if (!_isDisposed) {
        connect();
      }
    });
    // Exponential backoff
    _retryDelaySeconds = (_retryDelaySeconds * 2).clamp(2, _maxRetryDelaySeconds);
  }

  void dispose() {
    _isDisposed = true;
    _socket?.close();
    _socket = null;
  }
}

final syncWebSocketClientProvider = Provider<SyncWebSocketClient>((ref) {
  final client = SyncWebSocketClient(ref);
  client.connect();
  ref.onDispose(() => client.dispose());
  return client;
});
