// Project: 	   muutsch
// File:    	   chat_event
// Path:    	   lib/blocs/chat/chat_event.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:34:57 -- Friday
// Description:

import 'dart:core';

import 'package:petcare/models/chat_model.dart';

import '../../models/user_profile_model.dart';

abstract class ChatEvent {}

/// Fetch All Event
class ChatEventFetchAll extends ChatEvent {}

/// Create Chat Event
class ChatEventCreate extends ChatEvent {
  final String title;
  final String? avatar;
  final String? description;
  final int maxMembers;

  ChatEventCreate(
      {required this.title,
      this.avatar,
      this.description,
      required this.maxMembers});
}

/// Update Chat Event
class ChatEventUpdate extends ChatEvent {
  final String title;
  final String? avatar;
  final String? description;
  final int maxMembers;
  final String chatId;

  ChatEventUpdate(
      {required this.title,
      this.avatar,
      this.description,
      required this.chatId,
      required this.maxMembers});
}

class ChatEventAddMembers extends ChatEvent {
  final String chatId;
  final List<UserProfileModel> users;

  ChatEventAddMembers({required this.users, required this.chatId});
}

class ChatEventSendInvites extends ChatEvent {
  final ChatModel chat;
  final List<UserProfileModel> users;

  ChatEventSendInvites({required this.users, required this.chat});
}

/// Chat Join
class ChatEventJoin extends ChatEvent {
  final String chatId;

  ChatEventJoin({required this.chatId});
}

/// Remove Member
class ChatEventRemoveMember extends ChatEvent {
  final UserProfileModel member;
  final String chatId;
  ChatEventRemoveMember({required this.member, required this.chatId});
}

class ChatEventSearch extends ChatEvent {
  final String by;

  ChatEventSearch({required this.by});
}

// ===========================================================
class ChatEventAddAdmin extends ChatEvent {
  final String chatId;
  final UserProfileModel user;

  ChatEventAddAdmin({required this.chatId, required this.user});
}

class ChatEventRemoveAdmin extends ChatEvent {
  final String chatId;
  final UserProfileModel user;

  ChatEventRemoveAdmin({required this.chatId, required this.user});
}

class ChatEventExit extends ChatEvent {
  final String chatId;
  final List<UserProfileModel> members;
  final bool isCreator;
  final bool isAdmin;

  ChatEventExit(
      {required this.chatId,
      required this.members,
      required this.isCreator,
      required this.isAdmin});
}

class ChatEventDelete extends ChatEvent {
  final String chatId;

  ChatEventDelete({required this.chatId});
}
