import 'package:floralist/models/Flower.dart';
import 'package:flutter/material.dart';
import 'package:floralist/helper/convert_json.dart';
import 'package:floralist/models/Cart.dart';
import 'package:floralist/services/cart_service.dart';
import 'package:floralist/services/floral_service.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Map<String, dynamic>>> _cartWithFlowerData;

  Future<List<Map<String, dynamic>>> _loadCartWithFlowers() async {
    final cartItems = await CartService.loadCart();
    final List<Flower> flowers = await FlowerService.loadFlowers();

    return cartItems.map((item) {
      final flower = flowers.firstWhere((f) => f.id == item.flowerId);
      return {'flower': flower, 'quantity': item.quantity};
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _cartWithFlowerData = _loadCartWithFlowers();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 16,
          children: const [
            Text(
              'MY CART',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            Icon(Icons.shopping_cart, color: Colors.pink, size: 25),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cartWithFlowerData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartData = snapshot.data!;
          if (cartData.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final grandTotal = cartData.fold<int>(0,
                (sum, item) => sum +
                ((item['flower'] as Flower).price * (item['quantity'] as int)),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    final flower = cartData[index]['flower'] as Flower;
                    final quantity = cartData[index]['quantity'] as int;
                    final itemTotal = flower.price * quantity;

                    return Card(
                      color: const Color(0xFFFFF8F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Image.network(
                          flower.imageUrl,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          flower.name,
                          style: const TextStyle(
                            color: Colors.black,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          '${flower.category}\n${flower.scientificName}\n'
                              '${formatCurrency.format(flower.price)} × $quantity',
                          style: const TextStyle(height: 1.6),
                        ),
                        trailing: Text(
                          formatCurrency.format(itemTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.pink,
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatCurrency.format(grandTotal),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );;
        },
      ),
    );
  }
}
