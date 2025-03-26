// Project: 	   muutsch
// File:    	    chat_bloc
// Path:    	   lib/blocs/chat/ chat_bloc.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:44:34 -- Friday
// Description:

// ignore_for_file: file_names

import 'package:petcare/models/notification_model.dart';
import 'package:petcare/repos/community/chat_repo_action.dart';
import 'package:petcare/repos/community/chat_repo_read.dart';
import 'package:petcare/repos/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/data_exceptions.dart';
import '../../manager/app_manager.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../repos/message_repo.dart';
import '../../models/user_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatModel> chats = [];
  final UserModel currentUser = AppManager.currentUser!;

  ChatBloc() : super(ChatStateInitial()) {
    /// Fetch Single Chat Evenst
    on<ChatEventFetchAll>(
      (event, emit) async {
        emit(ChatStateFetching());
        await ChatRepoRead().fetchChats(
          onFetchedAll: () {
            emit(ChatStateUpdates(chats: chats));
          },
          onAdded: (chat) {
            if (chats.where((e) => e.uuid == chat.uuid).isEmpty) {
              chats.add(chat);
            }
            emit(ChatStateUpdates(chats: chats));
          },
          onDeleted: (chat) {
            final int index = chats.indexWhere((e) => e.uuid == chat.uuid);
            if (index > -1) {
              chats.removeAt(index);
            }
            emit(ChatStateUpdates(chats: chats));
          },
          onUpdated: (chat) {
            final int index = chats.indexWhere((e) => e.uuid == chat.uuid);
            if (index > -1) {
              chats[index] = chat;
            }
            emit(ChatStateUpdates(chats: chats));
          },
          onError: (e) {
            emit(ChatStateFetchFailure(exception: e));
          },
        );
      },
    );

    /// Create Chat Event
    on<ChatEventCreate>(
      (event, emit) async {
        try {
          emit(ChatStateCreating());
          final ChatModel chat = await ChatRepoAction().createGroupChat(
            title: event.title,
            avatar: event.avatar,
            totoalMemebrs: event.maxMembers,
            description: event.description,
          );
          emit(ChatStateCreated(chat: chat));
        } on AppException catch (e) {
          emit(ChatStateCreateFailure(exception: e));
        }
      },
    );

    on<ChatEventUpdate>(
      (event, emit) async {
        try {
          emit(ChatStateUpdating());
          await ChatRepoAction().update(
              chatId: event.chatId,
              title: event.title,
              avatar: event.avatar,
              description: event.description,
              totoalMemebrs: event.maxMembers);
          final int index = chats.indexWhere((e) => e.uuid == e.uuid);
          if (index > -1) {
            emit(ChatStateeUpdated(chat: chats[index]));
          } else {
            emit(ChatStateeUpdateFailure(exception: DataExceptionNotFound()));
          }
        } on AppException catch (e) {
          emit(ChatStateeUpdateFailure(exception: e));
        }
      },
    );

    /// Add Group Chat
    on<ChatEventAddMembers>(
      (event, emit) async {
        try {
          emit(ChatStateAddingMembers());
          // await ChatRepoAction()
          //     .addMembers(chatId: event.chatId, users: event.users);

          emit(ChatStateAddedMembers());
        } on AppException catch (e) {
          emit(ChatStateAddMemberFailure(exception: e));
        }
      },
    );

    /// Add Group Chat
    on<ChatEventSendInvites>(
      (event, emit) async {
        try {
          emit(ChatStateSendingInvites());
          ChatRepoAction().SendInvites(chat: event.chat, users: event.users);
          emit(ChatStateSentInvites());
        } on AppException catch (e) {
          emit(ChatStateSendInvitesFailure(exception: e));
        }
      },
    );

    /// Join Group Chat
    on<ChatEventJoin>(
      (event, emit) async {
        try {
          emit(ChatStateJoining());
          await ChatRepoAction().joinChat(chatId: event.chatId);
          emit(ChatStateJoined());

          MessageRepo().sendMessage(
              type: MessageType.addMember,
              content: "${currentUser.name} joined ${currentUser.name}",
              onMessagePrepareToSend: () {},
              conversationId: event.chatId);
        } on AppException catch (e) {
          emit(ChatStateJoinFailure(exception: e));
        }
      },
    );

    /// Remove Member Chat
    on<ChatEventRemoveMember>(
      (event, emit) async {
        try {
          ChatRepoAction()
              .removeMember(chatId: event.chatId, member: event.member);
          emit(ChatStateMemberRemoved(memeberId: event.member.uid));

          NotificationRepo().save(
            title: currentUser.name,
            message: "${currentUser.name} remove you community.",
            avatar: currentUser.avatar ?? "",
            recieverId: event.member.uid,
            type: NotificationType.chat,
          );
          MessageRepo().sendMessage(
              type: MessageType.addMember,
              content: "${currentUser.name} removed ${event.member.name}",
              onMessagePrepareToSend: () {},
              conversationId: event.chatId);
        } on AppException catch (e) {
          debugPrint(e.message.toString());
        }
      },
    );

    /// Search Chat Event
    on<ChatEventSearch>(
      (event, emit) async {
        try {
          emit(ChatStateSearching());
          final List<ChatModel> chats =
              await ChatRepoRead().searchChats(by: event.by);
          emit(ChatStateSearched(chats: chats));
        } on AppException catch (e) {
          emit(ChatStateSearchFailure(exception: e));
        }
      },
    );

    /// exit the community
    on<ChatEventExit>(
      (event, emit) async {
        try {
          await ChatRepoAction().exitChat(
              chatId: event.chatId,
              members: event.members,
              isAdmin: event.isAdmin,
              isCreator: event.isCreator);
          emit(ChatStateExited());

          MessageRepo().sendMessage(
              type: MessageType.addMember,
              content: "${currentUser.name} left",
              onMessagePrepareToSend: () {},
              conversationId: event.chatId);
        } on AppException catch (e) {
          debugPrint(e.message.toString());
        }
      },
    );

    /// Delete the community
    on<ChatEventDelete>(
      (event, emit) async {
        try {
          await ChatRepoAction().deleteChat(chatId: event.chatId);
          emit(ChatStateDeleted());
        } on AppException catch (e) {
          debugPrint(e.message.toString());
        }
      },
    );

    /// make the admin to the community
    on<ChatEventAddAdmin>(
      (event, emit) async {
        try {
          await ChatRepoAction()
              .addAdmin(chatId: event.chatId, user: event.user);
          emit(ChatStateMadeAdmin());

          NotificationRepo().save(
            title: currentUser.name,
            message: "${currentUser.name} made you admin.",
            avatar: currentUser.avatar ?? "",
            recieverId: event.user.uid,
            type: NotificationType.chat,
          );

          MessageRepo().sendMessage(
              type: MessageType.addMember,
              content: "${currentUser.name} made ${event.user.name} as admin.",
              onMessagePrepareToSend: () {},
              conversationId: event.chatId);
        } on AppException catch (e) {
          debugPrint(e.message.toString());
        }
      },
    );

    /// remove admin from the community
    on<ChatEventRemoveAdmin>(
      (event, emit) async {
        try {
          await ChatRepoAction()
              .removeAdmin(chatId: event.chatId, user: event.user);
          emit(ChatStateRemovedAdmin());

          NotificationRepo().save(
            title: currentUser.name,
            message: "${currentUser.name} remove you from admin.",
            avatar: currentUser.avatar ?? "",
            recieverId: event.user.uid,
            type: NotificationType.chat,
          );

          MessageRepo().sendMessage(
              type: MessageType.addMember,
              content:
                  "${currentUser.name} removed ${event.user.name} from admin.",
              onMessagePrepareToSend: () {},
              conversationId: event.chatId);
        } on AppException catch (e) {
          debugPrint(e.message.toString());
        }
      },
    );
  }
}
