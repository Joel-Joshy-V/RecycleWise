import 'package:flutter/material.dart';

class SalaryPage extends StatefulWidget {
  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  final int allowedLeavesPerYear = 12; // Allowed leaves per year
  final double baseSalary = 50000; // Base salary
  final double deductionPerLeave = 1000; // Deduction for each excess leave

  int leavesTaken = 15; // Example: Total leaves taken
  double finalSalary = 0.0; // Final salary after deductions

  @override
  void initState() {
    super.initState();
    calculateSalary(); // Calculate the salary on initialization
  }

  // Method to calculate final salary based on leaves taken
  void calculateSalary() {
    int excessLeaves = (leavesTaken > allowedLeavesPerYear) ? leavesTaken - allowedLeavesPerYear : 0;
    finalSalary = baseSalary - (excessLeaves * deductionPerLeave);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Deduction'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSalaryCard(),
            const SizedBox(height: 20),
            _buildFinalSalaryCard(),
            const SizedBox(height: 20),
            // Add a button to simulate a call to a backend for updating leaves taken
            ElevatedButton(
              onPressed: () {
                // Example action: Simulate an API call to update leaves taken
                setState(() {
                  leavesTaken = 20; // Update leaves taken
                  calculateSalary(); // Recalculate salary
                });
              },
              child: const Text('Update Leaves Taken'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the salary details card
  Widget _buildSalaryCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Salary Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Base Salary:', '₹${baseSalary.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            _buildDetailRow('Leaves Taken:', '$leavesTaken'),
            const SizedBox(height: 10),
            _buildDetailRow('Allowed Leaves:', '$allowedLeavesPerYear'),
            const SizedBox(height: 10),
            _buildDetailRow(
              'Salary Deduction:',
              '₹${(leavesTaken > allowedLeavesPerYear) ? (leavesTaken - allowedLeavesPerYear) * deductionPerLeave : 0}',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the final salary card
  Widget _buildFinalSalaryCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Final Salary',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '₹${finalSalary.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: (leavesTaken > allowedLeavesPerYear) ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            if (leavesTaken > allowedLeavesPerYear)
              Text(
                'You have exceeded the allowed leaves!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )
            else
              Text(
                'You are within the allowed leave limit.',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to create detail rows
  Widget _buildDetailRow(String label, String value, {Color color = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
