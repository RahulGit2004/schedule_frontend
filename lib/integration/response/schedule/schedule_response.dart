class ScheduleResponse {
  String scheduleId;
  String batchId;
  String className;
  String instructorName;
  String location;
  String eventType;
  String status;
  String date;
  String time;

  ScheduleResponse({required this.scheduleId,
    required this.batchId,
    required this.className,
    required this.instructorName,
    required this.location,
    required this.eventType,
    required this.status,
    required this.date,
    required this.time});

  factory ScheduleResponse.fromJson(Map<String, dynamic> data) {
    // final data = jsonData['data'];
    return ScheduleResponse(
        scheduleId: data['scheduleId'] ?? "",
        batchId: data['batchId'] ?? "",
        className: data['className'] ?? "",
        instructorName: data['instructorName'] ?? "",
        location: data['location'] ?? "",
        eventType: data['eventType'] ?? "",
        status: data['status'] ?? "",
        date: data['date'] ?? "",
        time: data['time'] ?? ""
    );
  }
}
