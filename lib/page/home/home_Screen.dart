import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:petcare/blocs/notification/notification_state.dart';
import 'package:petcare/blocs/post/post_bloc.dart';
import 'package:petcare/blocs/post/post_status.dart';
import 'package:petcare/page/home/notification_screen.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:petcare/blocs/pet/pet_bloc.dart';
import 'package:petcare/blocs/pet/pet_event.dart';
import 'package:petcare/blocs/user/user_bloc.dart';
import 'package:petcare/blocs/user/user_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/page/home/home_drawer.dart';
import 'package:petcare/page/home/post/create_post.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_button_2.dart';

import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/post/post_event.dart';
import '../../models/post_model.dart';
import '../../widgets/pet_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? user = AppManager.currentUser;
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();
  List<PostModel> posts = AppManager.posts;
  bool isNewNotifications = false;

  void triggerFetchAllPetsEvent() {
    if (AppManager.pets.isEmpty) {
      // Only fetch if pets list is empty
      context.read<PetBloc>().add(PetEventFetchAll());
    }
  }

  void triggerFetchAllPosts(bool isFetchNew) {
    context.read<PostBloc>().add(PostEventFetchAll(isFetchNew: isFetchNew));
  }

  void triggerFetchNotificationsEvent() {
    context.read<NotificationBloc>().add(NotificationEventFetch());
  }

  void addScrollListener() {
    scrollController.addListener(
      () {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          triggerFetchAllPosts(false);
        }
      },
    );
  }

  // void handlePushNotifications() {
  //   PushNotificationServices().onNotificationReceived = (remote) {
  //     log("On Notification Received");
  //   };
  // }

  @override
  void initState() {
    // handlePushNotifications();
    triggerFetchAllPetsEvent(); // this is calling or intialising home again anad again s
    triggerFetchAllPosts(true);
    triggerFetchNotificationsEvent();
    addScrollListener();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Notification
        BlocListener<NotificationBloc, NotificationState>(
          listener: (_, state) {
            if (state is NotificationStateNewAvailable) {
              setState(() {
                isNewNotifications = state.isNew;
              });
            }
          },
        ),

        /// userbloc
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserStateProfileUpdated) {
              setState(() {
                user = AppManager.currentUser;
              });
            }
          },
        ),

        /// PostBloc
        BlocListener<PostBloc, PostState>(
          listener: (_, state) {
            if (state is PostStateFetchedAll ||
                state is PostStateFetchingAll ||
                state is PostStateFetchAllFailure ||
                state is PostStateUpdated ||
                state is PostStateCreated ||
                state is PostStateDeleted) {
              setState(() {
                isLoading = state.isLoading;
              });

              if (state is PostStateFetchAllFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }

              if (state is PostStateFetchedAll ||
                  state is PostStateCreated ||
                  state is PostStateUpdated ||
                  state is PostStateDeleted) {
                setState(() {
                  posts = List.from(AppManager.posts);
                });
              }
            }
          },
        ),
      ],
      child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Scaffold(
            floatingActionButton: InkWell(
                onTap: () {
                  Get.to(CreatePost());
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CircleAvatar(
                    backgroundColor: MyColors.primary,
                    radius: 3.h,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 4.h,
                    ),
                  ),
                )),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white30,
            body: Column(
              children: [
                Container(
                  height: 15.h,
                  decoration: BoxDecoration(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.find<MyDrawerController>().toggleDrawer();
                                },
                                child: Image.asset(
                                  "assets/icons/logox.png",
                                  height: 3.5.h,
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(NotificationScreen());
                                    },
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          "assets/nav/d3.png",
                                          color: Colors.white,
                                          height: 4.0.h,
                                        ),
                                        if (isNewNotifications)
                                          Positioned(
                                            right: 5,
                                            child: CircleAvatar(
                                              radius: 5,
                                              backgroundColor: Colors.red,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  gapW10,
                                  AvatarWidget(
                                    width: 5.h,
                                    height: 5.h,
                                    avatarUrl: user?.avatar,
                                    backgroundColor: Colors.black,
                                    placeholderChar:
                                        user?.name.characters.firstOrNull ?? "",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Expanded(
                          child: PaginateFirestore(
                        key: Key(''),
                        onEmpty: Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: Text(
                            "Nothing Found",
                            style: GoogleFonts.abel(
                              color: Colors.black,
                              fontSize: 18,
                              wordSpacing: 1.5,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        initialLoader: Padding(
                          padding: EdgeInsets.only(bottom: 45.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: Colors.black, strokeWidth: 2),
                          ),
                        ),
                        itemBuilder: (context, documentSnapshots, index) {
                          if (documentSnapshots[index].exists) {
                            PostModel model = PostModel.fromMap(
                                documentSnapshots[index].data()
                                    as Map<String, dynamic>);
                            return Column(
                              children: [
                                PetPost(
                                  post: model,
                                  key: GlobalKey(),
                                ),
                                if (index == documentSnapshots.length - 1)
                                  SizedBox(
                                      height:
                                          20.h), // Extra space after last post
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        },
                        query: FirebaseFirestore.instance
                            .collection('Dev-Posts')
                            .orderBy('createdAt', descending: true),
                        itemBuilderType: PaginateBuilderType.listView,
                        isLive: true,
                      )),
                    ],
                  ),
                ))
              ],
            ),
          )),
    );
  }
}
