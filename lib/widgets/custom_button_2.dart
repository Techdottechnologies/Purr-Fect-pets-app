import 'package:petcare/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget gradientButton(
  String title, {
  bool isColor = false,
  // String? iconPath,
  Color clr = Colors.white,
  Function? ontap,
  Color txtColor = Colors.white,
  bColor,
  bWidth,
  double font = 0,
  double height = 0,
  double width = 0,
  bool isLoading = false,
}) {
  return InkWell(
    onTap: isLoading
        ? null
        : () {
            if (ontap != null) {
              ontap();
            }
          },
    child: Container(
      width: width.w,
      height: height == 0 ? 6.3.h : height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isColor ? clr : Colors.white,
        border: isColor
            ? null
            : Border.all(
                color: bColor ?? MyColors.primary,
                width: bWidth ?? 1,
              ),
      ),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: font == 0 ? 17.sp : font.sp,
                  fontWeight: FontWeight.w500,
                  color: txtColor,
                ),
              ),
      ),
    ),
  );
}
