

import 'package:petcare/exceptions/data_exceptions.dart';

class CommentValidation {
  static Future<void> validate({required String message}) async {
    if (message == "") {
      throw DataExceptionRequiredField(message: "Please write comment.");
    }
  }
}
