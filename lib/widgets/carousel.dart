import 'package:carousel_slider/carousel_slider.dart';
import 'package:floralist/helper/convert_json.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlowerCarousel extends StatelessWidget {
  final List<Flower> flowers;

  const FlowerCarousel({super.key, required this.flowers});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return CarouselSlider.builder(
      itemCount: flowers.length,
      itemBuilder: (context, index, realIndex) {
        final flower = flowers[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/floral/detail',
              arguments: flower.id,
            );
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Opacity(
                  opacity: 0.4,
                  child: Image.network(
                    flower.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.pink.withOpacity(0.10),
                      Colors.pink.withOpacity(0.50),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 20,
                bottom: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flower.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      flower.scientificName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatCurrency.format(flower.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 250,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.85,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
