import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Daily Schedules"),
      ),
      body: Container(


      ),
    );
  }
}
