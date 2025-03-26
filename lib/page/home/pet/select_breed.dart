import 'package:petcare/config/colors.dart';
import 'package:petcare/utils/extensions/string_extension.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectBreed extends StatefulWidget {
  const SelectBreed(
      {super.key, this.selectedBreed, required this.onSelectedBreed});
  final String? selectedBreed;
  final Function(String) onSelectedBreed;
  @override
  State<SelectBreed> createState() => _SelectBreedState();
}

class _SelectBreedState extends State<SelectBreed> {
  final List<String> breeds = [
    "Mixed/ Unknown",
    "Afghan",
    "Afghan Hound",
    "Afghan Terrier",
    "Akite",
    "Beagle",
  ];

  late List<String> filteredBreeds = breeds;
  late int current = breeds.indexWhere(
      (str) => str.toLowerCase() == widget.selectedBreed?.toLowerCase());

  void filtered(String? text) {
    if (text == null || text == "") {
      setState(() {
        filteredBreeds = breeds;
      });
      return;
    }

    setState(() {
      filteredBreeds = breeds
          .where((e) => e.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void checkExisted({String? breed}) {
    if (breed != null && breed != "") {
      final int index =
          breeds.indexWhere((e) => e.toLowerCase() == breed.toLowerCase());
      if (index > -1) {
        setState(() {
          current = index;
        });
      } else {
        setState(() {
          breeds.insert(0, breed.capitalizeFirstCharacter());
          current = 0;
        });
      }
    } else if (current == -1 &&
        widget.selectedBreed != null &&
        widget.selectedBreed != "") {
      setState(() {
        breeds.insert(
            0, (widget.selectedBreed ?? "").capitalizeFirstCharacter());
        current = 0;
      });
    }

    setState(() {
      filteredBreeds = breeds;
    });
  }

  @override
  void initState() {
    checkExisted();
    super.initState();
  }

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
                    textWidget(
                      "Select Breed",
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Search Breed",
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  bColor: Colors.transparent,
                  suffixIcon: "assets/icons/s1.png",
                  isSuffix: true,
                  onTyping: (text) {
                    filtered(text);
                  },
                ),
                SizedBox(height: 4.h),
                textWidget("Bread Name"),
                SizedBox(height: 2.h),
                textFieldWithPrefixSuffuxIconAndHintText(
                  "Input Breed",
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  bColor: Colors.transparent,
                  onCompleted: (text) {
                    checkExisted(breed: text);
                  },
                ),
                SizedBox(height: 1.5.h),
                ...List.generate(
                  filteredBreeds.length,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        current = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: current == index
                                ? MyColors.primary
                                : Colors.transparent,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Spacer(),
                                textWidget(
                                  filteredBreeds[index],
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.5.h),
                gradientButton(
                  "Select",
                  font: 17,
                  txtColor: MyColors.white,
                  ontap: () {
                    current < 0
                        ? null
                        : widget.onSelectedBreed(filteredBreeds[current]);
                    Get.back();
                  },
                  width: 90,
                  height: 6.6,
                  isColor: true,
                  clr: MyColors.primary,
                ),
                SizedBox(height: 3.5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
