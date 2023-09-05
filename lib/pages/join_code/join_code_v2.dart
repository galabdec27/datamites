import 'dart:convert';

import 'package:datamites/helper/connection.dart';
import 'package:datamites/model/class_code_v2.dart';
import 'package:datamites/pages/candidate_portal/candidate_rest_request.dart';
import 'package:datamites/pages/join_code/show_class_code.dart';
import 'package:datamites/pages/main_page.dart';
import 'package:datamites/pages/verify_otp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/auth.dart';
import '../../helper/color.dart';
import '../../helper/user_details.dart';
import '../../provider/rating_provider_all.dart';
import '../contact_us.dart';
import '../login_page.dart';
import 'feedback_popup_all_classroom.dart';

class JoinCodeV2 extends StatefulWidget {
  const JoinCodeV2({Key? key}) : super(key: key);

  @override
  State<JoinCodeV2> createState() => _JoinCodeState();
}

class _JoinCodeState extends State<JoinCodeV2> {
  List<bool> ratingOverallList = [];
  List<bool> ratingClassroomList = [];
  List<bool> ratingTrainerList = [];
  List<bool> ratingCourseMaterialList = [];
  TextEditingController feedbackController = TextEditingController();
  final _ratingFormKey = GlobalKey<FormState>();
  FocusNode feedBackFocusNode = FocusNode();
  String classroomFeedback = "";

  String feedback = "";
  var overallRating = 5;
  var classroomRating = 5;
  var trainerRating = 5;
  var courseMaterialRating = 5;
  bool firstTime = true;
  bool showFeedback = false;

  final UserAuth _userAuth = UserAuth();
  bool refreshing = true;
  bool showLogin = false;
  bool showError = false;
  bool emailNotVerified = false;
  bool classCodeLoaded = false;
  late ClassCodeV2Model classCodeV2Model;
  CandidateRestRequest candidateRestRequest = CandidateRestRequest();
  int totalRating = 5;

  List<String> feedbackStringList = [""];

  getBatchInformation() async {
    setState(() {
      classCodeLoaded = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String candidate_portal_url = prefs.getString("candidate_portal_url") ?? "";
    String token = prefs.getString("jwtToken") ?? "";
    var finalUrl =
        "${candidate_portal_url}dm-api/lma/getLastRatedTrainingDetails/";
    if (kDebugMode) {
      print(finalUrl);
    }

    print(token);
    http.Response res =
        await http.get(Uri.parse(finalUrl), headers: {"jwt": token});
    print(res.body);

    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      classCodeV2Model = ClassCodeV2Model.fromJson(response);
      if (classCodeV2Model.is_rating_needed == 1) {
        showFeedback = true;
      } else {
        showFeedback = false;
      }

      setState(() {
        classCodeLoaded = true;
      });
    } else {
      getBatchInformation();
    }
  }


  Future<void> submitRatingtest(
      String feedback, int rating, String classId) async {
    bool connected = await ConnectionCheck.isAvailable();
    if (!connected) {
      AlertDialog(
        title: const Text("Connection Lost"),
        content: const Text("Please check your internet connection"),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false);
            },
            child: const Text("Ok"),
          )
        ],
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String authUrl = prefs.getString("auth_url") ?? "";
      String apiPath = "ClassRating/addRating";

      String token = prefs.getString("jwtToken") ?? "";
      String finalUrl = authUrl + apiPath;

      print("Rating");
      print(finalUrl);

      var map = <String, dynamic>{};
      map['rating'] = rating.toString();
      map['feedback'] = feedback;
      map['class_id'] = classId.toString();
      print(map);
      if (kDebugMode) {
        print(map);
      }

      http.Response res = await http.post(Uri.parse(finalUrl),
          headers: {"jwt": token}, body: map);
      print(res.body);

