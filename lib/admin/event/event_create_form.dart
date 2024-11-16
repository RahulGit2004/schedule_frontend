import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_system/integration/event_api_service.dart';

class EventCreateForm extends StatefulWidget {
  String batchId;

  EventCreateForm({super.key, required this.batchId});

  @override
  _EventCreateFormState createState() => _EventCreateFormState();
}

class _EventCreateFormState extends State<EventCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController organizerController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController eventTypeController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TimeOfDay? startTime = TimeOfDay.now();
  TimeOfDay? endTime;

  bool isLoad = false;

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextFormField(
                  controller: titleController,
                  label: 'Event Title',
                  icon: Icons.title,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: organizerController,
                  label: 'Organizer',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: locationController,
                  label: 'Location',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: eventTypeController,
                  label: 'Event Type',
                  icon: Icons.event,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(context),
                const SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(context, true), // Start Time
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(context, false), // End Time
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 5,
                      backgroundColor: Colors.blueGrey,
                      // Background color
                      foregroundColor: Colors.white,
                      // Text color
                      textStyle: const TextStyle(
                        fontSize: 18, // Increase font size
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(
                            selectedDate);
                        String startTimeFormatted = formatTimeOfDay(startTime!);
                        String endTimeFormatted = formatTimeOfDay(endTime!);

                        setState(() {
                          isLoad =true;
                        });
                        EventApiService api = EventApiService();
                        await api.createEventApi(
                            widget.batchId,
                            titleController.text,
                            organizerController.text,
                            descriptionController.text,
                            locationController.text,
                            eventTypeController.text,
                            startTimeFormatted,
                            endTimeFormatted,
                            formattedDate,
                            context);
                        setState(() {
                          isLoad = false;
                        });

                        Navigator.pop(context);
                      }
                    },
                    child: isLoad ? CircularProgressIndicator(color: Colors.white,) : Text('Create Event')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hintText,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 16.0, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w600),
          hintText: hintText ?? 'Enter your $label here',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          helperText: helperText,
          helperStyle: TextStyle(color: Colors.blueGrey),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 20.0, horizontal: 16.0),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
                color: Colors.blueAccent.shade100, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          ),
          errorStyle: TextStyle(
              color: Colors.redAccent, fontWeight: FontWeight.bold),
          suffixIcon: maxLines > 1
              ? Icon(Icons.message, color: Colors.blueAccent.shade100)
              : null,
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
        ),
        child: Text(
          DateFormat('yyyy-MM-dd').format(selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isStartTime) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: isStartTime
              ? (startTime ?? TimeOfDay.now())
              : (endTime ?? TimeOfDay.now()),
        );
        if (pickedTime != null) {
          setState(() {
            if (isStartTime) {
              startTime = pickedTime;
            } else {
              endTime = pickedTime;
            }
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: isStartTime ? 'Start Time' : 'End Time',
        ),
        child: Text(
          isStartTime
              ? startTime?.format(context) ?? 'Select Start Time'
              : endTime?.format(context) ?? 'Select End Time',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}