import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/schedule_card.dart';
import 'package:schedule_system/integration/response/batch/batch_response.dart';
import 'package:schedule_system/integration/response/schedule/daily_schedule_response.dart';
import 'package:schedule_system/integration/schedule_api_service.dart';
import 'package:schedule_system/admin/daily_schedule/create_schedule_form.dart';

/// this screen shows list of created schedule
class ListSchedule extends StatefulWidget {
  BatchResponse batch;

   ListSchedule({super.key, required this.batch});

  @override
  State<ListSchedule> createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {

  late Future<List<DailyScheduleResponse>?> _future;
  ScheduleApiService api = ScheduleApiService();
  @override
  void initState() {
    super.initState();
    _future = api.getDailySchedules(context,widget.batch.batchId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateDailyScheduleForm(batch: widget.batch)));
        },
        child: Icon(Icons.add, color: Colors.black, size: 22),
      ),
      appBar: AppBar(
        title: Text("List Of All Schedule"),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blueGrey,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return DailyScheduleCard(
                  dailySchedule: snapshot.data![index],
                    onRemoveEvent: (String eventId) {
                      _showMyDialog(eventId);
                    }
                );
              },
            );
          }
        },
      ),
    );
  }
  /// this method helps to remove my event from Data base
  /// call here remove event by event Id;
  void removeEventFromDatabase(String eventId) {
    print("This will be remove : $eventId");
  }

  Future<void> _showMyDialog(String eventId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Approve to remove'),
          content: const SingleChildScrollView(
            child: Text('Do you want to remove This Schedule'),
          ),
          actions: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               TextButton(
                 child: const Text('No',),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
               TextButton(
                 child: const Text('Approve', style: TextStyle(color: Colors.red)),
                 onPressed: () {
                   removeEventFromDatabase(eventId);
                   Navigator.of(context).pop();
                 },
               ),
             ],
           )
          ],
        );
      },
    );
  }
// 11:04 status = 100%

}
