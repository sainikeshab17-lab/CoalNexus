import 'package:coalnexus/shared/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.permissions,
    super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleString = json['role'] as String;
    final role = UserRole.values.firstWhere(
      (e) => e.name == roleString,
      orElse: () => UserRole.inspector,
    );

    final permissionsList = json['permissions'] as List<dynamic>? ?? [];
    final permissions = permissionsList
        .map((p) => UserPermission.values.firstWhere(
              (e) => e.name == p.toString(),
              orElse: () => UserPermission.viewDashboard,
            ))
        .toSet();

    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: role,
      permissions: permissions,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'permissions': permissions.map((p) => p.name).toList(),
      'isActive': isActive,
    };
  }
}
