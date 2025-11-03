import 'package:floralist/models/Flower.dart';
import 'package:floralist/services/floral_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FloralDetail extends StatelessWidget {
  const FloralDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final flowerId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
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
                    children: [
                      Chip(
                        label: Text(flower.category),
                        backgroundColor: Colors.pink[100],
                        labelStyle: const TextStyle(color: Colors.pink),
                      ),
                      Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.pink),
                            const SizedBox(width: 4),
                            Text(flower.origin),
                          ],
                        ),
                        backgroundColor: Colors.pink[50],
                      ),
                      Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_florist, size: 16, color: Colors.pink),
                            const SizedBox(width: 4),
                            Text(flower.fragranceLevel),
                          ],
                        ),
                        backgroundColor: Colors.pink[50],
                      ),
                    ],
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
                              style: const TextStyle(fontSize: 16),
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
