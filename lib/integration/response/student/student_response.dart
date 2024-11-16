import 'dart:ffi';

class StudentResponse {
  String studentId;
  String studentName;
  String phoneNumber;
  String emailId;

  StudentResponse({
    required this.studentId,
    required this.studentName,
    required this.phoneNumber,
    required this.emailId,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> jsonData) {
    return StudentResponse(
      studentId: jsonData['userId'],
      studentName: jsonData['userName'],
      phoneNumber: jsonData['phoneNumber'],
      emailId: jsonData['emailId'],
    );
  }
}



class StudentAll {
  String studentId;
  String studentName;
  String phoneNumber;
  String emailId;
  bool inBatch;

  StudentAll({
    required this.studentId,
    required this.studentName,
    required this.phoneNumber,
    required this.emailId,
    required this.inBatch,
  });

  factory StudentAll.fromJson(Map<String, dynamic> jsonData) {
    // Use null-aware operators to provide default values
    return StudentAll(
      studentId: jsonData['userId'] ?? '', // Default to empty string if null
      studentName: jsonData['userName'] ?? '', // Default to empty string if null
      phoneNumber: jsonData['phoneNumber'] ?? '', // Default to empty string if null
      emailId: jsonData['emailId'] ?? '', // Default to empty string if null
      inBatch: jsonData['inBatch'] ?? false, // Default to false if null
    );
  }
}
