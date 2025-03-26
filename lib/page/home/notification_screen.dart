import 'package:petcare/blocs/notification/notification_bloc.dart';
import 'package:petcare/blocs/notification/notification_event.dart';
import 'package:petcare/blocs/notification/notification_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationModel> notifications =
      context.read<NotificationBloc>().notifications;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationBloc, NotificationState>(
          listener: (_, state) {
            if (state is NotificationStateSaveFailure) {
              CustomDialogs().errorBox(message: state.exception.message);
            }
            if (state is NotificationStateFetched ||
                state is NotificationStateFetching ||
                state is NotificationStateFetchFailure ||
                state is NotificationStateUpdated) {
              setState(() {
                isLoading = state.isLoading;
              });

              if (state is NotificationStateUpdated) {
                setState(() {
                  notifications = state.notifications;
                });
              }

              if (state is NotificationStateFetched) {
                notifications.sort((a, b) => b.createdAt.millisecondsSinceEpoch
                    .compareTo(a.createdAt.millisecondsSinceEpoch));
                setState(() {});
              }
            }
          },
        ),
      ],
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              context
                                  .read<NotificationBloc>()
                                  .add(NotificationEventMarkReadable());

                              Get.back();
                            },
                            child: CircleAvatar(
                              radius: 2.3.h,
                              backgroundColor: MyColors.primary,
                              child: Icon(
                                Remix.arrow_left_s_line,
                                color: Colors.white,
                                size: 3.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          textWidget(
                            "Notification",
                            fontWeight: FontWeight.w500,
                            fontSize: 19.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : notifications.isEmpty
                                ? Center(
                                    child: Text("No updates."),
                                  )
                                : ListView.builder(
                                    itemCount: notifications.length,
                                    padding: EdgeInsets.only(top: 20),
                                    itemBuilder: (ctx, index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: notifications[index].type ==
                                                NotificationType.invite
                                            ? _InviteCell(notifications[index])
                                            : _AvatarCell(notifications[index]),
                                      );
                                    },
                                  ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextDescriptionCell extends StatelessWidget {
  const _TextDescriptionCell();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            "Notification heading here",
            fontSize: 15.5.sp,
          ),
          SizedBox(height: 0.6.h),
          textWidget(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown",
              fontSize: 14.sp,
              fontWeight: FontWeight.w200,
              color: Color(0xff080422)),
        ],
      ),
    );
  }
}

class _InviteCell extends StatelessWidget {
  const _InviteCell(this.notification);
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(
                width: 40,
                height: 40,
                avatarUrl: notification.avatar,
                placeholderChar:
                    notification.title.characters.firstOrNull ?? "N",
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(notification.title),
                  text_w(
                    notification.message,
                    fontSize: 13.6.sp,
                    maxline: 2,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (notification.data?['status'] == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: gradientButton(
                      "Reject",
                      font: 14,
                      txtColor: MyColors.primary,
                      ontap: () {
                        context.read<NotificationBloc>().add(
                            NotificationEventRejectPressed(
                                notificationId: notification.uuid));
                      },
                      width: 90,
                      height: 3.6,
                      isColor: false,
                      clr: MyColors.white,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: gradientButton(
                      "Accept",
                      font: 14,
                      txtColor: MyColors.white,
                      ontap: () {
                        context.read<NotificationBloc>().add(
                            NotificationEventAcceptPressed(
                                notificationId: notification.uuid,
                                data: notification.data?['chat'] ?? {},
                                addedBy: notification.title));
                      },
                      width: 90,
                      height: 3.6,
                      isColor: true,
                      clr: MyColors.primary,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _AvatarCell extends StatelessWidget {
  const _AvatarCell(this.notification);
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarWidget(
                  width: 40,
                  height: 40,
                  avatarUrl: notification.avatar,
                  placeholderChar:
                      notification.title.characters.firstOrNull ?? "N",
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(notification.title),
                    text_w(notification.message, fontSize: 13.6.sp, maxline: 2)
                  ],
                ),
              ],
            ),
            // SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
