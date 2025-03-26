import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../models/privacy_model.dart';
import '../../blocs/privacy/privacy_bloc.dart';
import '../../blocs/privacy/privacy_event.dart';
import '../../blocs/privacy/privacy_state.dart';
import '../../utils/constants/constants.dart';

class PrivacyPolicyPage extends StatefulWidget {
  final bool isDrawer;
  const PrivacyPolicyPage({super.key, required this.isDrawer});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  List<PrivacyModel> privacies = [];
  bool isLoading = false;

  void triggerFetchAllPrivaciesEvent() {
    context.read<PrivacyBloc>().add(PrivacyEventFetch());
  }

  @override
  void initState() {
    triggerFetchAllPrivaciesEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrivacyBloc, PrivacyState>(
      listener: (context, state) {
        if (state is PrivacyStateFetchFailure ||
            state is PrivacyStateFetched ||
            state is PrivacyStateFetching) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is PrivacyStateFetched) {
            setState(() {
              privacies = state.privacies;
            });
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Remix.arrow_left_s_line,
                              color: Colors.black,
                              size: 4.h,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          textWidget(
                            "Terms & Conditions ",
                            color: Colors.black,
                            fontSize: 18.sp,
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Welcome to Purrfect Link! These Terms and Conditions govern"
                                  "your use of our pet community app, available on Android and iOS.\n"
                                  "By accessing or using Purrfect Link, you agree to comply with these Terms. \n"
                                  "\n\n"
                                  "User Eligibility\n\n"
                                  "Must be 13+ years old (under 18 requires parental permission).\n\n"
                                  "Provide accurate information and keep your account secure.\n\n"
                                  "User Responsibilities\n\n"
                                  "✅ Respect others and their pets.\n\n"
                                  "✅ Use the app for personal, non-commercial purposes.\n\n"
                                  "✅ Post accurate and lawful content.\n\n"
                                  "🚫 Do NOT:\n\n"
                                  "❌ Post harmful, offensive, or illegal content.\n\n"
                                  "❌ Harass, impersonate, or threaten others.\n\n"
                                  "❌ Upload spam, malware, or misuse location services.\n\n"
                                  "Violations may lead to suspension or ban.\n\n"
                                  "Content & Privacy\n\n"
                                  "You own your content but grant us a license to display it within the app.\n\n"
                                  "We do not sell your data.\n\n"
                                  "Location services help find nearby pet-related services (e.g., parks, vets).",
                                  style: TextStyle(fontSize: 16.0, height: 1.5),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
