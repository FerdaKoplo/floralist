import 'package:floralist/screen/floral/floral-detail.dart';
import 'package:floralist/screen/floral/floral-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloralistApp extends StatelessWidget {
  const FloralistApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'Floralist',
     routes: {
       '/floral': (context) => const FloralList(),
       '/floral/detail': (context) => const FloralDetail()
     },
   );
  }
}