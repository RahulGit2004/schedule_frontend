import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:schedule_system/integration/api_services.dart';
import 'package:schedule_system/integration/response/time_table/time_table_response.dart';

import '../provider/login_provider.dart';

class TimeTableApiService {
  static String ngRockUrl = ApiService.renderUrl;
  final String getTimeTableUrl = "$ngRockUrl/api/v1/time_table/batchId";
  final String createTimeUrl = "$ngRockUrl/api/v1/time_table/create";
  final String updateTimeUrl = "$ngRockUrl/api/v1/time_table/update";

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<List<TimeTableResponse>?> getTimeTableByBatch(
      String batchId, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(getTimeTableUrl)
          .replace(queryParameters: {"batchId": batchId}));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        _showSnackBar(context, "Success", Colors.green);
        return data.map((e) => TimeTableResponse.fromJson(e)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['errorMessage'] ?? "Empty error message";
        _showSnackBar(context, errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      print(e.toString());
      // Show a generic error message in case of an unexpected error
      _showSnackBar(context, "An  error occurred. Please try again.",
          Colors.grey);
      return null;
    }
    return null;
  }


  Future<void> updateTimeTable(
      String className,
      String instructor,
      String location,
      String eventType,
      String startTime,
      String endTime,
      String batchId,
      BuildContext context) async {
    String formatDateTime(DateTime dateTime) {
      return dateTime.toIso8601String(); // Returns a string in ISO 8601 format
    }

    try {
      final response = await http.put(Uri.parse(updateTimeUrl),
          headers: {'content-type': 'application/json'},
          body: jsonEncode({
            "batchId": batchId,
            "eventType": eventType,
            "instructor": instructor,
            "startTime": startTime,
            "endTime": endTime,
            "updatedAt": formatDateTime(DateTime.now())
          }));
      if (response.statusCode == 200) {
        _showSnackBar(context, "Successfully Updated TimeTable", Colors.green);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['errorMessage'] ?? "Empty error message";
        _showSnackBar(context, errorMessage, Colors.grey);
      }
    } catch (e) {
      print(e.toString());
      // Show a generic error message in case of an unexpected error
      _showSnackBar(context, "An unexpected error occurred. Please try again.",
          Colors.grey);
      return null;
    }
  }


  Future<void> createTimeTable(
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
    print(loggedId);
    try {
      final response = await http.post(
        Uri.parse(createTimeUrl),
        headers: {
          'content-type': 'application/json',
        },

        body: jsonEncode({
          "batchId": batchId,
          "creatorId": loggedId,
          "date": date,
          "createScheduleReqList": [
            {
              "timetableId": "",
              "className": className,
              "instructor": instructor,
              "location": location,
              "startTime": startTime,
              "eventType": eventType,
              "duration": duration
            }
          ]

        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
       _showSnackBar(context, "Created Success", Colors.green);
      } else {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        String errorMessage = jsonData['errorMessage'] ?? "empty error message";
        _showSnackBar(context, errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      print(e.toString());
      _showSnackBar(context, "An unexpected error occurred. Please try again.",
          Colors.grey);
    }
  }



}
