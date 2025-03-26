// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:petcare/utils/constants/enum.dart';
import 'package:petcare/utils/extensions/string_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  final String uuid;
  final DateTime createdAt;
  final String owner;
  final PetType type;
  final String breed;
  final String? additionalBreed;
  final String gender;
  final String? avatar;
  final String name;
  final DateTime? dob;
  final String? instaUsername;
  final String? tikUsername;
  final String vaccinated;
  final String neutered;
  final String? behavior;
  final String anxiety;
  final String? dietPlan;
  final double weight;
  PetModel({
    required this.uuid,
    required this.createdAt,
    required this.owner,
    required this.type,
    required this.breed,
    this.additionalBreed,
    required this.gender,
    this.avatar,
    required this.name,
    this.dob,
    this.instaUsername,
    this.tikUsername,
    required this.vaccinated,
    required this.neutered,
    this.behavior,
    required this.anxiety,
    this.dietPlan,
    required this.weight,
  });

  PetModel copyWith({
    String? uuid,
    DateTime? createdAt,
    String? owner,
    PetType? type,
    String? breed,
    String? additionalBreed,
    String? gender,
    String? avatar,
    String? name,
    DateTime? dob,
    String? instaUsername,
    String? tikUsername,
    String? vaccinated,
    String? neutered,
    String? behavior,
    String? anxiety,
    String? dietPlan,
    double? weight,
  }) {
    return PetModel(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      owner: owner ?? this.owner,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      additionalBreed: additionalBreed ?? this.additionalBreed,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      instaUsername: instaUsername ?? this.instaUsername,
      tikUsername: tikUsername ?? this.tikUsername,
      vaccinated: vaccinated ?? this.vaccinated,
      neutered: neutered ?? this.neutered,
      behavior: behavior ?? this.behavior,
      anxiety: anxiety ?? this.anxiety,
      dietPlan: dietPlan ?? this.dietPlan,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'createdAt': Timestamp.fromDate(createdAt),
      'owner': owner,
      'type': type.name.capitalizeFirstCharacter(),
      'breed': breed,
      'additionalBreed': additionalBreed,
      'gender': gender,
      'avatar': avatar,
      'name': name,
      'dob': dob == null ? null : Timestamp.fromDate(dob!),
      'instaUsername': instaUsername,
      'tikUsername': tikUsername,
      'vaccinated': vaccinated,
      'neutered': neutered,
      'behavior': behavior,
      'anxiety': anxiety,
      'dietPlan': dietPlan,
      'weight': weight,
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      uuid: map['uuid'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      owner: map['owner'] as String,
      type: PetType.values.firstWhere(
          (e) => e.name.toLowerCase() == (map['type'] as String).toLowerCase()),
      breed: map['breed'] as String,
      additionalBreed: map['additionalBreed'] != null
          ? map['additionalBreed'] as String
          : null,
      gender: map['gender'] as String,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      name: map['name'] as String,
      dob: map['dob'] != null ? (map['dob'] as Timestamp).toDate() : null,
      instaUsername:
          map['instaUsername'] != null ? map['instaUsername'] as String : null,
      tikUsername:
          map['tikUsername'] != null ? map['tikUsername'] as String : null,
      vaccinated: map['vaccinated'] as String,
      neutered: map['neutered'] as String,
      behavior: map['behavior'] != null ? map['behavior'] as String : null,
      anxiety: map['anxiety'] as String,
      dietPlan: map['dietPlan'] != null ? map['dietPlan'] as String : null,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetModel.fromJson(String source) =>
      PetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PetModel(uuid: $uuid, createdAt: $createdAt, owner: $owner, type: $type, breed: $breed, additionalBreed: $additionalBreed, gender: $gender, avatar: $avatar, name: $name, dob: $dob, instaUsername: $instaUsername, tikUsername: $tikUsername, vaccinated: $vaccinated, neutered: $neutered, behavior: $behavior, anxiety: $anxiety, dietPlan: $dietPlan, weight: $weight)';
  }

  @override
  bool operator ==(covariant PetModel other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid &&
        other.createdAt == createdAt &&
        other.owner == owner &&
        other.type == type &&
        other.breed == breed &&
        other.additionalBreed == additionalBreed &&
        other.gender == gender &&
        other.avatar == avatar &&
        other.name == name &&
        other.dob == dob &&
        other.instaUsername == instaUsername &&
        other.tikUsername == tikUsername &&
        other.vaccinated == vaccinated &&
        other.neutered == neutered &&
        other.behavior == behavior &&
        other.anxiety == anxiety &&
        other.dietPlan == dietPlan &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        createdAt.hashCode ^
        owner.hashCode ^
        type.hashCode ^
        breed.hashCode ^
        additionalBreed.hashCode ^
        gender.hashCode ^
        avatar.hashCode ^
        name.hashCode ^
        dob.hashCode ^
        instaUsername.hashCode ^
        tikUsername.hashCode ^
        vaccinated.hashCode ^
        neutered.hashCode ^
        behavior.hashCode ^
        anxiety.hashCode ^
        dietPlan.hashCode ^
        weight.hashCode;
  }
}
