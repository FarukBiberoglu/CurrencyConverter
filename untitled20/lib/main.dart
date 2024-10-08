import 'package:flutter/material.dart';
import 'package:untitled20/home_screen.dart';

void main (){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
