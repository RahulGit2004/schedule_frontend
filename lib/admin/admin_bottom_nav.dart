import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/admin/batch/batch_list.dart';
import 'package:schedule_system/admin/daily_schedule/batch_list_schedule.dart';
import 'package:schedule_system/admin/event/list_event.dart';
import 'package:schedule_system/admin/time_table/time_table_list.dart';

import '../integration/batch_api_service.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int currentIndex = 0;
  final List<Widget> tabs = [
    BatchList(),
    BatchListDailySchedule(),
    TimeTableList(),
    EventList(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.batch_prediction),label: "batch"),
          BottomNavigationBarItem(icon: Icon(Icons.schedule),label: "schedule"),
          BottomNavigationBarItem(icon: Icon(Icons.timer),label: "timeTable"),
          BottomNavigationBarItem(icon: Icon(Icons.event),label: "events"),
        ],
        onTap: (index) async{
          if(currentIndex == 0 ) {
            await BatchApiService().batchList(context);
            print(index);
          }
          setState(() {
            currentIndex = index;
          });

        },

      ),
    );
  }
}
