import 'dart:developer';

import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/login_page.dart';
import 'package:petcare/page/auth/reset_password.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/images/bbg.png",
            fit: BoxFit.cover,
            height: Get.height,
            width: Get.width,
          )),
          // Positioned.fill(
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Scaffold(

          //       backgroundColor: Colors.transparent,

          //     ),
          //   ),
          // ),
          Positioned.fill(
              child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  SafeArea(
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircleAvatar(
                                radius: 2.3.h,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Remix.arrow_left_s_line,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12),
                      child: Container(
                        height: 80.h,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Image.asset(
                                "assets/new/11.png",
                                height: 25.h,
                              )),
                              SizedBox(height: 3.h),
                              Center(
                                child: textWidget(
                                  "Verify Your Email",
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
                              otpField(),
                              SizedBox(height: 3.h),
                              Center(
                                  child: Image.asset("assets/icons/rsend.png",
                                      height: 2.h)),
                              SizedBox(height: 5.h),
                              gradientButton("Next",
                                  font: 17,
                                  txtColor: MyColors.white, ontap: () {
                                Get.to(ResetPassword());

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
                      )),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

Widget otpField() {
  return OtpPinField(
      maxLength: 4,
      fieldHeight: 8.h,
      fieldWidth: 15.w,
      // key: _otpPinFieldController,

      /// to clear the Otp pin Controller
      onSubmit: (text) {
        log(text);

        /// return the entered pin
      },
      onChange: (text) {
        /// return the entered pin
      },
      otpPinInputCustom: "&",
      upperChild: Column(
        children: const [CircleAvatar()],
      ),
      middleChild: Column(
        children: const [CircleAvatar()],
      ),

      /// to decorate your Otp_Pin_Field
      otpPinFieldStyle: OtpPinFieldStyle(
        textStyle: GoogleFonts.kanit(
            color: MyColors.primary,
            fontWeight: FontWeight.w400,
            fontSize: 17.sp),
        activeFieldBorderColor: MyColors.primary,
        fieldBorderWidth: 1.2,
        fieldBorderRadius: 20,

        /// Background Color for inactive/unfocused Otp_Pin_Field
        defaultFieldBackgroundColor: Color(0xffF7F7F7),

        /// Background Color for active/focused Otp_Pin_Field
        activeFieldBackgroundColor: Color(0xffF7F7F7),

        /// Background Color for filled field pin box
        filledFieldBackgroundColor: Color(0xffF7F7F7),

        /// border Color for filled field pin box
        filledFieldBorderColor: MyColors.primary,
        // border color for inactive/unfocused Otp_Pin_Field
        defaultFieldBorderColor: MyColors.primary,

        // border color for active/focused Otp_Pin_Field
        // activeFieldBorderColor: DynamicColors.primaryColor,

        // /// Background Color for inactive/unfocused Otp_Pin_Field
        // defaultFieldBackgroundColor: Colors.grey.withOpacity(0.4),
        // activeFieldBackgroundColor:Colors.grey.withOpacity(0.5),

        /// Background Color for active/focused Otp_Pin_Field
      ),
      // maxLength: 4,

      /// no of pin field
      showCursor: true,

      /// bool to show cursor in pin field or not
      cursorColor: MyColors.primary,

      /// to choose cursor color

      showCustomKeyboard: false,
      cursorWidth: 1,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration);
}

class ChangeDone extends StatelessWidget {
  final bool isLogin;

  const ChangeDone({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                width: 90.w,
                // height: 45.h,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                // color: Color(0xfff9f8f6),

                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 1.4.h),
                      Image.asset(
                        "assets/images/done1.png",
                        height: 7.h,
                      ),
                      SizedBox(height: 1.4.h),
                      textWidget("Change Successfully",
                          color: MyColors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 1.5.h),
                      textWidget("Your Password Has Been Change Successfully",
                          textAlign: TextAlign.center,
                          color: Color(0xff2F3342).withOpacity(0.50),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp),
                      SizedBox(height: 3.h),
                      isLogin
                          ? SizedBox()
                          : Row(
                              children: [
                                Expanded(
                                  child: gradientButton("Back to login",
                                      ontap: () async {
                                    Navigator.pop(context);
                                    Get.to(LoginPage());
                                  },
                                      height: 6,
                                      font: 13.5,
                                      width: 60,
                                      isColor: true,
                                      clr: MyColors.primary),
                                ),
                              ],
                            ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class DeleteDone extends StatelessWidget {
  const DeleteDone({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/images/bb11.png",
            height: Get.height,
            width: Get.width,
            fit: BoxFit.fill,
          )),
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/new/28.png",
                    height: 30.h,
                  ),
                )),
                Container(
                    width: 90.w,
                    // height: 45.h,
                    margin: EdgeInsets.only(top: 25.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    // color: Color(0xfff9f8f6),

                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 1.4.h),
                          textWidget("Delete Successfully",
                              color: MyColors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                          SizedBox(height: 1.5.h),
                          textWidget(
                              "Your Created Community Has Been Delete Successfully",
                              textAlign: TextAlign.center,
                              color: Color(0xff2F3342).withOpacity(0.50),
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
