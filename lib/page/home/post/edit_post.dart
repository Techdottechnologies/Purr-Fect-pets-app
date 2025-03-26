import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/otp_password.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditPost extends StatefulWidget {
  const EditPost({super.key});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  String? selectedValue;
  List<String> attributes = ["Lost", "Happy", "Moody"];

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
                    textWidget("Edit Post ",
                        fontWeight: FontWeight.w500, fontSize: 19.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/dog.png",
                        height: 25.h,
                        fit: BoxFit.cover,
                        width: Get.width,
                      ),
                    ),
                    Positioned.fill(
                        child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              showDialog(
                                  useSafeArea: false,
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  builder: (context) => ChangeDone(
                                        isLogin: true,
                                      ));
                            },
                            child: Image.asset(
                              "assets/nav/del1.png",
                              height: 4.h,
                            )),
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 4.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
                  // controller: _.password,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  line: 3,
                  // enable: false,
                  bColor: Colors.transparent,
                  // suffixIcon: "assets/icons/down.png",
                  // isSuffix: true,
                ),
                SizedBox(height: 2.h),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      "Select Status ",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF676767),
                      ),
                    ),
                    items: attributes
                        .map(
                          (String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.workSans(
                                fontSize: 14.sp,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      height: 6.5.h,
                      width: 100.w,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      elevation: 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(Remix.arrow_down_s_line, size: 3.4.h),
                    ),
                    menuItemStyleData: const MenuItemStyleData(height: 40),
                  ),
                ),
                SizedBox(height: 16.h),
                gradientButton("Save Changes",
                    font: 17, txtColor: MyColors.white, ontap: () {
             
                },
                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary),
                SizedBox(height: 2.h),
                gradientButton("Cancel", font: 17, txtColor: MyColors.primary,
                    ontap: () {
                  // Get.to(BottomNavUser());

                  // Get.to(HomeDrawer());
                  // _.loginUser();
                },
                    width: 90,
                    height: 6.6,
                    isColor: false,
                    clr: MyColors.primary),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
