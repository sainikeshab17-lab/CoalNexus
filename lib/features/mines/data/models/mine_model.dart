import 'package:coalnexus/features/mines/domain/entities/mine.dart';

class MineModel extends Mine {
  const MineModel({
    required super.localId,
    super.serverId,
    required super.name,
    required super.mineCode,
    required super.latitude,
    required super.longitude,
    required super.status,
    super.company,
    super.district,
    super.state,
    super.ownerCode,
    super.ownerName,
    super.ownershipType,
    super.commodity,
    super.mineType,
    super.productionHist,
    super.coordinateAccuracy,
    super.source,
    required super.createdAt,
    required super.updatedAt,
    super.localVersion = 1,
  });

  factory MineModel.fromDomain(Mine mine, {int? localVersion}) {
    return MineModel(
      localId: mine.localId,
      serverId: mine.serverId,
      name: mine.name,
      mineCode: mine.mineCode,
      latitude: mine.latitude,
      longitude: mine.longitude,
      status: mine.status,
      company: mine.company,
      district: mine.district,
      state: mine.state,
      ownerCode: mine.ownerCode,
      ownerName: mine.ownerName,
      ownershipType: mine.ownershipType,
      commodity: mine.commodity,
      mineType: mine.mineType,
      productionHist: mine.productionHist,
      coordinateAccuracy: mine.coordinateAccuracy,
      source: mine.source,
      createdAt: mine.createdAt,
      updatedAt: mine.updatedAt,
      localVersion: localVersion ?? mine.localVersion,
    );
  }

  Mine toDomain() {
    return Mine(
      localId: localId,
      serverId: serverId,
      name: name,
      mineCode: mineCode,
      latitude: latitude,
      longitude: longitude,
      status: status,
      company: company,
      district: district,
      state: state,
      ownerCode: ownerCode,
      ownerName: ownerName,
      ownershipType: ownershipType,
      commodity: commodity,
      mineType: mineType,
      productionHist: productionHist,
      coordinateAccuracy: coordinateAccuracy,
      source: source,
      createdAt: createdAt,
      updatedAt: updatedAt,
      localVersion: localVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'server_id': serverId,
      'name': name,
      'mine_code': mineCode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'company': company,
      'district': district,
      'state': state,
      'owner_code': ownerCode,
      'owner_name': ownerName,
      'ownership_type': ownershipType,
      'commodity': commodity,
      'mine_type': mineType,
      'production_hist': productionHist,
      'coordinate_accuracy': coordinateAccuracy,
      'source': source,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'local_version': localVersion,
    };
  }

  factory MineModel.fromJson(Map<String, dynamic> json) {
    return MineModel(
      localId: json['local_id'] ?? json['localId'] as String? ?? 'loc_${json['id']}',
      serverId: (json['id'] ?? json['serverId']) as String?,
      name: json['name'] as String,
      mineCode: json['mine_code'] ?? json['mineCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: MineStatus.values.firstWhere((e) => e.name == json['status']),
      company: json['company'] as String?,
      district: json['district'] as String?,
      state: json['state'] as String?,
      ownerCode: json['owner_code'] as String?,
      ownerName: json['owner_name'] as String?,
      ownershipType: json['ownership_type'] as String?,
      commodity: json['commodity'] as String?,
      mineType: json['mine_type'] as String?,
      productionHist: json['production_hist'] != null ? (json['production_hist'] as num).toDouble() : null,
      coordinateAccuracy: json['coordinate_accuracy'] as String?,
      source: json['source'] as String?,
      createdAt: DateTime.parse(
        (json['created_at'] ?? json['createdAt']) as String,
      ),
      updatedAt: DateTime.parse(
        (json['updated_at'] ?? json['updatedAt']) as String,
      ),
      localVersion: (json['local_version'] ?? json['localVersion'] ?? 1) as int,
    );
  }
}
