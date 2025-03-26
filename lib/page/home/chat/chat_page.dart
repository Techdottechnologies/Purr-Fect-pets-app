import 'package:petcare/blocs/chat/%20chat_bloc.dart';
import 'package:petcare/blocs/chat/chat_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/chat_model.dart';
import 'package:petcare/page/home/community/community_info_screen.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_ink_well.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../widgets/txt_widget.dart';
import '../../../blocs/message/mesaage_bloc.dart';
import '../../../blocs/message/message_event.dart';
import '../../../models/message_model.dart';
import '../../../widgets/my_image_picker.dart';
import 'bubble_widget.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({super.key, required this.chat});
  final ChatModel chat;

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

TextEditingController cont = TextEditingController();

class _UserChatPageState extends State<UserChatPage> {
  late ChatModel chat = widget.chat;
  TextEditingController messageController = TextEditingController();

  void triggerSenderMediaMessageEvent(
      {required String fileUrl, required String contentType}) {
    context.read<MessageBloc>().add(
          MessageEventSend(
            content: fileUrl,
            type: MessageType.photo,
            conversationId: widget.chat.uuid,
            friendId: "",
          ),
        );
  }

  void onMediaPressed() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection((exception, data) {
      if (data is XFile) {
        triggerSenderMediaMessageEvent(
          fileUrl: data.path,
          contentType: "image/jpeg",
        );
      }
    });
  }

  void triggerSenderMessageEvent() {
    context.read<MessageBloc>().add(
          MessageEventSend(
            content: messageController.text,
            type: MessageType.text,
            conversationId: widget.chat.uuid,
            friendId: ""
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatBloc, ChatState>(
          listener: (_, state) {
            if (state is ChatStateUpdates) {
              setState(() {
                final int index =
                    state.chats.indexWhere((e) => e.uuid == chat.uuid);
                if (index > -1) {
                  chat = state.chats[index];
                } else {
                  Get.back();
                  CustomDialogs().errorBox(
                    message: "You're no longer a member of this community",
                  );
                }
              });
            }
          },
        )
      ],
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              Container(
                height: 15.h,
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
          Positioned.fill(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: 100.w,
                    child: Row(
                      children: [
                        SizedBox(width: 1.w),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: chat.participantUids
                                    .contains(AppManager.currentUser?.uid)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: TextField(
                                      controller: messageController,
                                      style: GoogleFonts.roboto(
                                          fontSize: 16.sp, color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Color(0xffF9F9F9),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                        suffixIconConstraints:
                                            BoxConstraints(minWidth: 10.w),
                                        prefixIcon: InkWell(
                                          onTap: () {
                                            onMediaPressed();
                                          },
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Center(
                                              child: Icon(
                                                Icons.photo_library_rounded,
                                                color: MyColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomInkWell(
                                              onTap: () {
                                                if (messageController.text !=
                                                    "") {
                                                  triggerSenderMessageEvent();
                                                  messageController.clear();
                                                }
                                              },
                                              child: Image.asset(
                                                "assets/icons/send.png",
                                                height: 2.4.h,
                                                color: MyColors.primary,
                                              ),
                                            ),
                                            // SizedBox(width: 4.w),
                                          ],
                                        ),
                                        hintText: "Write Here",
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.black54,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "You can't send messages to this community because you're no longer a member."),
                          ),
                        ),
                        SizedBox(width: 1.w)
                      ],
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: CustomInkWell(
                        onTap: () {
                          Get.to(CommunityInfoScreen(chat: chat));
                        },
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Remix.arrow_left_s_line,
                                color: Colors.white,
                                size: 3.h,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            AvatarWidget(
                              backgroundColor: Colors.black,
                              placeholderChar:
                                  chat.title.characters.firstOrNull ?? "",
                              avatarUrl: chat.avatar ?? '',
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(
                                  chat.title,
                                  fontSize: 16.4.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                textWidget(
                                  "${chat.participants.length} ${chat.participants.length > 1 ? "Members" : "Member"}",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            // Spacer(),
                            // selectPopup()
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Expanded(child: BubbleWidget(conversationId: chat.uuid)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget selectPopup() => PopupMenuButton<int>(
      color: Color(0xffF9F8F8),
      constraints: BoxConstraints.expand(width: 47.w, height: 8.h),
      // surfaceTintColor: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 1.w),
              Image.asset(
                "assets/icons/log.png",
                height: 2.h,
              ),
              SizedBox(width: 3.w),
              textWidget(
                "Leave Community",
                fontWeight: FontWeight.w300,
                fontSize: 16.sp,
              ),
            ],
          ),
        ),
      ],
      // initialValue: 0,
      onCanceled: () {},
      onSelected: (value) {
        Get.back();
      },
      icon: Icon(
        Icons.more_vert_outlined,
        color: Colors.white,
      ),
      offset: const Offset(0, 50),
    );
