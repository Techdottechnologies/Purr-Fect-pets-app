import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectAnxiety extends StatefulWidget {
  const SelectAnxiety(
      {super.key, this.selectedAnxiety, required this.onSelected});
  final String? selectedAnxiety;
  final Function(String) onSelected;

  @override
  State<SelectAnxiety> createState() => _SelectAnxietyState();
}

class _SelectAnxietyState extends State<SelectAnxiety> {
  final List<String> anxieties = [
    "Separation Anxiety ",
    "Loud Noises",
    "Fireworks",
    "Stranger Anxiety",
    "General / Situational",
  ];

  late String? anxiety = widget.selectedAnxiety;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: gradientButton(
        "Select",
        font: 17,
        txtColor: MyColors.white,
        ontap: anxiety != null
            ? () {
                widget.onSelected(anxiety!);
                Get.back();
              }
            : () {},
        width: 90,
        height: 6.6,
        isColor: true,
        clr: MyColors.primary,
      ),
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
                    textWidget(
                      "Select Anxiety",
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 4.h),
                SizedBox(height: 1.5.h),
                ...List.generate(anxieties.length, (index) {
                  final bool isSelected =
                      anxiety?.toLowerCase() == anxieties[index].toLowerCase();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          anxiety = anxieties[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? MyColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Spacer(),
                                textWidget(
                                  anxieties[index],
                                  fontSize: 16.sp,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w300,
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
