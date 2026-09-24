import 'package:flutter/foundation.dart';

enum ViolationSeverity {
  low,
  medium,
  high,
  critical,
}

enum ViolationStatus {
  detected,
  recorded,
  assigned,
  correctiveAction,
  evidenceSubmitted,
  verification,
  closed,
  overdue,
}

@immutable
class Violation {
  final String localId;
  final String? serverId;
  final String inspectionId;
  final String findingId;
  final String mineId;
  final String title;
  final String description;
  final ViolationSeverity severity;
  final ViolationStatus status;
  final String? assignedTo;
  final DateTime? dueDate;
  final DateTime detectedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;

  const Violation({
    required this.localId,
    this.serverId,
    required this.inspectionId,
    required this.findingId,
    required this.mineId,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    this.assignedTo,
    this.dueDate,
    required this.detectedAt,
    required this.createdAt,
    required this.updatedAt,
    this.localVersion = 1,
  });

  Violation copyWith({
    String? localId,
    String? serverId,
    String? inspectionId,
    String? findingId,
    String? mineId,
    String? title,
    String? description,
    ViolationSeverity? severity,
    ViolationStatus? status,
    String? assignedTo,
    DateTime? dueDate,
    DateTime? detectedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) {
    return Violation(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      inspectionId: inspectionId ?? this.inspectionId,
      findingId: findingId ?? this.findingId,
      mineId: mineId ?? this.mineId,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDate: dueDate ?? this.dueDate,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Violation &&
          runtimeType == other.runtimeType &&
          localId == other.localId &&
          serverId == other.serverId &&
          inspectionId == other.inspectionId &&
          findingId == other.findingId &&
          mineId == other.mineId &&
          title == other.title &&
          description == other.description &&
          severity == other.severity &&
          status == other.status &&
          assignedTo == other.assignedTo &&
          dueDate == other.dueDate &&
          detectedAt == other.detectedAt &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          localVersion == other.localVersion;

  @override
  int get hashCode =>
      localId.hashCode ^
      serverId.hashCode ^
      inspectionId.hashCode ^
      findingId.hashCode ^
      mineId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      severity.hashCode ^
      status.hashCode ^
      assignedTo.hashCode ^
      dueDate.hashCode ^
      detectedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      localVersion.hashCode;
}
