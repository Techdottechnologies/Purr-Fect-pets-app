import 'package:petcare/config/colors.dart';
import 'package:petcare/page/auth/upload_picture.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegistrationPage3 extends StatefulWidget {
  const RegistrationPage3({super.key});

  @override
  State<RegistrationPage3> createState() => _RegistrationPage3State();
}

class _RegistrationPage3State extends State<RegistrationPage3> {
  final List<String> plan1 = [
    '10:00',
    '17:00',
    "19:00",
    "20:00",
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/images/sign3.png",
            fit: BoxFit.cover,
            height: Get.height,
            width: Get.width,
          )),
          // Positioned.fill(
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Scaffold(

          //       backgroundColor: Colors.transparent,

          //     ),
          //   ),
          // ),
          Positioned.fill(
              child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset("assets/icons/back.png",
                                height: 5.h)),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12),
                      child: Container(
                        height: 72.h,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                "Registration",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              text_w("Enter your credentials to Sign up",
                                  fontSize: 14.7.sp,
                                  color: Color(0xff080422),
                                  fontWeight: FontWeight.w300),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Chip",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/chip.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Medical conditions",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/kit.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Vaccination",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/med.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Breed",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/bred.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              textFieldWithPrefixSuffuxIconAndHintText(
                                "Pet's behavior",
                                // controller: _.password,
                                fillColor: Color(0xffF9F9F9),
                                mainTxtColor: Colors.black,
                                radius: 20,
                                bColor: Colors.transparent,
                                prefixIcon: "assets/icons/p1.png",
                                isPrefix: true,
                              ),
                              SizedBox(height: 1.5.h),
                              Container(
                                height: 6.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Row(
                                  children: [
                                    SizedBox(width: 5.w),
                                    Image.asset(
                                      "assets/icons/phone.png",
                                      height: 2.3.h,
                                    ),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            "Emergency Contact",
                                            style: GoogleFonts.nunito(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black54),
                                          ),
                                          items: plan1
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 14.sp,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22),
                                            height: 6.h,
                                            width: 100.w,
                                          ),
                                          iconStyleData: IconStyleData(
                                              icon: Icon(
                                            Remix.arrow_down_s_line,
                                            size: 2.5.h,
                                          )),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.h),
                              gradientButton("Next",
                                  font: 17,
                                  txtColor: MyColors.white, ontap: () {
                                Get.to(UploadPicture(
                                  save: false,
                                ));

                                },
                                  width: 90,
                                  height: 6.6,
                                  isColor: true,
                                  clr: MyColors.primary),
                              SizedBox(
                                height: 40.h,
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
