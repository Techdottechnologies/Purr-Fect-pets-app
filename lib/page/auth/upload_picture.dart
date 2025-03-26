import 'package:petcare/blocs/user/user_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/page/home/home_drawer.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/my_image_picker.dart';

class UploadPicture extends StatefulWidget {
  final bool save;
  const UploadPicture({super.key, required this.save});

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  String? avatar;
  final UserModel? user = AppManager.currentUser;
  bool isLoading = false;

  void triggerUpdateProfileEvent(UserBloc bloc) {
    if (avatar == "" || avatar == null) {
      CustomDialogs().errorBox(message: "Please select profile");
      return;
    }
    bloc.add(UserEventUpdateProfile(avatar: avatar));
  }

  void selectImage() {
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

  @override
  void initState() {
    if (user != null) {
      avatar = user!.avatar;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateProfileUpdating ||
            state is UserStateProfileUpdated ||
            state is UserStateProfileUpdatingFailure ||
            state is UserStateAvatarUploading ||
            state is UserStateAvatarUploaded ||
            state is UserStatAvatareUploadingFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is UserStateProfileUpdatingFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is UserStateAvatarUploaded) {
            Get.offAll(HomeDrawer());
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: Colors.white,
            )),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/images/shape.png",
                fit: BoxFit.cover,
                // height: Get.height,
                // width: Get.width,
              ),
            )),
            Positioned.fill(
                child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12,
                      ),
                      child: Container(
                        height: 85.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: CircleAvatar(
                                      radius: 2.3.h,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Remix.arrow_left_s_line,
                                        color: Colors.white,
                                      ),
                                    )),
                                Center(
                                  child: Image.asset(
                                    "assets/icons/logo.png",
                                    height: 4.h,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {},
                                    child: CircleAvatar(
                                      radius: 2.3.h,
                                      backgroundColor: Colors.transparent,
                                      child: Icon(
                                        Remix.arrow_left_s_line,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            textWidget(
                              "Profile Picture",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            text_w(
                              "Please add your profile picture",
                              fontSize: 14.7.sp,
                              color: Color(0xff080422),
                              fontWeight: FontWeight.w300,
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                selectImage();
                              },
                              child: Center(
                                child: Stack(
                                  children: [
                                    AvatarWidget(
                                      height: 130,
                                      width: 130,
                                      placeholderChar:
                                          user?.name.characters.firstOrNull,
                                      avatarUrl: avatar,
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          radius: 2.h,
                                          backgroundColor: MyColors.primary,
                                          child: Image.asset(
                                            "assets/icons/edit.png",
                                            height: 1.7.h,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            gradientButton(
                              widget.save ? "Save" : "Next",
                              font: 17,
                              txtColor: MyColors.white,
                              isLoading: isLoading,
                              ontap: () {
                                triggerUpdateProfileEvent(
                                    context.read<UserBloc>());
                              },
                              width: 90,
                              height: 6.6,
                              isColor: true,
                              clr: MyColors.primary,
                            ),
                            SizedBox(height: 10.h)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
