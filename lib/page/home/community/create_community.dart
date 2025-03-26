import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../blocs/chat/ chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/dialogs/dialogs.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_network_image.dart';
import '../../../widgets/my_image_picker.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  String? avatar;
  bool isLoading = false;

  void triggerCreateCommunityEvent() {
    context.read<ChatBloc>().add(ChatEventCreate(
        title: nameController.text,
        maxMembers: int.tryParse(maxController.text) ?? 0,
        avatar: avatar,
        description: descriptionController.text));
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatStateCreated ||
            state is ChatStateCreating ||
            state is ChatStateCreateFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ChatStateCreated) {
            Get.back();
          }

          if (state is ChatStateCreateFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        "Create Community ",
                        fontWeight: FontWeight.w500,
                        fontSize: 19.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  /// Upload Image Button
                  CustomContainer(
                    onPressed: () {
                      showImagePicker();
                    },
                    size: Size.fromHeight(
                      183,
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(21)),
                    child: avatar != null
                        ? CustomNetworkImage(imageUrl: avatar ?? "")
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_upload_outlined,
                                size: 40,
                                color: MyColors.primary,
                              ),
                              gapH6,
                              Text(
                                'Upload Image',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 4.h),
                  textWidget("Community Name"),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter Community Name",
                    controller: nameController,
                    fillColor: Color(0xffF9F9F9),
                    mainTxtColor: Colors.black,
                    radius: 20,
                    bColor: Colors.transparent,
                  ),
                  SizedBox(height: 2.h),
                  textWidget("Description"),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter Description",
                    controller: descriptionController,
                    fillColor: Color(0xffF9F9F9),
                    mainTxtColor: Colors.black,
                    radius: 16,
                    line: 6,
                    bColor: Colors.transparent,
                  ),
                  SizedBox(height: 2.h),
                  textWidget("Max Community Limit"),
                  SizedBox(height: 1.h),
                  textFieldWithPrefixSuffuxIconAndHintText(
                    "Enter value between 1 to 250",
                    controller: maxController,
                    fillColor: Color(0xffF9F9F9),
                    mainTxtColor: Colors.black,
                    radius: 20,
                    bColor: Colors.transparent,
                  ),
                  SizedBox(height: 6.h),
                  gradientButton(
                    "Create",
                    font: 17,
                    txtColor: MyColors.white,
                    isLoading: isLoading,
                    ontap: () {
                      //1234
                      triggerCreateCommunityEvent();
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
