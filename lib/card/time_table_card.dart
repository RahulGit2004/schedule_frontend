import 'package:flutter/material.dart';
import 'package:schedule_system/integration/response/time_table/time_table_response.dart';


class TimeTableCard extends StatelessWidget {
  final TimeTableResponse tableResponse;

  const TimeTableCard({required this.tableResponse, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class: ${tableResponse.scheduleEntries.isNotEmpty ? tableResponse.scheduleEntries[0].location : 'N/A'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Creator Name: ${tableResponse.scheduleEntries.isNotEmpty ? tableResponse.scheduleEntries[0].instructor : 'N/A'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Date: ${tableResponse.date}', // Displaying only the date part
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Schedule Entries:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            ...tableResponse.scheduleEntries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.className} - ${entry.startTime}', // Displaying class name and start time
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              );
            }).toList(),
            SizedBox(height: 8),
            /// no need of this one if this card shows enough info...
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoreInfoPage(tableResponse: tableResponse),
                  ),
                );
              },
              style:  ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('More Info'),
            ),
          ],
        ),
      ),
    );
  }
}
class MoreInfoPage extends StatelessWidget {
  final TimeTableResponse tableResponse;

  const MoreInfoPage({required this.tableResponse, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.blueGrey,
        title: Text('More Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myHeader('Batch ID: ${tableResponse.timeTableId}'),
              myHeader('Creator ID: ${tableResponse.creatorId}'),
              myHeader('Date: ${tableResponse.date}'),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Schedule Entries:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
              SizedBox(height: 8),
              ...tableResponse.scheduleEntries.map((entry) {
                return entries(entry);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent[800]),
      ),
    );
  }
  Widget entries(ScheduleEntry entry) {
    return Card(
      margin: const EdgeInsets.only(top: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class: ${entry.className}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Instructor: ${entry.instructor}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('Location: ${entry.location}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('Start Time: ${entry.startTime}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('Duration: ${entry.duration} minutes', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}