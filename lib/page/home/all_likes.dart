import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllLikesPage extends StatefulWidget {
  const AllLikesPage({super.key});

  @override
  State<AllLikesPage> createState() => _AllLikesPageState();
}

class _AllLikesPageState extends State<AllLikesPage> {
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
                      ),
                    ),
                    SizedBox(width: 5.w),
                    textWidget(
                      "Likes",
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                ...List.generate(
                  0,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: MyColors.primary,
                            radius: 2.4.h,
                            backgroundImage:
                                AssetImage("assets/images/girl.png"),
                          ),
                          title: textWidget("Jessica Parker",
                              fontSize: 16.5.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
