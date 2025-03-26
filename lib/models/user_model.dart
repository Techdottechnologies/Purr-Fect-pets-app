// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:petcare/utils/helping_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'location_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final bool? isActived;
  final LocationModel? location;
  final String phone;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.isActived,
    this.location,
    required this.phone,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatar,
    DateTime? createdAt,
    bool? isActived,
    LocationModel? location,
    String? phone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isActived: isActived ?? this.isActived,
      location: location ?? this.location,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'avatar': avatar,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActived': isActived,
      'location': location?.toMap(),
      'phone': phone,
      'searchCharacters': generateSubstrings(name),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActived: map['isActived'] != null ? map['isActived'] as bool : null,
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      phone: map['phone'] != null ? map['phone'] as String : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, isActived: $isActived, location: $location, phone: $phone)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.avatar == avatar &&
        other.createdAt == createdAt &&
        other.isActived == isActived &&
        other.location == location &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        createdAt.hashCode ^
        isActived.hashCode ^
        location.hashCode ^
        phone.hashCode;
  }
}
