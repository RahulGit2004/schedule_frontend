import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/integration/schedule_api_service.dart';
import 'package:schedule_system/admin/daily_schedule/batch_list_schedule.dart';
import 'package:schedule_system/admin/time_table/time_table_list.dart';
import '../integration/response/batch/batch_response.dart';
import '../admin/daily_schedule/list_schedule.dart';


/// this screen shows a batch card like how list of batches looks like simply design of batch card
class BatchCardSchedule extends StatefulWidget {
  final BatchResponse batch;

  BatchCardSchedule({required this.batch, Key? key}) : super(key: key);

  @override
  State<BatchCardSchedule> createState() => _BatchCardScheduleState();
}

class _BatchCardScheduleState extends State<BatchCardSchedule> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListSchedule(batch: widget.batch,)));
      },
      child: Card(
        elevation: 8, // Increased shadow effect for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // More rounded corners
        ),
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjusted margin
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Increased padding for a spacious feel
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.batch.batchName,
                      style: TextStyle(
                        fontSize: 20, // Larger font size for the batch name
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent, // Changed color for emphasis
                      ),
                      overflow: TextOverflow.ellipsis, // Handle overflow
                    ),
                  ),
                  SizedBox(width: 10), // Space between batch name and creator name
                  Text(
                    widget.batch.creatorName,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12), // Increased space between rows
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600]), // Calendar icon
                  SizedBox(width: 4), // Space between icon and text
                  Text(
                    'Created on: ${widget.batch.createdDate.toLocal().toString().split(' ')[0]}', // Format date
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle, color: widget.batch.isActive ? Colors.green : Colors.red), // Status icon
                  SizedBox(width: 4), // Space between icon and text
                  Text(
                    'Status: ${widget.batch.isActive ? 'Active' : 'Inactive'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.batch.isActive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}