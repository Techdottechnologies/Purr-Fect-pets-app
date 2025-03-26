// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:petcare/utils/constants/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'user_profile_model.dart';

class PostModel {
  final String uuid;
  final DateTime createdAt;
  final PostMediaModel media;
  final UserProfileModel userInfo;
  final PostStatus? status;

  PostModel({
    required this.uuid,
    required this.createdAt,
    required this.media,
    required this.userInfo,
    this.status,
  });

  PostModel copyWith({
    String? uuid,
    DateTime? createdAt,
    PostMediaModel? media,
    UserProfileModel? userInfo,
    PostStatus? status,
  }) {
    return PostModel(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      media: media ?? this.media,
      userInfo: userInfo ?? this.userInfo,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'createdAt': Timestamp.fromDate(createdAt),
      'media': media.toMap(),
      'userInfo': userInfo.toMap(),
      'status': status?.name.toLowerCase(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uuid: map['uuid'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      media: PostMediaModel.fromMap(map['media'] as Map<String, dynamic>),
      userInfo:
          UserProfileModel.fromMap(map['userInfo'] as Map<String, dynamic>),
      status: PostStatus.values.firstWhereOrNull((e) =>
              e.name.toLowerCase() ==
              (map['status'] as String).toLowerCase()) ??
          PostStatus.moody,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(uuid: $uuid, createdAt: $createdAt, media: $media, userInfo: $userInfo, status: $status)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.createdAt == createdAt &&
        other.media == media &&
        other.status == status &&
        other.userInfo == userInfo;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        createdAt.hashCode ^
        media.hashCode ^
        status.hashCode ^
        userInfo.hashCode;
  }
}

class PostMediaModel {
  final String? content;
  final String? mediaUrl;
  PostMediaModel({
    this.content,
    this.mediaUrl,
  });

  PostMediaModel copyWith({
    String? content,
    String? mediaUrl,
  }) {
    return PostMediaModel(
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'mediaUrl': mediaUrl,
    };
  }

  factory PostMediaModel.fromMap(Map<String, dynamic> map) {
    return PostMediaModel(
      content: map['content'] != null ? map['content'] as String : null,
      mediaUrl: map['mediaUrl'] != null ? map['mediaUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostMediaModel.fromJson(String source) =>
      PostMediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostMediaModel(content: $content, mediaUrl: $mediaUrl)';

  @override
  bool operator ==(covariant PostMediaModel other) {
    if (identical(this, other)) return true;

    return other.content == content && other.mediaUrl == mediaUrl;
  }

  @override
  int get hashCode => content.hashCode ^ mediaUrl.hashCode;
}
