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
  List<Flower> allFlowers = [];
  List<Flower> displayedFlowers = [];
  // biar searchnya gak tabrakan jadi set ke default value dulu hihi
  String selectedCategory = 'All';
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadFlowers();
  }

  Future<void> _loadFlowers() async {
    final flowers = await FlowerService.loadFlowers();
    setState(() {
      allFlowers = flowers;
      displayedFlowers = flowers;
    });
  }

  void _filterFlowers() {
    List<Flower> filtered = allFlowers;

    // Filter by category
    if (selectedCategory != 'All') {
      filtered = filtered.where((f) => f.category == selectedCategory).toList();
    }

    // Filter by search query
    if (query.isNotEmpty) {
      filtered = filtered
          .where((f) =>
      f.name.toLowerCase().contains(query.toLowerCase()) ||
          f.category.toLowerCase().contains(query.toLowerCase()) ||
          f.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() => displayedFlowers = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      body: SafeArea(
        child: allFlowers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
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
                itemCount: ['All', ...{for (var f in allFlowers) f.category}].length,
                itemBuilder: (context, index) {
                  final categories = ['All', ...{for (var f in allFlowers) f.category}];
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
                        setState(() {
                          selectedCategory = category;
                        });
                        _filterFlowers();
                      },
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search flowers...',
                  prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  query = value;
                  _filterFlowers();
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
                itemCount: displayedFlowers.length,
                itemBuilder: (context, index) {
                  return FlowerCard(flower: displayedFlowers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
