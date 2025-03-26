// Project: 	   muutsche_admin_panel
// File:    	   contact_repo_impl
// Path:    	   lib/repos/contact_repo/contact_repo_impl.dart
// Author:       Ali Akbar
// Date:        18-07-24 12:57:46 -- Thursday
// Description:

import 'package:petcare/manager/app_manager.dart';

import '/exceptions/exception_parsing.dart';
import '/repos/contact_repo/validation.dart';
import '/utils/constants/firebase_collections.dart';
import '../../services/web/firestore_services.dart';

import '../../models/contact_us_model.dart';
import 'contact_repo_interface.dart';

class ContactRepo implements ContactRepoInterface {
  @override
  Future<void> save({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await ContactValidation.validate(
          name: name, email: email, message: message);
      final ContactUsModel model = ContactUsModel(
        uuid: '',
        username: name,
        email: email,
        message: message,
        avatar: AppManager.currentUser?.avatar ?? "",
        createdAt: DateTime.now(),
        senderId: AppManager.currentUser?.uid ?? "",
      );

      await FirestoreService().saveWithSpecificIdFiled(
          path: FIREBASE_COLLECTION_CONTACTS,
          data: model.toMap(),
          docIdFiled: 'uuid');
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
