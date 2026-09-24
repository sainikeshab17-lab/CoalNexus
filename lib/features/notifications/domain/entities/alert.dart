import 'package:flutter/foundation.dart';

enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

@immutable
class Alert {
  final String localId;
  final String? serverId;
  final String mineId;
  final String title;
  final String message;
  final AlertSeverity severity;
  final DateTime createdAt;
  final bool isRead;

  const Alert({
    required this.localId,
    this.serverId,
    required this.mineId,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    this.isRead = false,
  });

  Alert copyWith({
    String? localId,
    String? serverId,
    String? mineId,
    String? title,
    String? message,
    AlertSeverity? severity,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Alert(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      mineId: mineId ?? this.mineId,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
