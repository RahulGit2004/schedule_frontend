import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/time_table_card.dart';
import 'package:schedule_system/integration/response/batch/batch_response.dart';
import 'package:schedule_system/integration/response/time_table/time_table_response.dart';
import 'package:schedule_system/integration/time_table_api_service.dart';
import 'package:schedule_system/admin/time_table/create_timetable_form.dart';

class TimeTableList extends StatefulWidget {

  @override
  State<TimeTableList> createState() => _TimeTableListState();
}

class _TimeTableListState extends State<TimeTableList> {
  late Future<List<TimeTableResponse>?> _future;
  final TimeTableApiService api = TimeTableApiService();
  final BatchProvider batchProvider = BatchProvider(); // Batch provider for fetching batches

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
      _fetchTimeTable();
    }
  }

  void _fetchTimeTable() {
    if (selectedBatchId != null) {
      setState(() {
        _future = api.getTimeTableByBatch(selectedBatchId!, context);
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
            MaterialPageRoute(builder: (context) => CreateTimetableForm(batchId: selectedBatchId!,)),
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
                  _fetchTimeTable(); // Fetch timetable data for selected batch
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Filter by Batch',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TimeTableResponse>?>(
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
                      return TimeTableCard(
                        tableResponse: snapshot.data![index],
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
