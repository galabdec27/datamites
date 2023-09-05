import 'dart:convert';

import 'package:datamites/helper/HexColor.dart';
import 'package:datamites/helper/auth.dart';
import 'package:datamites/helper/user_details.dart';
import 'package:datamites/pages/login_page.dart';
import 'package:datamites/pages/verify_otp.dart';
import 'package:datamites/widgets/feedback_widget.dart';
import 'package:datamites/widgets/rating_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/class_code.dart';
import 'package:http/http.dart' as http;

import 'contact_us.dart';

class ClassCodeService {}

class ClassCode extends StatefulWidget {
  const ClassCode({Key? key}) : super(key: key);

  @override
  State<ClassCode> createState() => _ClassCodeState();
}

class _ClassCodeState extends State<ClassCode> {
  final UserAuth _userAuth = UserAuth();
  bool refreshing = true;
  bool classCodeRefreshing = false;
  bool ratingRefreshing = false;
  bool showRating = false;
  bool showLogin = false;
  bool showError = false;
  bool emailNotVerified = false;
  late ClassCodeModel classCodeModel;

  List<String> feedback = [""];

  Future<ClassCodeModel?> getBatchInformation() async {
    setState(() {
      classCodeRefreshing = true;
    });
    print("Getting batch information");
    String apiPath = "MeetingotpNew";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String baseUrl = prefs.getString("auth_url") ?? "";
    String token = prefs.getString("jwtToken") ?? "";
    String finalUrl = baseUrl + apiPath;

    if (kDebugMode) {
      print("header $token");
      print(finalUrl);
    }
    http.Response res =
        await http.get(Uri.parse(finalUrl), headers: {"jwt": token});

    if (kDebugMode) {
      print("Getting batch response");
      print(res.body);
    }

    setState(() {
      classCodeRefreshing = false;
    });
    if (res.statusCode == 200) {

      var response = json.decode(res.body);
      classCodeModel = ClassCodeModel.fromJson(response);

      // getting feedback array
      http.Response feedResponse = await http
          .get(Uri.parse("${baseUrl}ClassRating/feedback"));
      var feedbackList =
          json.decode(feedResponse.body)["feedback"] as List<dynamic>;
      feedback =
          feedbackList.map((feedback) => feedback.toString()).toList();
      if (kDebugMode) {
        print("feedbackList: ${feedback.length}");
      }
      setState(() {
        if (classCodeModel.is_rating_needed == 1) showRating = true;
      });

      return classCodeModel;
    } else {
      return getBatchInformation();
    }
  }

