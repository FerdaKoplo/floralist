import 'dart:convert';
import 'package:floralist/models/Cart.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class CartService {
  static Future<File> _getCartFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/cart.json');
  }

  static Future<List<CartItem>> loadCart() async {
    try {
      final file = await _getCartFile();

      if (!(await file.exists())) {
        await file.writeAsString(jsonEncode([]));
      }

      final content = await file.readAsString();
      final data = jsonDecode(content) as List;
      return data.map((e) => CartItem.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading cart: $e');
      return [];
    }
  }

  static Future<void> saveCart(List<CartItem> cart) async {
    final file = await _getCartFile();
    print('Cart file path: ${file.path}');
    await file.writeAsString(jsonEncode(cart.map((e) => e.toJson()).toList()));
  }

  static Future<void> addToCart(int flowerId) async {
    final cart = await loadCart();
    final index = cart.indexWhere((item) => item.flowerId == flowerId);

    if (index != -1) {
      cart[index] = CartItem(flowerId: flowerId, quantity: cart[index].quantity + 1);
    } else {
      cart.add(CartItem(flowerId: flowerId, quantity: 1));
    }

    await saveCart(cart);
  }

  static Future<void> removeFromCart(int flowerId) async {
    final cart = await loadCart();
    cart.removeWhere((item) => item.flowerId == flowerId);
    await saveCart(cart);
  }
}
