import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/integration/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:schedule_system/integration/response/event/event_response.dart';

import '../provider/login_provider.dart';

class EventApiService {
  static String renderUrl = ApiService.renderUrl;

  final String createEventUrl = "$renderUrl/event/create";
  final String getEventUrl = "$renderUrl/event/get/by/batch";
  final String upcomingEvents = "$renderUrl/event/all/upcoming";

  void _showSnackBar(BuildContext context, String message,
      Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<List<EventResponse>?> getEventListByBatchId(BuildContext context,
      String batchId) async {
    try {
      final response = await http.get(
          Uri.parse(getEventUrl).replace(queryParameters: {
            "batchId": batchId,
          }));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data']; // this is opening my wrapped data data
        _showSnackBar(context, "Fetched!!", Colors.green);
        return data.map((e) => EventResponse.fromJson(e)).toList();
      } else {
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['errorMessage'] ?? "Empty error message";
        _showSnackBar(context, errorMessage, Colors.red.shade400);
      }
    } catch (e) {
      _showSnackBar(context, "An unexpected error occurred. Please try again.",
          Colors.grey);
    }
  }

  Future<void> createEventApi(String batchId,
      String title,
      String organizer,
      String description,
      String location,
      String eventType,
      String startTime,
      String endTime,
      String date,
      BuildContext context,) async {
    try {
      String? loggedId = Provider
          .of<LoginProvider>(context, listen: false)
          .loginResponse
          ?.loggedId;

      // Create a map with your data
      final Map<String, dynamic> body = {
        "creatorId": loggedId,
        "batchId": batchId,
        "title": title,
        "organizer": organizer,
        "description": description,
        "location": location,
        "eventType": eventType,
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(createEventUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body), // Convert the map to a JSON string
      );

      // Check the response
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        _showSnackBar(context, "Event Successfully Created", Colors.green);
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
    }
  }


  Future<List<EventResponse>?> getAllUpComingEvents(
      BuildContext context) async {
    String? loggedId = Provider
        .of<LoginProvider>(context, listen: false)
        .loginResponse
        ?.loggedId;

    print(loggedId);
    try {
      final response = await http.get(
          Uri.parse(upcomingEvents).replace(queryParameters: {
            "studentId": loggedId
          }));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> data = jsonData['data'];
        _showSnackBar(context, "Event Updated", Colors.green);
        return data.map((e) => EventResponse.fromJson(e)).toList();

      } else {
        final data = jsonDecode(response.body);
        String error = data['errorMessage'];
        print(data);
        _showSnackBar(context, error, Colors.red.shade400);
      }
    } catch (e) {
      print(e.toString());
      _showSnackBar(
          context, "Unknown error occurs from server", Colors.grey.shade400);
    }
  }
}