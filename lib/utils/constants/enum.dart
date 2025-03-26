// Project: 	   barkingclub
// File:    	   enum
// Path:    	   lib/utils/constants/enum.dart
// Author:       Ali Akbar
// Date:        25-06-24 12:30:02 -- Tuesday
// Description:

enum PetType {
  cat(name: "Cat", icon: "assets/icons/pets/cat-ic.png"),
  dog(name: "Dog", icon: "assets/icons/pets/dog-ic.png");

  final String name;
  final String icon;
  const PetType({required this.name, required this.icon});
}

enum PostStatus { lost, found, happy, moody }

enum LikeType { post, comment }
