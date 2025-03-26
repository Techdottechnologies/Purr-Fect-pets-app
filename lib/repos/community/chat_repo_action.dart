// Project: 	   barkingclub
// File:    	   chat_repo_action
// Path:    	   lib/repos/community/chat_repo_action.dart
// Author:       Ali Akbar
// Date:        11-07-24 13:54:50 -- Thursday
// Description:

import 'dart:io';

import 'package:petcare/exceptions/data_exceptions.dart';
import 'package:petcare/models/chat_model.dart';
import 'package:petcare/models/notification_model.dart';
import 'package:petcare/repos/community/chat_repo_interface.dart';
import 'package:petcare/repos/community/chat_repo_read.dart';
import 'package:petcare/repos/community/validation.dart';
import 'package:petcare/repos/notification_repo.dart';
import 'package:petcare/services/notifications/fire_notification.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/helping_methods.dart';
import 'package:petcare/services/web/web_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../manager/app_manager.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../models/user_profile_model.dart';
import '../../utils/constants/firebase_collections.dart';
import '../../services/web/storage_services.dart';

class ChatRepoAction extends ChatRepoInterface with ChatRepoMixin {
  final UserModel currentUser = AppManager.currentUser!;

  @override
  Future<ChatModel> createGroupChat(
      {String? title,
      String? avatar,
      int? totoalMemebrs,
      String? description}) async {
    await ChatValidation.chat(max: totoalMemebrs ?? 0, name: title);
    final List<UserProfileModel> participants = [];
    final List<String> participantIds = [];
    if (avatar != null && Uri.parse(avatar).host.isEmpty) {
      avatar = await StorageService().uploadImage(
        withFile: File(avatar),
        collectionPath:
            "$FIREBASE_COLLECTION_CHAT/${DateTime.now().millisecondsSinceEpoch}",
      );
    }
    // Current User Info
    participantIds.add(currentUser.uid);
    participants.add(
      UserProfileModel(
        uid: currentUser.uid,
        name: currentUser.name,
        avatarUrl: currentUser.avatar ?? "",
      ),
    );

    final ChatModel chatModel = ChatModel(
      uuid: "",
      createdAt: DateTime.now(),
      createdBy: currentUser.uid,
      participants: participants,
      participantUids: participantIds,
      maxMemebrs: totoalMemebrs ?? 0,
      avatar: avatar,
      description: description,
      title: title!,
      admins: [currentUser.uid],
      prohibitedUsers: [],
      lastMessage: MessageModel(
        messageId: "",
        conversationId: "",
        content: "",
        messageTime: DateTime.now(),
        type: MessageType.text,
        senderId: "",
        senderName: "",
        senderAvatar: "",
      ),
    );

    return await WebServices().save<ChatModel>(
      path: FIREBASE_COLLECTION_CHAT,
      model: chatModel,
      docIdFiled: 'uuid',
    );
  }

  @override
  Future<void> update(
      {String? title,
      String? avatar,
      int? totoalMemebrs,
      String? description,
      required String chatId}) async {
    await ChatValidation.chat(max: totoalMemebrs ?? 0, name: title);

    if (avatar != null && Uri.parse(avatar).host.isEmpty) {
      avatar = await StorageService().uploadImage(
        withFile: File(avatar),
        collectionPath:
            "$FIREBASE_COLLECTION_CHAT/${DateTime.now().millisecondsSinceEpoch}",
      );
    }

    await WebServices().update(
      path: FIREBASE_COLLECTION_CHAT,
      data: {
        "title": title,
        "titles": generateSubstrings(title ?? ""),
        "avatar": avatar,
        "maxMemebrs": totoalMemebrs,
        "description": description,
      },
      docId: chatId,
    );
  }

  /// Member Action
  @override
  Future<void> addTo({required String chatId, required String addBy}) async {
    final me = UserProfileModel(
        uid: currentUser.uid,
        name: currentUser.name,
        avatarUrl: currentUser.avatar ?? "");
    final chat = await ChatRepoRead().fetchChat(byUuid: chatId);
    if (chat.participantUids.contains(me.uid)) {
      throw throwDataException(
          errorCode: 'already', message: "Invitaion expired.");
    }
    if (chat.participantUids.length >= chat.maxMemebrs) {
      throw throwDataException(
          errorCode: 'exceed',
          message: "This community reached the member joining limit.");
    }

    await WebServices().update(
      path: FIREBASE_COLLECTION_CHAT,
      docId: chatId,
      data: {
        "participantUids": FieldValue.arrayUnion([me.uid]),
        "participants": FieldValue.arrayUnion([me.toMap()]),
        "prohibitedUsers": FieldValue.arrayRemove([me.uid]),
      },
    );
  }

