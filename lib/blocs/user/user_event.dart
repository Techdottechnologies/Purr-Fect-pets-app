// ignore: dangling_library_doc_comments
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/location_model.dart';

abstract class UserEvent {}

/// Update Profile Event
class UserEventUpdateProfile extends UserEvent {
  final String? avatar;
  final LocationModel? location;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;

  UserEventUpdateProfile({
    this.location,
    this.avatar,
    this.name,
    this.email,
    this.phone,
    this.userType,
  });
}

class UserEventFindBy extends UserEvent {
  final LatLngBounds? bounds;
  final String? searchText;

  UserEventFindBy({this.bounds, this.searchText});
}

class UserEventFetchDetail extends UserEvent {
  final String uid;

  UserEventFetchDetail({required this.uid});
}

class UserEventSearchUsers extends UserEvent {
  final String search;
  final List<String> ignoreIds;

  UserEventSearchUsers({required this.search, required this.ignoreIds});
}

class UserEventFetchAll extends UserEvent {
  final List<String> ignoreIds;
  final DocumentSnapshot? lastDocSnap;

  UserEventFetchAll({required this.ignoreIds, required this.lastDocSnap});
}
