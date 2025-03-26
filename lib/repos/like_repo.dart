import 'package:petcare/exceptions/exception_parsing.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/like_model.dart';
import 'package:petcare/utils/constants/firebase_collections.dart';
import 'package:petcare/services/web/firestore_services.dart';
import 'package:petcare/services/web/query_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikeRepo {
  // ===========================Singleton Instance================================
  static final LikeRepo _instance = LikeRepo._internal();
  LikeRepo._internal();
  factory LikeRepo() => _instance;
  // ===========================Properties================================

  // ===========================API Methods================================

  Future<LikeModel> addLike({required LikeModel model}) async {
    try {
      final data = await FirestoreService().saveWithSpecificIdFiled(
          path: FIREBASE_COLLECTION_LIKES,
          data: model.toMap(),
          docIdFiled: "uuid");
      return LikeModel.fromMap(data);
    } catch (e) {
      debugPrint("[debug LiKeRpo] $e");
      throw throwAppException(e: e);
    }
  }

  Future<void> removeLike({required String uuid}) async {
    try {
      FirestoreService()
          .delete(collection: FIREBASE_COLLECTION_LIKES, docId: uuid);
    } catch (e) {
      debugPrint("[debug RemoveLike] $e");
    }
  }

  Future<Set<dynamic>> getLikeData({required String contentId}) async {
    try {
      final AggregateQuery query = FirebaseFirestore.instance
          .collection(FIREBASE_COLLECTION_LIKES)
          .where("contentId", isEqualTo: contentId)
          .count();
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_LIKES,
        queries: [
          QueryModel(
              field: "contentId", value: contentId, type: QueryType.isEqual),
          QueryModel(
              field: "likedBy.uid",
              value: [AppManager.currentUser?.uid],
              type: QueryType.whereIn),
          QueryModel(field: "", value: 1, type: QueryType.limit),
        ],
      );

      final value = await query.get();

      if (data.isNotEmpty) {
        return {
          (value.count ?? 0),
          LikeModel.fromMap(data.first),
        };
      }
      return {value.count ?? 0};
    } catch (e) {
      debugPrint("[debug likecounts] $e");
      return {0};
    }
  }
}
