import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/data/student.dart';
import 'package:schedule_system/integration/response/student/student_response.dart';


/// this scree is for how added students looks like it is simply a student card
class StudentCard extends StatefulWidget {
  StudentResponse student;
  StudentCard({required this.student, Key? key}) : super(key: key);

  @override
  State<StudentCard> createState() => _StudentCardState();
}


class _StudentCardState extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10, // Increased shadow effect for depth
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
              children: [
                CircleAvatar(
                  radius: 30, // Size of the avatar
                  backgroundColor: Colors.blueAccent, // Background color of the avatar
                  child: Text(
                    widget.student.studentName[0].toUpperCase(), // First letter of the student's name
                    style: TextStyle(
                      fontSize: 24, // Font size for the letter
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color for the letter
                    ),
                  ),
                ),
                SizedBox(width: 16), // Space between avatar and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student.studentName,
                        style: TextStyle(
                          fontSize: 22, // Larger font size for the student name
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent, // Changed color for emphasis
                        ),
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                      SizedBox(height: 4), // Space between name and phone number
                      Text(
                        widget.student.phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4), // Space between phone number and email
                      Text(
                        widget.student.emailId,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
