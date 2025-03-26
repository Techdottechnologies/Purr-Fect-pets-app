// Project: 	   muutsch
// File:    	   privacy_repo_impl
// Path:    	   lib/repos/privacy/privacy_repo_impl.dart
// Author:       Ali Akbar
// Date:        18-07-24 18:16:00 -- Thursday
// Description:

import '/exceptions/exception_parsing.dart';
import '/models/privacy_model.dart';
import '/repos/privacy/privacy_repo_interface.dart';
import '/utils/constants/firebase_collections.dart';
import '../../services/web/firestore_services.dart';
import '../../services/web/query_model.dart';

class PrivacyRepo implements PrivacyRepoInterface {
  @override
  Future<List<PrivacyModel>> fetch() async {
    try {
      final List<Map<String, dynamic>> data =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_AGREEMENTS,
        queries: [
          QueryModel(field: "createdAt", value: false, type: QueryType.orderBy)
        ],
      );

      return data.map((e) => PrivacyModel.fromMap(e)).toList();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
