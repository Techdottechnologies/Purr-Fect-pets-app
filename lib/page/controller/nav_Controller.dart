
import 'package:get/get.dart';
import 'package:flutter/material.dart';
class NavControllerD extends GetxController {
  NavControllerD(){
    currentIndex=0;
  }
  int currentTab = 0;
  int currentIndex = 0;
  bool isVisible = true;

  Widget currentScreen = SizedBox();
}