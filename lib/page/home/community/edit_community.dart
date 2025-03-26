import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/otp_password.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditCommunity extends StatefulWidget {
  const EditCommunity({super.key});

  @override
  State<EditCommunity> createState() => _EditCommunityState();
}

class _EditCommunityState extends State<EditCommunity> {
  int current1 = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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
                      ),
                    ),
                    SizedBox(width: 2.w),
                    textWidget("Edit Community ",
                        fontWeight: FontWeight.w500, fontSize: 19.sp),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 4.h),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 7.h,
                        backgroundColor: MyColors.primary,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 6.6.h,
                          backgroundImage: AssetImage("assets/images/dog.png"),
                        ),
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
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 0.6.h),
                Center(child: textWidget("Pawsitive Pets", fontSize: 18.sp)),
                SizedBox(height: 4.h),
                textWidget(
                  "Community Name",
                ),
                SizedBox(height: 1.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Pawsitive Pets",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  // enable: false,
                  bColor: Colors.transparent,
                  suffixIcon: "assets/icons/pen.png",
                  isSuffix: true,
                ),
                SizedBox(height: 2.h),
                textWidget(
                  "Message",
                ),
                SizedBox(height: 1.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Enter Your Message",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  suffixIcon: "assets/icons/pen.png",
                  isSuffix: true,
                  radius: 16,
                  line: 6,
                  // enable: false,
                  bColor: Colors.transparent,
                  // suffixIcon: "assets/icons/down.png",
                  // isSuffix: true,
                ),
                SizedBox(height: 2.h),
                textWidget(
                  "Max Community Limit",
                ),
                SizedBox(height: 1.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Enter Amount",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  suffixIcon: "assets/icons/pen.png",
                  isSuffix: true,
                  mainTxtColor: Colors.black,
                  radius: 20,
                  // enable: false,
                  bColor: Colors.transparent,
                  // suffixIcon: "assets/icons/down.png",
                  // isSuffix: true,
                ),
                SizedBox(height: 6.h),
                Column(
                  children: [
                    gradientButton("Delete Community",
                        font: 15, txtColor: MyColors.white, ontap: () {
                      showDialog(
                          useSafeArea: false,
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) => DeleteDone());
                    },
                        width: 90,
                        height: 6.6,
                        isColor: true,
                        clr: MyColors.primary),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
