import 'package:flutter/material.dart';
import 'package:schedule_system/integration/response/event/event_response.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventCardStudent extends StatelessWidget {
  EventResponse eventResponse;
  EventCardStudent({super.key, required this.eventResponse});

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6.0,
      margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event,
                  color: Colors.blueAccent,
                  size: 28.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    eventResponse.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300], height: 20.0, thickness: 1.0),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Organizer: ${eventResponse.organizer}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.orange,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    eventResponse.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Location: ${eventResponse.location}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: Colors.purple,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Type: ${eventResponse.eventType}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blueGrey,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Date: ${eventResponse.date}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.teal,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Time: ${eventResponse.startTime} - ${eventResponse.endTime}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
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