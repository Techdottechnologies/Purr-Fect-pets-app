import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/txt_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  SizedBox(height: 1.h),
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
                        SizedBox(width: 5.w),
                        textWidget("Privacy Policy",
                            fontWeight: FontWeight.w500, fontSize: 19.sp),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget("Heading here",
                              fontWeight: FontWeight.w500),
                          SizedBox(height: 2.h),
                          textWidget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type.",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400),
                          SizedBox(height: 2.h),
                          textWidget("Heading here",
                              fontWeight: FontWeight.w500),
                          SizedBox(height: 1.h),
                          textWidget(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                              color: Color(0xff000000).withOpacity(0.46),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400)
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
