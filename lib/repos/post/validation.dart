// Project: 	   barkingclub
// File:    	   validation
// Path:    	   lib/repos/post/validation.dart
// Author:       Ali Akbar
// Date:        26-06-24 12:39:27 -- Wednesday
// Description:

import 'package:petcare/exceptions/data_exceptions.dart';
import 'package:petcare/models/post_model.dart';

class PostValidation {
  static Future<void> validate({required PostModel model}) async {
    if (model.media.content == "" && (model.media.mediaUrl == null)) {
      throw DataExceptionRequiredField(
          message: "Please upload media or add content.");
    }

    if (model.status == null) {
      throw DataExceptionRequiredField(message: "Please add status.");
    }
  }
}
