// Project: 	   balanced_workout
// File:    	   model_prototype
// Path:    	   lib/web_services/model_prototype.dart
// Author:       Ali Akbar
// Date:        06-07-24 12:48:35 -- Saturday
// Description:

abstract class ModelPrototype {
  Map<String, dynamic> toMap();
  T fromMap<T>(Map<String, dynamic> map);
}
