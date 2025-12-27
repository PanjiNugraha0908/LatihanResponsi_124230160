import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AmiiboApp());
}

class AmiiboApp extends StatelessWidget {
  const AmiiboApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nintendo Amiibo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}