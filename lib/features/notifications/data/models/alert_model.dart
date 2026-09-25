import 'package:coalnexus/features/notifications/domain/entities/alert.dart';

class AlertModel {
  final String localId;
  final String? serverId;
  final String mineId;
  final String title;
  final String message;
  final String severity;
  final String createdAt;
  final bool isRead;

  const AlertModel({
    required this.localId,
    this.serverId,
    required this.mineId,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    required this.isRead,
  });

  factory AlertModel.fromDomain(Alert alert) {
    return AlertModel(
      localId: alert.localId,
      serverId: alert.serverId,
      mineId: alert.mineId,
      title: alert.title,
      message: alert.message,
      severity: alert.severity.name.toUpperCase(),
      createdAt: alert.createdAt.toIso8601String(),
      isRead: alert.isRead,
    );
  }

  Alert toDomain() {
    return Alert(
      localId: localId,
      serverId: serverId,
      mineId: mineId,
      title: title,
      message: message,
      severity: AlertSeverity.values.firstWhere(
        (e) => e.name.toUpperCase() == severity.toUpperCase(),
        orElse: () => AlertSeverity.medium,
      ),
      createdAt: DateTime.parse(createdAt),
      isRead: isRead,
    );
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      localId: (json['local_id'] ?? json['localId']) as String,
      serverId: (json['server_id'] ?? json['id'] ?? json['serverId']) as String?,
      mineId: (json['mine_id'] ?? json['mineId']) as String,
      title: json['title'] as String,
      message: json['message'] as String,
      severity: json['severity'] as String,
      createdAt: (json['created_at'] ?? json['createdAt']) as String,
      isRead: (json['is_read'] ?? json['isRead']) as bool? ?? false,
    );
  }
}
