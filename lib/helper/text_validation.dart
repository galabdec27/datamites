import 'package:flutter/material.dart';

class TextValidation {
  TextValidation() {}

  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp phoneRegex = RegExp(r"^[0-9]{10}$");

  // Password that contain minimum 8 character, atleast one num and one letter
  RegExp passRegex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

  String validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot by empty!";
    } else if (!emailRegex.hasMatch(email)) {
      return ("Email is not a valid email!");
    } else {
      return "Valid";
    }
  }

  String validateEmailOrPhone(String text) {
    if (text.isEmpty) {
      return "Email cannot by empty!";
    } else if (phoneRegex.hasMatch(text)) {
      debugPrint("Match phoneReg");
      return "Valid";
    } else if (!emailRegex.hasMatch(text)) {
      return ("Enter a valid email!");
    } else
      return "Valid";
  }

  String validatePassword(String pass) {
    if (pass.trim().length < 6) {
      return "Password should be atleast 6 char long!";
    } else
      return "Valid";
  }

  String validatePhone(String phone) {
    if (phone.trim().isEmpty) {
      return "Phone cannot be empty!";
    } else if (phone.length > 5) {
      return 'Valid';
    } else
      return "Enter 10 digit phone";
  }
}
