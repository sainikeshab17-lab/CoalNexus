import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/api/api_providers.dart';

enum BackendHealthStatus {
  online,
  backendUnavailable,
  offline
}

final backendHealthProvider = StreamProvider<BackendHealthStatus>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final controller = StreamController<BackendHealthStatus>();

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    try {
      final response = await apiClient.get('/health');
      if (response.isSuccess && response.data?['status'] == 'ok') {
        controller.add(BackendHealthStatus.online);
      } else {
        controller.add(BackendHealthStatus.backendUnavailable);
      }
    } catch (_) {
      controller.add(BackendHealthStatus.backendUnavailable);
    }
  });

  // Initial check
  apiClient.get('/health').then((response) {
    if (response.isSuccess && response.data?['status'] == 'ok') {
      controller.add(BackendHealthStatus.online);
    } else {
      controller.add(BackendHealthStatus.backendUnavailable);
    }
  }).catchError((_) {
    controller.add(BackendHealthStatus.backendUnavailable);
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
