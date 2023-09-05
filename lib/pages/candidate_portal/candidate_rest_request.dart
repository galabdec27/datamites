import 'dart:convert';

import 'package:datamites/pages/candidate_portal/data_model/CourseEventModel.dart';
import 'package:datamites/pages/candidate_portal/data_model/RatingModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data_model/EnrollmentModel.dart';
import 'data_model/PaymentDetailModel.dart';

class CandidateRestRequest {
  readJson(var path) async {
    String response = await rootBundle.loadString(path);
    var data = await json.decode(response);
    return data;
  }


  Future<List<EnrollmentModel>> getCourseEnrollment(
      BuildContext context) async {
    List<EnrollmentModel> enrolledCourses = [];
    var prefs = await SharedPreferences.getInstance();
    var candidate_portal_url = prefs.getString("candidate_portal_url") ?? "";
    var user_email = prefs.getString("user_email") ?? "";
    var finalUrl =
        "${candidate_portal_url}dm-api/lma/getCourse?user_email=$user_email";
    http.Response response = await http.get(Uri.parse(finalUrl));
    if (kDebugMode) {
      print(finalUrl);
      print("Response body");
      print(response.body);
    }

    try {
      var responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        List<dynamic> body = responseBody['data'] as List;
        enrolledCourses = body
            .map(
              (dynamic item) => EnrollmentModel.fromJson(item),
            )
            .toList();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['msg'], textAlign: TextAlign.center),
        ));
      }
    } catch (err) {
      print(err);
    }
    return enrolledCourses;
  }

  Future<List<CourseEventModel>> getCourseDetails(
      BuildContext context, String eventId) async {
    List<CourseEventModel> courseEvents = [];
    var prefs = await SharedPreferences.getInstance();
    var candidate_portal_url = prefs.getString("candidate_portal_url") ?? "";
    var finalUrl =
        "${candidate_portal_url}dm-api/lma/getCourseEvents?bundle_event_id=$eventId";
    if (kDebugMode) {
      print(finalUrl);
    }
    http.Response response = await http.get(Uri.parse(finalUrl));

    try {

      var responseBody = json.decode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        List<dynamic> body = responseBody as List;
        courseEvents = body
            .map(
              (dynamic item) => CourseEventModel.fromJson(item),
            )
            .toList();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['msg'], textAlign: TextAlign.center),
        ));
      }
    } catch (err) {
      print(err);
    }
    return courseEvents;
  }

  Future<List<RatingModel>> getRatings(BuildContext context) async {
    List<RatingModel> ratingList = [];
    var prefs = await SharedPreferences.getInstance();
    var candidate_portal_url = prefs.getString("candidate_portal_url") ?? "";
    var email = prefs.getString("user_email")?? "";
    var finalUrl = "${candidate_portal_url}dm-api/lma/getTrainerFeedbackDetails?email_id=$email";
    if (kDebugMode) {
      print(finalUrl);
    }

    http.Response response = await http.get(Uri.parse(finalUrl));

    try{
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        List<dynamic> responseBody = responseJson["classroom_rating"];
        ratingList = responseBody
            .map(
              (dynamic item) => RatingModel.fromJson(item),
        )
            .toList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseJson['msg'],
              textAlign: TextAlign.center),
        ));
      }
    } catch(err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString(),
            textAlign: TextAlign.center),
      ));
    }

    // print("ratingList length: ${ratingList.length}");
    return ratingList;
  }

  Future<List<PaymentDetailModel>> getPayments(BuildContext context) async {
    List<PaymentDetailModel> cpList = [];
    var prefs = await SharedPreferences.getInstance();
    var candidate_portal_url = prefs.getString("candidate_portal_url") ?? "";
    var email = prefs.getString("user_email")?? "";
    var finalUrl = "${candidate_portal_url}dm-api/lma/getEnrolmentPaymentsDetails?candidate_email=$email";
    // if (kDebugMode) {
    //   print(finalUrl);
    // }

    http.Response response = await http.get(Uri.parse(finalUrl));

    try{
      var responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        List<dynamic> body = responseBody['data'] as List;
        cpList = body
            .map(
              (dynamic item) => PaymentDetailModel.fromJson(item),
        )
            .toList().cast<PaymentDetailModel>();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['msg'],
              textAlign: TextAlign.center),
        ));
      }
    } catch(err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString(),
            textAlign: TextAlign.center),
      ));
    }

    return cpList;
  }


  Future<bool> sendRating(BuildContext context, String jsonBody) async {
    var prefs = await SharedPreferences.getInstance();
    var candidate_portal_url = prefs.getString("candidate_portal_url") ?? "";
    var email = prefs.getString("user_email")?? "";
    var finalUrl = "${candidate_portal_url}dm-api/lma/addTrainerFeedbackDetails?candidate_email=$email";
    if (kDebugMode) {
      print(jsonBody);
      print(finalUrl);
    }

    http.Response response = await http.post(Uri.parse(finalUrl), body: jsonBody, headers: {"Content-Type": "application/json"});
    var responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseJson["msg"],
            textAlign: TextAlign.center),
      ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseJson["msg"],
            textAlign: TextAlign.center),
      ));
      return false;
    }
  }
}
