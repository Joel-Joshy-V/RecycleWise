import 'package:flutter/material.dart';

class EventManagementPage extends StatefulWidget {
  @override
  _EventManagementPageState createState() => _EventManagementPageState();
}

class _EventManagementPageState extends State<EventManagementPage> {
  // Controllers for handling user input
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _facultyHostController = TextEditingController();
  final TextEditingController _coordinatorsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();  // Key for form validation

  // Lists to hold event data dynamically
  List<Map<String, String>> _upcomingEvents = [];
  List<Map<String, String>> _eventHistory = [];

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _eventNameController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    _facultyHostController.dispose();
    _coordinatorsController.dispose();
    super.dispose();
  }

  // Add event function
  void _addEvent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _upcomingEvents.add({
          'title': _eventNameController.text,
          'date': _eventDateController.text,
          'time': _eventTimeController.text,
          'host': _facultyHostController.text,
          'coordinators': _coordinatorsController.text,
        });
      });

      // Clear the fields after adding the event
      _eventNameController.clear();
      _eventDateController.clear();
      _eventTimeController.clear();
      _facultyHostController.clear();
      _coordinatorsController.clear();
    }
  }

  // Select date from date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _eventDateController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  // Select time from time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _eventTimeController.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6A1B9A),
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

  // Add event form section
  Widget _buildAddEventSection() {
    return Form(
      key: _formKey,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.purple[50],
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
              _buildTextField('Event Name', _eventNameController),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildTextField('Select Date', _eventDateController),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: _buildTextField('Select Time', _eventTimeController),
                      ),
                    ),
                  ),
                ],
              ),
              _buildTextField('Faculty Host', _facultyHostController),
              _buildTextField('Event Coordinators (comma-separated)', _coordinatorsController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addEvent,
                child: const Text('Add Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E24AA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field widget
  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hint';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Upcoming events section
  Widget _buildUpcomingEventsSection() {
    return _buildEventList(_upcomingEvents, false);
  }

  // Event history section
  Widget _buildEventHistorySection() {
    return _buildEventList(_eventHistory, true);
  }

  // Reusable event list builder
  Widget _buildEventList(List<Map<String, String>> events, bool isHistory) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index], isHistory: isHistory);
      },
    );
  }

  // Event card widget
  Widget _buildEventCard(Map<String, String> event, {bool isHistory = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isHistory ? Colors.red[50] : Colors.green[50],
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
          onPressed: () {},
          child: const Text('View Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
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
