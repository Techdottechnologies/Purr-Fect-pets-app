class MapReview {
  final String? authorName;
  final String? authorUrl;
  final String? language;
  final String? originalLanguage;
  final String? profilePhotoUrl;
  final int rating;
  final String? relativeTimeDescription;
  final String? text;
  final DateTime? time;
  final bool? translated;

  MapReview({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    required this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });

  factory MapReview.fromJson(Map<String, dynamic> json) {
    return MapReview(
      authorName: json['author_name'],
      authorUrl: json['author_url'],
      language: json['language'],
      originalLanguage: json['original_language'],
      profilePhotoUrl: json['profile_photo_url'],
      rating: json['rating'] != null ? json['rating'] : 0,
      relativeTimeDescription: json['relative_time_description'],
      text: json['text'],
      time: json['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000)
          : null,
      translated: json['translated'],
    );
  }
}
