import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/registration_page3.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegistrationPage2 extends StatefulWidget {
  const RegistrationPage2({super.key});

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
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
            "assets/images/sign.png",
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
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset("assets/icons/back.png",
                                height: 5.h)),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12),
                      child: Container(
                        height: 72.h,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                "Registration",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              text_w("Enter your credentials to Sign up",
                                  fontSize: 14.7.sp,
                                  color: Color(0xff080422),
                                  fontWeight: FontWeight.w300),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Parents  photograph ",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/pp.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Pet's name",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/p1.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Date Of Birth",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/dob.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Photographs",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/cam.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Special diet",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/eat.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 5.h),
                              gradientButton("Next",
                                  font: 17,
                                  txtColor: MyColors.white, ontap: () {
                                Get.to(RegistrationPage3());
                              },
                                  width: 90,
                                  height: 6.6,
                                  isColor: true,
                                  clr: MyColors.primary),
                              SizedBox(
                                height: 40.h,
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
