import 'package:flutter/foundation.dart';

enum CorrectiveActionStatus {
  assigned,
  inProgress,
  submitted,
  verification,
  verified,
  rejected,
  closed,
}

@immutable
class CorrectiveAction {
  final String localId;
  final String? serverId;
  final String violationId;
  final String title;
  final String description;
  final String assignedTo;
  final String priority;
  final DateTime dueDate;
  final CorrectiveActionStatus status;
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  final String? evidence;
  final int localVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CorrectiveAction({
    required this.localId,
    this.serverId,
    required this.violationId,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
    required this.status,
    this.submittedAt,
    this.verifiedAt,
    this.evidence,
    this.localVersion = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  CorrectiveAction copyWith({
    String? localId,
    String? serverId,
    String? violationId,
    String? title,
    String? description,
    String? assignedTo,
    String? priority,
    DateTime? dueDate,
    CorrectiveActionStatus? status,
    DateTime? submittedAt,
    DateTime? verifiedAt,
    String? evidence,
    int? localVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CorrectiveAction(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      violationId: violationId ?? this.violationId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      evidence: evidence ?? this.evidence,
      localVersion: localVersion ?? this.localVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CorrectiveAction &&
          runtimeType == other.runtimeType &&
          localId == other.localId &&
          serverId == other.serverId &&
          violationId == other.violationId &&
          title == other.title &&
          description == other.description &&
          assignedTo == other.assignedTo &&
          priority == other.priority &&
          dueDate == other.dueDate &&
          status == other.status &&
          submittedAt == other.submittedAt &&
          verifiedAt == other.verifiedAt &&
          evidence == other.evidence &&
          localVersion == other.localVersion &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      localId.hashCode ^
      serverId.hashCode ^
      violationId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      assignedTo.hashCode ^
      priority.hashCode ^
      dueDate.hashCode ^
      status.hashCode ^
      submittedAt.hashCode ^
      verifiedAt.hashCode ^
      evidence.hashCode ^
      localVersion.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
