import 'package:flutter/material.dart';
import 'package:mysql_project/time_table.dart';
import 'leave_request.dart';
import 'event_management.dart';
import 'profile.dart'; // Import profile page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A1B9A), // Dark purple color for the AppBar
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.deepPurple, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // White background
        child: SingleChildScrollView(
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
                    Colors.blue.shade600,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimeTablePage()),
                      );
                    },
                  ),
                  _buildIconButton(
                    Icons.request_page,
                    "Leave Request",
                    Colors.teal.shade600,
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
                    Colors.orange.shade600,
                    () {},
                  ),
                  _buildIconButton(
                    Icons.event,
                    "Events",
                    Colors.purple.shade600,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventManagementPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Upcoming Classes Section
              const Text(
                'Upcoming Classes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              _buildClassCard("Computer Science 101", "Room 302", "09:00 AM"),
              _buildClassCard("Advanced Mathematics", "Room 205", "11:30 AM"),

              const SizedBox(height: 30),

              // Upcoming Events Section
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for class cards
  Widget _buildClassCard(String title, String room, String time) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple[100],
          child: Text(title[0], style: const TextStyle(color: Colors.deepPurple)),
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
      color: Colors.white.withOpacity(0.9),
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
