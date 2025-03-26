// Project: 	   barkingclub
// File:    	   pet_repo
// Path:    	   lib/repos/pet/pet_repo.dart
// Author:       Ali Akbar
// Date:        25-06-24 16:13:44 -- Tuesday
// Description:

import 'dart:developer';
import 'dart:io';

import 'package:petcare/exceptions/exception_parsing.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/pet_model.dart';
import 'package:petcare/utils/constants/firebase_collections.dart';
import 'package:petcare/services/web/query_model.dart';
import 'package:petcare/services/web/storage_services.dart';

import '../../services/web/firestore_services.dart';

class PetRepo {
  /// Add New One
  static Future<void> add({required PetModel model}) async {
    try {
      // await PetValidation.validate(model: model);
      if (model.avatar != null && Uri.parse(model.avatar!).host.isEmpty) {
        final String downloadedUrl = await StorageService().uploadImage(
            withFile: File(model.avatar!),
            collectionPath:
                "$FIREBASE_COLLECTION_PETS/${DateTime.now().millisecondsSinceEpoch}");
        model = model.copyWith(avatar: downloadedUrl);
      }
      final Map<String, dynamic> data =
          await FirestoreService().saveWithSpecificIdFiled(
        path: FIREBASE_COLLECTION_PETS,
        data: model.toMap(),
        docIdFiled: 'uuid',
      );
      final PetModel pet = PetModel.fromMap(data);
      AppManager.pets.add(pet);
    } catch (e) {
      log(e.toString());
      throw throwAppException(e: e);
    }
  }

  /// Update Pet
  static Future<PetModel> update({required PetModel model}) async {
    try {
      // await PetValidation.validate(model: model, page: 0);
      if (model.avatar != null && Uri.parse(model.avatar!).host.isEmpty) {
        final String downloadedUrl = await StorageService().uploadImage(
            withFile: File(model.avatar!),
            collectionPath:
                "$FIREBASE_COLLECTION_PETS/${DateTime.now().millisecondsSinceEpoch}");
        model = model.copyWith(avatar: downloadedUrl);
      }
      final Map<String, dynamic> data =
          await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_PETS,
        data: model.toMap(),
        docId: model.uuid,
      );
      final PetModel pet = PetModel.fromMap(data);
      final int index = AppManager.pets.indexWhere((e) => e.uuid == pet.uuid);
      if (index > -1) {
        AppManager.pets[index] = pet;
      }
      return pet;
    } catch (e) {
      log(e.toString());
      throw throwAppException(e: e);
    }
  }

  /// Fetch All the pets
  static Future<void> fetch() async {
    try {
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_PETS,
        queries: [
          QueryModel(
              field: "owner",
              value: AppManager.currentUser?.uid,
              type: QueryType.isEqual),
        ],
      );

      AppManager.pets = data.map((e) => PetModel.fromMap(e)).toList();
    } catch (e) {
      log(e.toString());
      throw throwAppException(e: e);
    }
  }
}
