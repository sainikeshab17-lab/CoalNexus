import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  inspector,
  manager,
}

enum UserPermission {
  viewDashboard,
  viewMine,
  createInspection,
  editInspection,
  submitInspection,
  viewViolation,
  createViolation,
  assignCorrectiveAction,
  verifyCorrectiveAction,
  viewRisk,
  viewAuditLog,
}

@immutable
class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final Set<UserPermission> permissions;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.permissions,
    this.isActive = true,
  });

  bool hasPermission(UserPermission permission) {
    return permissions.contains(permission);
  }

  bool hasRole(UserRole targetRole) {
    return role == targetRole;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          setEquals(permissions, other.permissions) &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      role.hashCode ^
      permissions.hashCode ^
      isActive.hashCode;
}
