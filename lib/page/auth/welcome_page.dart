import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/login_page.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int selectPage = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "assets/images/wel.jpg",
          fit: BoxFit.cover,
          height: Get.height,
          width: Get.width,
        )),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SizedBox(
              width: 80.w,
              child: Column(
                children: [
                  Spacer(),
                  Center(
                    child: SmoothPageIndicator(
                        controller: PageController(
                            initialPage: selectPage), // PageController
                        count: 2,
                        effect: WormEffect(
                            activeDotColor: Colors.black,
                            dotColor: Colors.black.withOpacity(0.1),
                            dotHeight: 1.h,
                            dotWidth: 1.h), // your preferred effect
                        onDotClicked: (index) {}),
                  ),
                  SizedBox(height: 7.h),
                  textWidget("Hey there, Pet Lover!",
                      color: Colors.black,
                      fontSize: 19.3.sp,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center),
                  SizedBox(height: 1.h),
                  text_w(
                      selectPage == 0
                          ? "Welcome to Puurfect Link Up - the ultimate space where tails wag, whiskers twitch, and every pet has a story to share!"
                          : "Whether you're a proud dog parent, a devoted cat companion, or someone who loves all creatures big and small, this is your safe and happy place. Share adorable moments, discover new pet friends, and join communities that celebrate every purr, bark, and chirp!",
                      fontSize: 14.sp,
                      color: Color(0xff080422),
                      fontWeight: FontWeight.w300,
                      textAlign: TextAlign.center),
                  SizedBox(height: 3.h),
                  InkWell(
                    onTap: () {
                      if (selectPage == 1) {
                        Get.to(
                          LoginPage(),
                        );
                      } else {
                        setState(() {
                          selectPage++;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 2.6.h,
                      backgroundColor: MyColors.primary,
                      child: Icon(Remix.arrow_right_line,
                          color: Colors.white, size: 2.3.h),
                    ),
                  ),
                  // Spacer(),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
