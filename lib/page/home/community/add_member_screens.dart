// Project: 	   balanced_workout
// File:    	   add_member_screens
// Path:    	   lib/screens/main/user/community/add_member_screens.dart
// Author:       Ali Akbar
// Date:        09-05-24 16:51:01 -- Thursday
// Description:

import 'package:petcare/config/colors.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user_model.dart';
import '../../../../utils/constants/app_theme.dart';
import '../../../../utils/constants/constants.dart';
import '../../../blocs/chat/ chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_profile_model.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_title_textfiled.dart';
import '../../../widgets/paddings.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key, required this.chat});
  final ChatModel chat;
  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  List<UserModel> filteredUsers = [];
  List<UserModel> allUsers = [];

  late List<UserProfileModel> addedUsers = [];
  bool isSearching = false;
  bool isFetching = false;
  bool isAdding = false;
  bool isFetchedAll = false;
  DocumentSnapshot? lastSnapDoc;
  final ScrollController scrollController = ScrollController();

  void triggerFetchAllMembers() {
    context.read<UserBloc>().add(
          UserEventFetchAll(
            ignoreIds: widget.chat.participantUids,
            lastDocSnap: lastSnapDoc,
          ),
        );
  }

  void triggerSendInviteMemberEvent() {
    context.read<ChatBloc>().add(
          ChatEventSendInvites(users: addedUsers, chat: widget.chat),
        );
  }

  void addScrollListener() {
    scrollController.addListener(
      () {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!isFetchedAll) {
            triggerFetchAllMembers();
          }
        }
      },
    );
  }

  @override
  void initState() {
    triggerFetchAllMembers();
    addScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// UserBloc
        BlocListener<UserBloc, UserState>(
          listener: (ctx, state) {
            if (state is UserStateFetchedAll ||
                state is UserStateFetchingAll ||
                state is UserStateFetchedAll ||
                state is UserStateLastSnapDocRecieved) {
              setState(() {
                isFetching = state.isLoading;
              });

              if (state is UserStateFetchedAll) {
                setState(() {
                  isFetchedAll = state.users.isEmpty;
                });

                if (isFetchedAll) {}

                for (final UserModel user in state.users) {
                  if (!allUsers.contains(user)) {
                    allUsers.add(user);
                  }
                }
                setState(() {
                  filteredUsers = allUsers;
                });
              }

              if (state is UserStateLastSnapDocRecieved) {
                lastSnapDoc = state.lastDocumentSnapshot;
              }
            }

            if (state is UserStateSearchFetchFailure ||
                state is UserStateSearchFetched ||
                state is UserStateSearchFetching) {
              setState(() {
                isSearching = state.isLoading;
              });

              if (state is UserStateSearchFetched) {
                setState(() {
                  filteredUsers = state.users;
                });
              }

              if (state is UserStateSearchFetchFailure) {
                debugPrint(state.exception.message);
              }
            }
          },
        ),

        /// ChatBloc
        BlocListener<ChatBloc, ChatState>(
          listener: (ctx, state) {
            if (state is ChatStateSentInvites ||
                state is ChatStateSendingInvites ||
                state is ChatStateSendInvitesFailure) {
              setState(() {
                isAdding = state.isLoading;
              });

              if (state is ChatStateSentInvites) {
                setState(() {
                  addedUsers = [];
                });
                CustomDialogs().successBox(message: "Invites sent");
              }

              if (state is ChatStateSendInvitesFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: HorizontalPadding(
          child: Visibility(
            visible: addedUsers.isNotEmpty,
            child: CustomButton(
              backgroundColor: MyColors.primary,
              isLoading: isAdding,
              onPressed: () {
                triggerSendInviteMemberEvent();
              },
              title: 'Send ${addedUsers.length > 1 ? "Invites" : "Invite"}',
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Add Members"),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 29, right: 29, top: 30, bottom: 30),
          child: Column(
            children: [
              /// Search TF
              CustomTextField(
                hintText: 'Search',
                prefixWidget: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                textInputAction: TextInputAction.search,
                onChange: (text) {
                  if (text == "") {
                    setState(() {
                      filteredUsers = allUsers;
                    });
                  }
                },
                onSubmitted: (text) {
                  final ignoreIds = widget.chat.participantUids;
                  ignoreIds.addAll(addedUsers.map((e) => e.uid).toList());
                  context.read<UserBloc>().add(
                        UserEventSearchUsers(
                          search: text,
                          ignoreIds: ignoreIds,
                        ),
                      );
                },
              ),

              /// Profile List View
              Expanded(
                child: isSearching
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : filteredUsers.isEmpty
                        ? Center(
                            child: Text("No users found"),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: filteredUsers.length,
                                  padding: const EdgeInsets.only(
                                    top: 22,
                                    bottom: 80,
                                  ),
                                  itemBuilder: (context, index) {
                                    final UserModel user = filteredUsers[index];
                                    late final bool isSelected = addedUsers
                                        .where(
                                          (e) => e.uid == user.uid,
                                        )
                                        .isNotEmpty;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: CustomContainer(
                                        onPressed: () {
                                          final int index =
                                              addedUsers.indexWhere(
                                                  (e) => e.uid == user.uid);
                                          setState(() {
                                            if (index > -1) {
                                              addedUsers.removeAt(index);
                                            } else {
                                              addedUsers.add(UserProfileModel(
                                                uid: user.uid,
                                                name: user.name,
                                                avatarUrl: user.avatar ?? "",
                                              ));
                                            }
                                          });
                                        },
                                        color: const Color(0xFF232323)
                                            .withOpacity(0.16),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 9,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            /// Custom Avatar
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  AvatarWidget(
                                                    width: 41,
                                                    height: 41,
                                                    backgroundColor:
                                                        Colors.black,
                                                    avatarUrl: user.avatar,
                                                  ),
                                                  gapW10,

                                                  /// Name Text
                                                  Flexible(
                                                    child: Text(
                                                      user.name,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Checkbox(
                                              value: isSelected,
                                              onChanged: (value) {},
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(300)),
                                              ),
                                              fillColor:
                                                  const WidgetStatePropertyAll(
                                                      Colors.transparent),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              side: WidgetStateBorderSide
                                                  .resolveWith(
                                                (states) => BorderSide(
                                                  color: !isSelected
                                                      ? const Color(0xFF434242)
                                                      : AppTheme.primaryColor1,
                                                ),
                                              ),
                                              checkColor: MyColors.primary,
                                              visualDensity:
                                                  VisualDensity.comfortable,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (isFetching)
                                Center(child: CircularProgressIndicator()),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
