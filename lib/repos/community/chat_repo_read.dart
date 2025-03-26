// Project: 	   barkingclub
// File:    	   chat_repo_read
// Path:    	   lib/repos/community/chat_repo_read.dart
// Author:       Ali Akbar
// Date:        11-07-24 13:50:34 -- Thursday
// Description:

// ===========================Fetch Methods================================
import 'dart:developer';
import 'dart:ui';

import 'package:petcare/exceptions/data_exceptions.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/services/web/web_services.dart';
import 'package:flutter/material.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/exception_parsing.dart';
import '../../models/chat_model.dart';
import '../../utils/constants/firebase_collections.dart';
import '../../services/web/firestore_services.dart';
import '../../services/web/query_model.dart';
import 'chat_repo_interface.dart';

class ChatRepoRead extends ChatRepoInterface with ChatRepoMixin {
  final UserModel? user = AppManager.currentUser;
  @override
  Future<void> fetchChats({
    required Function(ChatModel) onAdded,
    required Function(ChatModel) onDeleted,
    required Function(ChatModel) onUpdated,
    required Function(AppException) onError,
    required VoidCallback onFetchedAll,
  }) async {
    final List<QueryModel> queries = [
      QueryModel(
        field: "participantUids",
        value: user?.uid,
        type: QueryType.arrayContains,
      ),
      QueryModel(
        field: "lastMessage.messageTime",
        value: true,
        type: QueryType.orderBy,
      ),
      QueryModel(field: "", value: 20, type: QueryType.limit),
    ];

    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_CHAT,
      onError: (e) {
        log("[debug FetchChats] $e");
        onError(throwAppException(e: e));
      },
      onAdded: (data) {
        final chat = ChatModel.fromMap(data);
        onAdded(chat);
      },
      onRemoved: (data) {
        final chat = ChatModel.fromMap(data);
        onDeleted(chat);
      },
      onUpdated: (data) {
        final chat = ChatModel.fromMap(data);
        onUpdated(chat);
      },
      onAllDataGet: () {
        onFetchedAll();
      },
      onCompleted: (l) {},
      queries: queries,
    );
  }

  @override
  Future<List<ChatModel>> searchChats({required String by}) async {
    try {
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_CHAT,
        queries: [
          QueryModel(
            field: 'titles',
            value: [by],
            type: QueryType.arrayContainsAny,
          ),
        ],
      );

      if (data.isNotEmpty) {
        return data.map((e) => ChatModel.fromMap(e)).toList();
      }
      throw DataExceptionNotFound();
    } catch (e) {
      log("[search chat] $e");
      throw throwAppException(e: e);
    }
  }

  @override
  Future<ChatModel> fetchChat({required String byUuid}) async {
    final Map<String, dynamic>? map = await WebServices()
        .fetch(path: FIREBASE_COLLECTION_CHAT, docId: byUuid);
    if (map == null) {
      throw throwDataException(errorCode: 'NOT-FOUND');
    }
    return ChatModel.fromMap(map);
  }
}