      if (kDebugMode) {
        print("Response is ");
        print(res.body);
      }
      if (res.statusCode == 200) {
        if (kDebugMode) {
          print(json.decode(res.body));
        }
      }
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
    bool connected = await ConnectionCheck.isAvailable();
    if (!connected) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Connection Lost"),
              content: const Text("Please check your internet connection"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                        (route) => false);
                  },
                  child: const Text("Ok"),
                )
              ],
            );
          });
    } else {
      refreshing = true;
      // ignore: use_build_context_synchronously
      int refreshed = await _userAuth.tokenRefresh(context);
      if (kDebugMode) {
        print("Refreshed first: $refreshed");
      }
      if (refreshed == 1) {
        // ignore: use_build_context_synchronously`, use_build_context_synchronously
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
      } else {
        getBatchInformation();
      }
      if (kDebugMode) {
        print("Verification is ");
        print(showError);
        print(showLogin);
      }
      setState(() {
        refreshing = false;
      });
    }
  }

  Future<void> _refreshWithScaffold() async {
    await _refresh();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Refreshed successfully'),
      duration: Duration(milliseconds: 500),
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
  void didUpdateWidget(covariant JoinCodeV2 oldWidget) {
    print("Updated");
    _refresh();
    super.didUpdateWidget(oldWidget);
  }


  var rating = 0;

  showSnackBar(BuildContext context, String text) {
    Future.delayed(Duration.zero, () async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    submitRating(int overallRating, int classroomRating, int trainerRating,
        intCourseMaterialRating, String classroomFeedback) async {
      bool connected = await ConnectionCheck.isAvailable();
      if (!connected) {
        AlertDialog(
          title: const Text("Connection Lost"),
          content: const Text("Please check your internet connection"),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                        (route) => false);
              },
              child: const Text("Ok"),
            )
          ],
        );
      } else {
        if (classCodeV2Model.ratings.isNotEmpty) {
          var selectedRating = classCodeV2Model.ratings.first;
          String requestJson =
              '{"enrollment_id": "${selectedRating.enrolment_id}","trainer_schedule_id": "${selectedRating.trainer_schedule_id}", '
              '"training_feedback_date": "${selectedRating.course_event_start_date}", "course_event_id": "${selectedRating.course_event_id}", '
              '"training_feedback_rating_overall": "$overallRating","training_feedback_rating_facility": "$classroomRating" ,'
              '"training_feedback_rating_trainer": "$trainerRating" ,"training_feedback_rating_material": "$intCourseMaterialRating", '
              '"training_feedback_comment":"$classroomFeedback"  }';

          showSnackBar(context, "Submitting rating");
          bool submitted =
          await candidateRestRequest.sendRating(context, requestJson);
          if (submitted) {
            setState(() {
              showFeedback = false;
            });
            feedbackController.text = "";

            context
                .read<RatingProviderAll>()
                .setOverallRating(5);
            setState(() {});
            _refreshWithScaffold();
          }
        }
      }
    }

    if (firstTime) {
      context
          .read<RatingProviderAll>()
          .changeRatingByType("overall", totalRating);
      context
          .read<RatingProviderAll>()
          .changeRatingByType("classroom", totalRating);
      context
          .read<RatingProviderAll>()
          .changeRatingByType("trainer", totalRating);
      context
          .read<RatingProviderAll>()
          .changeRatingByType("courseMaterial", totalRating);
      firstTime = false;
    }

    overallRating = Provider.of<RatingProviderAll>(context).getOverallRating;
    classroomRating =
        Provider.of<RatingProviderAll>(context).getClassroomRating;
    trainerRating = Provider.of<RatingProviderAll>(context).getTrainerRating;
    courseMaterialRating =
        Provider.of<RatingProviderAll>(context).getCourseMaterialRating;
    // if (kDebugMode) {
    //   print("overallRating is $overallRating");
    //   print("classroomRating is $classroomRating");
    //   print("trainerRating is $trainerRating");
    //   print("courseMaterialRating is $courseMaterialRating");
    // }

    ratingOverallList = List.filled(totalRating, false);
    ratingClassroomList = List.filled(totalRating, false);
    ratingTrainerList = List.filled(totalRating, false);
    ratingCourseMaterialList = List.filled(totalRating, false);

    for (int i = 0; i < overallRating; i++) {
      ratingOverallList[i] = true;
    }
    for (int i = 0; i < classroomRating; i++) {
      ratingClassroomList[i] = true;
    }
    for (int i = 0; i < trainerRating; i++) {
      ratingTrainerList[i] = true;
    }
    for (int i = 0; i < courseMaterialRating; i++) {
      ratingCourseMaterialList[i] = true;
    }
    // if (kDebugMode) {
    //   print(ratingOverallList);
    //   print(classroomRating);
    //   print(trainerRating);
    //   print(courseMaterialRating);
    // }

    if (Provider.of<RatingProviderAll>(context).submitClicked) {
      // else {
      //   feedBackFocusNode.requestFocus();
      // }
      if (kDebugMode) {
        print("Submit clicked");
      }
      String allClassroomFeedback = "";
      String allTrainerFeedback = "";
      String allCourseMaterialFeedback = "";
      if (classroomRating != totalRating) {
        allClassroomFeedback = Provider.of<RatingProviderAll>(context)
            .getConcatenatedClassroomFeedback;
      }
      if (trainerRating != totalRating) {
        allTrainerFeedback = Provider.of<RatingProviderAll>(context)
            .getConcatenatedTrainerFeedback;
      }
      if (courseMaterialRating != totalRating) {
        allCourseMaterialFeedback = Provider.of<RatingProviderAll>(context)
            .getConcatenatedCourseMaterialFeedback;
      }
      if (kDebugMode) {
        print("allClassroomFeedback text $allClassroomFeedback");
        print("allTrainerFeedback text $allTrainerFeedback");
        print("allCourseMaterialFeedback text $allCourseMaterialFeedback");
      }
      context.read<RatingProviderAll>().submitted();

      if (overallRating == totalRating) {
        submitRating(overallRating, classroomRating, trainerRating,
            courseMaterialRating, feedbackController.text.toString());
      } else {
        if (_ratingFormKey.currentState!.validate()) {
          submitRating(overallRating, classroomRating, trainerRating,
              courseMaterialRating, feedbackController.text.toString());
        } else {
          feedBackFocusNode.requestFocus();
          showSnackBar(context, "Please add feedback");
        }
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _refreshWithScaffold();
      },
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
              child: Column(
            children: [
              if (refreshing)
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                emailNotVerified
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
                                    const Text(
                                        "Seems like you are not logged in!!!"),
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
                            : !classCodeLoaded
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : (showFeedback)
                                    ? Form(
                                        key: _ratingFormKey,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Rate your class", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                                            ),
                                            FeedbackPopupAllClassroom(
                                              ratingList: ratingOverallList,
                                              rating: overallRating,
                                              type: "overall",
                                              feedbackList: const [],
                                              title: "",
                                              className: classCodeV2Model
                                                  .ratings.first.course_name,
                                              trainerName: classCodeV2Model
                                                  .ratings.first.trainer_name,
                                              startDate: classCodeV2Model
                                                  .ratings
                                                  .first
                                                  .course_event_start_date,
                                              startTime: classCodeV2Model
                                                  .ratings
                                                  .first
                                                  .course_event_start_time,
                                              endTime: classCodeV2Model.ratings
                                                  .first.course_event_end_time,
                                            ),
                                            if (overallRating < totalRating)
                                              FeedbackPopupAllClassroom(
                                                ratingList: ratingClassroomList,
                                                rating: classroomRating,
                                                type: "classroom",
                                                feedbackList: const [],
                                                title: "Classroom rating",
                                                className: classCodeV2Model.ratings.first.course_name,
                                                trainerName: classCodeV2Model.ratings.first.trainer_name,
                                                startDate: classCodeV2Model.ratings.first.course_event_start_date,
                                                startTime: classCodeV2Model.ratings.first.course_event_start_time,
                                                endTime: classCodeV2Model.ratings.first.course_event_end_time,
                                              ),
                                            if (overallRating < totalRating)
                                              FeedbackPopupAllClassroom(
                                                ratingList: ratingTrainerList,
                                                rating: trainerRating,
                                                type: "trainer",
                                                feedbackList: const [],
                                                title: "Trainer rating",
                                                className: classCodeV2Model.ratings.first.course_name,
                                                trainerName: classCodeV2Model.ratings.first.trainer_name,
                                                startDate: classCodeV2Model.ratings.first.course_event_start_date,
                                                startTime: classCodeV2Model.ratings.first.course_event_start_time,
                                                endTime: classCodeV2Model.ratings.first.course_event_end_time,
                                              ),
                                            if (overallRating < totalRating)
                                              FeedbackPopupAllClassroom(
                                                ratingList: ratingCourseMaterialList,
                                                rating: courseMaterialRating,
                                                type: "courseMaterial",
                                                feedbackList: const [],
                                                title: "Course material rating",
                                                className: "",
                                                trainerName: "",
                                                startDate: "",
                                                startTime: "",
                                                endTime: "",
                                              ),
                                            if (overallRating < totalRating)
                                              Container(
                                                padding: EdgeInsets.all(16.0),
                                                color: Colors.white,
                                                child: TextFormField(
                                                  controller:
                                                      feedbackController,
                                                  focusNode: feedBackFocusNode,
                                                  maxLines: 3,
                                                  decoration:
                                                      const InputDecoration(
                                                    icon: Icon(Icons.feedback),
                                                    border:
                                                        const OutlineInputBorder(),
                                                    hintText:
                                                        'Please give your feedback here',
                                                    labelText: 'Feedback *',
                                                  ),
                                                  validator: (String? value) {
                                                    return (value == null ||
                                                            value.isEmpty)
                                                        ? 'Enter your feedback'
                                                        : null;
                                                  },
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: MaterialButton(
                                                minWidth: double.infinity,
                                                height: 48,
                                                onPressed: () {
                                                  context
                                                      .read<RatingProviderAll>()
                                                      .submit = true;
                                                },
                                                color: MainColor.darkGreen,
                                                child: const Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          ShowCLassCode(
                                            classCodeModel: classCodeV2Model,
                                          ),
                                          Container(
                                            height: 100,
                                          )
                                        ],
                                      )
            ],
          ))),
    );
  }
}
