import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/product_tile.dart';

class DashboardScreen extends StatelessWidget {
  // Sample data. In a production app, fetch from backend.
  final int totalPoints = 1500;
  final double carbonCredits = 12.5;
  final int itemsScanned = 250;

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            'Dashboard',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          StatCard(title: 'Total Points', value: totalPoints.toString(), color: Colors.green),
          SizedBox(height: 20),
          StatCard(title: 'Carbon Credits Earned', value: carbonCredits.toString(), color: Colors.blue),
          SizedBox(height: 20),
          StatCard(title: 'Items Scanned', value: itemsScanned.toString(), color: Colors.orange),
          SizedBox(height: 40),
          Text(
            'Recommended Eco-Friendly Products',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ProductTile(icon: Icons.eco, title: 'Reusable Water Bottle', subtitle: '10% discount available'),
          ProductTile(icon: Icons.eco, title: 'Eco-Friendly Tote Bag', subtitle: '15% discount available'),
          // Add more dynamic product recommendations as needed.
        ],
      ),
    );
  }
}
