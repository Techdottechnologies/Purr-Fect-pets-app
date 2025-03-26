import 'package:petcare/config/colors.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/txt_field.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/dialogs/dialogs.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void triggerForgotPassword(AuthBloc bloc) {
    bloc.add(
      AuthEventForgotPassword(email: emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSendingForgotEmail ||
            state is AuthStateSendForgotEmailFailure ||
            state is AuthStateSentForgotEmail) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is AuthStateSendForgotEmailFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is AuthStateSentForgotEmail) {
            CustomDialogs().successBox(
              message:
                  "We've just sent you an email containing a password reset link.\nPlease check your mail.",
              title: "Mail Sent!",
              positiveTitle: "Go back",
              onPositivePressed: () {
                Get.back();
              },
            );
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
              backgroundColor: Colors.white,
              body: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    SafeArea(
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircleAvatar(
                                  radius: 2.3.h,
                                  backgroundColor: MyColors.primary,
                                  child: Icon(
                                    Remix.arrow_left_s_line,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          Spacer(),
                          Image.asset(
                            "assets/icons/logo.png",
                            height: 4.h,
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 2.3.h,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Spacer(),
                    // Spacer(),
                    SizedBox(height: 6.h),

                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: textWidget(
                                  "Forgot Password",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              text_w(
                                  "Please check your inbox and follow the instructions to reset your password.",
                                  fontSize: 14.7.sp,
                                  textAlign: TextAlign.center,
                                  color: Color(0xff080422),
                                  fontWeight: FontWeight.w300),
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
                              SizedBox(height: 1.h),
                              // Center(
                              //     child: Image.asset(
                              //   "assets/images/oor.png",
                              //   height: 3.h,
                              // )),
                              // SizedBox(height: 1.h),
                              // textFieldWithPrefixSuffuxIconAndHintText(
                              //   "Phone",
                              //   // controller: _.password,
                              //   fillColor: Color(0xffF9F9F9),
                              //   mainTxtColor: Colors.black,
                              //   radius: 20,
                              //   bColor: Colors.transparent,
                              //   prefixIcon: "assets/icons/phone.png",
                              //   isPrefix: true,
                              // ),
                              SizedBox(height: 5.h),
                              gradientButton("Send",
                                  font: 17,
                                  txtColor: MyColors.white, ontap: () {
                                triggerForgotPassword(context.read<AuthBloc>());
                              },
                                  width: 90,
                                  height: 6.6,
                                  isColor: true,
                                  clr: MyColors.primary),
                              SizedBox(
                                height: 25.h,
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}




/*
emailController
 triggerForgotPassword(
                                        context.read<AuthBloc>());
 */