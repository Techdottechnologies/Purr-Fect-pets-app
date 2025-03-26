import 'package:petcare/config/colors.dart';
import 'package:petcare/utils/constants/enum.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomCarouselFB2 extends StatefulWidget {
  const CustomCarouselFB2(
      {Key? key, required this.onSelectPet, required this.selectedPet})
      : super(key: key);
  final Function(PetType) onSelectPet;
  final PetType selectedPet;

  @override
  _CustomCarouselFB2State createState() => _CustomCarouselFB2State();
}

class _CustomCarouselFB2State extends State<CustomCarouselFB2> {
  // - - - - - - - - - - - - Instructions - - - - - - - - - - - - - -
  // 1.Replace cards list with whatever widgets you'd like.
  // 2.Change the widgetMargin attribute, to ensure good spacing on all screensize.
  // 3.If you have a problem with this widget, please contact us at flutterbricks90@gmail.com
  // Learn to build this widget at https://www.youtube.com/watch?v=dSMw1Nb0QVg!
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  final double carouselItemMargin = 16;

  late PageController _pageController;
  late int position = widget.selectedPet.index;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: .7);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            SmoothPageIndicator(
              controller: _pageController,
              count: PetType.values.length,
              axisDirection: Axis.horizontal,
              effect: ExpandingDotsEffect(
                  dotHeight: 1.h,
                  dotWidth: 1.h,
                  dotColor: Colors.grey.withOpacity(0.4),
                  activeDotColor: MyColors.primary),
            ),
          ],
        ),
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: PetType.values.length,
              onPageChanged: (int p) {
                setState(() {
                  position = p;
                });
              },
              itemBuilder: (BuildContext context, int position) {
                return imageSlider(position);
              }),
        ),
      ],
    );
  }

  Widget imageSlider(int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(
          margin: EdgeInsets.all(carouselItemMargin),
          child: Center(child: widget),
        );
      },
      child: Container(
        child: CardFb1(
          text: PetType.values[position].name,
          position: position,
          subtitle: "",
          imageUrl: PetType.values[position].icon,
          onPressed: () {
            setState(() {
              final PetType pet = PetType.values[position];
              widget.onSelectPet(pet);
            });
          },
        ),
      ),
    );
  }
}

int current = 0;

class CardFb1 extends StatefulWidget {
  final String text;
  final String imageUrl;
  final int position;

  final String subtitle;
  final Function() onPressed;

  const CardFb1(
      {required this.text,
      required this.imageUrl,
      required this.position,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  State<CardFb1> createState() => _CardFb1State();
}

class _CardFb1State extends State<CardFb1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          current = widget.position;
        });
        widget.onPressed();
      },
      child: Container(
        width: 60.w,

        // height: 230,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
        decoration: BoxDecoration(
          color: current == widget.position ? Color(0xffFEDFC3) : Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(widget.imageUrl, height: 18.h, fit: BoxFit.fill),
            const Spacer(),
            textWidget(
              widget.text,
              fontSize: 18.sp,
              color: current == widget.position ? Colors.black : Colors.black,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
