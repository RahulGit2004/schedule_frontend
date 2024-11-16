class Schedule {
  String scheduleId;

  String batchId;
  String creatorId;
  String className;
  String instructorName;
  String location;
  String eventType; // Replace String with EventType enum
  String status;
  DateTime date;
  DateTime time;

  Schedule({required this.scheduleId,
    required this.batchId,
    required this.creatorId,
    required this.className,
    required this.instructorName,
    required this.location,
    required this.eventType,
    required this.status,
    required this.date,
    required this.time});
  factory

  Schedule.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Schedule(
        scheduleId: data['scheduleId'],
        batchId: data['batchId'],
        creatorId: data['creatorId'],
        className: data['className'],
        instructorName: data['instructorName'],
        location: data['location'],
        eventType: data['eventType'],
        status: data['status'],
        date: data['date'],
        time: data['time']
    );
  }
}
