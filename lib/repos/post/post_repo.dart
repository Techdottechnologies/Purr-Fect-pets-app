// Project: 	   barkingclub
// File:    	   post_repo
// Path:    	   lib/repos/post/post_repo.dart
// Author:       Ali Akbar
// Date:        26-06-24 12:20:48 -- Wednesday
// Description:

import 'dart:io';

import 'package:petcare/exceptions/exception_parsing.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/post_model.dart';
import 'package:petcare/repos/post/validation.dart';
import 'package:petcare/utils/constants/firebase_collections.dart';
import 'package:petcare/services/web/firestore_services.dart';
import 'package:petcare/services/web/query_model.dart';
import 'package:petcare/services/web/storage_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DocumentSnapshot? _lastOwnDocSnap;
DocumentSnapshot? _lastAllDocSnap;
bool _isLastOwnSnap = false;
bool _isAllOwnSnap = false;

class PostRepo {
  /// Create Post

  static Future<void> create({required PostModel model}) async {
    try {
      await PostValidation.validate(model: model);

      /// Upload Media
      if (model.media.mediaUrl != null && model.media.mediaUrl != "") {
        final downloadUrl = await StorageService().uploadImage(
            withFile: File(model.media.mediaUrl!),
            collectionPath:
                "$FIREBASE_COLLECTION_POSTS/${AppManager.currentUser?.uid ?? "--"}/${DateTime.now().millisecondsSinceEpoch}.jpeg");
        model = model.copyWith(
            media: PostMediaModel(
                content: model.media.content, mediaUrl: downloadUrl));
      }

      final Map<String, dynamic> data = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_POSTS,
              data: model.toMap(),
              docIdFiled: 'uuid');

      final PostModel post = PostModel.fromMap(data);
      AppManager.ownPosts.insert(0, post);
      AppManager.posts.insert(0, post);
    } catch (e) {
      debugPrint("[debug CreatePost] ${e.toString()}");
      throw throwAppException(e: e);
    }
  }

  /// Update Post
  static Future<PostModel> update({required PostModel model}) async {
    try {
      await PostValidation.validate(model: model);

      /// Upload Media
      if (model.media.mediaUrl != null &&
          model.media.mediaUrl != "" &&
          Uri.parse(model.media.mediaUrl!).host.isEmpty) {
        final downloadUrl = await StorageService().uploadImage(
            withFile: File(model.media.mediaUrl!),
            collectionPath:
                "$FIREBASE_COLLECTION_POSTS/${AppManager.currentUser?.uid ?? "--"}/${DateTime.now().millisecondsSinceEpoch}.jpeg");
        model = model.copyWith(
            media: PostMediaModel(
                content: model.media.content, mediaUrl: downloadUrl));
      }

      final Map<String, dynamic> data =
          await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_POSTS,
        data: model.toMap(),
        docId: model.uuid,
      );

      final PostModel post = PostModel.fromMap(data);
      final int index =
          AppManager.ownPosts.indexWhere((e) => e.uuid == post.uuid);
      if (index > -1) {
        AppManager.ownPosts[index] = post;
      }

      final int i = AppManager.posts.indexWhere((e) => e.uuid == post.uuid);
      if (index > -1) {
        AppManager.posts[i] = post;
      }

      return post;
    } catch (e) {
      debugPrint("[debug UpdatePost] ${e.toString()}");
      throw throwAppException(e: e);
    }
  }

  /// Fetch Own Posts
  static Future<void> fetchOwn() async {
    try {
      if (_isLastOwnSnap) {
        return;
      }
      final String userId = AppManager.currentUser?.uid ?? "";
      final List<QueryModel> quries = [
        QueryModel(
            field: "userInfo.uid", value: userId, type: QueryType.isEqual),
        QueryModel(field: "createdAt", value: true, type: QueryType.orderBy),
        QueryModel(field: "", value: 10, type: QueryType.limit),
      ];

      if (_lastOwnDocSnap != null) {
        quries.add(
          QueryModel(
              field: "",
              value: _lastOwnDocSnap,
              type: QueryType.startAfterDocument),
        );
      }

      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_POSTS,
        queries: quries,
        lastDocSnapshot: (snap) {
          if (snap != null) {
            _lastOwnDocSnap = snap;
          }
          _isLastOwnSnap = snap == null;
        },
      );

      final List<PostModel> posts =
          data.map((e) => PostModel.fromMap(e)).toList();
      for (final PostModel post in posts) {
        final int index =
            AppManager.ownPosts.indexWhere((e) => e.uuid == post.uuid);
        if (index <= -1) {
          AppManager.ownPosts.add(post);
        } else {
          AppManager.ownPosts[index] = post;
        }

        AppManager.posts.insert(0, post);
      }
    } catch (e) {
      debugPrint("[debug FetchWonPosts] ${e.toString()}");
      throw throwAppException(e: e);
    }
  }

  /// Fetch Own Posts
  static Future<void> fetchAll(bool isFetchNew) async {
    try {
      if (_isAllOwnSnap) {
        return;
      }
      final List<QueryModel> quries = [
        QueryModel(field: "createdAt", value: true, type: QueryType.orderBy),
        QueryModel(field: "", value: 10, type: QueryType.limit),
      ];

      if (_lastAllDocSnap != null && !isFetchNew) {
        quries.add(
          QueryModel(
              field: "",
              value: _lastAllDocSnap,
              type: QueryType.startAfterDocument),
        );
      }

      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_POSTS,
        queries: quries,
        lastDocSnapshot: (snap) {
          if (snap != null) {
            _lastAllDocSnap = snap;
          }
          _isAllOwnSnap = snap == null;
        },
      );

      final List<PostModel> posts =
          data.map((e) => PostModel.fromMap(e)).toList();
      for (final PostModel post in posts) {
        final int index =
            AppManager.posts.indexWhere((e) => e.uuid == post.uuid);
        if (index <= -1) {
          AppManager.posts.add(post);
        } else {
          AppManager.posts[index] = post;
        }
      }
      AppManager.posts.sort((a, b) => b.createdAt.millisecondsSinceEpoch
          .compareTo(a.createdAt.millisecondsSinceEpoch));
    } catch (e) {
      debugPrint("[debug FetchWonPosts] ${e.toString()}");
      throw throwAppException(e: e);
    }
  }

  static Future<void> delete({required String uuid}) async {
    try {
      FirestoreService()
          .delete(collection: FIREBASE_COLLECTION_POSTS, docId: uuid);
      final int index = AppManager.ownPosts.indexWhere((e) => e.uuid == uuid);
      if (index > -1) {
        AppManager.ownPosts.removeAt(index);
      }

      final int i = AppManager.posts.indexWhere((e) => e.uuid == uuid);
      if (index > -1) {
        AppManager.posts.removeAt(i);
      }
    } catch (e) {
      debugPrint("[debug DeletePost] ${e.toString()}");
      throw throwAppException(e: e);
    }
  }
}
