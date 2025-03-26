import 'package:petcare/blocs/pet/pet_bloc.dart';
import 'package:petcare/blocs/pet/pet_event.dart';
import 'package:petcare/blocs/pet/pet_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/exceptions/app_exceptions.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/models/pet_model.dart';
import 'package:petcare/page/home/home_drawer.dart';
import 'package:petcare/page/home/pet/select_anexity.dart';
import 'package:petcare/page/home/pet/select_breed.dart';
import 'package:petcare/repos/pet/validation.dart';
import 'package:petcare/utils/constants/enum.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/utils/extensions/date_extension.dart';
import 'package:petcare/utils/extensions/string_extension.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/slider_widget.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:petcare/widgets/wheel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../widgets/my_image_picker.dart';
import '../../../auth/login_page.dart';

class AddPet extends StatefulWidget {
  const AddPet({
    super.key,
    this.isComingFromSignup = false,
    this.isNeedToVerify = false,
    this.pet,
  });
  final bool isComingFromSignup, isNeedToVerify;
  final PetModel? pet;

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  PageController pageController = PageController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController additionalBreedController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController instaController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController behaviorController = TextEditingController();
  final TextEditingController anxietyController = TextEditingController();
  final TextEditingController dietController = TextEditingController();

  String? vaccinated;
  String? neutered;
  double weight = 0.0;
  PetType type = PetType.cat;

  int selectPage = 0;
  int gender = 0;
  String? avatar;
  DateTime? dob;
  bool isLoading = false;
  late PetModel? pet = widget.pet;

  void triggerAddPetEvent() {
    final PetModel model = PetModel(
      uuid: "",
      createdAt: DateTime.now(),
      owner: AppManager.currentUser!.uid,
      type: type,
      breed: breedController.text,
      additionalBreed: additionalBreedController.text,
      gender: gender == 0 ? "male" : "female",
      name: nameController.text,
      avatar: avatar,
      dob: dob,
      instaUsername: instaController.text,
      tikUsername: tiktokController.text,
      vaccinated: vaccinated ?? "",
      neutered: neutered ?? "",
      behavior: behaviorController.text,
      anxiety: anxietyController.text,
      dietPlan: dietController.text,
      weight: weight,
    );

    context.read<PetBloc>().add(PetEventAdd(model: model));
  }

  void triggerUpdatePetEvent() {
    pet = pet!.copyWith(
      type: type,
      breed: breedController.text,
      additionalBreed: additionalBreedController.text,
      gender: gender == 0 ? "male" : "female",
      name: nameController.text,
      avatar: avatar,
      dob: dob,
      instaUsername: instaController.text,
      tikUsername: tiktokController.text,
      vaccinated: vaccinated ?? "",
      neutered: neutered ?? "",
      behavior: behaviorController.text,
      anxiety: anxietyController.text,
      dietPlan: dietController.text,
      weight: weight,
    );

    context.read<PetBloc>().add(PetEventUpdate(model: pet!));
  }

  void setData() {
    type = pet!.type;
    breedController.text = pet!.breed;
    additionalBreedController.text = pet?.additionalBreed ?? "";
    gender = pet!.gender == "male" ? 0 : 1;
    avatar = pet?.avatar;
    nameController.text = pet!.name;
    dob = pet!.dob;
    instaController.text = pet!.instaUsername ?? "";
    tiktokController.text = pet!.tikUsername ?? "";
    vaccinated = pet!.vaccinated;
    neutered = pet!.neutered;
    behaviorController.text = pet?.behavior ?? "";
    anxietyController.text = pet!.anxiety;
    dietController.text = pet!.dietPlan ?? "";
    weight = pet!.weight;

    dobController.text = dob!.dateToString("dd MMM yyyy");
  }

