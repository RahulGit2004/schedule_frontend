
import 'package:schedule_system/integration/api_services.dart';
import 'package:schedule_system/integration/response/batch/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class BatchResponse {
  String batchId;
  String batchName;
  String creatorName;
  bool isActive;
  DateTime createdDate;

  BatchResponse({
    required this.batchId,
    required this.batchName,
    required this.creatorName,
    required this.createdDate,
    required this.isActive,
  });

  factory BatchResponse.fromJson(Map<String, dynamic> json) {
    return BatchResponse(
      batchId: json["batchId"] ?? "",
      batchName: json["batchName"] ?? "",
      creatorName: json["creatorName"] ?? "",
      createdDate: DateTime.tryParse(json["createdDate"] ?? "") ?? DateTime.now(),
      isActive: json["activeBatch"] ?? false
    );
  }
}



class BatchProvider with ChangeNotifier {
  static String ngRockUrl = ApiService.renderUrl;
  final String url = "$ngRockUrl/api/v1/batch/all/list";

  List<BatchResponse> _batches = [];
  bool _isLoading = false;

  List<BatchResponse> get batches => _batches;
  bool get isLoading => _isLoading;

  // Function to fetch batches and store additional data
  Future<void> fetchBatches() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        _batches = jsonList.map((json) => BatchResponse.fromJson(json)).toList();
      } else {
        // Handle error
        throw Exception('Failed to load batches');
      }
    } catch (error) {
      // Handle error
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}


