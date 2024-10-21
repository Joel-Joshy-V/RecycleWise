import 'package:flutter/material.dart';

class LeaveRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests Status'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSectionTitle("Leave Requests Status"),
            const SizedBox(height: 10),
            _buildLeaveCard(
              "Medical Leave",
              "Recovering from flu",
              "May 10, 2023 - May 12, 2023",
              "3 days",
              Icons.check_circle,
              Colors.green,
              "Approved",
            ),
            const SizedBox(height: 10),
            _buildLeaveCard(
              "Personal Leave",
              "Family function",
              "June 5, 2023 - June 7, 2023",
              "3 days",
              Icons.cancel,
              Colors.red,
              "Rejected",
            ),
            const SizedBox(height: 10),
            _buildLeaveCard(
              "Conference Leave",
              "Attending AI conference",
              "July 15, 2023 - July 18, 2023",
              "4 days",
              Icons.hourglass_bottom,
              Colors.orange,
              "Pending",
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Leave Balance"),
            const SizedBox(height: 10),
            _buildLeaveBalance("Casual Leave", "8/12", "8 days remaining"),
            _buildLeaveBalance("Sick Leave", "5/10", "5 days remaining"),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveCard(
    String title,
    String reason,
    String dateRange,
    String duration,
    IconData statusIcon,
    Color statusColor,
    String statusText,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor),
                    const SizedBox(width: 5),
                    Text(statusText, style: TextStyle(color: statusColor)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text("Reason: $reason", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 5),
            Text(dateRange, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 5),
            Text(duration, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalance(String title, String progress, String remaining) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(progress, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(remaining),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
