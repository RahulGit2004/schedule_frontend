import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/admin/batch/student_list.dart';

import '../integration/response/batch/batch_response.dart';
import 'data/batch.dart';


/// this screen design a batch card like how prepared batch looks like
class BatchCard extends StatefulWidget {
  final BatchResponse batch;

  BatchCard({required this.batch, Key? key}) : super(key: key);

  @override
  State<BatchCard> createState() => _BatchCardState();
}

class _BatchCardState extends State<BatchCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentList(batch: widget.batch)));
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
              SizedBox(height: 8), // Space between rows
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