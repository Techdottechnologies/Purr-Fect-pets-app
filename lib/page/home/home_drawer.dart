import 'dart:async';
import 'dart:developer';
import 'package:petcare/blocs/auth/auth_bloc.dart';
import 'package:petcare/blocs/auth/auth_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/page/auth/login_page.dart';
import 'package:petcare/page/auth/reset_password.dart';
import 'package:petcare/page/auth/upload_picture.dart';
import 'package:petcare/page/controller/nav_Controller.dart';
import 'package:petcare/page/home/bottom_navigation.dart';
import 'package:petcare/page/home/contact_us.dart';
import 'package:petcare/page/home/notification_screen.dart';
import 'package:petcare/page/home/post/all_post.dart';
import 'package:petcare/page/home/terms_page.dart';
import 'package:petcare/page/home/write_review.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_event.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../utils/dialogs/dialogs.dart';

List titles = [
  "Home",
  "My Post",
  "Notifications",
  "Change Password",
  "Teams & Conditions",
  "Contact us",
  "Rate Our App",

  // "Setting",
];

List images = [
  "assets/nav/d2.png",
  "assets/nav/d1.png",
  "assets/nav/d3.png",
  "assets/nav/d4.png",
  "assets/nav/d5.png",
  "assets/nav/d6.png",
  "assets/nav/d7.png",
];

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  int currentIndex = -1;
  UserModel? user = AppManager.currentUser;

  void trigegrLogoutEvent(AuthBloc bloc) {
    CustomDialogs().alertBox(
      title: "Logout Action",
      message: "Are you sure to logout this account?",
      negativeTitle: "No",
      positiveTitle: "Yes",
      onPositivePressed: () {
        bloc.add(AuthEventPerformLogout());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateLogout) {
              Get.offAll(LoginPage());
            }
          },
        ),

        //// UserBloc
        ///print(BlocProvider.of<UserBloc>(context, listen: false));
        // BlocListener<UserBloc, UserState>(
        //   listener: (context, state) {
        //     print(BlocProvider.of<UserBloc>(context, listen: false));
        //     if (state is UserStateProfileUpdated) {
        //       setState(() {
        //         print(user);
        //         user = AppManager.currentUser;
        //       });
        //     }
        //   },
        //   child: Container(), // Provide a default child
        // )
      ],
      child: GetBuilder<MyDrawerController>(
        builder: (MyDrawerController _) => GestureDetector(
          onTap: () {
            _.closeDrawer();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xffFEDFC3),
            body: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    ZoomDrawer(
                      disableDragGesture: true,
                      controller: _.zoomDrawerController,
                      menuScreen: DrawerScreen(setIndex: (index) {
                        setState(() {
                          currentIndex = index;
                          _.open = false;
                        });
                      }),
                      mainScreen: Builder(builder: (context) {
                        return currentScreen();
                      }),
                      borderRadius: 30,
                      // style: DrawerStyle.style2,
                      showShadow: true,
                      angle: -0,
                      slideWidth: 290,
                      shadowLayer1Color: Colors.grey.shade200,
                      // slideHeight: 0,
                      menuBackgroundColor: Colors.transparent,
                    ),
                    _.open
                        ? Positioned.fill(
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _.closeDrawer();
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
                                        SizedBox(width: 2.w),
                                        textWidget(
                                          "Setting",
                                          fontSize: 18.sp,
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 3.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              AvatarWidget(
                                                width: 80,
                                                height: 80,
                                                placeholderChar: user
                                                        ?.name
                                                        .characters
                                                        .firstOrNull ??
                                                    "",
                                                avatarUrl: user?.avatar,
                                              ),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _.closeDrawer();
                                                      Get.to(
                                                        UploadPicture(
                                                            save: true),
                                                      );
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 1.3.h,
                                                      backgroundColor:
                                                          MyColors.white,
                                                      child: Image.asset(
                                                        "assets/icons/edit.png",
                                                        height: 1.4.h,
                                                        color: MyColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          textWidget(
                                            user?.name ?? "",
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    _.open
                        ? Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.find<MyDrawerController>()
                                              .closeDrawer();

                                          trigegrLogoutEvent(
                                              context.read<AuthBloc>());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30.0, vertical: 10),
                                          margin: const EdgeInsets.all(14.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(80),
                                            color: MyColors.primary,
                                          ),
                                          child: textWidget(
                                            "Logout",
                                            color: MyColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return BottomNavUser();
      case 1:
        return BottomNavUser();
      case 2:
        return BottomNavUser();
      case 3:
        return BottomNavUser();
      case 4:
        return BottomNavUser();
      case 5:
        return BottomNavUser();
      case 6:
        return BottomNavUser();
      case 7:
        return BottomNavUser();
      default:
        return BottomNavUser();
    }
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List pages = [
    BottomNavUser(),
    AllPosts(),
    NotificationScreen(),
    ResetPassword(),
    PrivacyPolicyPage(isDrawer: false),
    ContactUsPage(isDrawer: false),
    WriteReview(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      init: MyDrawerController(),
      builder: (MyDrawerController _) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 75.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 43.w,
                            child: ListView.builder(
                              // padding: EdgeInsets.zero,
                              itemCount: titles.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    // widget.setIndex(
                                    //     index);

                                    _.update();
                                    log(_.active.toString());
                                    Get.to(pages[index]);
                                    _.closeDrawer();
                                    if (_.active != 3 &&
                                        _.active != 5 &&
                                        _.active != 6) {
                                      Get.find<NavControllerD>().isVisible =
                                          true;
                                      Get.find<NavControllerD>().update();
                                    }
                                    ZoomDrawer.of(context)!.close();
                                    _.closeDrawer();
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                        color: _.active == index
                                            ? Color(0xffFFFFFF)
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 4.w),
                                        Image.asset(
                                          images[index],
                                          height: 2.h,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          titles[index],
                                          style: GoogleFonts.plusJakartaSans(
                                              color: MyColors.black,
                                              fontSize: 14.sp,
                                              fontWeight: _.active == index
                                                  ? FontWeight.w500
                                                  : FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();
  bool open = false;
  void toggleDrawer() {
    print("Toggle drawer");
    Timer(const Duration(microseconds: 30), () {
      open = true;
      Get.find<NavControllerD>().isVisible = false;
      Get.find<NavControllerD>().update();

      update();
    });
    zoomDrawerController.toggle?.call();
    update();
  }

  int active = 0;

  void closeDrawer() {
    print("Close drawer");
    Timer(const Duration(microseconds: 800), () {
      open = false;
      Get.find<NavControllerD>().isVisible = true;
      Get.find<NavControllerD>().update();

      update();
    });
    zoomDrawerController.close?.call();
    update();
  }
}
