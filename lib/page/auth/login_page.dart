import 'package:petcare/blocs/pet/pet_bloc.dart';
import 'package:petcare/blocs/pet/pet_event.dart';
import 'package:petcare/blocs/pet/pet_state.dart';
import 'package:petcare/config/colors.dart';
import 'package:petcare/manager/app_manager.dart';
import 'package:petcare/page/auth/forgot_password.dart';
import 'package:petcare/page/auth/registration_page1.dart';
import 'package:petcare/page/home/home_drawer.dart';
import 'package:petcare/page/home/pet/pet/add_pet.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/dialogs/loaders.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void triggerLoginEvent(AuthBloc bloc) {
    bloc.add(AuthEventPerformLogin(
        email: emailController.text, password: passwordController.text));
  }

  void triggeEmailVerificationMail(AuthBloc bloc) {
    bloc.add(AuthEventSentEmailVerificationLink());
  }

  void triggerAppleLogin(AuthBloc bloc) {
    bloc.add(AuthEventAppleLogin());
  }

  void triggerGoogleLogin(AuthBloc bloc) {
    bloc.add(AuthEventGoogleLogin());
  }

  void triggerFetchAllPets() {
    context.read<PetBloc>().add(PetEventFetchAll());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Pet Bloc
        BlocListener<PetBloc, PetState>(
          listener: (_, state) {
            if (state is PetStateFetchedAll ||
                state is PetStateFetchingAll ||
                state is PetStateFetchingAll) {
              // state.isLoading ? Loader().show() : Loader().hide();
              setState(() {
                isLoading = state.isLoading;
              });
              if (state is PetStateFetchedAll) {
                if (AppManager.pets.isEmpty) {
                  Get.to(AddPet(isComingFromSignup: true));
                  return;
                }
                Get.back();
                Get.to(HomeDrawer());
              }
            }
          },
        ),

        /// Auth Bloc
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateLogging ||
                state is AuthStateLoggedIn ||
                state is AuthStateLoginFailure ||
                state is AuthStateEmailVerificationRequired ||
                state is AuthStateAppleLoggedIn ||
                state is AuthStateGoogleLoggedIn ||
                state is AuthStateGoogleLogging ||
                state is AuthStateSendingMailVerification ||
                state is AuthStateSendingMailVerificationFailure ||
                state is AuthStateSentMailVerification) {
              /// Start Of Logic
              if (state is AuthStateLogging ||
                  state is AuthStateLoggedIn ||
                  state is AuthStateLoginFailure ||
                  state is AuthStateEmailVerificationRequired ||
                  state is AuthStateAppleLoggedIn ||
                  state is AuthStateGoogleLoggedIn ||
                  state is AuthStateGoogleLogging) {
                setState(() {
                  isLoading = state.isLoading;
                });

                if (state is AuthStateLoginFailure) {
                  CustomDialogs().errorBox(message: state.exception.message);
                }

                if (state is AuthStateLoggedIn) {
                  Get.offAll(const HomeDrawer());
                }

                if (state is AuthStateAppleLoggedIn ||
                    state is AuthStateGoogleLoggedIn) {
                  triggerFetchAllPets();
                }
              }

              if (state is AuthStateEmailVerificationRequired) {
                //1234
                //   Get.put(MyDrawerController);
                // Get.offAll(const HomeDrawer());
                CustomDialogs().alertBox(
                  message:
                      "Please verify your email by clicking on the link provided in the email we've sent you.",
                  title: "Email Verification Required",
                  positiveTitle: "Login again",
                  negativeTitle: "Sent link agin",
                  onPositivePressed: () {
                    triggerLoginEvent(context.read<AuthBloc>());
                  },
                  onNegativePressed: () {
                    triggeEmailVerificationMail(context.read<AuthBloc>());
                  },
                );
              }
              // For Email Verification States
              if (state is AuthStateSendingMailVerification ||
                  state is AuthStateSendingMailVerificationFailure ||
                  state is AuthStateSentMailVerification) {
                state.isLoading ? Loader().show() : Get.back();

                if (state is AuthStateSendingMailVerificationFailure) {
                  CustomDialogs().errorBox(message: state.exception.message);
                }

                if (state is AuthStateSentMailVerification) {
                  CustomDialogs().successBox(
                      message:
                          "We've sent you an email verification link to ${emailController.text}. Please verify your email by clicking the link before logging in.");
                }
              }
            }
          },
        )
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Stack(
          children: [
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
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: Container(
                      height: 80.h,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/icons/logo.png",
                                      height: 4.h,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
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
                            SizedBox(
                              height: 8.h,
                            ),
                            textWidget(
                              "Login",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            text_w(
                              "Enter your credentials to log in",
                              fontSize: 14.7.sp,
                              color: Color(0xff080422),
                              fontWeight: FontWeight.w300,
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
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(RegistrationPage());
                                  },
                                  child: text_widgetP("Create a new account",
                                      color: MyColors.primary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Get.to(ForgotPassword());
                                  },
                                  child: text_widgetP(
                                    "Forgot Password?",
                                    color: MyColors.primary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            gradientButton(
                              "Log In",
                              isLoading: isLoading,
                              font: 17,
                              txtColor: MyColors.white,
                              ontap: () {
                                triggerLoginEvent(context.read<AuthBloc>());
                              },
                              width: 90,
                              height: 6.6,
                              isColor: true,
                              clr: MyColors.primary,
                            ),
                            SizedBox(height: 3.h),
                            Image.asset("assets/icons/or.png"),
                            SizedBox(height: 3.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    triggerGoogleLogin(
                                        context.read<AuthBloc>());
                                  },
                                  child: Image.asset("assets/icons/google.png",
                                      height: 5.h),
                                ),
                                if (Platform.isIOS) SizedBox(width: 4.w),
                                if (Platform.isIOS)
                                  InkWell(
                                    onTap: () {
                                      triggerAppleLogin(
                                          context.read<AuthBloc>());
                                    },
                                    child: Image.asset("assets/icons/apple.png",
                                        height: 5.h),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 40.h,
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
