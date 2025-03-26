import 'dart:async';
import 'package:petcare/page/auth/welcome_page.dart';
import 'package:petcare/page/home/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void triggerSplashEvent(AuthBloc bloc) {
    bloc.add(AuthEventSplashAction());
  }

  @override
  void initState() {
    triggerSplashEvent(context.read<AuthBloc>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSplashActionDone) {
          Future.delayed(const Duration(seconds: 3), () {
            Get.offAll(const HomeDrawer());
          });
        }

        if (state is AuthStateLoginRequired) {
          Future.delayed(const Duration(seconds: 3), () {
            Get.off(const WelcomePage());
          });
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/spp.png",
              fit: BoxFit.cover,
              height: Get.height,
              width: Get.width,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Image.asset(
                "assets/icons/logo_new.png",
                fit: BoxFit.cover,
                height: 50.h,
                width: 70.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
