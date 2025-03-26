import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/otp_password.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Column(
                children: [
                  SafeArea(
                    child: Row(
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
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 80.h,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Center(
                          //     child: Image.asset(
                          //   "assets/new/12.png",
                          //   height: 25.h,
                          // )),
                          SizedBox(height: 3.h),
                          Center(
                            child: textWidget(
                              "Reset Your Password",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          text_w(
                              "Please check your inbox and follow the instructions to reset your password.",
                              fontSize: 14.7.sp,
                              textAlign: TextAlign.center,
                              color: Color(0xff080422),
                              fontWeight: FontWeight.w300),
                          SizedBox(height: 1.5.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Password",
                            // controller: _.password,
                            fillColor: Color(0xffF9F9F9),
                            mainTxtColor: Colors.black,
                            radius: 20,
                            bColor: Colors.transparent,
                            prefixIcon: "assets/icons/lock.png",
                            isPrefix: true,
                          ),
                          SizedBox(height: 1.h),
                          textFieldWithPrefixSuffuxIconAndHintText(
                            "Confirm Password",
                            // controller: _.password,
                            fillColor: Color(0xffF9F9F9),
                            mainTxtColor: Colors.black,
                            radius: 20,
                            bColor: Colors.transparent,
                            prefixIcon: "assets/icons/lock.png",
                            isPrefix: true,
                          ),
                          SizedBox(height: 5.h),
                          gradientButton("Confirm",
                              font: 17, txtColor: MyColors.white, ontap: () {
                            // Get.to(BottomNavUser());
                            showDialog(
                                useSafeArea: false,
                                context: context,
                                barrierColor: Colors.transparent,
                                builder: (context) => ChangeDone(
                                      isLogin: false,
                                    ));
                         
                          },
                              width: 90,
                              height: 6.6,
                              isColor: true,
                              clr: MyColors.primary),
                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
