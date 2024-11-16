class EventResponse {
  String eventId;
  String creatorId;
  String batchId;
  String title;
  String organizer;
  String description;
  String location;
  String eventType;
  String date;
  String startTime;
  String endTime;

  EventResponse({
    required this.eventId,
    required this.creatorId,
    required this.batchId,
    required this.title,
    required this.organizer,
    required this.description,
    required this.location,
    required this.eventType,
    required this.date,
    required this.startTime,
    required this.endTime,
  });


  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      eventId: json['eventId'],
      creatorId: json['creatorId'],
      batchId: json['batchId'],
      title: json['title'],
      organizer: json['organizer'],
      description: json['description'],
      location: json['location'],
      eventType: json['eventType'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

}

