// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart' show kReleaseMode;

const String FIREBASE_COLLECTION_USER =
    "${kReleaseMode ? "Dev-" : "Dev-"}Users";
const String FIREBASE_COLLECTION_USER_PROFILES =
    "${kReleaseMode ? "Dev-" : "Dev-"}Avatars";
const FIREBASE_COLLECTION_PETS = "${kReleaseMode ? "Dev-" : "Dev-"}Pets";
const FIREBASE_COLLECTION_POSTS = "${kReleaseMode ? "Dev-" : "Dev-"}Posts";
const FIREBASE_COLLECTION_LIKES = "${kReleaseMode ? "Dev-" : "Dev-"}Likes";
const FIREBASE_COLLECTION_COMMENTS =
    "${kReleaseMode ? "Dev-" : "Dev-"}Comments";
const String FIREBASE_COLLECTION_CHAT =
    "${kReleaseMode ? "Dev-" : "Dev-"}Chats";

const FIREBASE_COLLECTION_MESSAGES =
    "${kReleaseMode ? "Dev-" : "Dev-"}Messages";
const String FIREBASE_COLLECTION_NOTIFICATION =
    "${kReleaseMode ? "Dev-" : "Dev-"}Notifications";
const FIREBASE_COLLECTION_CONTACTS =
    "${kReleaseMode ? "Dev-" : "Dev-"}Contacts";
const FIREBASE_COLLECTION_AGREEMENTS =
    "${kReleaseMode ? "Dev-" : "Dev-"}Agreements";
