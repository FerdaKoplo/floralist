import 'package:carousel_slider/carousel_slider.dart';

// import 'package:floralist/helper/convert_json.dart';
import 'package:floralist/models/Flower.dart';
import 'package:floralist/services/floral_service.dart';
import 'package:floralist/widgets/carousel.dart';
import 'package:floralist/widgets/flower_card.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final void Function(int) onTabSelected;

  const Home({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
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
            onPressed: () {
              Navigator.pushNamed(context, '/carts');
              },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.black),
            onPressed: () {
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Flower>>(
          future: FlowerService.loadFlowers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading flowers'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No flowers found'));
            }

            final flowers = snapshot.data!;
            final newest = flowers.take(4).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),

              child: Column(
                // spacing: 50,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Best Seller',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                              onTap: () => onTabSelected(1),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.pink,
                                ),
                              ),
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      FlowerCarousel(flowers: flowers),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Newest Release',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                            onTap: () => onTabSelected(1),
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.pink,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      // height: 500,
                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: newest.length,
                        itemBuilder: (context, index) {
                          return FlowerCard(flower: newest[index]);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
