// Project: 	   barkingclub
// File:    	   validation
// Path:    	   lib/repos/community/validation.dart
// Author:       Ali Akbar
// Date:        11-07-24 14:00:54 -- Thursday
// Description:

import '../../exceptions/data_exceptions.dart';

class ChatValidation {
  static Future<void> chat({String? name, required int max}) async {
    if (name == null || name == "") {
      throw DataExceptionRequiredField(message: "Community name required");
    }

    if (max < 0 || max > 250) {
      throw DataExceptionRequiredField(
          message: "Maximum Limit of community is 1 to 250");
    }
  }
}
