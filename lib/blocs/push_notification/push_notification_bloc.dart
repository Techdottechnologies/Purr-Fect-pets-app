// Project: 	   muutsch
// File:    	   push_notification_bloc
// Path:    	   lib/blocs/push_notification/push_notification_bloc.dart
// Author:       Ali Akbar
// Date:        20-05-24 18:54:04 -- Monday
// Description:

import 'dart:developer';

import 'package:petcare/manager/app_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/notifications/push_notification_services.dart';
import '../../utils/constants/constants.dart';
import 'psuh_notification_event.dart';
import 'push_notification_state.dart';

class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> {
  PushNotificationBloc() : super(PushNotificationStateInitial()) {
    // ===========================Friend Request Events================================
    on<PushNotificationEventUserSubscribed>(
      (event, emit) async {
        try {
          await PushNotificationServices().subscribe(
              forTopic:
                  "$PUSH_NOTIFICATION_USER${AppManager.currentUser?.uid}");
          emit(PushNotificationStateUserSubscribed());
        } catch (e) {
          log("[debug UserRequestSubscribed] $e");
        }
      },
    );

    on<PushNotificationEventUserUnSubscribed>(
      (event, emit) async {
        try {
          await PushNotificationServices().unSubscribeAllTopics();
          emit(PushNotificationStateUserUnSubscribed());
        } catch (e) {
          log("[debug UserRequestUnSubscribed] $e");
        }
      },
    );
  }
}
