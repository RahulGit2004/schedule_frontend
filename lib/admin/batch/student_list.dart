import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/student_card.dart';
import 'package:schedule_system/integration/batch_api_service.dart';
import 'package:schedule_system/integration/response/student/student_response.dart';
import 'package:schedule_system/admin/batch/assign_student.dart';

import '../../integration/response/batch/batch_response.dart';




/// this screen shows list of students
class StudentList extends StatefulWidget {
  BatchResponse batch;

  StudentList({super.key, required this.batch});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late Future<List<StudentResponse>?>? _future;

  @override
  void initState() {
    super.initState();
    _future = BatchApiService().studentListByBatch(context, widget.batch.batchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Text("Students In Batch"),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () async{
         await Navigator.push(context, MaterialPageRoute(builder: (context) => AssignStudent(batchId: widget.batch.batchId)));

        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  student: snapshot.data![index],
                );
              },
            );
          }
        },
      ),
    );
  }
}
