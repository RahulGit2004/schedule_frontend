import 'package:flutter/cupertino.dart';
import 'package:schedule_system/integration/response/user/LoginResponse.dart';

class LoginProvider with ChangeNotifier {
  LoginResponse?  loginResponse;
  LoginResponse? get login => loginResponse;

  void updateLoginResponse(LoginResponse response) {
    loginResponse = response;
    notifyListeners();
  }
}