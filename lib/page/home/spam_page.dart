import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SpamPage extends StatefulWidget {
  const SpamPage({super.key});

  @override
  State<SpamPage> createState() => _SpamPageState();
}

class _SpamPageState extends State<SpamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
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
                        )),
                    SizedBox(width: 5.w),
                    textWidget("Spam",
                        fontWeight: FontWeight.w500, fontSize: 19.sp),
                  ],
                ),
                SizedBox(height: 7.h),
                textWidget(
                  "Name",
                  fontSize: 16.sp,
                ),
                SizedBox(height: 0.6.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Enter Name",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  bColor: Colors.transparent,
                  prefixIcon: "assets/icons/lock.png",
                  isPrefix: false,
                ),
                SizedBox(height: 3.h),
                textWidget(
                  "Email",
                  fontSize: 16.sp,
                ),
                SizedBox(height: 0.6.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Enter Email",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  bColor: Colors.transparent,
                  prefixIcon: "assets/icons/lock.png",
                  isPrefix: false,
                ),
                SizedBox(height: 3.h),
                textWidget(
                  "Message",
                  fontSize: 16.sp,
                ),
                SizedBox(height: 0.6.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Enter Message",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  line: 6,
                  bColor: Colors.transparent,
                  prefixIcon: "assets/icons/lock.png",
                  isPrefix: false,
                ),
                SizedBox(height: 15.h),
                gradientButton("Send", font: 17, txtColor: MyColors.white,
                    ontap: () {
                   },
                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
