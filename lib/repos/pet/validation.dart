// Project: 	   barkingclub
// File:    	   validation
// Path:    	   lib/repos/pet/validation.dart
// Author:       Ali Akbar
// Date:        25-06-24 17:18:52 -- Tuesday
// Description:

import 'package:petcare/exceptions/data_exceptions.dart';

class PetValidation {
  static Future<void> validate({
    required String breed,
    required String name,
    required String avatar,
    DateTime? dob,
    required String insta,
    required String tiktok,
    required String vaccinated,
    required String neutered,
    required String behavior,
    required String anxiety,
    required String diet,
    required double weight,
    required int page,
  }) async {
    if (breed == "" && page == 0) {
      throw DataExceptionRequiredField(message: 'Please select breed.');
    }
    if (avatar == "" && page == 2) {
      throw DataExceptionRequiredField(
          message: 'Please add profile picture of your pet.');
    }

    if (name == "" && page == 2) {
      throw DataExceptionRequiredField(message: 'Please enter name.');
    }

    if (dob == null && page == 2) {
      throw DataExceptionRequiredField(message: 'Please select date of birth.');
    }
    if (insta == "" && page == 2) {
      throw DataExceptionRequiredField(message: 'Please add insta usernmae.');
    }
    if (tiktok == "" && page == 2) {
      throw DataExceptionRequiredField(message: 'Please add tiktok usernmae.');
    }

    if (vaccinated == "" && page == 3) {
      throw DataExceptionRequiredField(message: 'Please select vaccination.');
    }

    if (neutered == "" && page == 3) {
      throw DataExceptionRequiredField(
          message: 'Please select neutered/spayed.');
    }

    if (behavior == "" && page == 3) {
      throw DataExceptionRequiredField(message: 'Please add behavior detail.');
    }
    if (anxiety == "" && page == 3) {
      throw DataExceptionRequiredField(message: 'Please select anxiety.');
    }

    if (diet == "" && page == 3) {
      throw DataExceptionRequiredField(message: 'Please add diet detail.');
    }

    if (weight <= 0 && page == 4) {
      throw DataExceptionRequiredField(message: 'Weight must not be zero.');
    }
  }
}
