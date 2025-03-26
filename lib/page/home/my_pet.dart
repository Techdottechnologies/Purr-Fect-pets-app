import 'package:petcare/blocs/pet/pet_bloc.dart';
import 'package:petcare/blocs/pet/pet_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/page/home/pet/pet/add_pet.dart';
import 'package:petcare/page/home/pet/pet_view.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/utils/extensions/string_extension.dart';

import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/custom_network_image.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/pet_model.dart';

class MyPets extends StatefulWidget {
  const MyPets({super.key});
  @override
  State<MyPets> createState() => _MyPetsState();
}

class _MyPetsState extends State<MyPets> {
  List<PetModel> pets = AppManager.pets;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PetBloc, PetState>(
      listener: (context, state) {
        if (state is PetStateAdded ||
            state is PetStateUpdated ||
            state is PetStateFetchedAll ||
            state is PetStateDeleted) {
          setState(() {
            pets = AppManager.pets;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     Get.find<NavController>().currentIndex = 0;
                        //     Get.find<NavController>().update();
                        //     setState(() {});
                        //   },
                        //   child: CircleAvatar(
                        //     radius: 2.3.h,
                        //     backgroundColor: MyColors.primary,
                        //     child: Icon(
                        //       Remix.arrow_left_s_line,
                        //       color: Colors.white,
                        //       size: 3.h,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(width: 5.w),
                        textWidget(
                          "My Pets",
                          fontWeight: FontWeight.w500,
                          fontSize: 19.sp,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Get.to(AddPet());
                          },
                          child: CircleAvatar(
                            radius: 2.3.h,
                            backgroundColor: MyColors.primary,
                            child: Icon(
                              Remix.add_line,
                              color: Colors.white,
                              size: 2.5.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: pets.isNotEmpty
                          ? _PetView(
                              pets: pets,
                            )
                          : _EmptyWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetView extends StatelessWidget {
  const _PetView({required this.pets});
  final List<PetModel> pets;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 40, bottom: 100),
      itemCount: pets.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 200,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        final PetModel pet = pets[index];

        return InkWell(
          onTap: () {
            Get.to(PetView(pet: pet));
          },
          child: Card(
            surfaceTintColor: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            elevation: 1,
            color: Colors.white,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.6,
                    child: CustomNetworkImage(imageUrl: pet.avatar ?? ""),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textWidget(
                              pet.name,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xFF080422),
                            ),
                            textWidget(
                              pet.type.name,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xFF080422).withOpacity(0.5),
                            ),
                          ],
                        ),
                        gapH4,
                        textWidget(
                          pet.breed.capitalizeFirstCharacter(),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Color(0xFF080422).withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: textWidget(
            "No Pet Add",
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Center(
          child: text_w(
            "You have’nt connected any pets. add your first pet",
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff080422),
          ),
        ),
        SizedBox(height: 3.h),
        gradientButton(
          "Add Pet",
          font: 17,
          txtColor: MyColors.white,
          ontap: () {
            Get.to(AddPet());
          },
          width: 90,
          height: 6.6,
          isColor: true,
          clr: MyColors.primary,
        ),
      ],
    );
  }
}
