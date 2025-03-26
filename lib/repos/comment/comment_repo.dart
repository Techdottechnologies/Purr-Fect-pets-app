import 'package:petcare/exceptions/exception_parsing.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/comment_model.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/repos/comment/validation.dart';
import 'package:petcare/services/web/firestore_services.dart';
import 'package:petcare/services/web/query_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';
import '../../utils/constants/firebase_collections.dart';

class CommentRepo {
  // ===========================Singleton Instance================================
  // static final CommentRepo _instance = CommentRepo._internal();
  // CommentRepo._internal();
  // factory CommentRepo() => _instance;

  // ===========================Properties================================

  // ===========================API Methods================================

  /// Add Comment
  static Future<CommentModel> addComment({
    required String comment,
    required String postId,
    required String contentId,
  }) async {
    try {
      await CommentValidation.validate(message: comment);
      final UserModel user = AppManager.currentUser!;

      final CommentModel model = CommentModel(
        uuid: "",
        createdAt: DateTime.now(),
        isEdited: false,
        commentBy: UserProfileModel(
            uid: user.uid, name: user.name, avatarUrl: user.avatar ?? ""),
        comment: comment,
        contentId: contentId,
        postId: postId,
      );
      final Map<String, dynamic> data = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_COMMENTS,
              data: model.toMap(),
              docIdFiled: 'uuid');
      return CommentModel.fromMap(data);
    } catch (e) {
      debugPrint("[debug AddComments] $e");
      throw throwAppException(e: e);
    }
  }

  /// Fetch CommentForPost
  static Future<List<CommentModel>> fetchComments({
    required String forPost,
    DocumentSnapshot? lastDoc,
    required Function(DocumentSnapshot) onGetLastDocSnap,
  }) async {
    try {
      final List<QueryModel> queries = [
        QueryModel(field: "contentId", value: forPost, type: QueryType.isEqual),
        QueryModel(field: "createdAt", value: true, type: QueryType.orderBy),
        QueryModel(field: "", value: 10, type: QueryType.limit),
      ];

      if (lastDoc != null) {
        queries.add(
          QueryModel(
              field: "", value: lastDoc, type: QueryType.startAfterDocument),
        );
      }
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_COMMENTS,
        queries: queries,
        lastDocSnapshot: (lastDoc) {
          if (lastDoc != null) {
            onGetLastDocSnap(lastDoc);
          }
        },
      );

      return data.map((e) => CommentModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("[debug fetchComments] $e");
      throw throwAppException(e: e);
    }
  }

  /// Fetch CommentForComment
  static Future<List<CommentModel>> fetchCommentsFor({
    required String commentId,
    DocumentSnapshot? lastDoc,
    required Function(DocumentSnapshot) onGetLastDocSnap,
  }) async {
    try {
      final List<QueryModel> queries = [
        QueryModel(
            field: "contentId", value: commentId, type: QueryType.isEqual),
        QueryModel(field: "createdAt", value: true, type: QueryType.orderBy),
        QueryModel(field: "", value: 2, type: QueryType.limit),
      ];

      if (lastDoc != null) {
        queries.add(QueryModel(
            field: "", value: lastDoc, type: QueryType.startAfterDocument));
      }
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_COMMENTS,
        queries: queries,
        lastDocSnapshot: (lastDoc) {
          if (lastDoc != null) {
            onGetLastDocSnap(lastDoc);
          }
        },
      );

      return data.map((e) => CommentModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("[debug fetchComments] $e");
      throw throwAppException(e: e);
    }
  }

  /// Count Comments for post
  static Future<int> countComments({required String postId}) async {
    try {
      final AggregateQuery query = FirebaseFirestore.instance
          .collection(FIREBASE_COLLECTION_COMMENTS)
          .where("postId", isEqualTo: postId)
          .count();
      final value = await query.get();
      return value.count ?? 0;
    } catch (e) {
      debugPrint("[debug commentCounts] $e");
      return 0;
    }
  }

  /// Count Comments for Comments
  static Future<int> countCommentsFor({required String commentId}) async {
    try {
      final AggregateQuery query = FirebaseFirestore.instance
          .collection(FIREBASE_COLLECTION_COMMENTS)
          .where("contentId", isEqualTo: commentId)
          .count();
      final value = await query.get();
      return value.count ?? 0;
    } catch (e) {
      debugPrint("[debug commentCounts] $e");
      return 0;
    }
  }
}
