// Project: 	   muutsch
// File:    	   chat_state
// Path:    	   lib/blocs/chat/chat_state.dart
// Author:       Ali Akbar
// Date:        31-05-24 13:26:54 -- Friday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/chat_model.dart';

abstract class ChatState {
  final bool isLoading;

  ChatState({this.isLoading = false});
}

/// initialState
class ChatStateInitial extends ChatState {}

// ===========================Creating Chat================================
class ChatStateCreating extends ChatState {
  ChatStateCreating({super.isLoading = true});
}

class ChatStateCreateFailure extends ChatState {
  final AppException exception;
  ChatStateCreateFailure({required this.exception});
}

class ChatStateCreated extends ChatState {
  final ChatModel chat;

  ChatStateCreated({required this.chat});
}

// ===========================Udpate Chat================================
class ChatStateUpdating extends ChatState {
  ChatStateUpdating({super.isLoading = true});
}

class ChatStateeUpdateFailure extends ChatState {
  final AppException exception;
  ChatStateeUpdateFailure({required this.exception});
}

class ChatStateeUpdated extends ChatState {
  final ChatModel chat;
  ChatStateeUpdated({required this.chat});
}

// ===========================Fetch all chats================================
class ChatStateFetchingAll extends ChatState {
  ChatStateFetchingAll({super.isLoading = true});
}

class ChatStateFetchAllFailure extends ChatState {
  final AppException exception;
  ChatStateFetchAllFailure({required this.exception});
}

class ChatStateFetchedAll extends ChatState {}

// ===========================Fetch Single Chat================================
class ChatStateFetching extends ChatState {
  ChatStateFetching({super.isLoading = true});
}

class ChatStateFetchFailure extends ChatState {
  final AppException exception;
  ChatStateFetchFailure({required this.exception});
}

class ChatStateUpdates extends ChatState {
  final List<ChatModel> chats;

  ChatStateUpdates({required this.chats});
}

// ===========================Added================================
class ChatStateAddingMembers extends ChatState {
  ChatStateAddingMembers({super.isLoading = true});
}

class ChatStateAddMemberFailure extends ChatState {
  final AppException exception;
  ChatStateAddMemberFailure({required this.exception});
}

class ChatStateAddedMembers extends ChatState {}

// ===========================Send================================
class ChatStateSendingInvites extends ChatState {
  ChatStateSendingInvites({super.isLoading = true});
}

class ChatStateSendInvitesFailure extends ChatState {
  final AppException exception;
  ChatStateSendInvitesFailure({required this.exception});
}

class ChatStateSentInvites extends ChatState {}

// ===========================Joined================================

class ChatStateJoining extends ChatState {
  ChatStateJoining({super.isLoading = true});
}

class ChatStateJoinFailure extends ChatState {
  final AppException exception;

  ChatStateJoinFailure({required this.exception});
}

class ChatStateJoined extends ChatState {}

// ===========================Remove Member Chat================================

class ChatStateMemberRemoved extends ChatState {
  final String memeberId;
  ChatStateMemberRemoved({required this.memeberId});
}

// ===========================Search Chat================================

class ChatStateSearching extends ChatState {
  ChatStateSearching({super.isLoading = true});
}

class ChatStateSearchFailure extends ChatState {
  final AppException exception;

  ChatStateSearchFailure({required this.exception});
}

class ChatStateSearched extends ChatState {
  final List<ChatModel> chats;

  ChatStateSearched({required this.chats});
}

// ===========================Exit Chat================================
class ChatStateExited extends ChatState {}

// ===========================Delete Chat================================

class ChatStateDeleted extends ChatState {}

// ===========================Make Admin================================
class ChatStateMadeAdmin extends ChatState {}

// ===========================Remove Admin================================
class ChatStateRemovedAdmin extends ChatState {}
