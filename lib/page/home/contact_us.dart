import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/contact_us/contact_us_bloc.dart';
import '../../blocs/contact_us/contact_us_event.dart';
import '../../blocs/contact_us/contact_us_state.dart';
import '../../models/user_model.dart';
import '../../utils/dialogs/dialogs.dart';

class ContactUsPage extends StatefulWidget {
  final bool isDrawer;
  const ContactUsPage({super.key, required this.isDrawer});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  void triggerContactUsEvent() {
    context.read<ContactUsBloc>().add(ContactEventSend(
        name: nameController.text,
        email: emailController.text,
        message: messageController.text));
  }

  @override
  void initState() {
    final UserModel user = AppManager.currentUser!;
    nameController.text = user.name;
    emailController.text = user.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsBloc, ContactUsState>(
      listener: (context, state) {
        if (state is ContactStateSending ||
            state is ContactStateSendFailure ||
            state is ContactStateSent) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ContactStateSendFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ContactStateSent) {
            CustomDialogs().successBox(
              message: "Your message has been recorded.",
              positiveTitle: "Back",
              barrierDismissible: false,
              onPositivePressed: () {
                Get.back();
              },
            );
            // messageController.clear();
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned.fill(
              child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Remix.arrow_left_s_line,
                                color: Colors.black, size: 4.h),
                          ),
                          SizedBox(width: 2.w),
                          textWidget(
                            "Contact us",
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(height: 1.h),
                      textWidget(
                        "Name",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(height: 1.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write Here",
                        controller: nameController,
                        fillColor: Color(0xffF9F9F9),
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: false,
                      ),
                      SizedBox(height: 2.h),
                      textWidget(
                        "Email",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(height: 1.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write Here",
                        controller: emailController,
                        fillColor: Color(0xffF9F9F9),
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: false,
                      ),
                      SizedBox(height: 2.h),
                      textWidget(
                        "Message",
                        fontSize: 15.6.sp,
                      ),
                      SizedBox(height: 1.h),
                      textFieldWithPrefixSuffuxIconAndHintText(
                        "Write Here",
                        line: 5,
                        controller: messageController,
                        fillColor: Color(0xffF9F9F9),
                        mainTxtColor: Colors.black,
                        radius: 12,
                        bColor: Colors.transparent,
                        prefixIcon: "assets/icons/lock.png",
                        isPrefix: false,
                      ),
                      SizedBox(height: 4.h),
                      gradientButton(
                        isLoading ? "Sending" : "Submit",
                        font: 16,
                        txtColor: MyColors.white,
                        ontap: () {
                          triggerContactUsEvent();
                        },
                        width: 90,
                        isLoading: isLoading,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary,
                      ),
                      SizedBox(height: 14.h),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
