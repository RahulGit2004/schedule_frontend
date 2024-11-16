// todo call api getAllBatch()

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/card/batch_card.dart';
import 'package:schedule_system/integration/batch_api_service.dart';
import '../../integration/response/batch/batch_response.dart';
import 'create_batch.dart';


/// this page shows list of batches
class BatchList extends StatefulWidget {
  const BatchList({super.key});

  @override
  State<BatchList> createState() => _BatchListState();
}

class _BatchListState extends State<BatchList> {
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
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBatch()));
        },
        child: Icon(Icons.add, color: Colors.black, size: 22, weight: 800),
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
                      return BatchCard(batch: snapshot.data![index]);
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
