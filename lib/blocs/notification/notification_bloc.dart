// Project: 	   muutsch
// File:    	   notification_bloc
// Path:    	   lib/blocs/notification/notification_bloc.dart
// Author:       Ali Akbar
// Date:        29-05-24 17:09:14 -- Wednesday
// Description:

import 'dart:developer';

import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/notification_model.dart';
import 'package:petcare/repos/community/chat_repo_action.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/message_model.dart';
import '../../repos/message_repo.dart';
import '../../repos/notification_repo.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final List<NotificationModel> notifications = [];

  NotificationBloc() : super(NotificationStateInitial()) {
    final List<String> readableNotificationIds = [];

    /// on Save
    on<NotificationEventSave>(
      (event, emit) {
        try {
          emit(NotificationStateSaving());
          NotificationRepo().save(
            recieverId: event.receiverId,
            title: event.title,
            contentId: event.contentId,
            message: event.message,
            type: event.type,
            data: null,
            avatar: '',
          );
          emit(NotificationStateSaved());
        } on AppException catch (e) {
          emit(NotificationStateSaveFailure(exception: e));
        }
      },
    );

    /// on Fetch
    on<NotificationEventFetch>(
      (event, emit) async {
        emit(NotificationStateFetching());
        await NotificationRepo().fetch(
          onAdded: (p0) {
            if (!notifications.contains(p0)) {
              emit(NotificationStateUpdated(notifications: notifications));
              notifications.insert(0, p0);
              if (!p0.isRead) {
                readableNotificationIds.add(p0.uuid);
              }
              emit(NotificationStateNewAvailable(
                  isNew: readableNotificationIds.isNotEmpty));
            }
          },
          onRemoved: (p0) {
            final int index =
                notifications.indexWhere((e) => e.uuid == p0.uuid);
            if (index > -1) {
              notifications.removeAt(index);
              emit(NotificationStateUpdated(notifications: notifications));
              readableNotificationIds.remove(p0.uuid);
              emit(NotificationStateNewAvailable(
                  isNew: readableNotificationIds.isNotEmpty));
            }
          },
          onUpdated: (p0) {
            if (p0.isRead) {
              readableNotificationIds.remove(p0);
              emit(NotificationStateNewAvailable(
                  isNew: readableNotificationIds.isNotEmpty));
            }
            final int index =
                notifications.indexWhere((e) => e.uuid == p0.uuid);
            if (index > -1) {
              notifications[index] = p0;
            }
            emit(NotificationStateUpdated(notifications: notifications));
          },
          onGetAll: () {
            emit(NotificationStateFetched());
            emit(NotificationStateNewAvailable(
                isNew: readableNotificationIds.isNotEmpty));
          },
          onError: (p0) {
            emit(NotificationStateFetchFailure(exception: p0));
          },
        );
      },
    );

    on<NotificationEventAcceptPressed>(
      (event, emit) async {
        try {
          await NotificationRepo().update(
            id: event.notificationId,
            data: {
              'data': {'status': true}
            },
          );

          await ChatRepoAction()
              .addTo(chatId: event.data['uuid'], addBy: event.addedBy);
          await MessageRepo().sendMessage(
            type: MessageType.addMember,
            content: "${event.addedBy} added ${AppManager.currentUser!.name}",
            onMessagePrepareToSend: () {},
            conversationId: event.data['uuid'],
          );
        } on AppException catch (e) {
          emit(NotificationStateSaveFailure(exception: e));
        }
      },
    );

    on<NotificationEventRejectPressed>(
      (event, emit) async {
        try {
          await NotificationRepo().update(
            id: event.notificationId,
            data: {
              'data': {'status': true}
            },
          );
        } on AppException catch (e) {
          emit(NotificationStateSaveFailure(exception: e));
        }
      },
    );

    /// Mark readable
    on<NotificationEventMarkReadable>(
      (event, emit) async {
        for (final String id in readableNotificationIds) {
          NotificationRepo().markRead(notificationId: id);
          readableNotificationIds.remove(id);
        }
        emit(NotificationStateNewAvailable(
            isNew: readableNotificationIds.isNotEmpty));
      },
    );

    /// onRecievedPush
    on<NotificationEventOnReceivedPushNotification>(
      (event, emit) {
        log("Called in Nloc");

        emit(NotificationStateOnReceivedPush(message: event.message));
      },
    );

    /// On Delete Event Trigger
    on<NotificationEventDelete>(
      (event, emit) async {
        NotificationRepo().delete(notificationId: event.notificationId);

        emit(NotificationStateDeleted(uuid: event.notificationId));
      },
    );
  }
}
