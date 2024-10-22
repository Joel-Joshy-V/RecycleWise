import 'package:flutter/material.dart';

class EventManagementPage extends StatefulWidget {
  @override
  _EventManagementPageState createState() => _EventManagementPageState();
}

class _EventManagementPageState extends State<EventManagementPage> {
  final List<Map<String, String>> _upcomingEvents = [
    {
      'title': 'Annual Science Fair',
      'date': 'May 15, 2023',
      'time': '10:00 AM - 4:00 PM',
    },
    {
      'title': 'Guest Lecture Series',
      'date': 'May 20, 2023',
      'time': '2:00 PM - 4:00 PM',
    },
  ];

  final List<Map<String, String>> _eventHistory = [
    {
      'title': 'Spring Art Exhibition',
      'date': 'April 10, 2023',
      'time': '11:00 AM - 6:00 PM',
    },
    {
      'title': 'Career Fair 2023',
      'date': 'March 25, 2023',
      'time': '9:00 AM - 3:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A1B9A), // Vibrant purple
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddEventSection(),
            const SizedBox(height: 20),
            _buildUpcomingEventsSection(),
            const SizedBox(height: 20),
            _buildEventHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddEventSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.purple[50], // Light purple background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextField('Event Name'),
            Row(
              children: [
                Expanded(child: _buildTextField('Select Date')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField('Select Time')),
              ],
            ),
            _buildTextField('Faculty Host'),
            _buildTextField('Event Coordinators (comma-separated)'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add event logic here
              },
              child: const Text('Add Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E24AA), // Bright purple button
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Events',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._upcomingEvents.map((event) => _buildEventCard(event)).toList(),
      ],
    );
  }

  Widget _buildEventHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._eventHistory.map((event) => _buildEventCard(event, isHistory: true)).toList(),
      ],
    );
  }

  Widget _buildEventCard(Map<String, String> event, {bool isHistory = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isHistory ? Colors.red[50] : Colors.green[50], // Different background for history and upcoming
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isHistory ? Colors.red[100] : Colors.green[100],
          child: Icon(
            Icons.event,
            color: isHistory ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          event['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${event['date']} • ${event['time']}'),
        trailing: ElevatedButton(
          onPressed: () {
            // View event details logic
          },
          child: const Text('View Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A), // Same purple as the AppBar
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
