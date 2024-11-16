class DailyScheduleResponse {
  String dailyScheduleId;
  String date;
  List<ScheduleEvent> events;

  DailyScheduleResponse({
    required this.dailyScheduleId,
    required this.date,
    required this.events,
  });

  factory DailyScheduleResponse.fromJson(Map<String, dynamic> json) {
    return DailyScheduleResponse(
      dailyScheduleId: json['dailyScheduleId'] ?? 'Unknown ID', // Provide a default value
      date: json['date'] ?? 'Unknown Date', // Provide a default value
      events: (json['events'] as List<dynamic>? ?? []).map((event) => ScheduleEvent.fromJson(event)).toList(),
    );
  }
}

class ScheduleEvent {
  final String scheduleEntryId;
  final String className;
  final String instructor;
  final String location;
  final String startTime;
  final String eventType;
  final int duration;
  final String date;

  ScheduleEvent({
    required this.scheduleEntryId,
    required this.className,
    required this.instructor,
    required this.location,
    required this.startTime,
    required this.eventType,
    required this.duration,
    required this.date,
  });

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) {
    return ScheduleEvent(
      scheduleEntryId: json['scheduleEntryId'] ?? 'Unknown Id', // Provide a default value
      className: json['className'] ?? 'Unknown Class', // Provide a default value
      instructor: json['instructor'] ?? 'Unknown Instructor', // Provide a default value
      location: json['location'] ?? 'Unknown Location', // Provide a default value
      startTime: json['startTime'] ?? 'Unknown Start Time', // Provide a default value
      eventType: json['eventType'] ?? 'Unknown Event Type', // Provide a default value
      duration: json['duration'] ?? 0, // Provide a default value
      date: json['date'] ?? 'Unknown Date', // Provide a default value
    );
  }
}