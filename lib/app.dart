import 'package:floralist/screen/cart_screen.dart';
import 'package:floralist/screen/floral/floral-detail.dart';
import 'package:floralist/screen/floral/floral-list.dart';
import 'package:floralist/screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloralistApp extends StatelessWidget {
  const FloralistApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,

     title: 'Floralist',
     home: MainLayout(),
     routes: {
       '/floral/list' : (context) => const FloralList(),
       '/carts' : (context) => const CartScreen(),
       '/floral/detail': (context) => const FloralDetail()
     },
   );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    Home(onTabSelected: (index) => _onItemTapped(index)),
    FloralList(),
    // const CartScreen(),
    Center(child: Text('Favorites')),
    Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF80AB),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined),
            activeIcon: Icon(Icons.local_florist),
            label: 'Flowers',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.favorite_border),
          //   activeIcon: Icon(Icons.favorite),
          //   label: 'Favorites',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_outline),
          //   activeIcon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
        ],
      ),
    );
  }
}