  void checkValidation() async {
    try {
      await PetValidation.validate(
        breed: breedController.text,
        name: nameController.text,
        vaccinated: vaccinated ?? "",
        neutered: neutered ?? "",
        anxiety: anxietyController.text,
        weight: weight,
        page: selectPage,
        dob: dob,
        insta: instaController.text,
        tiktok: tiktokController.text,
        avatar: avatar ?? "",
        behavior: behaviorController.text,
        diet: dietController.text,
      );

      if (selectPage == 4) {
        pet != null ? triggerUpdatePetEvent() : triggerAddPetEvent();
        return;
      }

      setState(() {
        selectPage++;
      });

      pageController.animateToPage(
        selectPage,
        curve: Curves.linear,
        duration: Duration(
          milliseconds: 300,
        ),
      );
    } on AppException catch (e) {
      CustomDialogs().errorBox(message: e.message);
    }
  }

  void selectImage() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            avatar = data.path;
          });
        }
      },
    );
  }

  void pickDateOfBirth() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      initialDate: dob,
      currentDate: dob,
    );

    if (selectedDate != null) {
      dob = selectedDate;
      dobController.text = selectedDate.dateToString("dd MMM, yyyy");
    }
  }

  @override
  void initState() {
    if (pet != null) {
      setData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PetBloc, PetState>(
      listener: (context, state) {
        if (state is PetStateAdding ||
            state is PetStateAdded ||
            state is PetStateAddFailure ||
            state is PetStateUpdateFailure ||
            state is PetStateUpdated ||
            state is PetStateUpdating) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is PetStateAddFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is PetStateUpdateFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is PetStateAdded) {
            if (widget.isComingFromSignup) {
              if (widget.isNeedToVerify) {
                CustomDialogs().successBox(
                  message:
                      "We've sent you an email verification link to email. Please verify your email by clicking the link before logging in.",
                  positiveTitle: "Go to Login",
                  onPositivePressed: () {
                    Get.offAll(const LoginPage());
                  },
                );
                return;
              }
              Get.offAll(
                  HomeDrawer()); // Move when Sign up or sign in with social auth method
              return;
            }
            Get.back(); // Otherwise move to previous screen
          }

          if (state is PetStateUpdated) {
            Get.back();
          }
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  height: 1.5.h,
                  decoration: BoxDecoration(color: Color(0xffD9D9D9)),
                  child: Row(
                    children: [
                      Container(
                        width: selectPage == 0
                            ? 20.w
                            : selectPage == 1
                                ? 40.w
                                : selectPage == 2
                                    ? 60.w
                                    : selectPage == 3
                                        ? 80.w
                                        : selectPage == 4
                                            ? 90.w
                                            : 100.w,
                        color: MyColors.primary,
                      ),
                      Container(child: SizedBox())
                    ],
                  ),
                ),
                // LinearPercentIndicator(
                //     width: Get.width,
                //     lineHeight: 14.0,
                //     // percent: selectPage+1/6,

                //     linearStrokeCap: LinearStrokeCap.roundAll,
                //     backgroundColor: Color(0xffD9D9D9),
                //     progressColor: MyColors.primary,
                //   ),
                SizedBox(height: 3.h),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectPage == 0) {
                            Get.back();
                          } else {
                            setState(() {
                              selectPage--;
                            });
                            pageController.animateToPage(selectPage,
                                curve: Curves.linear,
                                duration: Duration(milliseconds: 300));
                          }
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
                        "Add Pet information",
                        fontWeight: FontWeight.w500,
                        fontSize: 19.sp,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    onPageChanged: (value) {
                      setState(() {
                        selectPage = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return index == 0
                          ? petTypeContent()
                          : index == 1
                              ? PetGenderContent()
                              : index == 2
                                  ? petInfoContent()
                                  : index == 3
                                      ? petHealthContent()
                                      : petWeightContent();
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget petTypeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            textWidget(
              "What is Your Pet Type?",
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
            SizedBox(height: 0.4.h),
            textWidget(
              "What type  of pet do you own?",
              color: Color(0xff080422),
              fontWeight: FontWeight.w300,
              fontSize: 15.sp,
            ),
            SizedBox(height: 2.h),
            Container(
              height: 30.h,
              child: CustomCarouselFB2(
                selectedPet: type,
                onSelectPet: (t) {
                  type = t;
                },
              ),
            ),
            SizedBox(height: 3.h),
            textWidget(
              "Dog Breed information",
            ),
            SizedBox(height: 1.h),
            InkWell(
              onTap: () {
                Get.to(
                  SelectBreed(
                    selectedBreed: breedController.text,
                    onSelectedBreed: (breed) {
                      breedController.text = breed;
                    },
                  ),
                );
              },
              child: textFieldWithPrefixSuffuxIconAndHintText(
                "Select Breed",
                controller: breedController,
                fillColor: Color(0xffF9F9F9),
                mainTxtColor: Colors.black,
                radius: 20,
                enable: false,
                bColor: Colors.transparent,
                suffixIcon: "assets/icons/down.png",
                isSuffix: true,
              ),
            ),
            SizedBox(height: 3.h),
            textWidget(
              "Additional Breed (optional)",
            ),
            SizedBox(height: 1.h),
            InkWell(
                onTap: () {
                  Get.to(
                    SelectBreed(
                      selectedBreed: additionalBreedController.text,
                      onSelectedBreed: (breed) {
                        additionalBreedController.text = breed;
                      },
                    ),
                  );
                },
                child: textFieldWithPrefixSuffuxIconAndHintText(
                  "Select Breed",
                  controller: additionalBreedController,
                  fillColor: Color(0xffF9F9F9),
                  mainTxtColor: Colors.black,
                  radius: 20,
                  enable: false,
                  bColor: Colors.transparent,
                  suffixIcon: "assets/icons/down.png",
                  isSuffix: true,
                )),
            SizedBox(height: 6.h),
            gradientButton(
              "Next",
              font: 17,
              txtColor: MyColors.white,
              ontap: () {
                checkValidation();
              },
              width: 90,
              height: 6.6,
              isColor: true,
              clr: MyColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget PetGenderContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          textWidget("Gender", fontWeight: FontWeight.w500, fontSize: 20.sp),
          SizedBox(height: 0.4.h),
          text_w("Is your pet male of female?",
              color: Color(0xff080422),
              fontWeight: FontWeight.w300,
              fontSize: 15.sp),
          // SizedBox(height: 2.h),
          Spacer(),
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = 0;
                });
              },
              child: gender == 0
                  ? CircleAvatar(
                      radius: 7.h,
                      backgroundColor: Color(0xffFEDFC3),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset(
                            "assets/images/male.png",
                            height: 4.h,
                          ),
                          SizedBox(height: 1.5.h),
                          textWidget(
                            "Male",
                            fontSize: 15.sp,
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : CircleAvatar(
                      radius: 7.h,
                      backgroundColor: Color(0xffF9F9F9),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset(
                            "assets/images/male.png",
                            height: 4.h,
                          ),
                          SizedBox(height: 1.5.h),
                          textWidget(
                            "Male",
                            fontSize: 15.sp,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = 1;
                });
              },
              child: gender == 1
                  ? CircleAvatar(
                      radius: 7.h,
                      backgroundColor: Color(0xffFEDFC3),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset(
                            "assets/images/fem.png",
                            height: 4.h,
                          ),
                          SizedBox(height: 1.5.h),
                          textWidget(
                            "Female",
                            fontSize: 15.sp,
                          ),
                          Spacer(),
                        ],
                      ),
                    )
                  : CircleAvatar(
                      radius: 7.h,
                      backgroundColor: Color(0xffF9F9F9),
                      child: Column(
                        children: [
                          Spacer(),
                          Image.asset(
                            "assets/images/fem.png",
                            height: 4.h,
                          ),
                          SizedBox(height: 1.5.h),
                          textWidget(
                            "Female",
                            fontSize: 15.sp,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
            ),
          ),

          Spacer(
            flex: 2,
          ),
          SizedBox(height: 4.h),
          gradientButton(
            "Next",
            font: 17,
            txtColor: MyColors.white,
            ontap: () {
              checkValidation();
            },
            width: 90,
            height: 6.6,
            isColor: true,
            clr: MyColors.primary,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget petInfoContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            textWidget(
              "Pet information",
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
            SizedBox(height: 0.4.h),
            textWidget(
              "Tell us about your pet  This information helps with \nidentification leter on.",
              color: Color(0xff080422),
              fontWeight: FontWeight.w300,
              fontSize: 15.sp,
            ),
            SizedBox(height: 4.h),
            Center(
              child: Stack(
                children: [
                  AvatarWidget(
                    width: 120,
                    height: 120,
                    avatarUrl: avatar,
                  ),
                  Positioned.fill(
                    child: InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 2.h,
                          backgroundColor: Colors.black,
                          child: Image.asset(
                            "assets/icons/edit.png",
                            height: 1.7.h,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 3.h),
            textWidget(
              "First Name ",
              fontSize: 15.sp,
            ),
            SizedBox(height: 1.h),
            textFieldWithPrefixSuffuxIconAndHintText(
              "Enter Name",
              controller: nameController,
              fillColor: Color(0xffF9F9F9),
              mainTxtColor: Colors.black,
              radius: 20,
              bColor: Colors.transparent,
            ),
            SizedBox(height: 2.h),
            textWidget(
              "Date of Birth",
              fontSize: 15.sp,
            ),
            SizedBox(height: 1.h),
            InkWell(
              onTap: () {
                pickDateOfBirth();
              },
              child: textFieldWithPrefixSuffuxIconAndHintText(
                "Select Date",
                controller: dobController,
                fillColor: Color(0xffF9F9F9),
                mainTxtColor: Colors.black,
                radius: 20,
                enable: false,
                bColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 2.h),
            textWidget(
              "Instagram Username ",
              fontSize: 15.sp,
            ),
            SizedBox(height: 1.h),
            textFieldWithPrefixSuffuxIconAndHintText(
              "@heybuddyclub",
              controller: instaController,
              fillColor: Color(0xffF9F9F9),
              mainTxtColor: Colors.black,
              radius: 20,
              bColor: Colors.transparent,
            ),
            SizedBox(height: 2.h),
            textWidget(
              "Tiktok Username ",
              fontSize: 15.sp,
            ),
            SizedBox(height: 1.h),
            textFieldWithPrefixSuffuxIconAndHintText(
              "@heybuddyclub",
              controller: tiktokController,
              fillColor: Color(0xffF9F9F9),
              mainTxtColor: Colors.black,
              radius: 20,
              // enable: false,
              bColor: Colors.transparent,
            ),
            SizedBox(height: 4.h),
            gradientButton(
              "Next",
              font: 17,
              txtColor: MyColors.white,
              ontap: () {
                checkValidation();
              },
              width: 90,
              height: 6.6,
              isColor: true,
              clr: MyColors.primary,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget petHealthContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            textWidget("Health", fontWeight: FontWeight.w500, fontSize: 20.sp),
            SizedBox(height: 0.4.h),
            RichText(
              text: TextSpan(
                style: GoogleFonts.nunito(
                    color: Color(0xff080422),
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp),
                children: <TextSpan>[
                  TextSpan(text: 'Visit Health information\t'),
                  TextSpan(
                    text:
                        'You will be able to access more health options after creating your profile.',
                    style: GoogleFonts.nunito(
                      color: Color(0xff080422),
                      fontWeight: FontWeight.w300,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Spacer(),
            SizedBox(height: 3.h),

            textWidget("Vaccination "),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        // Spacer(),
                        textWidget(
                          "Vaccination for Rubies",
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w300,
                        ),
                        Spacer(),
                        choose(
                          onSelected: (p0) {
                            setState(() {
                              vaccinated = p0;
                            });
                          },
                          selectedValue: vaccinated,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            textWidget("Neutered/Spayed "),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        // Spacer(),
                        textWidget(
                          "Select here",
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w300,
                        ),
                        Spacer(),
                        choose(
                          onSelected: (p0) {
                            setState(() {
                              neutered = p0;
                            });
                          },
                          selectedValue: neutered,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            textWidget(
              "Behavior ",
            ),
            SizedBox(height: 1.h),
            textFieldWithPrefixSuffuxIconAndHintText(
              "Ex:happy experience etc",
              controller: behaviorController,
              fillColor: Color(0xffF9F9F9),
              mainTxtColor: Colors.black,
              radius: 20,
              // enable: false,
              bColor: Colors.transparent,
            ),
            SizedBox(height: 2.h),
            textWidget("Anxiety "),
            SizedBox(height: 1.h),
            InkWell(
              onTap: () {
                Get.to(
                  SelectAnxiety(
                    selectedAnxiety: anxietyController.text,
                    onSelected: (anxiety) {
                      anxietyController.text =
                          anxiety.capitalizeFirstCharacter();
                    },
                  ),
                );
              },
              child: textFieldWithPrefixSuffuxIconAndHintText(
                "Select here",
                controller: anxietyController,
                fillColor: Color(0xffF9F9F9),
                mainTxtColor: Colors.black,
                radius: 20,
                enable: false,
                bColor: Colors.transparent,
                suffixIcon: "assets/icons/down.png",
                isSuffix: true,
              ),
            ),
            SizedBox(height: 2.h),
            textWidget("Diet "),
            SizedBox(height: 1.h),
            textFieldWithPrefixSuffuxIconAndHintText(
              "What food does Mostly eat?",
              controller: dietController,
              fillColor: Color(0xffF9F9F9),
              mainTxtColor: Colors.black,
              radius: 20,
              bColor: Colors.transparent,
            ),
            SizedBox(height: 6.h),

            gradientButton(
              "Next",
              font: 17,
              txtColor: MyColors.white,
              ontap: () {
                checkValidation();
              },
              width: 90,
              height: 6.6,
              isColor: true,
              clr: MyColors.primary,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget content5() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          textWidget("Microchip", fontWeight: FontWeight.w500, fontSize: 20.sp),
          SizedBox(height: 0.4.h),
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(
                  color: Color(0xff080422),
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp),
              children: <TextSpan>[
                TextSpan(text: 'Microchip are important!\t'),
                TextSpan(
                  text:
                      'These can only be accessed with and RFID scanner.its easier for the pet by entering in your now.',
                  style: GoogleFonts.nunito(
                      color: Color(0xff080422),
                      fontWeight: FontWeight.w300,
                      fontSize: 15.sp),
                ),
              ],
            ),
          ),
          // SizedBox(height: 2.h),

          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: gradientButton(
                  "No",
                  font: 17,
                  txtColor: MyColors.primary,
                  ontap: () {
                    setState(() {
                      selectPage++;
                    });
                    pageController.animateToPage(selectPage,
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 300));
                  },
                  width: 90,
                  height: 6.6,
                  isColor: false,
                  clr: MyColors.primary,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: gradientButton(
                  "Yes",
                  font: 17,
                  txtColor: MyColors.white,
                  ontap: () {
                    checkValidation();
                  },
                  width: 90,
                  height: 6.6,
                  isColor: true,
                  clr: MyColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget petWeightContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          textWidget(
            "Pet Weight",
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
          ),
          SizedBox(height: 0.4.h),
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(
                  color: Color(0xff080422),
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp),
              children: <TextSpan>[
                TextSpan(text: 'What your Pet Current Weight.'),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: WheelPage(
              title: "",
              onWeightChanged: (v) {
                weight = v;
              },
              currentWeight: weight,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: gradientButton(
                  pet != null ? "Update" : "Save",
                  font: 17,
                  isLoading: isLoading,
                  txtColor: MyColors.white,
                  ontap: () {
                    checkValidation();
                  },
                  width: 90,
                  height: 6.6,
                  isColor: true,
                  clr: MyColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget choose({String? selectedValue, required Function(String) onSelected}) {
    final List<String> attributes = ["Yes", "No"];
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          "Select",
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        items: attributes
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item,
                    style: GoogleFonts.workSans(
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          onSelected(value!);
        },
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: MyColors.primary,
            borderRadius: BorderRadius.circular(80),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 4.5.h,
          width: 23.w,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: MyColors.primary,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Remix.arrow_down_s_line,
            size: 2.4.h,
            color: Colors.white,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(height: 40),
      ),
    );
  }
}
