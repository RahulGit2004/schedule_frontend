class TimeTable {
  String timetableId;
  String batchId;
  String eventType; // event type may  test , extra session or events
  String instructor;
  DateTime date;
  DateTime startTime;
  DateTime endTime;

  TimeTable({required this.timetableId,
    required this.batchId,
    required this.eventType,
    required this.instructor,
    required this.date,
    required this.startTime,
    required this.endTime});

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return TimeTable(
        timetableId: data['timetableId'],
        batchId: data['batchId'],
        eventType: data['eventType'],
        instructor: data['instructor'],
        date: data['date'],
        startTime: data['startTime'],
        endTime: data['endTime']);
  }
}