  Future<bool?> rateClass(int rating, String feedback, int classId) async {
    ratingRefreshing = true;
    setState(() {});
    String apiPath = "ClassRating/addRating";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String baseUrl = prefs.getString("auth_url") ?? "";
    String token = prefs.getString("jwtToken") ?? "";
    String finalUrl = baseUrl + apiPath;

    var ratingBody = <String, dynamic>{};
    ratingBody['rating'] = rating;
    ratingBody['feedback'] = feedback;
    ratingBody['class_id'] = classId;

    http.Response res = await http.post(Uri.parse(finalUrl),
        headers: {"jwt": token}, body: ratingBody);

    if (kDebugMode) {
      print(res.body);
    }
    ratingRefreshing = false;
    setState(() {});
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  _verifyEmail() async {
    UserDetails userDetails = UserDetails();
    var user = await userDetails.getDetail();
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VerifyOtp(email: user.userEmail)));
  }

  Future<void> _refresh() async {
    refreshing = true;
    int refreshed = await _userAuth.tokenRefresh(context);
    if (kDebugMode) {
      print("Refreshed first: $refreshed");
    }
    if (refreshed == 1) {
      // ignore: use_build_context_synchronously
      refreshed = await _userAuth.tokenLogin(context);
      if (kDebugMode) {
        print("Refreshed second: $refreshed");
      }
    } else if (refreshed == 3) {
      showError = false;
      showLogin = false;
      emailNotVerified = true;
    }
    if (refreshed == 0) {
      showLogin = true;
      showError = false;
    } else if (refreshed == 2) {
      showError = true;
      showLogin = false;
    } else if (refreshed == 3) {
      showError = false;
      showLogin = false;
      emailNotVerified = true;
    }
    setState(() {
      refreshing = false;
    });
    await getBatchInformation();
  }

  Future<void> _refreshWithScaffold() async {
    if (kDebugMode) {
      print("refreshing");
    }
    await _refresh();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Refreshed Succesfully'),
      action: SnackBarAction(
        label: 'Refresh Again',
        onPressed: () {
          _refresh();
          // Some code to undo the change.
        },
      ),
    ));
  }

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await _refreshWithScaffold();
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: SingleChildScrollView(
            child: Column(
          children: [
            refreshing
                ? Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : emailNotVerified
                    ? Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 100,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Seems like you are not logged in"),
                            MaterialButton(
                              minWidth: 120,
                              color: Colors.blueAccent,
                              onPressed: () => {_verifyEmail()},
                              child: const Text(
                                "Verify Email",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: MaterialButton(
                                minWidth: 120,
                                color: Colors.blueAccent,
                                onPressed: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const LoginPage()))
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ))
                    : showError
                        ? Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.white,
                            child: const Center(
                              child: Text("Something went wrong!"),
                            ),
                          )
                        : showLogin
                            ? Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Seems like you are not logged in!!!"),
                                    MaterialButton(
                                      minWidth: 120,
                                      color: Colors.blueAccent,
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()))
                                      },
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    MaterialButton(
                                      minWidth: 120,
                                      color: Colors.white,
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ContactUsScreen(
                                                      title: "Contact us",
                                                        message: "")))
                                      },
                                      child: const Text(
                                        "Contact us",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ))
                            : SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Classcode here"),
                                    const Text("Classcode here"),
                                    showRating
                                        ? Column(
                                            children: [
                                              // RatingWidget(rating: const [
                                              //   true,
                                              //   true,
                                              //   true,
                                              //   true,
                                              //   true
                                              // ], height: 100,),
                                              FeedbackWidget(feedbackList: feedback),

                                            ],
                                          )
                                        : (!classCodeRefreshing &&
                                                classCodeModel.status == 1)
                                            ? Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(16),
                                                    color: HexColor(
                                                        classCodeModel
                                                            .background_color),
                                                    child: Text(
                                                      classCodeModel.msg,
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              classCodeModel
                                                                  .front_color)),
                                                    ),
                                                  ),
                                                  Text(classCodeModel
                                                      .batch_name),
                                                  Text(classCodeModel
                                                      .background_color),
                                                  Text(classCodeModel
                                                      .class_code),
                                                  Text(classCodeModel.msg)
                                                ],
                                              )
                                            : (!classCodeRefreshing &&
                                                    classCodeModel.status == 2)
                                                ? Column(
                                                    children: [
                                                      const Text("No active session"),
                                                      Text(classCodeModel
                                                          .batch_id),
                                                      Text(classCodeModel
                                                          .batch_name),
                                                      Text(classCodeModel
                                                          .background_color),
                                                      Text(classCodeModel
                                                          .class_code),
                                                      Text(classCodeModel.msg)
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets.all(16),
                                                        color: HexColor(
                                                            classCodeModel
                                                                .background_color),
                                                        child: Text(
                                                          classCodeModel.msg,
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  classCodeModel
                                                                      .front_color)),
                                                        ),
                                                      ),
                                                      Text(classCodeModel
                                                          .batch_id),
                                                      Text(classCodeModel
                                                          .batch_name),
                                                      Text(classCodeModel
                                                          .background_color),
                                                      Text(classCodeModel
                                                          .class_code),
                                                      Text(classCodeModel.msg)
                                                    ],
                                                  )
                                  ],
                                ),
                              ),
            Container(height: 120, width: double.infinity, color: Colors.red,)
          ],
        )));
  }
}
