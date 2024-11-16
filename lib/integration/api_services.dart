import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_system/integration/response/user/LoginResponse.dart';
import 'package:provider/provider.dart';
import '../admin/admin_bottom_nav.dart';
import '../provider/login_provider.dart';
import '../student/student_bottom.dart';


class ApiService {
  // todo make student in batch card beautiful and if u have time make api call for remove student from batch
  static final renderUrl =
      "https://schedule-timetable-events-viewer-system.onrender.com";
  final String loginUrl = "$renderUrl/api/v1/user/singIn";
  final String getUserUrl = "$renderUrl/";

  final signUpUrl = "$renderUrl/api/v1/user/signup";

  Future<void> signUp(String username, String password, String phone,
      String userRole, String emailId, BuildContext context) async {
    try{
      final response = await http.post(Uri.parse(signUpUrl), headers: {
        'Content-Type': 'application/json'
      },
          body: jsonEncode({
          "userName" : username,
            "password" : password,
            "phoneNumber" : phone,
            "emailId" : emailId,
            "userRole" : userRole
          })
      );
      if(response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("SignUp Success, Please Login"),
            backgroundColor: Colors.green,
          ),
        );
      } else{
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['errorMessage'] ??
            "empty error message";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.grey,
          ),
        );
      }

    } catch (e) {
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error erorr2. Please try again."),
          backgroundColor: Colors.grey,
        ),
      );
    }

  }

  Future<LoginResponse?> login(
      String phoneNumber, String password, BuildContext context) async {
    try {
      final uri = Uri.parse(loginUrl).replace(queryParameters: {
        "phoneNumber": phoneNumber,
        "password": password,
      });

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonData);
        String? role = loginResponse.loggedRole;
        if (role.toLowerCase() == "student") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentBottom()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBottomNav()));
        }
        Provider.of<LoginProvider>(context, listen: false)
            .updateLoginResponse(loginResponse);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Login successful! Welcome, ${loginResponse.loggedUserName}"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle error response
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['errorMessage'] ??
            "empty error message";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred. Please try again."),
          backgroundColor: Colors.grey,
        ),
      );
    }

    return null;
  }




}
