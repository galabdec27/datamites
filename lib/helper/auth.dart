import 'dart:convert';

import 'package:datamites/helper/user_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class UserAuth {
  UserDetails userDetails = UserDetails();
  UserModel userModel = UserModel();

  Future<int> tokenLogin(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authUrl = preferences.getString("auth_url") ?? "";
    String url = authUrl + "password/tokenLogin";
    int returnValue = 0;
    final _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString("jwtToken") ?? "";
    if (token != "") {
      http.Response response =
          await http.get(Uri.parse(url), headers: {"jwt": token});
      if (response.statusCode != 403) {
        if (response.statusCode == 200) {
          var userResponse = json.decode(response.body);

          // if (kDebugMode) print("User response");
          // if (kDebugMode) print(userResponse);

          userModel.userName = userResponse["user_data"]["name"];
          userModel.userEmail = userResponse["user_data"]["email"];
          userModel.userPhone = userResponse["user_data"]["mnumber"];
          userModel.userImage = userResponse["user_data"]["profile_pic"];
          userModel.userDob = userResponse["user_data"]["dob"]??"";
          userModel.jwtKey = userResponse["jwtkey"];
          userModel.refreshKey = userResponse["refreshToken"];
          await userDetails.setDetail(userModel);
          returnValue = 1;
        } else if (response.statusCode == 401) {
          await userDetails.logoutUser();
          returnValue = 3;
        } else {
          await userDetails.logoutUser();
          returnValue = 2;
        }
      }
    } else {
      await userDetails.logoutUser();
    }
    return returnValue;
  }

  Future<int> tokenRefresh(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String authUrl = preferences.getString("auth_url") ?? "";
    String url = authUrl + "refresh";
    int returnValue = 0;
    final _prefs = await SharedPreferences.getInstance();
    var refreshToken = _prefs.getString("refreshToken") ?? "";
    if (refreshToken != "") {
      http.Response response = await http
          .get(Uri.parse(url), headers: {"refresh_token": refreshToken});
      if (response.statusCode != 403) {
        if (response.statusCode == 200) {
          _prefs.setString("jwtToken", json.decode(response.body)["jwtkey"]);
          _prefs.setString(
              "refreshToken", json.decode(response.body)["refreshToken"]);
          returnValue = 1;
        } else if (response.statusCode == 401) {
          returnValue = 3;
        } else {
          returnValue = 2;
        }
      } else {
        userDetails.logout(context);
      }
    }
    return returnValue;
  }
}
