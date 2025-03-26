// Project: 	   balanced_workout
// File:    	   community_info_screen
// Path:    	   lib/screens/main/user/community/community_info_screen.dart
// Author:       Ali Akbar
// Date:        09-05-24 16:08:51 -- Thursday
// Description:

import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/user_profile_model.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/constants/app_theme.dart';
import '../../../../utils/constants/constants.dart';
import '../../../blocs/chat/ chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/extensions/navigation_service.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/circle_button.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_title_textfiled.dart';
import '../../../widgets/my_image_picker.dart';
import 'add_member_screens.dart';

class CommunityInfoScreen extends StatefulWidget {
  const CommunityInfoScreen({super.key, required this.chat});
  final ChatModel chat;

  @override
  State<CommunityInfoScreen> createState() => _CommunityInfoScreenState();
}

class _CommunityInfoScreenState extends State<CommunityInfoScreen> {
  late ChatModel chat = widget.chat;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  String? avatar;
  final UserModel? user = AppManager.currentUser;
  late bool isAdmin = chat.admins.contains(user?.uid);
  late bool isCreator = chat.createdBy == user?.uid;

  void triggerUpdateProfileEvent() {
    context.read<ChatBloc>().add(
          ChatEventUpdate(
              title: nameController.text,
              chatId: chat.uuid,
              maxMembers: int.tryParse(maxController.text) ?? 0,
              description: descriptionController.text,
              avatar: avatar),
        );
  }

  void triggerExitCommunityEvent() {
    CustomDialogs().alertBox(
      title: "Exit Community",
      message: "Are you sure to exit this community?",
      positiveTitle: "Exit",
      onPositivePressed: () {
        Navigator.of(context).popUntil((e) => e.isFirst);
        context.read<ChatBloc>().add(ChatEventExit(
            chatId: chat.uuid,
            members: chat.participants,
            isCreator: isCreator,
            isAdmin: isAdmin));
      },
    );
  }

  void triggerRemoveMemberEvent(UserProfileModel removedUser) {
    CustomDialogs().alertBox(
      title: "Remove Member",
      message: "Are you sure to remove ${removedUser.name}?",
      positiveTitle: "Remove",
      onPositivePressed: () {
        context
            .read<ChatBloc>()
            .add(ChatEventRemoveMember(chatId: chat.uuid, member: removedUser));
      },
    );
  }

  void triggerDeleteEvent() {
    CustomDialogs().deleteBox(
      title: "Delete Community",
      message: "Are you sure to this community? This process will not be undo.",
      onPositivePressed: () {
        context.read<ChatBloc>().add(ChatEventDelete(chatId: chat.uuid));
      },
    );
  }

  void triggerAddAdminEvent(UserProfileModel adminUser) {
    context
        .read<ChatBloc>()
        .add(ChatEventAddAdmin(chatId: chat.uuid, user: adminUser));
  }

  void triggerRemoveAdminEvent(UserProfileModel adminUser) {
    context
        .read<ChatBloc>()
        .add(ChatEventRemoveAdmin(chatId: chat.uuid, user: adminUser));
  }

