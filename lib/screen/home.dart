import 'package:floralist/helper/convert_json.dart';
import 'package:floralist/widgets/flower_card.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      appBar: AppBar(
        // backgroundColor: const Color(0xFFF1F8E9),
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
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Newest Release',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: FutureBuilder<List<Flower>>(
                  future: loadFlowers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading flowers'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No flowers found'));
                    }

                    final flowers = snapshot.data!;
                    final newest = flowers.take(4).toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newest.length,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      itemBuilder: (context, index) {
                        final flower = newest[index];
                        return FlowerCard(flower: flower);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
