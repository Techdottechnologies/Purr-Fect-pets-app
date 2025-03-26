// Project: 	   balanced_workout
// File:    	   circle_button
// Path:    	   lib/screens/components/circle_button.dart
// Author:       Ali Akbar
// Date:        06-05-24 13:47:28 -- Monday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.backgroundColor,
      this.colorFilter,
      this.iconSize});
  final VoidCallback onPressed;
  final String icon;
  final Color? backgroundColor;
  final ColorFilter? colorFilter;
  final Size? iconSize;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        icon,
        colorFilter: colorFilter,
        width: iconSize?.width,
        height: iconSize?.height,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
            backgroundColor ?? const Color.fromARGB(255, 150, 48, 166)),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
