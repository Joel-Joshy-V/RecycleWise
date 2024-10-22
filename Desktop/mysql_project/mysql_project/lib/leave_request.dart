import 'package:flutter/material.dart';

class LeaveRequest {
  final String title;
  final String reason;
  final String dateRange;
  final String duration;
  final String status; // "Approved", "Rejected", or "Pending"

  LeaveRequest({
    required this.title,
    required this.reason,
    required this.dateRange,
    required this.duration,
    required this.status,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      title: json['title'],
      reason: json['reason'],
      dateRange: json['dateRange'],
      duration: json['duration'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'reason': reason,
      'dateRange': dateRange,
      'duration': duration,
      'status': status,
    };
  }
}

class LeaveRequestPage extends StatelessWidget {
  // Assume this is fetched from an API
  final List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      title: "Medical Leave",
      reason: "Recovering from flu",
      dateRange: "May 10, 2023 - May 12, 2023",
      duration: "3 days",
      status: "Approved",
    ),
    LeaveRequest(
      title: "Personal Leave",
      reason: "Family function",
      dateRange: "June 5, 2023 - June 7, 2023",
      duration: "3 days",
      status: "Rejected",
    ),
    LeaveRequest(
      title: "Conference Leave",
      reason: "Attending AI conference",
      dateRange: "July 15, 2023 - July 18, 2023",
      duration: "4 days",
      status: "Pending",
    ),
  ];

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
            ...leaveRequests.map((request) => _buildLeaveCard(request)).toList(),
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

  Widget _buildLeaveCard(LeaveRequest request) {
    IconData statusIcon;
    Color statusColor;

    switch (request.status) {
      case "Approved":
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case "Rejected":
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        break;
      case "Pending":
        statusIcon = Icons.hourglass_bottom;
        statusColor = Colors.orange;
        break;
      default:
        statusIcon = Icons.error;
        statusColor = Colors.grey;
    }

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
                Text(request.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor),
                    const SizedBox(width: 5),
                    Text(request.status, style: TextStyle(color: statusColor)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text("Reason: ${request.reason}", style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 5),
            Text(request.dateRange, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 5),
            Text(request.duration, style: TextStyle(color: Colors.grey[600])),
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
          child: Text(progress, style: const TextStyle(fontWeight: FontWeight.bold)),
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
