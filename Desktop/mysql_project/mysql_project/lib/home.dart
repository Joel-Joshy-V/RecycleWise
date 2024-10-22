import 'package:flutter/material.dart';
import 'profile.dart';
import 'salary.dart';
import 'time_table.dart';
import 'leave_request.dart';
import 'event_management.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6A1B9A),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ),
              child: Hero(
                tag: 'profile-avatar',
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.deepPurple, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(
                    context,
                    Icons.schedule,
                    "Timetable",
                    Colors.blue,
                    TimeTablePage(),
                  ),
                  _buildIconButton(
                    context,
                    Icons.request_page,
                    "Leave Request",
                    Colors.teal,
                    LeaveRequestPage(),
                  ),
                  _buildIconButton(
                    context,
                    Icons.monetization_on,
                    "Salary",
                    Colors.orange,
                    SalaryPage(),
                  ),
                  _buildIconButton(
                    context,
                    Icons.event,
                    "Events",
                    Colors.purple,
                    EventManagementPage(),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildSectionTitle("Upcoming Classes"),
              _buildClassCard("Computer Science 101", "Room 302", "09:00 AM"),
              _buildClassCard("Advanced Mathematics", "Room 205", "11:30 AM"),
              SizedBox(height: 30),
              _buildSectionTitle("Upcoming Events"),
              _buildEventCard("Faculty Meeting", "Conference Room", "Tomorrow"),
              _buildEventCard("Science Fair", "Main Auditorium", "Next Week"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String label,
      Color color, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Column(
        children: [
          Hero(
            tag: label,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 30, color: color),
            ),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildClassCard(String title, String room, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(child: Text(title[0])),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(room),
        trailing: Text(time),
      ),
    );
  }

  Widget _buildEventCard(String title, String location, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.event),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(location),
        trailing: Text(time),
      ),
    );
  }
}
