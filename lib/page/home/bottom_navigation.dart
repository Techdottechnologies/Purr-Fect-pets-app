import 'package:petcare/config/colors.dart';
import 'package:petcare/page/home/community/community_page.dart';
import 'package:petcare/page/home/home_screen.dart';
import 'package:petcare/page/home/my_pet.dart';
import 'package:petcare/page/home/post/map_view.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavUser extends StatefulWidget {
  const BottomNavUser({super.key});
  @override
  _BottomNavWalkState createState() => _BottomNavWalkState();
}

class _BottomNavWalkState extends State<BottomNavUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(
      init: NavController(),
      builder: (NavController con) => Scaffold(
        // extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: MyColors.primary,
            borderRadius: BorderRadius.circular(100),
          ),
          width: 95.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: SalomonBottomBar(
              backgroundColor: Colors.transparent,
              selectedColorOpacity: 0.16,
              selectedItemColor: Color(0xffFEAF75),
              itemPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              currentIndex: con.currentIndex,
              onTap: (i) {
                con.currentIndex = i;
                con.update();
              },
              items: [
                SalomonBottomBarItem(
                  unselectedColor: Colors.transparent,
                  icon: Image.asset("assets/nav/n1.png",
                      height: 2.1.h,
                      color: con.currentIndex == 0
                          ? MyColors.white
                          : Colors.white70),
                  title: textWidget("Home".tr,
                      fontSize: 15.sp, color: MyColors.white),
                  selectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  unselectedColor: Colors.transparent,
                  icon: Image.asset("assets/nav/n2.png",
                      height: 2.1.h,
                      color: con.currentIndex == 1
                          ? MyColors.white
                          : Colors.white70),
                  title: textWidget("Find".tr,
                      fontSize: 15.sp, color: MyColors.white),
                  selectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  unselectedColor: Colors.transparent,
                  icon: Image.asset("assets/nav/n3.png",
                      height: 2.1.h,
                      color: con.currentIndex == 2
                          ? MyColors.white
                          : Colors.white70),
                  title: textWidget("Community".tr,
                      fontSize: 15.sp, color: MyColors.white),
                  selectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  unselectedColor: Colors.transparent,
                  icon: Image.asset("assets/nav/n4.png",
                      height: 2.1.h,
                      color: con.currentIndex == 3
                          ? MyColors.white
                          : Colors.white70),
                  title: textWidget("Profile".tr,
                      fontSize: 15.sp, color: MyColors.white),
                  selectedColor: Colors.white,
                ),
              ],
            ),
          ),
        ),

        // resizeToAvoidBottomInset: false,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            con.currentIndex == 0
                ? HomePage()
                : con.currentIndex == 1
                    ? MapSample()
                    : con.currentIndex == 2
                        ? Community_page()
                        : MyPets()
          ],
        ),
      ),
    );
  }
}

class NavController extends GetxController {
  NavController() {
    currentIndex = 0;
  }
  int currentTab = 0;
  int currentIndex = 0;
  bool isVisible = true;

  Widget currentScreen = SizedBox();
}
