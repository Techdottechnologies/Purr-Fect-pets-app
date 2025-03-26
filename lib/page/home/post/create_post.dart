import 'package:petcare/blocs/post/post_bloc.dart';
import 'package:petcare/blocs/post/post_event.dart';
import 'package:petcare/blocs/post/post_status.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/post_model.dart';
import 'package:petcare/models/user_model.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/constants/enum.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/utils/extensions/string_extension.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/custom_network_image.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/user_profile_model.dart';
import '../../../widgets/my_image_picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key, this.model});
  final PostModel? model;
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late PostModel? post = widget.model;

  PostStatus? selectedStatus;
  String? mediaUrl;
  final TextEditingController postController = TextEditingController();
  bool isLoading = false;

  void triggerCreatePostEvent() {
    final UserModel currentUser = AppManager.currentUser!;
    final PostModel model = PostModel(
      uuid: "",
      createdAt: DateTime.now(),
      media: PostMediaModel(content: postController.text, mediaUrl: mediaUrl),
      status: selectedStatus,
      userInfo: UserProfileModel(
          uid: currentUser.uid,
          name: currentUser.name,
          avatarUrl: currentUser.avatar ?? ""),
    );
    context.read<PostBloc>().add(PostEventCreate(model: model));
  }

  void triggerUpdatePostEvent() {
    if (post == null) {
      return;
    }

    post = post!.copyWith(
        media: PostMediaModel(content: postController.text, mediaUrl: mediaUrl),
        status: selectedStatus);
    context.read<PostBloc>().add(PostEventUpdate(model: post!));
  }

  void setData() {
    postController.text = post?.media.content ?? "";
    selectedStatus = post?.status;
    mediaUrl = post?.media.mediaUrl;
  }

  void selectImage() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            mediaUrl = data.path;
          });
        }
      },
    );
  }

  @override
  void initState() {
    if (post != null) {
      setData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostStateCreating ||
            state is PostStateCreated ||
            state is PostStateCreateFailure ||
            state is PostStateUpdated ||
            state is PostStateUpdating ||
            state is PostStateUpdateFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is PostStateCreateFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is PostStateUpdateFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is PostStateCreated) {
            CustomDialogs().successBox(
              message: "Post created.",
              positiveTitle: "Go Back",
              onPositivePressed: () {
                Get.back();
              },
            );
          }

          if (state is PostStateUpdated) {
            CustomDialogs().successBox(
              message: "Post updated.",
              positiveTitle: "Go Back",
              onPositivePressed: () {
                Get.back();
              },
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
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
                      SizedBox(width: 2.w),
                      textWidget(
                        post == null ? "Create Post" : "Update Post",
                        fontWeight: FontWeight.w500,
                        fontSize: 19.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  InkWell(
                    onTap: () {
                      selectImage();
                    },
                    child: Container(
                      height: 200,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomNetworkImage(
                              imageUrl: mediaUrl ?? "",
                              backgroundColor: Colors.white,
                              showPlaceholder: false,
                            ),
                          ),
                          if (mediaUrl == null)
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_upload_outlined,
                                    size: 48,
                                    color: MyColors.primary,
                                  ),
                                  gapH10,
                                  textWidget(
                                    "Upload Media",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Write a post.....",
                    controller: postController,
                    fillColor: Color(0xffF9F9F9),
                    mainTxtColor: Colors.black,
                    radius: 20,
                    bColor: Colors.transparent,
                  ),
                  SizedBox(height: 2.h),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        "Select Status ",
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF676767),
                        ),
                      ),
                      items: PostStatus.values
                          .map(
                            (PostStatus status) => DropdownMenuItem<String>(
                              value: status.name.capitalizeFirstCharacter(),
                              child: Text(
                                status.name.capitalizeFirstCharacter(),
                                style: GoogleFonts.workSans(
                                  fontSize: 14.sp,
                                  color: MyColors.primary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedStatus?.name.capitalizeFirstCharacter(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedStatus = PostStatus.values.firstWhere((e) =>
                              e.name.toLowerCase() == value?.toLowerCase());
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        height: 6.5.h,
                        width: 100.w,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        elevation: 0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                      iconStyleData: IconStyleData(
                        icon: Icon(Remix.arrow_down_s_line, size: 3.4.h),
                      ),
                      menuItemStyleData: const MenuItemStyleData(height: 40),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  gradientButton(
                    post == null ? "Post" : "Upload Post",
                    font: 17,
                    txtColor: MyColors.white,
                    isLoading: isLoading,
                    ontap: () {
//1234
                      post == null
                          ? triggerCreatePostEvent()
                          : triggerUpdatePostEvent();
                    },
                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary,
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
