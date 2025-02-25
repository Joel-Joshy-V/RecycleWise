import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Example wallet information. Replace with dynamic data later.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.account_balance_wallet, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Wallet Balance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$120.50',
              style: TextStyle(fontSize: 32, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
