import 'package:flutter/material.dart';
import 'package:mysql_project/time_table.dart';
import 'leave_request.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                  Icons.schedule,
                  "Timetable",
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimeTablePage()),
                    );
                  },
                ),
                _buildIconButton(
                  Icons.request_page,
                  "Leave Request",
                  Colors.teal,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaveRequestPage()),
                    );
                  },
                ),
                _buildIconButton(
                  Icons.monetization_on,
                  "Salary",
                  Colors.orange,
                  () {},
                ),
                _buildIconButton(
                  Icons.event,
                  "Events",
                  Colors.purple,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Upcoming Classes Section
            const Text(
              'Upcoming Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildClassCard("Computer Science 101", "Room 302", "09:00 AM"),
            _buildClassCard("Advanced Mathematics", "Room 205", "11:30 AM"),

            const SizedBox(height: 30),

            // Upcoming Events Section
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildEventCard(
              "Faculty Meeting",
              "Conference Room",
              "Tomorrow",
            ),
            _buildEventCard(
              "Science Fair",
              "Main Auditorium",
              "Next Week",
            ),
          ],
        ),
      ),
    );
  }

  // Widget for icon buttons
  Widget _buildIconButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Widget for class cards
  Widget _buildClassCard(String title, String room, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(title[0]),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(room),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  // Widget for event cards
  Widget _buildEventCard(String title, String location, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Icon(Icons.event, color: Colors.purple),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(location),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
