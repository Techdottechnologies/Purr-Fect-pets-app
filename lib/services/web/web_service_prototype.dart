// Project: 	   balanced_workout
// File:    	   web_service_prototype
// Path:    	   lib/web_services/web_service_prototype.dart
// Author:       Ali Akbar
// Date:        06-07-24 12:11:19 -- Saturday
// Description:

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'query_model.dart';

abstract class WebServicePrototype<D> {
  late final D service;

  // ===========================Save APIs================================
  /// Save Data with or without doc id
  Future<T> save<T>(
      {required String path, required String docIdFiled, required T model});

  // ===========================Update APIs================================

  Future<void> update({
    required String path,
    required String docId,
    required Map<String, dynamic> data,
  });

  // ===========================Fetch APIs================================

  Future<Map<String, dynamic>?> fetch({
    required String path,
    required String docId,
  });

  /// Fetch With Listener
  Future<void> fetchMultiple<T>({
    required String collection,
    required Function(dynamic) onError,
    required Function(T)? onAdded,
    required Function(T)? onRemoved,
    required Function(T)? onUpdated,
    VoidCallback? onAllDataGet,
    onCompleted,
    required List<QueryModel> queries,
  });

  /// with multiple with conditions and paginations
  Future<List<T>> fetchMultipleWithConditions<T>({
    required String collection,
    required List<QueryModel> queries,
    Function(DocumentSnapshot?)? lastDocSnapshot,
  });

  // ===========================Delete APIs================================
  Future<void> delete({required String collection, required String docId});

  // ===========================Other APIs================================
  Future<void> copyDoc<T>({required String from, required String to});
}
