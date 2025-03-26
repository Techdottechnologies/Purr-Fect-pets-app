// Project: 	   muutsch
// File:    	   notification_repo
// Path:    	   lib/repos/notification_repo.dart
// Author:       Ali Akbar
// Date:        29-05-24 16:45:35 -- Wednesday
// Description:

import 'dart:developer';

import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:flutter/foundation.dart';

import '../exceptions/exception_parsing.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../services/web/firestore_services.dart';
import '../services/web/query_model.dart';

class NotificationRepo {
  // ===========================Singleton Instance================================
  static final NotificationRepo _instance = NotificationRepo._internal();
  NotificationRepo._internal();
  factory NotificationRepo() => _instance;
  // ===========================Properties================================

  // ===========================Methods================================
  Future<void> fetch({
    required Function(NotificationModel) onAdded,
    required Function(NotificationModel) onRemoved,
    required Function(NotificationModel) onUpdated,
    required VoidCallback onGetAll,
    required Function(AppException) onError,
  }) async {
    final String userId = AppManager.currentUser?.uid ?? "";

    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_NOTIFICATION,
      onError: (e) {
        log("[debug fetchNotification] $e");
        onError(throwAppException(e: e));
      },
      onAdded: (data) {
        onAdded(NotificationModel.fromMap(data));
      },
      onRemoved: (data) {
        onRemoved(NotificationModel.fromMap(data));
      },
      onUpdated: (data) {
        onUpdated(NotificationModel.fromMap(data));
      },
      onAllDataGet: onGetAll,
      onCompleted: (_) {
        _?.cancel();
      },
      queries: [
        QueryModel(
          field: "receiverId",
          value: userId,
          type: QueryType.isEqual,
        ),
        QueryModel(field: "", value: 50, type: QueryType.limit),
        QueryModel(field: "createdAt", value: true, type: QueryType.orderBy),
      ],
    );
  }

  Future<void> save(
      {required String recieverId,
      required String title,
      String? contentId,
      required String message,
      Map<String, dynamic>? data,
      required String avatar,
      required NotificationType type}) async {
    try {
      final UserModel user = AppManager.currentUser!;
      final NotificationModel model = NotificationModel(
        uuid: "",
        title: title,
        message: message,
        senderId: user.uid,
        receiverId: recieverId,
        type: type,
        createdAt: DateTime.now(),
        avatar: avatar,
        contentId: contentId ?? user.uid,
        data: data,
        isRead: false,
      );
      FirestoreService().saveWithSpecificIdFiled(
          path: FIREBASE_COLLECTION_NOTIFICATION,
          data: model.toMap(),
          docIdFiled: 'uuid');
    } catch (e) {
      log("[debug saveNotification] $e");
      throw throwAppException(e: e);
    }
  }

  Future<void> markRead({required String notificationId}) async {
    await FirestoreService().updateWithDocId(
      path: FIREBASE_COLLECTION_NOTIFICATION,
      docId: notificationId,
      data: {'isRead': true},
    );
  }

  Future<void> update(
      {required String id, required Map<String, dynamic> data}) async {
    try {
      await FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_NOTIFICATION, docId: id, data: data);
    } catch (e) {
      log(e.toString());
    }
  }

  /// Delete Notification
  void delete({required String notificationId}) async {
    FirestoreService().delete(
        collection: FIREBASE_COLLECTION_NOTIFICATION, docId: notificationId);
  }
}
