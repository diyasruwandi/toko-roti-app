import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Toko Roti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0C4A3E),
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Crust & Co.'))),
    );
  }
}