  void showImagePicker() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            avatar = data.path;
          });
        }
      },
    );
  }

  void setData() {
    nameController.text = chat.title;
    descriptionController.text = chat.description ?? "";
    avatar = chat.avatar;
    maxController.text = chat.maxMemebrs.toString();

    isAdmin = chat.admins.contains(user?.uid);
    isCreator = chat.createdBy == user?.uid;
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatStateDeleted) {
          Navigator.of(context).popUntil((e) => e.isFirst);
        }

        if (state is ChatStateExited) {}

        if (state is ChatStateRemovedAdmin ||
            state is ChatStateMadeAdmin ||
            state is ChatStateRemovedAdmin ||
            state is ChatStateAddedMembers) {}

        if (state is ChatStateUpdates) {
          final int index = state.chats.indexWhere((e) => e.uuid == chat.uuid);
          if (index > -1) {
            setState(() {
              chat = state.chats[index];
            });
          }

          setState(() {
            setData();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Community Info"),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            CustomMenuDropdown(
              width: SCREEN_WIDTH * 0.6,
              items: [
                if (isAdmin)
                  DropdownMenuModel(
                    title: "Add Members",
                    icon: Icons.add_sharp,
                  ),
                if (isAdmin)
                  DropdownMenuModel(title: "Save Changes", icon: Icons.save),
                DropdownMenuModel(
                    title: "Exit Community", icon: Icons.logout_rounded),
                if (isCreator)
                  DropdownMenuModel(
                    title: "Delete Community",
                    icon: Icons.delete,
                  ),
              ],
              onSelectedItem: (val, index) {
                if (val == "Save Changes") {
                  triggerUpdateProfileEvent();
                }

                if (val == "Add Members") {
                  NavigationService.go(AddMemberScreen(chat: chat));
                }

                if (val == "Exit Community") {
                  triggerExitCommunityEvent();
                }

                if (val == "Delete Community") {
                  triggerDeleteEvent();
                }
              },
            )
          ],
        ),
        body: ListView(
          padding:
              const EdgeInsets.only(top: 47, left: 29, right: 29, bottom: 100),
          children: [
            /// Profile Widget
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  children: [
                    Positioned(
                      child: AvatarWidget(
                        backgroundColor: Colors.green,
                        width: 110,
                        height: 110,
                        placeholderChar:
                            chat.title.characters.firstOrNull ?? "B",
                        avatarUrl: avatar ?? "",
                      ),
                    ),

                    /// Camera Icon
                    if (isAdmin)
                      Positioned(
                        right: 0,
                        bottom: 20,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircleButton(
                            onPressed: () {
                              showImagePicker();
                            },
                            icon: 'assets/icons/camera-ic.svg',
                            backgroundColor: AppTheme.primaryColor1,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// Name
            gapH22,
            CustomTextField(
              controller: nameController,
              titleText: "Name",
              hintText: 'Community Name',
              isReadyOnly: !isAdmin,
            ),

            /// Description
            gapH22,
            CustomTextField(
              controller: descriptionController,
              titleText: "Description",
              hintText: 'Write Description',
              maxLines: 8,
              isReadyOnly: !isAdmin,
            ),

            /// Maximum Members
            gapH22,
            CustomTextField(
              controller: maxController,
              titleText: "Max Community Limit",
              hintText: 'Add number of persons can join.',
              keyboardType: TextInputType.number,
              isReadyOnly: !isAdmin,
            ),

            gapH22,

            /// Members Detail Screen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${chat.participants.length} ${chat.participants.length > 1 ? "Members" : "Member"}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    onPressed: () {
                      NavigationService.go(AddMemberScreen(chat: chat));
                    },
                    icon: const Icon(Icons.add, color: MyColors.primary),
                  )
              ],
            ),
            gapH10,
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                // color: Color.fromARGB(255, 233, 229, 229),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < chat.participants.length; i++)
                    Builder(builder: (context) {
                      final isUserAdmin =
                          chat.admins.contains(chat.participants[i].uid);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: CustomContainer(
                          onPressed: () {},
                          color: Color.fromARGB(255, 154, 153, 153)
                              .withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 9),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Custom Avatar
                              Expanded(
                                child: Row(
                                  children: [
                                    AvatarWidget(
                                      width: 41,
                                      height: 41,
                                      backgroundColor: Colors.black,
                                      avatarUrl: chat.participants[i].avatarUrl,
                                    ),
                                    gapW10,

                                    /// Name Text
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Row(
                                              children: [
                                                Text(
                                                  chat.participants[i].uid ==
                                                          user?.uid
                                                      ? "You"
                                                      : chat
                                                          .participants[i].name,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                gapW10,
                                                if (isUserAdmin ||
                                                    chat.participants[i].uid ==
                                                        chat.createdBy)
                                                  Text(
                                                    chat.participants[i].uid ==
                                                            chat.createdBy
                                                        ? "Creator"
                                                        : "Admin",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          gapW6,
                                          if (isAdmin &&
                                              chat.participants[i].uid !=
                                                  user?.uid &&
                                              chat.createdBy !=
                                                  chat.participants[i].uid)
                                            CustomMenuDropdown(
                                              width: SCREEN_WIDTH * 0.6,
                                              items: [
                                                if (!isUserAdmin)
                                                  DropdownMenuModel(
                                                    title: "Make Admin",
                                                    icon:
                                                        Icons.person_add_alt_1,
                                                  ),
                                                if (isUserAdmin)
                                                  DropdownMenuModel(
                                                    title: "Remove Admin",
                                                    icon: Icons.remove_circle,
                                                  ),
                                                DropdownMenuModel(
                                                  title: "Remove Member",
                                                  icon:
                                                      Icons.person_off_rounded,
                                                ),
                                              ],
                                              onSelectedItem: (val, index) {
                                                if (val == "Make Admin") {
                                                  triggerAddAdminEvent(
                                                      chat.participants[i]);
                                                }
                                                if (val == "Remove Admin") {
                                                  triggerRemoveAdminEvent(
                                                      chat.participants[i]);
                                                }

                                                if (val == "Remove Member") {
                                                  triggerRemoveMemberEvent(
                                                      chat.participants[i]);
                                                }
                                              },
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
