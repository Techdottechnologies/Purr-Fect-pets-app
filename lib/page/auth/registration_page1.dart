
import 'package:petcare/blocs/auth/auth_bloc.dart';
import 'package:petcare/blocs/auth/auth_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/models/location_model.dart';
import 'package:petcare/page/auth/login_page.dart';
import 'package:petcare/page/home/home_screen.dart';
import 'package:petcare/page/home/pet/pet/add_pet.dart';
import 'package:petcare/utils/dialogs/dialogs.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_event.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isLoading = false;
  LocationModel? location;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void triggerSignupEvent(AuthBloc bloc) {
    bloc.add(
      AuthEventRegistering(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmController.text,
          phoneNumber: phoneController.text,
          //1234
          location: LocationModel(
            latitude: 37.7749, // Example latitude (San Francisco)
            longitude: -122.4194, // Example longitude (San Francisco)
            city: "San Francisco",
            country: "USA",
            address: "123 Dummy Street, San Francisco, CA",
          )
          // location: location,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegisterFailure ||
            state is AuthStateRegistered ||
            state is AuthStateRegistering ||
            state is AuthStateAppleLoggedIn ||
            state is AuthStateGoogleLoggedIn ||
            state is AuthStateLogging ||
            state is AuthStateLoggedIn ||
            state is AuthStateLoginFailure ||
            state is AuthStateGoogleLogging) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is AuthStateRegisterFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is AuthStateRegistered) {
            Get.to(
              AddPet(
                isComingFromSignup: true,
                isNeedToVerify: true,
              ),
            );
          }

          if (state is AuthStateLoginFailure) {
            if (state.exception.errorCode != null) {
              CustomDialogs().errorBox(message: state.exception.message);
            }
          }

          if (state is AuthStateLoggedIn ||
              state is AuthStateAppleLoggedIn ||
              state is AuthStateGoogleLoggedIn) {
            Get.offAll(HomePage());
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     "assets/images/sing1.png",
            //     fit: BoxFit.cover,
            //     height: Get.height,
            //     width: Get.width,
            //   ),
            // ),
            Positioned.fill(
                child: Container(
              color: Colors.white,
            )),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/images/shape.png",
                fit: BoxFit.cover,
                // height: Get.height,
                // width: Get.width,
              ),
            )),
            Positioned.fill(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                "assets/icons/back.png",
                                height: 5.h,
                              ),
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              "assets/icons/logo.png",
                              height: 4.h,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                "assets/icons/back.png",
                                height: 5.h,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // CircleAvatar(),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12,
                        ),
                        child: Container(
                          height: 70.h,
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
                                textWidget(
                                  "Enter your credentials to Sign up",
                                  fontSize: 14.7.sp,
                                  color: Color(0xff080422),
                                  fontWeight: FontWeight.w300,
                                ),
                                SizedBox(height: 1.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "New Member",
                                  controller: nameController,
                                  fillColor: Color(0xffF9F9F9),
                                  mainTxtColor: Colors.black,
                                  radius: 20,
                                  bColor: Colors.transparent,
                                  prefixIcon: "assets/icons/user.png",
                                  isPrefix: true,
                                ),
                                SizedBox(height: 1.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "Email",
                                  controller: emailController,
                                  fillColor: Color(0xffF9F9F9),
                                  mainTxtColor: Colors.black,
                                  radius: 20,
                                  bColor: Colors.transparent,
                                  prefixIcon: "assets/icons/mail.png",
                                  isPrefix: true,
                                ),
                                SizedBox(height: 1.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "Enter Phone Number",
                                  controller: phoneController,
                                  fillColor: Color(0xffF9F9F9),
                                  mainTxtColor: Colors.black,
                                  radius: 20,
                                  bColor: Colors.transparent,
                                  prefixIcon: "assets/icons/phone.png",
                                  isPrefix: true,
                                ),
                                SizedBox(height: 1.5.h),
                                // InkWell(
                                // onTap: () async {
                                //   try {
                                //     location = await LocationPicker().pick();
                                //     setState(() {
                                //       addressController.text =
                                //           location?.address ?? "";
                                //     });
                                //   } on AppException catch (e) {
                                //     CustomDialogs()
                                //         .errorBox(message: e.message);
                                //   } catch (e) {
                                //     log("[debug LocationPicker] $e");
                                //     CustomDialogs().errorBox(
                                //         message: "Something went wrong.");
                                //   }
                                // },
                                // child:
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "Address",
                                  controller: addressController,
                                  fillColor: Color(0xffF9F9F9),
                                  mainTxtColor: Colors.black,
                                  radius: 20,
                                  bColor: Colors.transparent,
                                  enable: true,
                                  prefixIcon: "assets/icons/pin.png",
                                  isPrefix: true,
                                ),
                                // ),
                                SizedBox(height: 1.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "Enter Password",
                                  controller: passwordController,
                                  fillColor: Color(0xffF9F9F9),
                                  mainTxtColor: Colors.black,
                                  radius: 20,
                                  bColor: Colors.transparent,
                                  prefixIcon: "assets/icons/lock.png",
                                  isPrefix: true,
                                ),
                                SizedBox(height: 1.5.h),
                                textFieldWithPrefixSuffuxIconAndHintText(
                                  "Confirm Password",
                                  controller: confirmController,
                                  fillColor: Color(0xffF9F9F9),
                                  mainTxtColor: Colors.black,
                                  radius: 20,
                                  bColor: Colors.transparent,
                                  prefixIcon: "assets/icons/lock.png",
                                  isPrefix: true,
                                ),
                                SizedBox(height: 1.5.h),
                                Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Get.offAll(LoginPage());
                                      },
                                      child: text_widgetP(
                                          "Already have an account? ",
                                          color: MyColors.primary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                gradientButton(
                                  "Next",
                                  font: 17,
                                  isLoading: isLoading,
                                  txtColor: MyColors.white,
                                  ontap: () {
                                    location = LocationModel(
                                      latitude:
                                          37.7749, // Example latitude (San Francisco)
                                      longitude:
                                          -122.4194, // Example longitude (San Francisco)
                                      city: "San Francisco",
                                      country: "USA",
                                      address:
                                          "123 Dummy Street, San Francisco, CA",
                                    );
                                    triggerSignupEvent(
                                        context.read<AuthBloc>());
                                  },
                                  width: 90,
                                  height: 6.6,
                                  isColor: true,
                                  clr: MyColors.primary,
                                ),
                                SizedBox(
                                  height: 40.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
