import 'package:flutter/material.dart';

import '../integration/response/schedule/daily_schedule_response.dart';

class DailyScheduleCard extends StatelessWidget {
  final DailyScheduleResponse dailySchedule;
  final Function(String) onRemoveEvent;

  const DailyScheduleCard({
    Key? key,
    required this.dailySchedule,
    required this.onRemoveEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${dailySchedule.date}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            ...dailySchedule.events.map((event) => EventCard(
              event: event,
              onRemove: onRemoveEvent, // Pass the callback to EventCard
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final ScheduleEvent event;
  final Function(String) onRemove; // Callback for removing the event

  const EventCard({
    Key? key,
    required this.event,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.className,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Instructor: ${event.instructor}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Location: ${event.location}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Start Time: ${event.startTime}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Event Type: ${event.eventType}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Duration: ${event.duration} minutes',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(),
                ElevatedButton(
                  onPressed: () {
                    onRemove(event.scheduleEntryId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}