class Event {
  String eventId;
  String batchId;
  String eventName;
  String eventOrganizer;
  String eventDescription;
  String location;
  String status;
  bool isActive;
  DateTime eventDate;
  DateTime eventStartTime;
  DateTime eventEndTime;

  Event(
      {required this.eventId,
      required this.batchId,
      required this.eventName,
      required this.eventOrganizer,
      required this.eventDescription,
      required this.location,
      required this.status,
      required this.isActive,
      required this.eventDate,
      required this.eventStartTime,
      required this.eventEndTime});

  factory Event.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Event(
        eventId: data['eventId'],
        batchId: data['batchId'],
        eventName: data['eventName'],
        eventOrganizer: data['eventOrganizer'],
        eventDescription: data['eventDescription'],
        location: data['location'],
        status: data['status'],
        isActive: data['isActive'],
        eventDate: data['eventDate'],
        eventStartTime: data['eventStartTime'],
        eventEndTime: data['eventEndTime']);
  }
}
