import 'dart:async';
import 'dart:convert';
import 'package:petcare/config/colors.dart';
import 'package:petcare/models/pet_store_model.dart';
import 'package:petcare/page/home/post/all_review.dart';
import 'package:petcare/utils/constants/constants.dart';
import 'package:petcare/widgets/custom_button_2.dart';
import 'package:petcare/widgets/custom_network_image.dart';
import 'package:petcare/widgets/txt_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:ui' as ui;

import 'package:responsive_sizer/responsive_sizer.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  LatLng _initialPosition = LatLng(33.6844, 73.0479);
  String _mapStyle = '';
  List<dynamic> _searchResults = [];
  dynamic selectedPlace;
  bool isShowListView = false;
  final FocusNode searchFN = FocusNode();
  bool isInSearch = false;
  // ignore: unused_field
  Position? _currentPosition;

  @override
  void dispose() {
    searchFN.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    _loadMapStyle();
    searchFN.addListener(
      () {
        debugPrint(searchFN.hasFocus.toString());
        setState(() {
          isShowListView = searchFN.hasFocus;
        });
      },
    );
    // _fetchNearbyPetServices(_initialPosition);
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  String getPhotoUrl(String photoReference) {
    String apiKey = 'AIzaSyBpApTUmC8MKcGgy7YAiOWd0yigA7VmYOo';

    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey";
  }

  void _addMarker(dynamic place) {
    _markers.add(
      Marker(
        onTap: () {
          PetStoreModel store =
              PetStoreModel.fromMap(place as Map<String, dynamic>? ?? {});
          debugPrint(place.toString());
          List photos = (place!['photos'] as List?)
                  ?.map((photo) => getPhotoUrl(photo['photo_reference']))
                  .toList() ??
              [];
          store.photos = photos as List<String>;
          showDialog(
            context: context,
            useSafeArea: false,
            barrierColor: Colors.transparent,
            builder: (context) => MapPop(store: store),
          );
        },
        markerId: MarkerId(place['place_id']),
        position: LatLng(place['geometry']['location']['lat'],
            place['geometry']['location']['lng']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
  }

  Future<void> _fetchNearbyPetServices(LatLng location) async {
    String apiKey = 'AIzaSyBpApTUmC8MKcGgy7YAiOWd0yigA7VmYOo';
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=1500&type=pet_store&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> places = json['results'];
      setState(() {
        places.forEach(
          (place) async {
            _addMarker(place);
          },
        );
      });
    } else {
      throw Exception('Failed to load nearby pet services');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _onSearch() async {
    if (isInSearch) {
      return;
    }
    String searchQuery = _searchController.text;
    if (searchQuery.isEmpty) {
      setState(() {
        _searchResults = [];
      });
    }
    setState(() {
      isInSearch = true;
    });
    String apiKey = 'AIzaSyBpApTUmC8MKcGgy7YAiOWd0yigA7VmYOo';
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchQuery&location=${_initialPosition.latitude},${_initialPosition.longitude}&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    setState(() {
      isInSearch = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> places = json['results'];
      setState(() {
        _searchResults = places;
        selectedPlace = null;
      });
    } else {
      setState(() {
        isInSearch = false;
      });
      debugPrint('Failed to load search results');
    }
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show user a dialog
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("LocationPermission.denied");
        // Permissions are denied, handle the scenario.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("LocationPermission.deniedForever");

      // Permissions are denied forever, handle appropriately.
      return;
    }

    Position? position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _markers.add(
      Marker(
        markerId: MarkerId('current'),
        position: LatLng(position.latitude, position.longitude),
      ),
    );
    // Move camera to current position
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      ),
    ));
  }

  void _onPlaceSelected(dynamic place) async {
    setState(() {
      selectedPlace = place;
      _addMarker(place);
    });

    _controller?.animateCamera(CameraUpdate.newLatLng(
      LatLng(place['geometry']['location']['lat'],
          place['geometry']['location']['lng']),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (searchFN.hasFocus) {
          searchFN.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            /// Map
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              bottom: 0,
              child: GoogleMap(
                onTap: (argument) {
                  if (searchFN.hasFocus) {
                    searchFN.unfocus();
                  }
                },
                onMapCreated: _onMapCreated,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                    () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                style: _mapStyle,
                onCameraMove: (position) {
                  _fetchNearbyPetServices(position.target);
                },
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.0,
                ),
                markers: _markers,
              ),
            ),

            /// Top Nav
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    color: MyColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                "Find nearby pet services",
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Search Widget
            Positioned(
              left: 30,
              right: 30,
              top: 120,
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    focusNode: searchFN,
                    onChanged: (text) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        _onSearch();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      fillColor: Color(0xffF9F9F9),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: isInSearch
                          ? SizedBox(
                              height: 10,
                              width: 10,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _onSearch,
                            ),
                    ),
                  ),
                  if (_searchResults.isNotEmpty && isShowListView)
                    Container(
                      constraints: BoxConstraints(maxHeight: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final place = _searchResults[index];
                          return ListTile(
                            title: Text(
                              place['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              place['formatted_address'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              _searchController.text =
                                  "${place['name']}: ${place['formatted_address']}";
                              _onPlaceSelected(place);
                              if (searchFN.hasFocus) {
                                searchFN.unfocus();
                              }
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPop extends StatefulWidget {
  const MapPop({super.key, required this.store});
  final PetStoreModel store;

  @override
  State<MapPop> createState() => _MapPopState();
}

class _MapPopState extends State<MapPop> {
  String apiKey = 'AIzaSyBpApTUmC8MKcGgy7YAiOWd0yigA7VmYOo';

  @override
  Widget build(BuildContext context) {
    print('Store:');
    print(widget.store);
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 90.w,
            // height: 45.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            // color: Color(0xfff9f8f6),

            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 1.4.h),
                  CustomNetworkImage(
                    imageUrl: widget.store.photos.firstOrNull ?? "",
                    height: 25.h,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: textWidget(
                          widget.store.name,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(AllReviews(petStore: widget.store));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            gapW4,
                            textWidget(
                              "${widget.store.rating} (${widget.store.totalNumberOfRates})",
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_rounded,
                        size: 24,
                        color: MyColors.primary,
                      ),
                      gapW4,
                      Flexible(
                        child: textWidget(
                          widget.store.geometry.formatted_address == ""
                              ? widget.store.geometry.vicinity
                              : widget.store.geometry.formatted_address,
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // textWidget(
                  //   "Description",
                  // ),
                  // text_w(
                  //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
                  //     fontSize: 13.sp),
                  // SizedBox(height: 2.h),
                  gradientButton(
                    "View All Reviews",
                    font: 17,
                    txtColor: MyColors.white,
                    ontap: () {
                      Navigator.pop(context);
                      Get.to(AllReviews(petStore: widget.store));
                    },
                    width: 90,
                    height: 6.6,
                    isColor: true,
                    clr: MyColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  radius: 2.h,
                  backgroundColor: MyColors.primary,
                )),
          ))
        ],
      ),
    );
  }
}
