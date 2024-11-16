import 'dart:convert';

// import 'dart:ffi';
import 'dart:math';
import 'package:intl/intl.dart'; // Make sure to import the intl package for formatting
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/integration/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:schedule_system/integration/response/schedule/daily_schedule_response.dart';

import 'package:schedule_system/integration/response/schedule/schedule_response.dart';

import '../provider/login_provider.dart';

class ScheduleApiService {
  static String renderUrl = ApiService.renderUrl;
  final String scheduleListUrl = "$renderUrl/api/v1/daily_schedule/get/batchId";
  final String createScheduleUrl = "$renderUrl/api/v1/daily_schedule/create";
  final String dailyScheduleUrl = "$renderUrl/";


  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<List<DailyScheduleResponse>?> getDailySchedules(
      BuildContext context, String batchId) async {
    try {
      final response =
          await http.get(Uri.parse(scheduleListUrl).replace(queryParameters: {
        "batchId": batchId,
      }));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<dynamic> data = jsonData['data']; // this is opening my wrapped data data
        print(data);
        return data.map((e) => DailyScheduleResponse.fromJson(e)).toList();
      } else {
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['errorMessage'] ?? "Empty error message";
        _showSnackBar(context, errorMessage, Colors.red.shade400);
        return null;
      }
    } catch (e) {
      print(e.toString());
      _showSnackBar(context, "An unexpected error occurred. Please try again.",
          Colors.grey);
      return null; // Return null in case of an exception
    }
  }

  Future<void> createDailySchedule(
      String className,
      String batchId,
      String instructor,
      String location,
      String eventType,
      String startTime,
      String date,
      int duration,
      BuildContext context) async {
    String? loggedId = Provider.of<LoginProvider>(context, listen: false)
        .loginResponse
        ?.loggedId;

    try {
      final response = await http.post(
        Uri.parse(createScheduleUrl),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "batchId": batchId,
          "creatorId": loggedId,
          "date": date,
          "events": [
            {
              "className": className,
              "instructor": instructor,
              "location": location,
              "startTime": startTime,
              "eventType": eventType,
              "duration": duration,
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        _showSnackBar(
            context, "Successfully Created Daily Schedule", Colors.green);
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['errorMessage'] ?? "empty error message";
        print(jsonDecode(response.body));
        _showSnackBar(context, errorMessage, Colors.grey);
      }
    } catch (e) {
      print(e.toString());
      _showSnackBar(context, "An unexpected error occurred. Please try again.",
          Colors.grey);
    }
  }
}
