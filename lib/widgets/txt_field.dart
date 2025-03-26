import 'package:petcare/config/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget textFieldWithPrefixSuffuxIconAndHintText(
  String hintText, {
  suffixIcon,
  prefixIcon,
  TextEditingController? controller,
  int line = 1,
  bool isSuffix = false,
  bool enable = true,
  double? radius,
  fillColor,
  bColor,
  mainTxtColor,
  hintColor,
  bool isPrefix = false,
  color,
  iconColor,
  bool obsecure = false,
  Function(String)? onTyping,
  Function(String)? onCompleted,
}) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) {
      return TextField(
        maxLines: line,
        enabled: enable,
        obscureText: obsecure,
        controller: controller,
        onSubmitted: (value) {
          if (onCompleted != null) {
            onCompleted(value);
          }
        },
        onChanged: (value) {
          if (onTyping != null) {
            onTyping(value);
          }
        },
        style: GoogleFonts.nunito(
            color: mainTxtColor ?? Colors.black, fontSize: 15.sp),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(
                fontSize: 15.sp,
                fontWeight: FontWeight.w200,
                color: hintColor ?? Color(0xff080422)),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            suffixIconConstraints: BoxConstraints(),
            suffixIcon: isSuffix
                ? Padding(
                    padding: EdgeInsets.only(
                        right: suffixIcon == "assets/icons/down.png" ? 20 : 20),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        child: Image.asset(
                          suffixIcon ?? "assets/icons/eye.png",
                          height:
                              suffixIcon == "assets/icons/down.png" ? 1.h : 2.h,
                        )),
                  )
                : const SizedBox(),
            prefixIconConstraints: BoxConstraints(minWidth: 8.w),
            prefixIcon: isPrefix
                ? InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Image.asset(
                        prefixIcon,
                        height: 2.2.h,
                        color: MyColors.primary,
                      ),
                    ),
                  )
                : const SizedBox(),
            filled: true,
            fillColor: fillColor ?? Color(0xffF7F7F7),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 35),
                borderSide:
                    BorderSide(color: bColor ?? Color(0xffD3DEF3), width: 1)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 35),
                borderSide:
                    BorderSide(color: bColor ?? Color(0xffE6DCCD), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 35),
                borderSide: BorderSide(color: Color(0xffE6DCCD), width: 1))),
      );
    },
  );
}

class TextInputField3 extends StatelessWidget {
  final TextEditingController controller;
  // final ProfileController auth;

  final String labelText;
  final bool isObscure;
  final bool prefix;
  final bool enable;

  final bool isSuffix;

  // final IconData icon;
  const TextInputField3({
    Key? key,
    required this.controller,
    // required this.auth,
    required this.enable,
    required this.labelText,
    this.isObscure = false,
    this.prefix = false,
    this.isSuffix = false,
    // required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enable,
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffF7F7F7),
        hintText: labelText,
        hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff6B6B6B)),
        prefixIconConstraints: BoxConstraints(
            // maxWidth: 25.w
            ),
        suffixIconConstraints: BoxConstraints(),
        suffixIcon: isSuffix
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                    child: Image.asset(
                  "assets/images/edit.png",
                  height: 2.6.h,
                )),
              )
            : const SizedBox(),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 1.w),
            CountryCodePicker(
              onChanged: (CountryCode countryCode) {
                // auth.code = countryCode.toString();
                // auth.update();
                // log(auth.code);
              },
              showFlag: true,
              // flagWidth: 10.w,

              // flagWidth: 0.w,
              onInit: (value) {
                // auth.code = value.toString();
                // log(auth.code);
              },
              padding: EdgeInsets.zero,
              hideMainText: true,
              // initialSelection: 'IT',
              favorite: const ['+39', 'FR'],
              barrierColor: Colors.black12,
              dialogBackgroundColor: Colors.white,

              textStyle: GoogleFonts.plusJakartaSans(color: Colors.black),
              //    searchStyle:  GoogleFonts.nunito(color: Colors.black),
              // showCountryOnly: false,
              // showFlagMain: true,
              showOnlyCountryWhenClosed: false,
              showDropDownButton: true,
              alignLeft: false,
            ),
            SizedBox(
              width: 0.4.w,
              height: 4.5.h,
              child: VerticalDivider(
                color: Colors.grey,
                width: 1.w,
                thickness: 1,
              ),
            ),
            SizedBox(width: 1.w),
          ],
        ),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xffE8ECF4),
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xffE8ECF4),
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffE8ECF4),
            )),
      ),
      obscureText: isObscure,
    );
  }
}
