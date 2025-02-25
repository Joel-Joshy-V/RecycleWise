import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProductTile({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green, size: 40),
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
    );
  }
}
