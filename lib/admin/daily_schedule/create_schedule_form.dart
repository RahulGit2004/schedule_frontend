import 'package:flutter/material.dart';
import 'package:schedule_system/integration/response/batch/batch_response.dart';
import 'package:schedule_system/integration/schedule_api_service.dart';

/// this is for create a new daily schedule for a batch

class CreateDailyScheduleForm extends StatefulWidget {
  BatchResponse batch;

  CreateDailyScheduleForm({required this.batch, super.key});

  @override
  _CreateDailyScheduleFormState createState() =>
      _CreateDailyScheduleFormState();
}

class _CreateDailyScheduleFormState extends State<CreateDailyScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the fields
  final _classNameController = TextEditingController();
  final _instructorController = TextEditingController();
  final _locationController = TextEditingController();

  // Date and Time variables
  DateTime? _selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isLoading = false;

  // Dropdown for Event Type
  String? _eventType;
  final List<String> _eventTypes = ["Class", "Test", "Event"];

  /// helps to pick date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  /// helps to pick time
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

  /// helps to format time
  String? formatPickedDate(DateTime? pickedDate) {
    if (pickedDate != null) {
      return pickedDate.toUtc().toIso8601String(); // Convert to UTC and format
    }
    return null;
  }

  /// helps to format time {ai}
  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes'; // Format as HH:mm
  }
  /// helps to calculate duration
  int calculateDurationInSeconds(TimeOfDay startTime, TimeOfDay endTime) {
    // Get the current date
    DateTime now = DateTime.now();

    // Convert TimeOfDay to DateTime, assuming the current date
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
    DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // Calculate the difference between the two DateTime objects
    Duration duration = endDateTime.difference(startDateTime);

    // Return the duration in seconds
    return duration.inSeconds;
  }

  /// helps to submit my form and call api
  void _submitForm() async {
    String? formattedDate = formatPickedDate(_selectedDate);
   String  formattedStartTime = formatTimeOfDay(startTime!);// no need of formatted end time {no server need}
    int duration = calculateDurationInSeconds(startTime!, endTime!);

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      ScheduleApiService apiService = ScheduleApiService();
      await apiService.createDailySchedule(
          _classNameController.text,
          widget.batch.batchId,
          _instructorController.text,
          _locationController.text,
          _eventType!,
          formattedStartTime,
          formattedDate!,
          duration,
          context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Schdeule Creation"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _classNameController,
                hintText: "Class Name",
                icon: Icons.class_,
                validator: (value) => value!.isEmpty ? 'Please enter Class name' : null,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeField(context, true, startTime),
                  SizedBox(width: 10),
                  _buildTimeField(context, false, endTime),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  "Date: ${_selectedDate != null ? _selectedDate.toString().split(' ')[0] : "Select Date"}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.blueGrey),
                onTap: _pickDate,
              ),
              _buildTextField(
                controller: _instructorController,
                hintText: "Instructor",
                icon: Icons.person,
                validator: (value) => value!.isEmpty ? 'Please enter Instructor' : null,
              ),
              SizedBox(height: 16.0),
            _buildTextField(
              controller: _locationController,
              hintText: "Location",
              icon: Icons.pin_drop,
              validator: (value) => value!.isEmpty ? 'Please enter location' : null,
            ),
              SizedBox(height: 16.0),
              _buildDropdownField(),
              SizedBox(height: 30.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey, // Make the button background transparent
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 0, // Remove elevation since we have a shadow in the container
            ),
            onPressed: _submitForm,
            child: isLoading
                ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
            ],
          ),
        ),
    ));
  }

  Widget _buildTimeField(BuildContext context, bool isStartTime, TimeOfDay? time) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectTime(context, isStartTime),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: time != null ? time.format(context) : (isStartTime ? "Start Time" : "End Time"),
              prefixIcon: Icon(Icons.access_time, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _eventType,
      decoration: InputDecoration(
        labelText: 'Event Type',
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _eventTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
            type,
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _eventType = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select event type' : null,
      icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
      iconSize: 24,
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue.shade800, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.black54, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      validator: validator,
    );
  }
}





