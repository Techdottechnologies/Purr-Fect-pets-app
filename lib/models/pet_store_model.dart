class PetStoreModel {
  final String name;
  final double rating;
  final int totalNumberOfRates;
  final String status;
  final PetGeometry geometry;
  final String icon;
  final String placeId;
  List<String> photos;
  final PetStoreOpenStatus? storeOpenStatus;
  final PetStorePlusCode? plusCode;
  PetStoreModel._internal(
      {required this.status,
      required this.geometry,
      required this.icon,
      required this.placeId,
      required this.photos,
      this.storeOpenStatus,
      required this.name,
      required this.rating,
      required this.totalNumberOfRates,
      this.plusCode});

  factory PetStoreModel.fromMap(Map<String, dynamic> map) {
    return PetStoreModel._internal(
      name: map['name'] != null ? map['name'] as String : "",
      rating: map['rating'] != null
          ? map['rating'] is int
              ? (map['rating'] as int).toDouble()
              : map['rating']
          : 0,
      totalNumberOfRates:
          map["user_ratings_total"] != null ? map["user_ratings_total"] : 0,
      status: map['business_status'] != null ? map['business_status'] : "",
      geometry: PetGeometry._fromMap({
        'formatted_address': map['formatted_address'] as String? ?? "",
        'location': map['geometry']['location'],
        'vicinity': map['vicinity'] != null ? map['vicinity'] : "",
      }),
      icon: map['icon'] != null ? map['icon'] as String : "",
      placeId: map['place_id'] as String? ?? "",
      photos: map['photos'] != null ? _parsePhotos(map['photos']) : [],
      storeOpenStatus: map['opening_hours'] != null
          ? PetStoreOpenStatus._fromMap(map['opening_hours'])
          : null,
      plusCode: map['plus_code'] != null
          ? PetStorePlusCode._fromMap(map['plus_code'])
          : null,
    );
  }
  @override
  String toString() {
    return 'PetStoreModel(status: $status, geometry: $geometry, icon: $icon, placeId: $placeId, photos: $photos, storeOpenStatus: $storeOpenStatus, plusCode: $plusCode)';
  }

  static List<String> _parsePhotos(dynamic items) {
    final List<String> photos = [];
    if (items != null) {
      for (var item in items) {
        if (item['html_attributions'] != null &&
            item['html_attributions'].isNotEmpty) {
          final htmlString = item['html_attributions'][0];
          final url = _extractUrlFromHtml(htmlString);
          if (url != null) {
            photos.add(url);
          }
        }
      }
    }
    return photos;
  }

  static String? _extractUrlFromHtml(String html) {
    final regex = RegExp(r'<a href="(.*?)">');
    final match = regex.firstMatch(html);
    if (match != null && match.groupCount > 0) {
      return match.group(1);
    }
    return null;
  }
}

class PetGeometry {
  final double latitude;
  final double longitude;
  final String formatted_address;
  final String vicinity;

  PetGeometry._interal({
    required this.latitude,
    required this.longitude,
    required this.formatted_address,
    required this.vicinity,
  });

  factory PetGeometry._fromMap(Map<String, dynamic> map) {
    return PetGeometry._interal(
      latitude: map['location']['lat'] as double? ?? 0,
      longitude: map['location']['lng'] as double? ?? 0,
      formatted_address: map['formatted_address'] as String? ?? "",
      vicinity: map['vicinity'] as String? ?? "",
    );
  }

  @override
  String toString() =>
      'PetGeometry(latitude: $latitude, longitude: $longitude, formatted_address: $formatted_address)';
}

class PetStoreOpenStatus {
  final bool status;

  PetStoreOpenStatus._internal({required this.status});
  factory PetStoreOpenStatus._fromMap(Map<String, dynamic> map) {
    return PetStoreOpenStatus._internal(
        status: map['open_now'] != null ? map['open_now'] : false);
  }

  @override
  String toString() => 'PetStoreOpenStatus(status: $status)';
}

class PetStorePlusCode {
  final String compoundCode;

  PetStorePlusCode._internal({required this.compoundCode});

  factory PetStorePlusCode._fromMap(Map<String, dynamic> map) {
    return PetStorePlusCode._internal(
        compoundCode: map['compound_code'] as String? ?? "");
  }

  @override
  String toString() => 'PetStorePlusCode(compoundCode: $compoundCode)';
}
