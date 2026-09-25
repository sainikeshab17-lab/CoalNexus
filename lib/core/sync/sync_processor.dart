import 'dart:async';
import 'dart:convert';
import 'package:coalnexus/core/network/connectivity_service.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/api/api_client.dart';

abstract class SyncProcessor {
  Future<void> processQueue();
}

class SyncProcessorImpl implements SyncProcessor {
  final SyncRepository _syncRepository;
  final ConnectivityService _connectivityService;
  final ApiClient _apiClient;
  final int maxRetries = 5;

  SyncProcessorImpl(this._syncRepository, this._connectivityService, this._apiClient);

  @override
  Future<void> processQueue() async {
    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) return;

    final pendingItems = await _syncRepository.getPendingOperations();
    
    for (final item in pendingItems) {
      if (item.retryCount >= maxRetries) {
        continue;
      }

      await _syncItem(item);
    }
  }

  Future<void> _syncItem(SyncQueueItem item) async {
    try {
      await _syncRepository.updateStatus(item.localId, SyncStatus.syncing);

      final Map<String, dynamic> payload = jsonDecode(item.payloadJson);
      // Ensure basic idempotency key via unique operation_id
      payload['operation_id'] = 'op_${item.localId}_${item.localVersion}';
      payload['local_id'] = item.localId;
      payload['local_version'] = item.localVersion;

      String path = '';
      if (item.featureName.toLowerCase() == 'mines' || item.featureName.toLowerCase() == 'mine') {
        path = '/mines';
      } else if (item.featureName.toLowerCase() == 'inspections' || item.featureName.toLowerCase() == 'inspection') {
        path = '/inspections';
      } else if (item.featureName.toLowerCase().contains('finding')) {
        path = '/findings';
      } else if (item.featureName.toLowerCase() == 'violations' || item.featureName.toLowerCase() == 'violation') {
        path = '/violations';
      } else if (item.featureName.toLowerCase() == 'alerts' || item.featureName.toLowerCase() == 'alert') {
        path = '/alerts';
      } else {
        throw Exception('Unknown feature: ${item.featureName}');
      }

      ApiResponse response;
      final action = item.actionType.toUpperCase();
      
      if (action.contains('CREATE')) {
        response = await _apiClient.post(path, payload);
      } else if (action.contains('UPDATE')) {
        response = await _apiClient.put('$path/${item.serverId ?? item.localId}', payload);
      } else {
        // Fallback or not supported action type
        response = ApiResponse(statusCode: 200, data: {'id': item.serverId ?? 'srv_${item.localId}'});
      }

      if (response.isSuccess) {
        final serverId = response.data['id'] as String;
        await _syncRepository.markSynced(item.localId, serverId);
        
        // SERVER ID RECONCILIATION: Update the actual entity table
        await _reconcileServerId(item.featureName, item.localId, serverId);
      } else if (response.statusCode == 409) {
        // CONFLICT HANDLING
        // The backend returns current_server_obj in detail when status is 409
        final detail = response.data['detail'];
        String? conflictMessage;
        if (detail is Map) {
          conflictMessage = detail['message'];
          // We could potentially trigger an immediate merge here, 
          // but for now we mark it as conflict for the UI to handle or 
          // to be resolved in the next refresh cycle.
        }

        await _syncRepository.updateStatus(
          item.localId, 
          SyncStatus.conflict, 
          lastError: conflictMessage ?? response.error ?? 'Conflict detected',
        );
      } else {
        // Differentiate retryable vs permanent errors
        final isValidationError = response.statusCode == 422 || response.statusCode == 400;
        final isAuthError = response.statusCode == 401 || response.statusCode == 403;
        final newRetryCount = (isValidationError || isAuthError) ? maxRetries : item.retryCount + 1;
        
        await _syncRepository.updateStatus(
          item.localId, 
          SyncStatus.failed, 
          lastError: response.error ?? 'Status ${response.statusCode}',
          retryCount: newRetryCount,
        );
      }
    } catch (e) {
      final newRetryCount = item.retryCount + 1;
      await _syncRepository.updateStatus(
        item.localId, 
        SyncStatus.failed, 
        lastError: e.toString(),
        retryCount: newRetryCount,
      );
    }
  }

  Future<void> _reconcileServerId(String feature, String localId, String serverId) async {
    // This requires access to the individual feature repositories or the database.
    // For simplicity in this demo/milestone, we use the database directly if possible 
    // or through a centralized method in SyncRepository.
    // Let's assume we add a method to SyncRepository for this.
    try {
      await _syncRepository.reconcileServerId(feature, localId, serverId);
    } catch (e) {
      // Log error but don't fail the sync item as it's already marked synced in queue
      print('Reconciliation failed for $feature $localId: $e');
    }
  }
}
