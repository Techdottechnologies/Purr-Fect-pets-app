import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  List<bool> faqs = [false, false, false, false, false];
  bool status4 = false;
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14),
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
                    textWidget("Tips for pet",
                        fontWeight: FontWeight.w500, fontSize: 19.sp),
                  ],
                ),
                SizedBox(height: 2.h),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(5, (index) => faqWidget(index))
                    ],
                  ),
                ))
              ],
            ),
          )),
    );
  }

  Widget faqWidget(index) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                // backgroundColor: MyColors.primary,
                // collapsedBackgroundColor: Colors.white,
                tilePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                // shape: RoundedRectangleBorder(
                //     borderRadius:
                //         BorderRadius.circular(12)),
                // collapsedShape: RoundedRectangleBorder(
                //     borderRadius:
                //         BorderRadius.circular(12)),
                onExpansionChanged: (value) {
                  setState(() {
                    faqs[index] = value;
                  });
                },
                title: textWidget("Lorem Ipsum is simply dummy text",
                    fontWeight: FontWeight.w500,
                    color: MyColors.black,
                    fontSize: 15.5.sp),
                trailing: faqs[index] == true
                    ? Icon(Remix.arrow_up_s_line, color: MyColors.black)
                    : Icon(Remix.arrow_down_s_line, color: MyColors.black),
                children: [
                  textWidget(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled ",
                      color: MyColors.black.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp),
                  SizedBox(height: 2.h),
                ]),
          ),
        ));
  }
}
