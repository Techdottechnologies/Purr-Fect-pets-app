// ignore_for_file: public_member_api_docs, sort_constructors_first
// Project: 	   muutsch
// File:    	   chat_model
// Path:    	   lib/models/chat_model.dart
// Author:       Ali Akbar
// Date:        31-05-24 12:02:07 -- Friday
// Description:

import 'package:petcare/utils/helping_methods.dart';
import 'package:petcare/services/web/model_prototype.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'message_model.dart';
import 'user_profile_model.dart';

class ChatModel implements ModelPrototype {
  final String uuid;
  final DateTime createdAt;
  final String createdBy;
  final List<UserProfileModel> participants;
  final List<String> participantUids;
  final String title;
  final int maxMemebrs;
  final String? avatar;
  final String? description;
  final MessageModel? lastMessage;
  final List<String> admins;
  final List<String> prohibitedUsers;

  ChatModel({
    required this.uuid,
    required this.createdAt,
    required this.createdBy,
    required this.participants,
    required this.participantUids,
    required this.maxMemebrs,
    required this.title,
    this.avatar,
    this.description,
    this.lastMessage,
    required this.admins,
    required this.prohibitedUsers,
  });

  ChatModel copyWith({
    String? uuid,
    DateTime? createdAt,
    String? createdBy,
    List<UserProfileModel>? participants,
    List<String>? participantUids,
    List<String>? prohibitedUsers,
    List<String>? admins,
    int? maxMemebrs,
    String? avatar,
    String? description,
    String? title,
    MessageModel? lastMessage,
  }) {
    return ChatModel(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      participants: participants ?? this.participants,
      prohibitedUsers: prohibitedUsers ?? this.prohibitedUsers,
      admins: admins ?? this.admins,
      participantUids: participantUids ?? this.participantUids,
      maxMemebrs: maxMemebrs ?? this.maxMemebrs,
      title: title ?? this.title,
      avatar: avatar ?? avatar,
      lastMessage: lastMessage,
    );
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'uuid': uuid,
      'createdAt': toJson
          ? createdAt.millisecondsSinceEpoch
          : Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'participants': participants.map((x) => x.toMap()).toList(),
      'participantUids': participantUids,
      'admins': admins,
      'prohibitedUsers': prohibitedUsers,
      'maxMemebrs': maxMemebrs,
      'description': description,
      'title': title,
      'avatar': avatar,
      'lastMessage': lastMessage?.toMap(toJson: toJson),
      'titles': generateSubstrings(title.toLowerCase()),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        uuid: map['uuid'] as String,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        createdBy: map['createdBy'] as String,
        description: map['description'] as String?,
        participants: (map['participants'] as List<dynamic>)
            .map((e) => UserProfileModel.fromMap(e))
            .toList(),
        participantUids: List<String>.from(map['participantUids'] as List),
        admins: map['admins'] != null
            ? List<String>.from(map['admins'] as List)
            : [],
        prohibitedUsers: map['prohibitedUsers'] != null
            ? List<String>.from(map['prohibitedUsers'] as List)
            : [],
        maxMemebrs:
            map['maxMemebrs'] == null ? 0 : map['maxMemebrs'] as int? ?? 0,
        title: map['title'] as String,
        avatar: map['avatar'] as String?,
        lastMessage:
            MessageModel.fromMap(map['lastMessage'] as Map<String, dynamic>));
  }
  @override
  String toString() {
    return 'ChatModel(uuid: $uuid, createdAt: $createdAt, createdBy: $createdBy, participants: $participants, participantUids: $participantUids, maxMemebrs: $maxMemebrs, title: $title, avatar: $avatar, lastMessage: $lastMessage)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        listEquals(other.participants, participants) &&
        listEquals(other.participantUids, participantUids) &&
        other.maxMemebrs == maxMemebrs &&
        other.title == title &&
        other.lastMessage == lastMessage &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        participants.hashCode ^
        participantUids.hashCode ^
        maxMemebrs.hashCode ^
        title.hashCode ^
        lastMessage.hashCode ^
        avatar.hashCode;
  }

  @override
  T fromMap<T>(Map<String, dynamic> map) {
    return ChatModel(
      uuid: map['uuid'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      description: map['description'] as String?,
      participants: (map['participants'] as List<dynamic>)
          .map((e) => UserProfileModel.fromMap(e))
          .toList(),
      participantUids: List<String>.from(map['participantUids'] as List),
      admins:
          map['admins'] != null ? List<String>.from(map['admins'] as List) : [],
      prohibitedUsers: map['prohibitedUsers'] != null
          ? List<String>.from(map['prohibitedUsers'] as List)
          : [],
      maxMemebrs:
          map['maxMemebrs'] == null ? 0 : map['maxMemebrs'] as int? ?? 0,
      title: map['title'] as String,
      avatar: map['avatar'] as String?,
      lastMessage:
          MessageModel.fromMap(map['lastMessage'] as Map<String, dynamic>),
    ) as T;
  }
}
