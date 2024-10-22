import 'package:flutter/material.dart';

class ClassInfo {
  final String subject;
  final String room;
  final String time;

  ClassInfo({required this.subject, required this.room, required this.time});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      subject: json['subject'],
      room: json['room'],
      time: json['time'],
    );
  }
}

class Timetable {
  final String day;
  final List<ClassInfo> classes;

  Timetable({required this.day, required this.classes});
}

class TimeTablePage extends StatelessWidget {
  final Map<String, List<ClassInfo>> timetable = {
    'Monday': [
      ClassInfo(subject: 'Mathematics', room: 'Room 101', time: '09:00 AM'),
      ClassInfo(subject: 'Physics', room: 'Room 203', time: '11:00 AM'),
    ],
    'Tuesday': [
      ClassInfo(subject: 'Computer Science', room: 'Room 302', time: '10:00 AM'),
      ClassInfo(subject: 'English', room: 'Room 205', time: '01:00 PM'),
    ],
    // Add remaining days...
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
          List<ClassInfo> classes = timetable[day]!;

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
                            classInfo.subject[0],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(classInfo.subject,
                            style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            'Room: ${classInfo.room} \nTime: ${classInfo.time}'),
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
