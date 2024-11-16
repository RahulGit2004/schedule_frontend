import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:schedule_system/integration/batch_api_service.dart';

import '../../provider/login_provider.dart';


/// here admin can create a new batch
class CreateBatch extends StatefulWidget {
  const CreateBatch({super.key});

  @override
  State<CreateBatch> createState() => _CreateBatchState();
}

class _CreateBatchState extends State<CreateBatch> {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  bool _isLoading = false;
  final batchNameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? username = Provider
        .of<LoginProvider>(context, listen: false)
        .loginResponse
        ?.loggedUserName;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Create Batch",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildReadOnlyField(username),
              SizedBox(height: 20),
              _buildInputField(
                controller: batchNameController,
                hintText: "Batch Name",
                icon: Icons.batch_prediction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your batch name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildInputField(
                controller: descriptionController,
                hintText: "Description",
                icon: Icons.description,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Center(
                child: _isLoading ? CircularProgressIndicator() :
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true; // Set loading state
                    });
                    await BatchApiService().createBatch(
                        batchNameController.text, descriptionController.text,formattedDate, context);
                    setState(() {
                      _isLoading = false; // Reset loading state
                    });
                    BatchApiService(); // for update my data on prev list
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Submit ($formattedDate)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String? username) {
    return TextFormField(
      enabled: false,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: username ?? "Username",
        prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      validator: validator,
    );
  }
}
