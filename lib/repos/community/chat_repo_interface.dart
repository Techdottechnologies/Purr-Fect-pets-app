// Project: 	   barkingclub
// File:    	   chat_repo
// Path:    	   lib/repos/community/chat_repo.dart
// Author:       Ali Akbar
// Date:        11-07-24 13:37:36 -- Thursday
// Description:

import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/models/chat_model.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile_model.dart';

abstract class ChatRepoInterface {
  Future<void> fetchChats({
    required Function(ChatModel) onAdded,
    required Function(ChatModel) onDeleted,
    required Function(ChatModel) onUpdated,
    required Function(AppException) onError,
    required VoidCallback onFetchedAll,
  });

  Future<ChatModel> fetchChat({required String byUuid});

  /// Create Chat Method
  Future<ChatModel> createGroupChat({
    String? title,
    String? avatar,
    int? totoalMemebrs,
    String? description,
  });

  Future<List<ChatModel>> searchChats({required String by});

  /// Members
  Future<void> addTo({required String chatId, required String addBy});

  /// Members
  Future<void> SendInvites({
    required ChatModel chat,
    required List<UserProfileModel> users,
  });

  /// Members
  Future<void> joinChat({required String chatId});

  Future<void> removeMember({
    required String chatId,
    required UserProfileModel member,
  });

  Future<void> update({
    String? title,
    String? avatar,
    int? totoalMemebrs,
    String? description,
    required String chatId,
  });

  Future<void> addAdmin({
    required String chatId,
    required UserProfileModel user,
  });

  Future<void> removeAdmin({
    required String chatId,
    required UserProfileModel user,
  });

  Future<void> exitChat(
      {required String chatId,
      required List<UserProfileModel> members,
      required bool isAdmin,
      required bool isCreator});

  Future<void> deleteChat({required String chatId});
}

// ===========================Mixin Methods================================
mixin ChatRepoMixin on ChatRepoInterface {
  @override
  Future<void> fetchChats(
      {required Function(ChatModel p1) onAdded,
      required Function(ChatModel p1) onDeleted,
      required Function(ChatModel p1) onUpdated,
      required Function(AppException p1) onError,
      required VoidCallback onFetchedAll}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ChatModel>> searchChats({required String by}) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> createGroupChat(
      {String? title,
      String? avatar,
      int? totoalMemebrs,
      String? description}) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(
      {String? title,
      String? avatar,
      int? totoalMemebrs,
      String? description,
      required String chatId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> addAdmin(
      {required String chatId, required UserProfileModel user}) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeAdmin(
      {required String chatId, required UserProfileModel user}) {
    throw UnimplementedError();
  }

  @override
  Future<void> addTo({required String chatId, required String addBy}) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeMember(
      {required String chatId, required UserProfileModel member}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChat({required String chatId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> exitChat(
      {required String chatId,
      required List<UserProfileModel> members,
      required bool isCreator,
      required bool isAdmin}) {
    throw UnimplementedError();
  }

  @override
  Future<ChatModel> fetchChat({required String byUuid}) {
    throw UnimplementedError();
  }

  @override
  Future<void> joinChat({required String chatId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> SendInvites(
      {required ChatModel chat, required List<UserProfileModel> users}) {
    throw UnimplementedError();
  }
}
