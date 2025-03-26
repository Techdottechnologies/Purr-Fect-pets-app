import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_profile_model.dart';

class CommentModel {
  final String uuid;
  final DateTime createdAt;
  final bool isEdited;
  final DateTime? editedAt;
  final UserProfileModel commentBy;
  final String comment;
  final String contentId;
  final String postId;
  CommentModel({
    required this.uuid,
    required this.createdAt,
    required this.isEdited,
    this.editedAt,
    required this.commentBy,
    required this.comment,
    required this.contentId,
    required this.postId,
  });

  CommentModel copyWith({
    String? uuid,
    DateTime? createdAt,
    bool? isEdited,
    DateTime? editedAt,
    UserProfileModel? commentBy,
    String? comment,
    String? contentId,
    String? postId,
  }) {
    return CommentModel(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      commentBy: commentBy ?? this.commentBy,
      comment: comment ?? this.comment,
      contentId: contentId ?? this.contentId,
      postId: postId ?? this.postId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'createdAt': Timestamp.fromDate(createdAt),
      'isEdited': isEdited,
      'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
      'commentBy': commentBy.toMap(),
      'comment': comment,
      'contentId': contentId,
      'postId': postId,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uuid: map['uuid'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isEdited: map['isEdited'] as bool,
      editedAt: map['editedAt'] == null
          ? null
          : (map['editedAt'] as Timestamp).toDate(),
      commentBy:
          UserProfileModel.fromMap(map['commentBy'] as Map<String, dynamic>),
      comment: map['comment'] as String,
      contentId: map['contentId'] as String,
      postId: map['postId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(uuid: $uuid, createdAt: $createdAt, isEdited: $isEdited, editedAt: $editedAt, commentBy: $commentBy, comment: $comment, contentId: $contentId, postId: $postId)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.createdAt == createdAt &&
        other.isEdited == isEdited &&
        other.editedAt == editedAt &&
        other.commentBy == commentBy &&
        other.comment == comment &&
        other.contentId == contentId;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        createdAt.hashCode ^
        isEdited.hashCode ^
        editedAt.hashCode ^
        commentBy.hashCode ^
        comment.hashCode ^
        contentId.hashCode;
  }
}
