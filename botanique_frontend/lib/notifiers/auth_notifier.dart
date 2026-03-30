import 'package:flutter/material.dart';

class AuthNotifier {
  final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);
  String? token;

  void login(String authToken){
    token = authToken;
    isLoggedIn.value = true;
  }
  void logout(){
    token = null;
    isLoggedIn.value = false;
  }
}
