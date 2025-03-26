

import 'dart:convert';

import 'package:petcare/utils/constants/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_profile_model.dart';

class LikeModel {
  final String uuid;
  final DateTime likedAt;
  final UserProfileModel likedBy;
  final String contentId;
  final LikeType type;
  LikeModel({
    required this.uuid,
    required this.likedAt,
    required this.likedBy,
    required this.contentId,
    required this.type,
  });

  LikeModel copyWith({
    String? uuid,
    DateTime? likedAt,
    UserProfileModel? likedBy,
    String? contentId,
    LikeType? type,
  }) {
    return LikeModel(
      uuid: uuid ?? this.uuid,
      likedAt: likedAt ?? this.likedAt,
      likedBy: likedBy ?? this.likedBy,
      contentId: contentId ?? this.contentId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'likedAt': Timestamp.fromDate(likedAt),
      'likedBy': likedBy.toMap(),
      'contentId': contentId,
      'type': type.name.toLowerCase(),
    };
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      uuid: map['uuid'] as String,
      likedAt: (map['likedAt'] as Timestamp).toDate(),
      likedBy: UserProfileModel.fromMap(map['likedBy'] as Map<String, dynamic>),
      contentId: map['contentId'] as String,
      type: LikeType.values
          .firstWhere((e) => e.name.toLowerCase() == map['type'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeModel.fromJson(String source) =>
      LikeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LikeModel(uuid: $uuid, likedAt: $likedAt, likedBy: $likedBy, contentId: $contentId, type: $type)';
  }

  @override
  bool operator ==(covariant LikeModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.likedAt == likedAt &&
        other.likedBy == likedBy &&
        other.contentId == contentId &&
        other.type == type;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        likedAt.hashCode ^
        likedBy.hashCode ^
        contentId.hashCode ^
        type.hashCode;
  }
}
