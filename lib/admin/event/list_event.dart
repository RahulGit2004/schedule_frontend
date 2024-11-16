import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/event_card.dart';
import 'package:schedule_system/card/time_table_card.dart';
import 'package:schedule_system/integration/event_api_service.dart';
import 'package:schedule_system/integration/response/batch/batch_response.dart';
import 'package:schedule_system/integration/response/event/event_response.dart';
import 'package:schedule_system/integration/response/time_table/time_table_response.dart';
import 'package:schedule_system/integration/time_table_api_service.dart';
import 'package:schedule_system/admin/time_table/create_timetable_form.dart';

import '../../try.dart';
import 'event_create_form.dart';

class EventList extends StatefulWidget {

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Future<List<EventResponse>?> _future;
  final EventApiService api = EventApiService();
  final BatchProvider batchProvider = BatchProvider(); /// it helps to give me all data which is stored on it

  String? selectedBatchId;

  @override
  void initState() {
    super.initState();
    _future = Future.value([]);
    _initializeBatches();
  }

  Future<void> _initializeBatches() async {
    await batchProvider.fetchBatches();
    if (batchProvider.batches.isNotEmpty) {
      selectedBatchId = batchProvider.batches.first.batchId;
      _fetchEventByBatch();
    }
  }

  void _fetchEventByBatch() {
    if (selectedBatchId != null) {
      setState(() {
        _future = api.getEventListByBatchId(context, selectedBatchId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreateForm(batchId: selectedBatchId!,)),
          );
        },
        child: Icon(Icons.add, color: Colors.black, size: 22),
      ),
      appBar: AppBar(
        title: Text("Time-Table By Batch"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          // Filter Dropdown for Batch Selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              hint: Text("Select Batch"),
              value: selectedBatchId,
              items: batchProvider.batches
                  .map((batch) => DropdownMenuItem(
                value: batch.batchId,
                child: Text(batch.batchName),
              ))
                  .toList(),
              onChanged: (batchId) {
                setState(() {
                  selectedBatchId = batchId;
                  _fetchEventByBatch();
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Filter by Batch',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<EventResponse>?>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                        eventResponse: snapshot.data![index],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
