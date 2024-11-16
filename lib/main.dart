import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/home/splash_screen.dart';
import 'package:schedule_system/provider/login_provider.dart';
import 'package:provider/provider.dart';

import 'integration/response/batch/batch_response.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BatchProvider()),
        // Add this line
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Schedule System",
      home: SplashScreen(),
    );
  }
}
