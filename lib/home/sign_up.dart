import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:schedule_system/home/sign_in.dart';

import '../integration/api_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

final List<String> items = ["Student", "Admin"];

class _SignUpState extends State<SignUp> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = items.first;

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
        }, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.grey,
        title: Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myTextFormField(
                      controller: usernameController,
                      hintText: "username",
                      icon: Icons.person),
                  myTextFormField(
                      controller: phoneController,
                      hintText: "phone",
                      icon: Icons.phone),
                  myTextFormField(
                      controller: emailController,
                      hintText: "email",
                      icon: Icons.email),
                  myTextFormField(
                      controller: passwordController,
                      hintText: "password",
                      icon: Icons.remove_red_eye,),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                    ),
                    child: Container(
                      width: 100,
                      child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          underline: Container(
                            height: 2,
                            color: Colors.blue.shade800,
                          ),
                          elevation: 16,
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          }),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isLoad) return; // Prevent multiple presses
                        setState(() {
                          isLoad = true; // Set loading state to true
                        });

                        if (_formKey.currentState!.validate()) {
                          await ApiService().signUp(
                            usernameController.text,
                            passwordController.text,
                            phoneController.text,
                            dropdownValue,
                            emailController.text,
                            context,
                          );

                          // After successful signup, navigate to SignIn
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        }
                        setState(() {
                          isLoad = false;
                        });
                      },
                      child: isLoad
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade500,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Slightly less rounded for a modern look
                        ),
                        elevation: 5,
                        shadowColor: Colors.grey, // Shadow color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          fontSize: 18,
          color: Colors.teal.shade800, // Changed text color to teal
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors
                .blueGrey, // Changed hint text color to a lighter teal
          ),
          hintText: hintText,

          prefixIcon: Icon(
            icon,
            size: 25,
            color: Colors.black, // Changed icon color to teal
          ),
          filled: true,
          fillColor: Colors.white,
          // Keep the fill color white for contrast
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.teal.shade800, // Changed border color to teal
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.teal.shade900, // Darker teal for focused state
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.grey.shade400, // Lighter grey for enabled state
              width: 2.0,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          errorStyle: TextStyle(
            color: Colors.redAccent, // Error text color
            fontWeight: FontWeight.bold,
          ),
        ),
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your $hintText";
          }
          return null;
        },
      ),
    );
  }
}
