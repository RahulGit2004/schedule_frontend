import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:schedule_system/integration/api_services.dart';
import 'package:schedule_system/integration/time_table_api_service.dart';

/// this screen is use to create a time table and make api call accordingly

class CreateTimetableForm extends StatefulWidget {
  String batchId;

  CreateTimetableForm({super.key, required this.batchId});

  @override
  State<CreateTimetableForm> createState() => _CreateTimetableFormState();
}

class _CreateTimetableFormState extends State<CreateTimetableForm> {
  final _formKey = GlobalKey<FormState>();

  final classController = TextEditingController();
  final instructorController = TextEditingController();
  final locationController = TextEditingController();

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedEventType;
  bool isLoading = false;
  bool load = false;
  List<String> eventTypes = ['Class', 'Test', 'Event'];
  DateTime? _selectedDate;

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes'; // Format as HH:mm
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  int? getDuration() {
    if (startTime != null && endTime != null) {
      // Convert TimeOfDay to DateTime using the current date
      DateTime startDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        startTime!.hour,
        startTime!.minute,
      );

      DateTime endDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        endTime!.hour,
        endTime!.minute,
      );

      // Calculate the duration
      Duration duration = endDateTime.difference(startDateTime);

      // Return the duration in milliseconds as a long (int in Dart)
      return duration.inSeconds; // or use inSeconds or inMinutes as needed
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time-table Creation"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 25,
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: classController,
                      decoration: InputDecoration(
                        hintText: "Class Name",
                        prefixIcon: Icon(Icons.class_),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter Class Name' : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: instructorController,
                      decoration: InputDecoration(
                        hintText: "Instructor",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter Instructor Name'
                          : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: "Location",
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter Location' : null,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedEventType,
                      items: eventTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEventType = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Event Type",
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select Event Type' : null,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectTime(context, true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: startTime != null
                                      ? startTime!.format(context)
                                      : "Start Time",
                                  prefixIcon: Icon(Icons.access_time),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectTime(context, false),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: endTime != null
                                      ? endTime!.format(context)
                                      : "End Time",
                                  prefixIcon: Icon(Icons.access_time),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          // AbsorbPointer is used to prevent direct text input
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _selectedDate != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!)
                                  : "Select Date",
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          String startTimeFormatted = formatTimeOfDay(startTime!);
                          String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                          int? duration = getDuration();

                          await TimeTableApiService().createTimeTable(
                              classController.text,
                              widget.batchId,
                              instructorController.text,
                              locationController.text,
                              selectedEventType!,
                              startTimeFormatted,
                              formattedDate,
                              duration!,
                              context);

                          setState(() {
                            isLoading = false;
                          });
                          //   Navigator.pop(context);
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Create Timetable",
                              style: TextStyle(fontSize: 18),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
