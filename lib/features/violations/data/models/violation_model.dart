import 'package:coalnexus/features/violations/domain/entities/violation.dart';

class ViolationModel extends Violation {
  const ViolationModel({
    required super.localId,
    super.serverId,
    required super.inspectionId,
    required super.findingId,
    required super.mineId,
    required super.title,
    required super.description,
    required super.severity,
    required super.status,
    super.assignedTo,
    super.dueDate,
    required super.detectedAt,
    required super.createdAt,
    required super.updatedAt,
    super.localVersion = 1,
  });

  factory ViolationModel.fromDomain(Violation violation, {int? localVersion}) {
    return ViolationModel(
      localId: violation.localId,
      serverId: violation.serverId,
      inspectionId: violation.inspectionId,
      findingId: violation.findingId,
      mineId: violation.mineId,
      title: violation.title,
      description: violation.description,
      severity: violation.severity,
      status: violation.status,
      assignedTo: violation.assignedTo,
      dueDate: violation.dueDate,
      detectedAt: violation.detectedAt,
      createdAt: violation.createdAt,
      updatedAt: violation.updatedAt,
      localVersion: localVersion ?? violation.localVersion,
    );
  }

  Violation toDomain() {
    return Violation(
      localId: localId,
      serverId: serverId,
      inspectionId: inspectionId,
      findingId: findingId,
      mineId: mineId,
      title: title,
      description: description,
      severity: severity,
      status: status,
      assignedTo: assignedTo,
      dueDate: dueDate,
      detectedAt: detectedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      localVersion: localVersion,
    );
  }

  Map<String, dynamic> toJson() {
    String apiStatus = status.name;
    // Map internal status to backend-expected enum if necessary
    // Backend ViolationStatus: open, resolved, inProgress, closed
    if (apiStatus == 'detected' || apiStatus == 'recorded') {
      apiStatus = 'open';
    } else if (apiStatus == 'assigned' || apiStatus == 'correctiveAction' || apiStatus == 'evidenceSubmitted' || apiStatus == 'verification') {
      apiStatus = 'inProgress';
    } else if (apiStatus == 'closed') {
      apiStatus = 'closed';
    } else if (apiStatus == 'overdue') {
      apiStatus = 'open';
    }

    return {
      'local_id': localId,
      'server_id': serverId,
      'inspection_id': inspectionId,
      'finding_id': findingId,
      'mine_id': mineId,
      'title': title,
      'description': description,
      'severity': severity.name,
      'status': apiStatus,
      'assigned_to': assignedTo,
      'due_date': dueDate?.toIso8601String(),
      'detected_at': detectedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'local_version': localVersion,
    };
  }

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      localId: (json['local_id'] ?? json['localId']) as String,
      serverId: (json['server_id'] ?? json['id'] ?? json['serverId']) as String?,
      inspectionId: (json['inspection_id'] ?? json['inspectionId']) as String,
      findingId: (json['finding_id'] ?? json['findingId']) as String,
      mineId: (json['mine_id'] ?? json['mineId']) as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: ViolationSeverity.values.firstWhere((e) => e.name == json['severity']),
      status: ViolationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () {
          final s = json['status'] as String;
          if (s == 'open') return ViolationStatus.detected;
          if (s == 'inProgress') return ViolationStatus.assigned;
          if (s == 'resolved') return ViolationStatus.evidenceSubmitted;
          if (s == 'closed') return ViolationStatus.closed;
          return ViolationStatus.detected;
        },
      ),
      assignedTo: (json['assigned_to'] ?? json['assignedTo']) as String?,
      dueDate: (json['due_date'] ?? json['dueDate']) != null ? DateTime.parse((json['due_date'] ?? json['dueDate']) as String) : null,
      detectedAt: DateTime.parse((json['detected_at'] ?? json['detectedAt']) as String),
      createdAt: DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
      updatedAt: DateTime.parse((json['updated_at'] ?? json['updatedAt']) as String),
      localVersion: (json['local_version'] ?? json['localVersion']) as int,
    );
  }
}
