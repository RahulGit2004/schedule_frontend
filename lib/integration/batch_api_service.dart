import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_system/card/data/student.dart';
import 'package:schedule_system/integration/api_services.dart';
import 'package:schedule_system/integration/response/batch/batch_response.dart';
import 'package:schedule_system/integration/response/student/student_response.dart';
import 'package:schedule_system/admin/batch/assign_student.dart';

import '../provider/login_provider.dart';



class BatchApiService {
  static String ngRockUrl = ApiService.renderUrl;
  final String batchListUrl = "$ngRockUrl/api/v1/batch/all/list";
  final String createBatchUrl = "$ngRockUrl/api/v1/batch/create";
  final String studentsInBatch = "$ngRockUrl/api/v1/batch/all/students/batchId";
  final String assignStudentsUrl = "$ngRockUrl/api/v1/batch/assign/students";
  final String allStudents = "$ngRockUrl/api/v1/user/all/students";


  Future<List<BatchResponse>?> batchList(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(batchListUrl));

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final jsonData = jsonDecode(responseBody);
        if (jsonData is List) {
          return jsonData.map((e) => BatchResponse.fromJson(e)).toList();
        } else {
          _showSnackBar(context, "Unexpected data format", Colors.red);
          return null;
        }
      } else {
        // Handle HTTP errors
        final errorData = response.body; // Use response.body directly
        String errorMessage = "Error: ${response.statusCode} - ${errorData}";
        _showSnackBar(context, errorMessage, Colors.grey);
        return null;
      }
    } catch (e) {
      print(e.toString());
      // Show a generic error message in case of an unexpected error
      _showSnackBar(context, "An unexpected error occurred. Please try again.", Colors.grey);
      return null;
    }
  }
// Helper method to show SnackBar
  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> createBatch(String batchName, String description, String date,
      BuildContext context) async {
    try {
      String? loggedId = Provider.of<LoginProvider>(context, listen: false)
          .loginResponse
          ?.loggedId;

      String? loggedUsername =
          Provider.of<LoginProvider>(context, listen: false)
              .loginResponse
              ?.loggedUserName;
      final response = await http.post(Uri.parse(createBatchUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "batchName": batchName,
            "creatorId": loggedId,
            "creatorName": loggedUsername,
            "batchDescription": description,
            "createdDate": date
          }));
      if (response.statusCode == 200) {
        _showSnackBar(context, "Batch Created Success", Colors.green);
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        return;
      } else {
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['errorMessage'] ?? "empty error message";
        _showSnackBar(context, errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      print(e.toString());
     _showSnackBar(context, "An unexpected error occurred. Please try again", Colors.red.shade400);
    }
  }

  Future<List<StudentResponse>?> studentListByBatch(
      BuildContext context, String batchId) async {
    try {
      final uri = Uri.parse(studentsInBatch).replace(queryParameters: {
        "batchId": batchId,
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Access the 'data' key to get the list of students
        final List<dynamic> studentsJson = jsonData['data'];

        // Map the list of student JSON objects to StudentResponse objects
        return studentsJson
            .map((studentJson) => StudentResponse.fromJson(studentJson))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['errorMessage'] ??
            "empty error message";
      _showSnackBar(context, errorMessage, Colors.red.shade400);
        return null;
      }
    } catch (e) {
      print(e.toString());
     _showSnackBar(context, "An unexpected error occurred. Please try again", Colors.red.shade400);
      return null;
    }
  }

  Future<List<StudentAll>?> getAllStudents(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(allStudents));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final students = jsonData.map((e) => StudentAll.fromJson(e)).toList();
        Student.addStudentsFromResponse(students);
        _showSnackBar(context, "Students Fetched", Colors.green);
        return students;
            } else {
        final data = jsonDecode(response.body);
        String errorMessage = data['errorMessage'] ?? 'Empty Message';
        _showSnackBar(context, errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      print(e.toString());
    _showSnackBar(context, "Un expected error Form Server", Colors.red.shade400);
      return null;
    }
  }

  Future<void> assignStudentsInBatch(List<String> studentId, String batchId, BuildContext context) async {
    try {
      String? loggedId = Provider.of<LoginProvider>(context, listen: false).loginResponse?.loggedId;
      print(loggedId);
      print(batchId);

      final response = await http.put(
        Uri.parse(assignStudentsUrl),
        headers: {
          "content-type": "application/json"
        },
        body: jsonEncode({
          "studentId": studentId,
          "creatorId": loggedId,
          "batchId": batchId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['data'] == true) { // Adjust this according to your API's response structure
          _showSnackBar(context, "Student Assigned!!", Colors.green);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          String errorMessage = jsonData['errorMessage'] ?? "empty error message";
         _showSnackBar(context, errorMessage, Colors.red.shade400);
        }
      }  /// this is for when error is not 200
      else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['errorMessage'] ?? "empty error message";
       _showSnackBar(context, errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      print(e.toString());
      // Show a generic error message in case of an unexpected error
      _showSnackBar(context, "An unexpected error occurred. Please try again", Colors.red.shade400);
    }
  }}
