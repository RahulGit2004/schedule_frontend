import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/integration/batch_api_service.dart';
import 'package:schedule_system/integration/response/student/student_response.dart';


/// this screen add students in a batch

class Student {
  String studentId;
  String studentName;
  String phoneNumber;
  String emailId;
  bool inBatch;

  Student({
    required this.studentId,
    required this.studentName,
    required this.phoneNumber,
    required this.emailId,
    required this.inBatch});

  static List<Student> studentList = [];

  static void addStudentsFromResponse(List<StudentAll> students) {
    studentList.clear(); // Clear the static list before adding new data
    for (var student in students) {
      studentList.add(Student(
        studentId: student.studentId,
        studentName: student.studentName,
        phoneNumber: student.phoneNumber,
        emailId: student.emailId,
        inBatch: student.inBatch,
      ));
    }
  }
}

/// this screen add students in a batch


class AssignStudent extends StatefulWidget {
  String batchId;
   AssignStudent({required this.batchId,super.key});

  @override
  State<AssignStudent> createState() => _AssignStudentState();
}
class _AssignStudentState extends State<AssignStudent> {
  Future<List<StudentAll>?>? studentResponse;
  bool isLoad = false;
  BatchApiService api = BatchApiService();
  Map<int, bool> selectedStudents = {};
  List<String> selectedStudentId =
      []; // for sent data to server which is selected.

  @override
  void initState() {
    super.initState();
    // _fetchStudentData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchStudentData();
  }

  void _fetchStudentData() {
    if (selectedStudents.containsValue(true)) {
      Student.studentList.clear();
    }
    setState(() {
      studentResponse =
          api.getAllStudents(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)
        ),
        backgroundColor: Colors.blueGrey,
        title: Text("Assign Student in Batch"),
      ),
      body: FutureBuilder<List<StudentAll>?>(
        future: studentResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red.shade400,));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No students found."));
          }

          // If we reach here, we have data
          List<StudentAll> students = snapshot.data!;
          return Column(
            children: [
              showStudentList(students), // Pass the data to the list builder
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: _buildApplyButton(),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget showStudentList(List<StudentAll> students) {
    return Expanded(
      child: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return studentTile(index, students[index].inBatch, students); // Pass the students list
        },
      ),
    );
  }

// players tile widget
  Widget studentTile(int index, bool assignStatus, List<StudentAll> students) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blueGrey.shade400,
          child: Text(
            students[index].studentName[0],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          students[index].studentName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4), // Added spacing
            Text(
              '${students[index].emailId}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${students[index].phoneNumber}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: _buildSelectButton(index, assignStatus),
      ),
    );
  }

// select button
  Widget _buildSelectButton(int index, bool assignStatus) {
    bool isSelected = selectedStudents[index] ?? false;

    Color backgroundColor = assignStatus
        ? Colors.teal.shade700
        : (isSelected ? Colors.teal.shade700 : Colors.grey);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: assignStatus
          ? null
          : () {
        setState(() {
          selectedStudents[index] = !isSelected;
        });
      },
      child: Text(assignStatus || isSelected ? 'Selected' : 'Select'),
    );
  }
// apply button
  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Center(
        child: Transform(
          transform: Matrix4.skewX(-0.2),
          child: ElevatedButton(
            child: Text(
              'Apply',
              style: TextStyle(
                fontFamily: "Netflix",
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.2,
                color: Colors.white, // Keep the text color white for contrast
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700, // Teal background color
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
              shadowColor: Colors.teal.shade900, // Darker teal shadow for consistency
            ),
            onPressed: () async {
              setState(() {
                isLoad = true;
              });
              // Store selected player IDs in selectedStudentId list
              selectedStudentId.clear();
              for (int i = 0; i < Student.studentList.length; i++) {
                if (selectedStudents[i] ?? false) {
                  selectedStudentId.add(Student.studentList[i].studentId);
                }
              }
              // This helps to call my API to add players in the team correctly...
              await api.assignStudentsInBatch(selectedStudentId, widget.batchId, context);
              if(isLoad) {
                CircularProgressIndicator(color: Colors.red,);
              }
              setState(() {
                isLoad = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
