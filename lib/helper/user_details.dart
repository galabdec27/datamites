
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../pages/main_page.dart';

class UserDetails {


  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", "");
    await prefs.setString("refreshToken", "");
    await prefs.setString("userDob", "");
    await prefs.setString("userPhone", "");
    await prefs.setString("userImage", "");
    await prefs.setString("userName", "");
    await prefs.setString("userEmail", "");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainPage()), (route) => false);
  }
  Future<void> manualLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", "");
    await prefs.setString("refreshToken", "");
    await prefs.setString("userDob", "");
    await prefs.setString("userPhone", "");
    await prefs.setString("userImage", "");
    await prefs.setString("userName", "");
    await prefs.setString("userEmail", "");
    await prefs.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MainPage()), (route) => false);
  }



  Future<void> logoutOnly(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", "");
    await prefs.setString("refreshToken", "");
    await prefs.setString("userDob", "");
    await prefs.setString("userPhone", "");
    await prefs.setString("userImage", "");
    await prefs.setString("userName", "");
    await prefs.setString("userEmail", "");
  }

  Future<UserModel> getDetail() async {
    final _prefs = await SharedPreferences.getInstance();
    UserModel userModel = UserModel();
    userModel.userName = _prefs.getString("userName") ?? "";
    userModel.jwtKey = _prefs.getString("jwtToken") ?? "";
    userModel.refreshKey = _prefs.getString("refreshToken") ?? "";
    userModel.userDob = _prefs.getString("userDob") ?? "";
    userModel.userPhone = _prefs.getString("userPhone") ?? "";
    userModel.userImage = _prefs.getString("userImage") ?? "";
    userModel.userEmail = _prefs.getString("userEmail") ?? "";

    return userModel;
  }

  Future<void> setDetail(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userName", userModel.userName);
    await prefs.setString("userEmail", userModel.userEmail);
    await prefs.setString("userPhone", userModel.userPhone);
    await prefs.setString("userImage", userModel.userImage);
    await prefs.setString("userDob", userModel.userDob);
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwtToken", "");
    await prefs.setString("refreshToken", "");
    await prefs.setString("userDob", "");
    await prefs.setString("userPhone", "");
    await prefs.setString("userImage", "");
    await prefs.setString("userName", "");
    await prefs.setString("userEmail", "");
  }
}
