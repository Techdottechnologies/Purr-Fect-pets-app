import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({super.key});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  List txts = [
    "Terrible",
    "Poor",
    "Average",
    "Good",
    "Amazing",
  ];
  List<int> rate = [0, 1];

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
                    SizedBox(width: 5.w),
                    textWidget("Rate Our App",
                        fontWeight: FontWeight.w500, fontSize: 19.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                // Center(
                //     child: Image.asset(
                //   "assets/new/29.png",
                //   height: 25.h,
                // )),
                SizedBox(height: 4.h),
                textWidget("Share Your Feedback",
                    fontWeight: FontWeight.w500, fontSize: 20.sp),
                SizedBox(height: 0.4.h),
                text_w("How Would you rate  our App Experience?",
                    color: Color(0xff080422),
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                        5,
                        (index) => InkWell(
                            onTap: () {
                              if (rate.contains(index)) {
                                setState(() {
                                  rate.remove(index);
                                });
                              } else {
                                setState(() {
                                  rate.add(index);
                                });
                              }
                            },
                            child: rate.contains(index)
                                ? Image.asset(
                                    "assets/icons/star.png",
                                    height: 5.h,
                                    color: MyColors.primary,
                                  )
                                : Image.asset(
                                    "assets/icons/star1.png",
                                    height: 5.h,
                                  ))),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                        txts.length,
                        (index) => text_w(txts[index],
                            fontSize: 15.sp,
                            color: Color(0xff080422),
                            fontWeight: FontWeight.w300))
                  ],
                ),
                SizedBox(height: 4.h),
                textWidget("Comment"),
                SizedBox(height: 2.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Enter Your Message",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  line: 6,
                  bColor: Colors.transparent,
                ),
                SizedBox(height: 4.h),
                gradientButton("Submit", font: 15, txtColor: MyColors.white,
                    ontap: () {
                  // showDialog(
                  //             context: context,
                  //             barrierColor:
                  //                 MyColors.primary.withOpacity(0.88),
                  //             builder: (context) => DeleteDone());
                },
                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
