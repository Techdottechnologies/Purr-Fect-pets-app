import 'package:petcare/blocs/message/mesaage_bloc.dart';
import 'package:petcare/blocs/message/message_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/page/home/community/create_community.dart';
import 'package:petcare/services/local_storage/local_storage_services.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/utils/helping_methods.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../blocs/chat/ chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../manager/app_manager.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../chat/chat_page.dart';

class Community_page extends StatefulWidget {
  const Community_page({super.key});

  @override
  State<Community_page> createState() => _Community_pageState();
}

class _Community_pageState extends State<Community_page> {
  List<ChatModel> chats = [];
  List<ChatModel> filteredChats = [];
  bool isLoading = false;
  void triggerFetchChatsEvent() {
    context.read<ChatBloc>().add(ChatEventFetchAll());
  }

  void triggerSearchChatEvent(String search) {
    context.read<ChatBloc>().add(ChatEventSearch(by: search));
  }

  @override
  void initState() {
    triggerFetchChatsEvent();
    super.initState();
  }

  int current1 = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatStateJoinFailure) {
          CustomDialogs().errorBox(message: state.exception.message);
        }
        if (state is ChatStateFetching ||
            state is ChatStateUpdates ||
            state is ChatStateFetchFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ChatStateUpdates) {
            state.chats.sort(
              (a, b) => (b.lastMessage?.messageTime ?? b.createdAt)
                  .millisecondsSinceEpoch
                  .compareTo((a.lastMessage?.messageTime ?? a.createdAt)
                      .millisecondsSinceEpoch),
            );
            setState(() {
              chats = state.chats;
              filteredChats = state.chats;
            });
          }

          if (state is ChatStateFetchFailure) {
            debugPrint(state.exception.message);
          }
        }

        if (state is ChatStateSearchFailure ||
            state is ChatStateSearched ||
            state is ChatStateSearching) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ChatStateSearched) {
            setState(() {
              filteredChats = state.chats;
            });
          }

          if (state is ChatStateSearchFailure) {
            setState(() {
              filteredChats = [];
            });
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 90),
          child: IconButton(
            onPressed: () {
              Get.to(CreateCommunity());
            },
            icon: Icon(Icons.add),
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(MyColors.primary),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                iconSize: WidgetStatePropertyAll(25),
                padding: WidgetStatePropertyAll(EdgeInsets.all(20))),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    textWidget(
                      "Community",
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // textFieldWithPrefixSuffuxIconAndHintText(
                //   "Search",
                //   fillColor: Color(0xffF9F9F9),
                //   mainTxtColor: Colors.black,
                //   radius: 20,
                //   enable: true,
                //   bColor: Colors.transparent,
                //   suffixIcon: "assets/icons/s1.png",
                //   isSuffix: true,
                //   onCompleted: (p0) {
                //     if (p0 != "") {
                //       triggerSearchChatEvent(p0);
                //     }
                //   },
                //   onTyping: (p0) {
                //     if (p0 == "") {
                //       setState(() {
                //         filteredChats = chats;
                //       });
                //     }
                //   },
                // ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 0, bottom: 160),
                          itemCount: chats.length,
                          itemBuilder: (ctx, index) {
                            final ChatModel chat = chats[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: _ChatWidget(chat),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatWidget extends StatefulWidget {
  const _ChatWidget(this.chat);
  final ChatModel chat;

  @override
  State<_ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<_ChatWidget> {
  final UserModel? user = AppManager.currentUser;
  List<String> readMessages = [];

  void triggerAddMemberEvent() {
    context.read<ChatBloc>().add(ChatEventJoin(chatId: widget.chat.uuid));
  }

  void checkIsReadMessages() async {
    readMessages = await LocalStorageServices().getMessageIds();
    setState(() {});
  }

  @override
  void initState() {
    checkIsReadMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final isChatMember = widget.chat.participantUids.contains(user!.uid);
    late bool isReadMessage =
        widget.chat.lastMessage?.senderId == AppManager.currentUser!.uid ||
            readMessages.contains(widget.chat.lastMessage?.messageId);

    return MultiBlocListener(
      listeners: [
        BlocListener<MessageBloc, MessageState>(
          listener: (_, state) {
            if (state is MessageStateRead) {
              setState(() {
                readMessages.addAll(state.ids);
              });
            }
          },
        )
      ],
      child: InkWell(
        onTap: () async {
          if (widget.chat.participantUids.contains(user?.uid)) {
            await Get.to(UserChatPage(chat: widget.chat));
            checkIsReadMessages();
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 0, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(Radius.circular(21)),
          ),
          child: ListTile(
            // titleAlignment: ListTileTitleAlignment.top,
            leading: AvatarWidget(
              width: 4.h,
              height: 4.h,
              placeholderChar: widget.chat.title.characters.firstOrNull ?? "G",
              avatarUrl: widget.chat.avatar ?? '',
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.chat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isChatMember)
                  Text(
                    formatChatDateToString(
                            widget.chat.lastMessage?.messageTime ??
                                widget.chat.createdAt) ??
                        "-",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isReadMessage ? FontWeight.w400 : FontWeight.w900,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isChatMember)
                  Text(
                    widget.chat.lastMessage?.type == MessageType.text
                        ? "${widget.chat.lastMessage?.senderId == AppManager.currentUser?.uid ? "You: ${widget.chat.lastMessage?.content}" : "${widget.chat.lastMessage?.senderName}: ${widget.chat.lastMessage?.content}"}"
                        : widget.chat.lastMessage?.type == MessageType.photo
                            ? widget.chat.lastMessage?.senderId ==
                                    AppManager.currentUser?.uid
                                ? "You sent Photo"
                                : "${widget.chat.lastMessage?.senderName}: Sent a photo"
                            : widget.chat.lastMessage?.content ?? "",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isReadMessage ? FontWeight.w400 : FontWeight.w900,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (!isChatMember)
                  Column(
                    children: [
                      gapH20,
                      gradientButton(
                        "Join Community",
                        font: 14,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerAddMemberEvent();
                        },
                        width: 40,
                        height: 3.6,
                        isColor: true,
                        clr: MyColors.primary,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//12345

// import 'package:petcare/config/colors.dart';
// import 'package:petcare/page/home/bottom_navigation.dart';
// import 'package:petcare/page/home/chat/chat_page.dart';
// import 'package:petcare/page/home/community/community_view.dart';
// import 'package:petcare/page/home/community/create_community.dart';
// import 'package:petcare/widgets/custom_button.dart';
// import 'package:petcare/widgets/custom_button_2.dart';
// import 'package:petcare/widgets/txt_field.dart';
// import 'package:petcare/widgets/txt_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:remixicon/remixicon.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class Community_page extends StatefulWidget {
//   const Community_page({super.key});

//   @override
//   State<Community_page> createState() => _Community_pageState();
// }

// class _Community_pageState extends State<Community_page> {
//   int current1 = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       floatingActionButton: Column(
//         children: [
//           Spacer(
//             flex: 8,
//           ),
//           InkWell(
//               onTap: () {
//                 Get.to(CreateCommunity());
//               },
//               child: Image.asset(
//                 "assets/images/cm.png",
//                 height: 5.h,
//               )),
//           Spacer(),
//         ],
//       ),
//       body: SafeArea(
//         bottom: false,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Get.find<NavController>().currentIndex = 0;
//                         Get.find<NavController>().update();
//                         setState(() {});
//                       },
//                       child: CircleAvatar(
//                         radius: 2.3.h,
//                         backgroundColor: MyColors.primary,
//                         child: Icon(
//                           Remix.arrow_left_s_line,
//                           color: Colors.white,
//                           size: 3.h,
//                         ),
//                       ),
//                     ),
//                     Spacer(),
//                     textWidget("Community",
//                         fontWeight: FontWeight.w600, fontSize: 18.sp),
//                     Spacer(),
//                     CircleAvatar(
//                       radius: 2.3.h,
//                       backgroundColor: Colors.transparent,
//                       child: Icon(
//                         Remix.arrow_left_s_line,
//                         color: Colors.transparent,
//                         size: 3.h,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 3.h),
//                 textFieldWithPrefixSuffuxIconAndHintText(
//                   "Search",
//                   // controller: _.password,
//                   fillColor: Color(0xffF9F9F9),
//                   mainTxtColor: Colors.black,
//                   radius: 40,
//                   bColor: Colors.transparent,
//                   suffixIcon: "assets/icons/s1.png",
//                   isSuffix: true,
//                 ),
//                 SizedBox(height: 3.h),
                // Row(
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           current1 = 0;
                //         });
                //       },
                //       child: Column(
                //         children: [
                //           text_widgetP("All Community",
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: current1 == 0
                //                   ? Colors.black
                //                   : Color(0xffC5C5C5)),
                //           SizedBox(
                //             width: 30.w,
                //             child: Divider(
                //               thickness: 3,
                //               color: current1 == 0
                //                   ? MyColors.primary
                //                   : Colors.transparent,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 3.w),
                //     InkWell(
                //       onTap: () {
                //         setState(() {
                //           current1 = 1;
                //         });
                //       },
                //       child: Column(
                //         children: [
                //           text_widgetP("My Community",
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: current1 == 1
                //                   ? Colors.black
                //                   : Color(0xffC5C5C5)),
                //           SizedBox(
                //             width: 30.w,
                //             child: Divider(
                //               thickness: 3,
                //               color: current1 == 1
                //                   ? MyColors.primary
                //                   : Colors.transparent,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 2.h),
//                 current1 == 0
//                     ? Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Color(0xffF9F9F9),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(18.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       CircleAvatar(
//                                         // radius: 1.9.h,
//                                         backgroundImage:
//                                             AssetImage("assets/images/dog.png"),
//                                       ),
//                                       SizedBox(width: 2.w),
//                                       textWidget(
//                                         "Pawsitive Pets United",
//                                         fontSize: 15.6.sp,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 1.h),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         color: Color(0xffF2F2F2),
//                                         borderRadius:
//                                             BorderRadius.circular(22)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Row(
//                                         children: [
//                                           CircleAvatar(
//                                             backgroundImage: AssetImage(
//                                                 "assets/images/dog.png"),
//                                           ),
//                                           SizedBox(width: 2.w),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               textWidget(
//                                                 "Community Title",
//                                                 fontSize: 14.6.sp,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                               SizedBox(height: 0.3.h),
//                                               textWidget(
//                                                   "Faisal: Lorem Ipsum is simply dummy text of\nthe printing and.",
//                                                   fontSize: 12.5.sp,
//                                                   color: Colors.black),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 1.h),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         color: Color(0xffF2F2F2),
//                                         borderRadius:
//                                             BorderRadius.circular(22)),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Row(
//                                         children: [
//                                           CircleAvatar(
//                                             backgroundImage: AssetImage(
//                                                 "assets/images/dog.png"),
//                                           ),
//                                           SizedBox(width: 2.w),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               textWidget("Announcements Title ",
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 14.6.sp),
//                                               SizedBox(height: 0.3.h),
//                                               textWidget(
//                                                   "Faisal: Lorem Ipsum is simply dummy text of\nthe printing and.",
//                                                   fontSize: 12.5.sp,
//                                                   color: Colors.black),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 1.h),
//                           Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(22)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundImage:
//                                         AssetImage("assets/images/dog.png"),
//                                   ),
//                                   SizedBox(width: 2.w),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       textWidget("Announcements Title ",
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14.6.sp),
//                                       SizedBox(height: 0.3.h),
//                                       textWidget(
//                                           "Faisal: Lorem Ipsum is simply dummy text of\nthe printing and.",
//                                           fontSize: 12.5.sp,
//                                           color: Colors.black),
//                                       SizedBox(height: 2.h),
//                                       gradientButton("Join Community",
//                                           font: 14,
//                                           txtColor: MyColors.white,
//                                           ontap: () {},
//                                           width: 40,
//                                           height: 3.6,
//                                           isColor: true,
//                                           clr: MyColors.primary),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ...List.generate(5, (index) => chatList(index))
//                         ],
//                       )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget chatList(index) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: InkWell(
//       onTap: () {
//         // Get.to(UserChatPage(
//         //   IsSupport: false,
//         // ));
//         Get.to(CommunityView());
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: ListTile(
//           // isThreeLine: true,
//           leading: CircleAvatar(
//             backgroundColor: MyColors.primary,
//             radius: 2.8.h,
//             backgroundImage: AssetImage("assets/images/dog.png"),
//           ),
//           title: Row(
//             children: [
//               textWidget(
//                 "Pawsitive Pets United",
//                 fontWeight: FontWeight.w500,
//                 fontSize: 15.sp,
//               ),
//               Spacer(),
//               textWidget("54 min Ago",
//                   fontSize: 11.5.sp, color: Color(0xff9CA3AF)),
//             ],
//           ),
//           subtitle: textWidget(
//             "Faisal: Lorem Ipsum is simply dummy text of the printing and.",
//             fontSize: 12.4.sp,
//           ),
//         ),
//       ),
//     ),
//   );
// }
