import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/event_card.dart';
import 'package:schedule_system/integration/event_api_service.dart';

import '../card/event_card_student.dart';
import '../integration/response/event/event_response.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  late Future<List<EventResponse>?> _future;

  @override
  void initState() {
    super.initState();
    _future = EventApiService().getAllUpComingEvents(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming Events"),
        backgroundColor: Colors.blueGrey,
      ),
      body:
          FutureBuilder<List<EventResponse>?>(
              future: _future, 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.red,));
                } else if(snapshot.hasError) {
                  return Center(child: Text("Error Occured : ${snapshot.error}"),);
                } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No Upcoming Event Available"),);
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return EventCardStudent(eventResponse: snapshot.data![index]
                        );
                      }
                  );
                }
              }
          ),
    );
  }
}
