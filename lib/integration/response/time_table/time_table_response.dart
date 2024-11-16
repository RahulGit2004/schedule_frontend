import 'dart:ffi';

class TimeTableResponse {
  String timeTableId;
  String batchId;
  String creatorId;
  String date;
  List<ScheduleEntry> scheduleEntries;

  TimeTableResponse({
    required this.timeTableId,
    required this.batchId,
    required this.creatorId,
    required this.date,
    required this.scheduleEntries,
  });

  factory TimeTableResponse.fromJson(Map<String, dynamic> jsonData) {
    var scheduleEntriesList = jsonData['scheduleEntries'] as List;
    List<ScheduleEntry> scheduleEntries = scheduleEntriesList
        .map((item) => ScheduleEntry.fromJson(item))
        .toList();

    return TimeTableResponse(
      timeTableId: jsonData['timeTableId'],
      creatorId: jsonData['creatorId'],
      batchId: jsonData['batchId'],
      date: jsonData['date'],
      scheduleEntries: scheduleEntries,
    );
  }
}

class ScheduleEntry {
  String scheduleEntryId;
  String className;
  String instructor;
  String location;
  String startTime;
  String eventType;
  int duration;

  ScheduleEntry({
    required this.scheduleEntryId,
    required this.className,
    required this.instructor,
    required this.location,
    required this.startTime,
    required this.eventType,
    required this.duration,
  });

  factory ScheduleEntry.fromJson(Map<String, dynamic> jsonData) {
    return ScheduleEntry(
      scheduleEntryId: jsonData['scheduleEntryId'],
      className: jsonData['className'],
      instructor: jsonData['instructor'],
      location: jsonData['location'],
      startTime: jsonData['startTime'],
      eventType: jsonData['eventType'],
      duration: jsonData['duration'],
    );
  }
}
