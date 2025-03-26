import 'package:petcare/page/auth/otp_password.dart';
import 'package:petcare/page/home/comments.dart';
import 'package:petcare/page/home/post/edit_post.dart';
import 'package:petcare/page/home/report_page.dart';
import 'package:petcare/page/home/spam_page.dart';
import 'package:petcare/widgets/onTap.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../page/home/all_likes.dart';

//1234

// Widget petPost(context, {bool isEdit = false}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Container(
//       decoration: BoxDecoration(
//         color: Color(0xffF9F9F9),
//         borderRadius: BorderRadius.circular(21),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 2.h,
//                   child: CircleAvatar(
//                     radius: 1.8.h,
//                     backgroundImage: AssetImage("assets/images/girl.png"),
//                   ),
//                 ),
//                 SizedBox(width: 2.w),
//                 textWidget(
//                   "ukanto_bashir",
//                 ),
//                 Spacer(),
//                 textWidget(
//                   "3 hours ago",
//                   color: Color(0xffBFBFBF),
//                   fontSize: 13.sp,
//                 ),
//                 isEdit ? selectPopup1(context) : selectPopup()
//               ],
//             ),
//             SizedBox(height: 1.5.h),
//             text_w(
//               "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
//               fontSize: 14.sp,
//             ),
//             SizedBox(height: 2.h),
//             Stack(
//               children: [
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(
//                       'assets/images/dimg.png',
//                       height: 30.h,
//                       fit: BoxFit.fill,
//                     )),
//                 Positioned.fill(
//                     child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12.0, vertical: 8),
//                     child: Row(
//                       children: [
//                         onPress(
//                           ontap: () {
//                             Get.to(AllLikesPage());
//                           },
//                           child: Container(
//                             height: 3.h,
//                             decoration: BoxDecoration(
//                               color: Color(0xffF2F2F2).withOpacity(0.46),
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 4.0, horizontal: 10),
//                               child: Row(children: [
//                                 Image.asset("assets/icons/heart.png",
//                                     height: 2.2.h),
//                                 SizedBox(width: 1.w),
//                                 textWidget(
//                                   "5.3.k",
//                                   color: Colors.white,
//                                   fontSize: 13.sp,
//                                 ),
//                                 // SizedBox(width: 2.w),
//                               ]),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 1.w),
//                         onPress(
//                           ontap: () {
//                             // Get.to(CommentsPage());
//                           },
//                           child: Container(
//                             height: 3.h,
//                             decoration: BoxDecoration(
//                               color: Color(0xffF2F2F2).withOpacity(0.46),
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 4.0, horizontal: 10),
//                               child: Row(children: [
//                                 Image.asset("assets/icons/cmt.png",
//                                     height: 1.6.h),
//                                 SizedBox(width: 1.w),
//                                 textWidget(
//                                   "5.3.k",
//                                   color: Colors.white,
//                                   fontSize: 13.sp,
//                                 ),
//                                 // SizedBox(width: 2.w),
//                               ]),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 1.w),
//                         // Theme(
//                         //   data: Theme.of(context).copyWith(
//                         //       canvasColor: Color(0xffF2F2F2).withOpacity(0.46)),
//                         //   child: InkWell(
//                         //     onTap: () {
//                         //        Share.share('Visit FlutterCampus at https://www.fluttercampus.com');
//                         //     },
//                         //     child: Chip(
//                         //       padding: EdgeInsets.zero,
//                         //       label: text_w(
//                         //         "5.3k",
//                         //         fontSize: 13.sp,
//                         //         color: Colors.white,
//                         //       ),
//                         //       // padding: EdgeInsets.zero,
//                         //        side: BorderSide(color: Colors.transparent),
//                         //       shape: RoundedRectangleBorder(
//                         //           borderRadius: BorderRadius.circular(100)),
//                         //       avatar: Image.asset("assets/icons/share.png",height: 2.h,),
//                         //       backgroundColor:
//                         //           Color(0xffF2F2F2).withOpacity(0.036),
//                         //       shadowColor: Color(0xffF2F2F2).withOpacity(0.36),
//                         //     ),
//                         //   ),
//                         // ),
//                         Container(
//                           height: 3.h,
//                           decoration: BoxDecoration(
//                             color: Color(0xffF2F2F2).withOpacity(0.46),
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 10),
//                             child: Row(children: [
//                               Image.asset("assets/icons/share.png",
//                                   height: 1.6.h),
//                               SizedBox(width: 1.w),
//                               textWidget(
//                                 "5.3.k",
//                                 color: Colors.white,
//                                 fontSize: 13.sp,
//                               ),
//                               // SizedBox(width: 2.w),
//                             ]),
//                           ),
//                         ),
//                         Spacer(),
//                         Container(
//                           height: 3.h,
//                           decoration: BoxDecoration(
//                             color: Color(0xffE62F2F).withOpacity(0.80),
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 14),
//                             child: textWidget("Lost",
//                                 color: Colors.white,
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ))
//               ],
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }

Widget selectPopup() => Theme(
      data: ThemeData(canvasColor: Colors.white),
      child: PopupMenuButton<int>(
        color: Colors.white,
        constraints: BoxConstraints.expand(width: 35.w, height: 15.h),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icons/report.png",
                  height: 2.h,
                ),
                SizedBox(width: 3.w),
                textWidget("Report",
                    fontWeight: FontWeight.w300, fontSize: 16.sp),
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/spam.png",
                  height: 2.h,
                ),
                SizedBox(width: 3.w),
                textWidget("Spam",
                    fontWeight: FontWeight.w300, fontSize: 16.sp),
              ],
            ),
          ),
        ],
        // initialValue: 0,
        onCanceled: () {},
        onSelected: (value) {
          // print(value);
          value == 1 ? Get.to(ReportPage()) : Get.to(SpamPage());
        },
        icon: const Icon(
          Icons.more_vert_outlined,
          color: Colors.black,
        ),
        offset: const Offset(0, 50),
      ),
    );

Widget selectPopup1(context) => PopupMenuButton<int>(
      color: Colors.white,
      shadowColor: Colors.white,
      constraints: BoxConstraints.expand(width: 35.w, height: 15.h),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Image.asset(
            "assets/images/edd.png",
            height: 4.h,
            fit: BoxFit.fill,
            // color: MyColors.primary,
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Image.asset(
            "assets/nav/del.png",
            height: 4.h,
            fit: BoxFit.fill,
          ),
        ),
      ],
      // initialValue: 0,
      onCanceled: () {},
      onSelected: (value) {
        value == 1
            ? Get.to(EditPost())
            : showDialog(
                context: context,
                useSafeArea: false,
                barrierColor: Colors.transparent,
                builder: (context) => DeleteDone());
        // print(value);
      },
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.black,
      ),
      offset: const Offset(0, 50),
    );
