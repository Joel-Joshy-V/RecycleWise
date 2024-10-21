import 'package:flutter/material.dart';

class TimeTablePage extends StatelessWidget {
  final Map<String, List<Map<String, String>>> timetable = {
    'Monday': [
      {'subject': 'Mathematics', 'room': 'Room 101', 'time': '09:00 AM'},
      {'subject': 'Physics', 'room': 'Room 203', 'time': '11:00 AM'},
    ],
    'Tuesday': [
      {'subject': 'Computer Science', 'room': 'Room 302', 'time': '10:00 AM'},
      {'subject': 'English', 'room': 'Room 205', 'time': '01:00 PM'},
    ],
    'Wednesday': [
      {'subject': 'History', 'room': 'Room 104', 'time': '09:30 AM'},
      {'subject': 'Chemistry', 'room': 'Room 206', 'time': '02:00 PM'},
    ],
    'Thursday': [
      {'subject': 'Mathematics', 'room': 'Room 101', 'time': '09:00 AM'},
      {'subject': 'Economics', 'room': 'Room 304', 'time': '12:30 PM'},
    ],
    'Friday': [
      {'subject': 'Physics', 'room': 'Room 203', 'time': '10:30 AM'},
      {'subject': 'Computer Science', 'room': 'Room 302', 'time': '01:30 PM'},
    ],
    'Saturday': [
      {'subject': 'Biology', 'room': 'Room 107', 'time': '08:00 AM'},
      {'subject': 'Physical Education', 'room': 'Gym', 'time': '11:00 AM'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Timetable'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: timetable.keys.length,
        itemBuilder: (context, index) {
          String day = timetable.keys.elementAt(index);
          List<Map<String, String>> classes = timetable[day]!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ExpansionTile(
                title: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: classes
                    .map(
                      (classInfo) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            classInfo['subject']![0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(classInfo['subject']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            'Room: ${classInfo['room']} \nTime: ${classInfo['time']}'),
                        isThreeLine: true,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
