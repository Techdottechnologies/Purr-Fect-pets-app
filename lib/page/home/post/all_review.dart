import 'dart:convert';

import 'package:petcare/config/colors.dart';
import 'package:petcare/models/map_review.dart';
import 'package:petcare/utils/extensions/date_extension.dart';
import 'package:petcare/widgets/avatar_widget.dart';
import 'package:petcare/widgets/txt_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/pet_store_model.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_button_2.dart';

class AllReviews extends StatefulWidget {
  const AllReviews({super.key, required this.petStore});
  final PetStoreModel petStore;
  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  late final PetStoreModel petStore = widget.petStore;
  List<MapReview> reviews = [];
  String apiKey = 'AIzaSyBpApTUmC8MKcGgy7YAiOWd0yigA7VmYOo';
  bool isLoading = false;

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${petStore.placeId}&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (data['result']['reviews'] != null) {
          reviews = (data['result']['reviews'] as List)
              .map((e) => MapReview.fromJson(e))
              .toList();
        }
      });
      print(reviews.isNotEmpty);
    } else {
      debugPrint("Fail to load.");
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchInBrowser(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri,
            mode: LaunchMode.platformDefault); // Forces browser launch
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  @override
  void initState() {
    fetchReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: gradientButton(
              "Take Review",
              font: 17,
              txtColor: MyColors.white,
              ontap: () {
                try {
                  final url =
                      'https://www.google.com/maps/place/?q=place_id:ChIJx0AgzCZDIjkR76ohmtxHpAE';
                  _launchInBrowser(url);
                } catch (e) {}
              },
              width: 90,
              height: 6.6,
              isColor: true,
              clr: MyColors.primary,
            ),
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              radius: 2.3.h,
                              backgroundColor: MyColors.primary,
                              child: Icon(
                                Remix.arrow_left_s_line,
                                color: Colors.white,
                                size: 3.h,
                              ),
                            )),
                        SizedBox(width: 5.w),
                        textWidget(
                          "Reviews",
                          fontWeight: FontWeight.w500,
                          fontSize: 19.sp,
                        ),
                      ],
                    ),
                    Expanded(
                      child: isLoading && reviews.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : reviews.isEmpty
                              ? Center(
                                  child: Text("No reviews"),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await fetchReviews();
                                  },
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                      top: 30,
                                      bottom: 100,
                                    ),
                                    itemCount: reviews.length,
                                    itemBuilder: (_, index) {
                                      final MapReview review = reviews[index];
                                      return InkWell(
                                        onTap: () {
                                          _launchURL(review.authorUrl ?? "");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      AvatarWidget(
                                                        width: 34,
                                                        height: 34,
                                                        placeholderChar: review
                                                                .authorName
                                                                ?.characters
                                                                .firstOrNull ??
                                                            ".",
                                                        avatarUrl: review
                                                                .profilePhotoUrl ??
                                                            "",
                                                      ),
                                                      SizedBox(width: 2.w),
                                                      Flexible(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: textWidget(
                                                                review.authorName ??
                                                                    "-",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                            text_w(
                                                              review.time?.dateToString(
                                                                      "dd MMM yyyy, hh:mm a") ??
                                                                  "--",
                                                              fontSize: 12.sp,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  textWidget(
                                                    review.text ?? "",
                                                    color: Color(0xff1E1E1E)
                                                        .withOpacity(0.7),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Row(
                                                    children: [
                                                      for (int i = 0;
                                                          i < review.rating;
                                                          i++)
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              MyColors.primary,
                                                        ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
