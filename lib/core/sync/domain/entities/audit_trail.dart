import 'package:flutter/foundation.dart';

@immutable
class AuditTrail {
  final String localId;
  final String? serverId;
  final String entityType;
  final String entityId;
  final String action;
  final String? previousState;
  final String newState;
  final String actorId;
  final DateTime timestamp;
  final String? comment;

  const AuditTrail({
    required this.localId,
    this.serverId,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.previousState,
    required this.newState,
    required this.actorId,
    required this.timestamp,
    this.comment,
  });

  AuditTrail copyWith({
    String? localId,
    String? serverId,
    String? entityType,
    String? entityId,
    String? action,
    String? previousState,
    String? newState,
    String? actorId,
    DateTime? timestamp,
    String? comment,
  }) {
    return AuditTrail(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      previousState: previousState ?? this.previousState,
      newState: newState ?? this.newState,
      actorId: actorId ?? this.actorId,
      timestamp: timestamp ?? this.timestamp,
      comment: comment ?? this.comment,
    );
  }
}
