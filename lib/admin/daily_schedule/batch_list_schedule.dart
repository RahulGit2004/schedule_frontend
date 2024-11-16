// todo call api getAllBatch()

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/batch_card_schedule.dart';
import 'package:schedule_system/integration/batch_api_service.dart';

import '../../integration/response/batch/batch_response.dart';

/// this pages shows list of batches for schedule screen
class BatchListDailySchedule extends StatefulWidget {
  const BatchListDailySchedule({super.key});

  @override
  State<BatchListDailySchedule> createState() => _BatchListDailyScheduleState();
}

class _BatchListDailyScheduleState extends State<BatchListDailySchedule> {
  late Future<List<BatchResponse>?> futureBatches;

  @override
  void initState() {
    super.initState();
    futureBatches = BatchApiService().batchList(context); // Initialize the Future
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("All Batches"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: FutureBuilder<List<BatchResponse>?>(
              future: futureBatches, // Use the future here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return BatchCardSchedule(batch: snapshot.data![index]);
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
