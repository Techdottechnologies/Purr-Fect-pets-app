import 'package:petcare/blocs/pet/pet_bloc.dart';
import 'package:petcare/blocs/pet/pet_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/models/pet_model.dart';
import 'package:petcare/page/home/pet/pet/add_pet.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/extensions/date_extension.dart';
import 'package:petcare/utils/extensions/string_extension.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../widgets/avatar_widget.dart';

class PetView extends StatefulWidget {
  const PetView({super.key, required this.pet});
  final PetModel pet;
  @override
  State<PetView> createState() => _PetViewState();
}

class _PetViewState extends State<PetView> {
  late PetModel pet = widget.pet;

  List txt1 = [
    "Breed",
    "Breed",
    "Pet Birthday",
    "Weight",
    "Microchip",
    "Rabies Vacc",
    "Instagram",
    "Tiktok",
    "Anxiety",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PetBloc, PetState>(
      listener: (context, state) {
        if (state is PetStateUpdated) {
          setState(() {
            pet = state.pet;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32.h,
              width: Get.width,
              decoration: BoxDecoration(
                  color: MyColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              radius: 1.9.h,
                              backgroundColor: MyColors.white,
                              child: Icon(
                                Remix.arrow_left_s_line,
                                color: Colors.black,
                                size: 2.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Stack(
                        children: [
                          AvatarWidget(
                            width: 100,
                            height: 100,
                            backgroundColor: Colors.black,
                            avatarUrl: pet.avatar,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Row(
                        children: [
                          Spacer(),
                          textWidget(
                            pet.name,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),

            // Row(
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         Get.back();
            //       },
            //       child: CircleAvatar(
            //         radius: 1.9.h,
            //         backgroundColor: MyColors.white,
            //         child: Icon(
            //           Remix.arrow_left_s_line,
            //           color: Colors.black,
            //           size: 2.h,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Spacer(),
            // Center(
            //   child: Stack(
            //     children: [
            //       AvatarWidget(
            //         width: 100,
            //         height: 100,
            //         backgroundColor: Colors.black,
            //         avatarUrl: pet.avatar,
            //       ),
            //     ],
            //   ),
            // ),
            //     Spacer(),
            //   ],
            // ),
            // SizedBox(height: 1.h),
            // Row(
            //   children: [
            //     Spacer(),
            //     textWidget(
            //       pet.name,
            //       fontSize: 19.sp,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     Spacer(),
            //   ],
            // ),
            SizedBox(height: 2.h),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget("About ${pet.name}"),
                                    text_w(
                                      pet.behavior ?? "",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Color(0xffFEDFC3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textWidget(
                                          "Gender",
                                          color: Color(0xff1E1E1E)
                                              .withOpacity(0.50),
                                          fontSize: 14.sp,
                                        ),
                                        SizedBox(height: 0.4.h),
                                        text_w(
                                          pet.gender.capitalizeFirstCharacter(),
                                          // fontSize: 15.6.sp,
                                          // fontWeight: FontWeight.w300
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        textWidget(
                                          "Age",
                                          color: Color(0xff1E1E1E)
                                              .withOpacity(0.50),
                                          fontSize: 14.sp,
                                        ),
                                        SizedBox(height: 0.4.h),
                                        text_w(
                                          pet.dob == null
                                              ? "-"
                                              : pet.dob!.convertToAgeDiff(),
                                          // fontSize: 15.6.sp,
                                          // fontWeight: FontWeight.w300
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        textWidget(
                                          "Pet Type",
                                          color: Color(0xff1E1E1E)
                                              .withOpacity(0.50),
                                          fontSize: 14.sp,
                                        ),
                                        SizedBox(height: 0.4.h),
                                        text_w(
                                          pet.type.name,
                                          textAlign: TextAlign.center,
                                          // fontSize: 15.6.sp,
                                          // fontWeight: FontWeight.w300
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 2,
                              shrinkWrap: true,
                              children: List.generate(
                                txt1.length,
                                (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffF9F9F9),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          textWidget(
                                            txt1[index],
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 0.6.h),
                                          text_w(
                                            index == 0
                                                ? pet.breed
                                                : index == 1
                                                    ? pet.additionalBreed ??
                                                        "--"
                                                    : index == 2
                                                        ? (pet.dob != null
                                                            ? pet.dob!
                                                                .dateToString(
                                                                    "dd MMM yyyy")
                                                            : "-")
                                                        : index == 3
                                                            ? "${pet.weight} lbs"
                                                            : index == 5
                                                                ? pet.vaccinated
                                                                : index == 6
                                                                    ? (pet.instaUsername ??
                                                                        "-")
                                                                    : index == 7
                                                                        ? (pet.tikUsername ??
                                                                            "-")
                                                                        : index ==
                                                                                8
                                                                            ? (pet.anxiety)
                                                                            : "-",
                                            fontSize: 15.6.sp,
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // textWidget("Behavior:"),
                            // text_w(
                            //   pet.behavior ?? "",
                            //   fontSize: 15.6.sp,
                            // ),
                            // gapH10,
                            // textWidget("Diet:"),
                            // text_w(
                            //   pet.dietPlan ?? "",
                            //   fontSize: 15.6.sp,
                            // ),
                            SizedBox(height: 6.h),
                            gradientButton("Edit",
                                font: 17, txtColor: MyColors.white, ontap: () {
                              Get.to(
                                AddPet(pet: pet),
                              );
                            },
                                width: 90,
                                height: 6.6,
                                isColor: true,
                                clr: MyColors.primary),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
