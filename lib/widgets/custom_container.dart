// Project: 	   balanced_workout
// File:    	   custom_container
// Path:    	   lib/screens/components/custom_container.dart
// Author:       Ali Akbar
// Date:        07-05-24 17:41:13 -- Tuesday
// Description:

import 'package:flutter/material.dart';

import 'custom_ink_well.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.color,
    this.borderRadius,
    this.padding,
    this.child,
    this.size,
    this.onPressed,
  });
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Size? size;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: onPressed,
      child: SizedBox(
        height: size?.height,
        width: size?.width,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: ColoredBox(
            color: color ?? Colors.transparent,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
