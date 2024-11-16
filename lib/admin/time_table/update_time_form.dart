import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_system/integration/api_services.dart';
import 'package:schedule_system/integration/time_table_api_service.dart';

class BatchResponse2 {
  final String batchId;
  final String batchName;

  BatchResponse2({required this.batchId, required this.batchName});

  factory BatchResponse2.fromJson(Map<String, dynamic> json) {
    return BatchResponse2(
      batchId: json['batchId'],
      batchName: json['batchName'],
    );
  }
}

class UpdateTimetableForm extends StatefulWidget {
  const UpdateTimetableForm({super.key});

  @override
  State<UpdateTimetableForm> createState() => _UpdateTimetableFormState();
}

class _UpdateTimetableFormState extends State<UpdateTimetableForm> {
  final _formKey = GlobalKey<FormState>();

  final classController = TextEditingController();
  final instructorController = TextEditingController();
  final locationController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedEventType;
  BatchResponse2? selectedBatch;
  bool isLoading = false;
  bool load = false;
  static String ngRockUrl = ApiService.renderUrl;

  List<String> eventTypes = ['Class', 'Test', 'Event'];
  List<BatchResponse2> batchList = [];

  final String batchListUrl = '$ngRockUrl/api/v1/batch/all/list';

  @override
  void initState() {
    super.initState();
    fetchBatches();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes'; // Format as HH:mm
  }

  Future<void> fetchBatches() async {
    setState(() {
      load = true;
    });
    final batches = await fetchBatchListFromServer(context);

    if (batches != null) {
      setState(() {
        load = false;
        batchList = batches;
      });
    }
  }

  Future<List<BatchResponse2>?> fetchBatchListFromServer(
      BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(batchListUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          return jsonData.map((e) => BatchResponse2.fromJson(e)).toList();
        } else {
          _showSnackBar(context, "Unexpected data format", Colors.red);
          return null;
        }
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['errorMessage'] ??
            "Empty error message";
        _showSnackBar(context, errorMessage, Colors.grey);
        return null;
      }
    } catch (e) {
      print(e.toString());
      _showSnackBar(context, "An unexpected error occurred. Please try again.",
          Colors.grey);
      return null;
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time-table Updation"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 25,),
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
                      value!.isEmpty
                          ? 'Please enter Class Name'
                          : null,
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
                      validator: (value) =>
                      value!.isEmpty
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
                      value!.isEmpty
                          ? 'Please enter Location'
                          : null,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedEventType,
                      items: eventTypes
                          .map((type) =>
                          DropdownMenuItem(
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
                      value == null
                          ? 'Please select Event Type'
                          : null,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<BatchResponse2>(
                      value: selectedBatch,
                      items: batchList
                          .map((batch) =>
                          DropdownMenuItem(
                            value: batch,
                            child: Text(batch.batchName),
                          ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBatch = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Select Batch",
                        prefixIcon: Icon(Icons.group),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      validator: (value) =>
                      value == null
                          ? 'Please select a Batch'
                          : null,
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
                                  hintText: startTime != null ? startTime!
                                      .format(context) : "Start Time",
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
                                  hintText: endTime != null ? endTime!.format(
                                      context) : "End Time",
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
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          String startTimeFormatted = formatTimeOfDay(startTime!);
                          String endTimeFormatted = formatTimeOfDay(endTime!);

                          await TimeTableApiService().updateTimeTable(
                              classController.text,
                              instructorController.text,
                              locationController.text,
                              selectedEventType!,
                              startTimeFormatted,
                              endTimeFormatted,
                              selectedBatch!.batchId,
                              context);
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: isLoading ? CircularProgressIndicator() : Text(
                        "Create Timetable", style: TextStyle(fontSize: 18),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
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