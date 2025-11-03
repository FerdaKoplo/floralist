import 'dart:convert';
import 'package:floralist/models/Flower.dart';
import 'package:flutter/services.dart';

class FlowerService {
  static Future<List<Flower>> loadFlowers() async {
    final String response = await rootBundle.loadString('json/flowers.json');
    final data = json.decode(response);
    return (data['flowers'] as List).map((f) => Flower.fromJson(f)).toList();
  }

  static Future<List<String>> loadCategories() async {
    final flowers = await loadFlowers();
    final categories = flowers.map((f) => f.category).toSet().toList();
    categories.sort();
    return categories;
  }

  static Future<Flower?> loadFlowerById(int id) async {
    final flowers = await loadFlowers();
    try {
      return flowers.firstWhere((flower) => flower.id == id);
    } catch (e) {
      return null;
    }
  }
}
