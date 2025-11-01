import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Flower {
  final int id;
  final String name;
  final String scientificName;
  final String category;
  final int price;
  final String currency;
  final int stock;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> colors;
  final String origin;
  final String fragranceLevel;
  final List<String> careTips;

  Flower({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.price,
    required this.currency,
    required this.stock,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.colors,
    required this.origin,
    required this.fragranceLevel,
    required this.careTips,
  });

  factory Flower.fromJson(Map<String, dynamic> json) {
    return Flower(
      id: json['id'],
      name: json['name'],
      scientificName: json['scientific_name'],
      category: json['category'],
      price: json['price'],
      currency: json['currency'],
      stock: json['stock'],
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['image_url'],
      description: json['description'],
      colors: List<String>.from(json['colors']),
      origin: json['origin'],
      fragranceLevel: json['fragrance_level'],
      careTips: List<String>.from(json['care_tips']),
    );
  }
}

Future<List<Flower>> loadFlowers() async {
  final String response = await rootBundle.loadString('flowers.json');
  final data = json.decode(response);
  return (data['flowers'] as List).map((f) => Flower.fromJson(f)).toList();
}
