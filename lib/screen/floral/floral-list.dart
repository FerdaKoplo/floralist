import 'package:floralist/models/Flower.dart';
import 'package:floralist/services/floral_service.dart';
import 'package:flutter/material.dart';
import 'package:floralist/widgets/flower_card.dart';

class FloralList extends StatefulWidget {
  const FloralList({super.key});

  @override
  State<FloralList> createState() => _FloralListState();
}

class _FloralListState extends State<FloralList> {
  late Future<List<Flower>> _flowersFuture;
  List<Flower> allFlowers = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _flowersFuture = FlowerService.loadFlowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      body: SafeArea(
        child: FutureBuilder<List<Flower>>(
          future: _flowersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading flowers'));
            }

            allFlowers = snapshot.data!;
            final categories = ['All', ...{
              for (var f in allFlowers) f.category
            }];

            final displayed = selectedCategory == 'All'
                ? allFlowers
                : allFlowers
                .where((f) => f.category == selectedCategory)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: const [
                      Text(
                        'FLORIST',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.local_florist, color: Colors.pink, size: 25),
                    ],
                  ),
                ),

                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChoiceChip(
                          avatar: Icon(
                            Icons.local_florist_outlined,
                            color: isSelected ? Colors.white : Colors.pinkAccent,
                            size: 18,
                          ),
                          showCheckmark: false,
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: Colors.pinkAccent,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                          onSelected: (_) {
                            setState(() => selectedCategory = category);
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: displayed.length,
                    itemBuilder: (context, index) {
                      return FlowerCard(flower: displayed[index]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
