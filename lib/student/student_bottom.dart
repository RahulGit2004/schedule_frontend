import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/student/app_size.dart';
import 'package:schedule_system/student/student_home_page.dart';
import 'package:schedule_system/student/upcoming_events.dart';

import 'bottom_nav_button.dart';

class StudentBottom extends StatefulWidget {
  const StudentBottom({super.key});

  @override
  State<StudentBottom> createState() => _StudentBottomState();
}

class _StudentBottomState extends State<StudentBottom> {
  int currentIndex = 0;
  final List<Widget> tabs = [
    StudentHomePage(),
    UpcomingEvents(),
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.schedule), label: "schedules"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upcoming), label: "upcoming"),
            ],
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            }));

    // Widget build(BuildContext context) {
    //   AppSize().initSizes(context);
    //   return Scaffold(
    //
    //     body: SafeArea(
    //       bottom: false,
    //         child: Stack(
    //           children: [
    //             Positioned(
    //               bottom: 0,
    //                 right: 0,
    //                 left: 0,
    //
    //                 child: _buildCustomBottomNav()
    //             )
    //
    //           ],
    //         ),
    //     ),
    //   );
    // }
  }

  /// skipping it for now will do later
  Widget _buildCustomBottomNav() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSize.blockSizeHorizontal * 4.5,
        0,
        AppSize.blockSizeHorizontal * 4.5,
        50,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        elevation: 3,
        child: Container(
          width: AppSize.screenWidth,
          height: AppSize.blockSizeHorizontal * 18,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              BottomNavButton(
                iconData: Icons.home,
              )
            ],
          ),
        ),
      ),
    );
  }
}
