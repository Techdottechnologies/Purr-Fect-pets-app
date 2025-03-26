import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WheelPage extends StatefulWidget {
  WheelPage(
      {Key? key,
      required this.title,
      this.currentWeight,
      required this.onWeightChanged})
      : super(key: key);
  final double? currentWeight;
  final Function(double) onWeightChanged;
  final String title;

  @override
  _WheelPageState createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  final double min = 0;
  final double max = 20;
  late String selectedValue = widget.currentWeight?.toString() ?? "0.0";
  @override
  void initState() {
    super.initState();
  }

  double itemWidth = 60.0;
  int itemCount = 100;
  int selected = 50;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: AnimatedWeightPicker(
            squeeze: 2,
            dialHeight: 6.h,
            dialThickness: 3,
            division: 1,
            dialColor: Colors.black.withOpacity(0.6),
            subIntervalColor: Colors.black,
            suffixTextColor: Colors.black,
            selectedValueColor: Colors.transparent,
            subIntervalAt: 5,
            subIntervalHeight: 3.h,
            suffix: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                textWidget(selectedValue, fontSize: 24.sp),
                textWidget(
                  'lbs',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
            min: min,
            max: max,
            onChange: (newValue) {
              setState(() {
                selectedValue = newValue;
              });
              widget.onWeightChanged(double.parse(newValue));
            },
          ),
        ),
        SizedBox(height: 1.h),
        textWidget(
          "Weight",
          fontSize: 16.sp,
        ),
        //  Spacer(),
      ],
    );
  }
}
