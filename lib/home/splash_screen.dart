import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/home/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Schedule System",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
              ),
              Text("Make Schedules and view changes",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white60
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
