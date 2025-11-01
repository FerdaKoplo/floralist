import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9),
      appBar:  AppBar(
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
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.black),
            onPressed: () {
            },
          ),
        ],
        centerTitle: true,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
     body: SafeArea(
         child: Column(

         )
     ),
   );
  }
}