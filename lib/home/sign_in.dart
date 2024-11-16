import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_system/admin/admin_bottom_nav.dart';
import 'package:schedule_system/home/sign_up.dart';
import 'package:schedule_system/student/student_bottom.dart';
import 'package:schedule_system/integration/api_services.dart';
import 'package:provider/provider.dart';
import 'package:schedule_system/provider/login_provider.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  bool isLoading = false;
  bool isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Sign In",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                _buildPhoneField(),
                SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  hintText: "Password",
                  icon: Icons.lock_outline,
                  obscureText: !isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                _buildLoginButton(),
                SizedBox(height: 25),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      style: TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: "Phone",
        prefixIcon: Icon(Icons.phone, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your phone number";
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.blueGrey[700]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade700, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }


  Widget _buildLoginButton() {
    return isLoading
        ? CircularProgressIndicator()
        : ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() {
            isLoading = true; // Set loading state
          });
          await ApiService().login(phoneController.text, passwordController.text, context);
          setState(() {
            isLoading = false; // Reset loading state
          });
        }
      },
      child: Text(
        "Log In",
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade500,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: Colors.grey,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      child: Text("Don't have an account? Sign UP", style: TextStyle(color: Colors.blue)),
    );
  }
}