import 'package:floralist/models/Flower.dart';
import 'package:floralist/services/cart_service.dart';
import 'package:floralist/services/floral_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FloralDetail extends StatelessWidget {
  const FloralDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final flowerId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: const [
            // SizedBox(width: 2),
            Text(
              'FLORIST',
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            Icon(Icons.local_florist, color: Colors.pink, size: 25),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add to favorites logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Favorites')),
                    );
                  },
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Favorite'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100],
                    foregroundColor: Colors.pink[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await CartService.addToCart(flowerId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to Cart')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Flower?>(
          future: FlowerService.loadFlowerById(flowerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Flower not found'));
            }

            final flower = snapshot.data!;

            final List<Map<String, dynamic>> chipData = [
              {'label': flower.category, 'icon': null, 'bg': Colors.pink[100]},
              {'label': flower.origin, 'icon': Icons.location_on, 'bg': Colors.pink[50]},
              {'label': flower.fragranceLevel, 'icon': Icons.local_florist, 'bg': Colors.pink[50]},
              {'label': flower.rating.toString(), 'icon': Icons.stars, 'bg': Colors.pink[50]},
              {'label': flower.stock.toString(), 'icon': Icons.trending_up, 'bg': Colors.pink[50]},
            ];

            final rupiah = NumberFormat.currency(
              locale: 'id_ID',
              symbol: '${flower.currency} ',
              decimalDigits: 0,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 300 / 300,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                          image: NetworkImage(flower.imageUrl),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16,),
                  Text(
                    flower.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    flower.scientificName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: chipData.map((data) {
                      return Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (data['icon'] != null) ...[
                              Icon(data['icon'], size: 16, color: Colors.pink),
                              const SizedBox(width: 4),
                            ],
                            Text(data['label']),
                          ],
                        ),
                        backgroundColor: data['bg'],
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    rupiah.format(flower.price),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    flower.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  // Care Tips section
                  const Text(
                    'Care Tips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: flower.careTips
                        .map((tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 16, color: Colors.pink),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(
                                  fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
