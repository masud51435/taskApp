import 'dart:convert';

class PostModel {
  final String departureAirport;
  final String arrivalAirport;
  final String airline;
  final String travelClass;
  final String message;
  final String travelDate;
  final double rating;
  final List<String> images;
  final String? timestamp;

  PostModel({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.airline,
    required this.travelClass,
    required this.message,
    required this.travelDate,
    required this.rating,
    required this.images,
    this.timestamp,
  });

  /// Convert PostModel to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'airline': airline,
      'class': travelClass,
      'message': message,
      'travelDate': travelDate,
      'rating': rating,
      'images': images,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Create PostModel from Firestore Map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      departureAirport: json['departureAirport'],
      arrivalAirport: json['arrivalAirport'],
      airline: json['airline'],
      travelClass: json['class'],
      message: json['message'],
      travelDate: json['travelDate'],
      timestamp: json['timestamp'],
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }

  /// Optional: Convert to JSON string
  String toRawJson() => json.encode(toJson());

  /// Optional: Convert from JSON string
  factory PostModel.fromRawJson(String str) =>
      PostModel.fromJson(json.decode(str));
}