  @override
  Future<void> SendInvites(
      {required ChatModel chat, required List<UserProfileModel> users}) async {
    for (final receiver in users) {
      NotificationRepo().save(
        recieverId: receiver.uid,
        title: currentUser.name,
        message: "${currentUser.name} wants to add you in a ${chat.title}.",
        avatar: currentUser.avatar ?? "",
        type: NotificationType.invite,
        data: {
          'type': 'chat',
          'chat': chat.toMap(),
        },
      );

      FireNotification.fire(
          title: currentUser.name,
          description:
              "${currentUser.name} wants to add you in a ${chat.title}.",
          topic: "$PUSH_NOTIFICATION_USER${receiver.uid}",
          type: NotificationType.invite.toString(),
          additionalData: {
            'type': 'chat',
            'chat': chat.toMap(toJson: true),
          });
    }
  }

  @override
  Future<void> joinChat({required String chatId}) async {
    final chat = await ChatRepoRead().fetchChat(byUuid: chatId);
    if (chat.prohibitedUsers.contains(currentUser.uid)) {
      throw throwDataException(
          errorCode: 'not-allow',
          message: "You can't join this community because you were removed.");
    }

    if (chat.participantUids.length >= chat.maxMemebrs) {
      throw throwDataException(
          errorCode: 'exceed',
          message:
              "You can't join this community because it reached the member joining limit.");
    }
    await WebServices().update(
      path: FIREBASE_COLLECTION_CHAT,
      docId: chatId,
      data: {
        "participantUids": FieldValue.arrayUnion([currentUser.uid]),
        "participants": FieldValue.arrayUnion(
          [
            UserProfileModel(
                    uid: currentUser.uid,
                    name: currentUser.name,
                    avatarUrl: currentUser.avatar ?? "")
                .toMap()
          ],
        ),
      },
    );
  }

  @override
  Future<void> removeMember(
      {required String chatId, required UserProfileModel member}) async {
    await WebServices().update(
      path: FIREBASE_COLLECTION_CHAT,
      docId: chatId,
      data: {
        "participantUids": FieldValue.arrayRemove([member.uid]),
        "participants": FieldValue.arrayRemove([member.toMap()]),
        "prohibitedUsers": FieldValue.arrayUnion([member.uid]),
      },
    );
  }

  @override
  Future<void> exitChat(
      {required String chatId,
      required List<UserProfileModel> members,
      required bool isAdmin,
      required bool isCreator}) async {
    final index = members.indexWhere((e) => e.uid == currentUser.uid);
    final exit = members[index];
    members.removeAt(index);

    final Map<String, dynamic> data = {
      "participantUids": FieldValue.arrayRemove([currentUser.uid]),
      "participants": FieldValue.arrayRemove([exit.toMap()]),
    };

    if (isAdmin) {
      data['admins'] = FieldValue.arrayRemove([exit.uid]);
      if (members.isNotEmpty)
        data['admins'] = FieldValue.arrayUnion([members.first.uid]);
    }

    if (isCreator && members.isNotEmpty) {
      data['createdBy'] = members.first.uid;
    }

    debugPrint("Exit Member Data: ${data.toString()}");
    await WebServices()
        .update(path: FIREBASE_COLLECTION_CHAT, docId: chatId, data: data);
  }

  @override
  Future<void> addAdmin(
      {required String chatId, required UserProfileModel user}) async {
    await WebServices().update(
      path: FIREBASE_COLLECTION_CHAT,
      docId: chatId,
      data: {
        "admins": FieldValue.arrayUnion([user.uid]),
      },
    );
  }

  @override
  Future<void> removeAdmin(
      {required String chatId, required UserProfileModel user}) async {
    await WebServices().update(
      path: FIREBASE_COLLECTION_CHAT,
      docId: chatId,
      data: {
        "admins": FieldValue.arrayRemove([user.uid])
      },
    );
  }

  @override
  Future<void> deleteChat({required String chatId}) async {
    WebServices().delete(collection: FIREBASE_COLLECTION_CHAT, docId: chatId);
  }
}
