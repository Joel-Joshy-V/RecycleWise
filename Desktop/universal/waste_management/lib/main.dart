import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(RecycleWiseApp());
}

class RecycleWiseApp extends StatelessWidget {
  const RecycleWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecycleWise+',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
