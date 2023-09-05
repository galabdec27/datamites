import 'dart:convert';

import 'package:datamites/helper/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/user_details.dart';
import '../../model/user_model.dart';
import '../../provider/rating_provider_all.dart';
import '../../widgets/CustomWidget.dart';
import '../../widgets/rating_widget.dart';
import '../join_code/feedback_popup_all_classroom.dart';
import '../update_profile_page.dart';
import 'candidate_rest_request.dart';
import 'data_model/RatingModel.dart';

class RatingPage extends StatefulWidget {
  final String pageTitle;

  const RatingPage({Key? key, required this.pageTitle}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  List<bool> ratingOverallList = [];
  List<bool> ratingClassroomList = [];
  List<bool> ratingTrainerList = [];
  List<bool> ratingCourseMaterialList = [];
  TextEditingController feedbackController = TextEditingController();
  final _ratingFormKey = GlobalKey<FormState>();
  FocusNode feedBackFocusNode = FocusNode();
  String classroomFeedback = "";

  CandidateRestRequest candidateRestRequest = CandidateRestRequest();
  List<RatingModel> classRatingList = [];
  RatingModel? selectedRating;
  bool loaded = false;
  bool loading = true;
  int totalRating = 5;
  List<String> feedbackClassroomStringList = [""];
  List<String> feedbackTrainerStringList = [""];
  List<String> feedbackCourseMaterialStringList = [""];

  getRatings() async {
    if (kDebugMode) {
      print("Getting ratings");
    }
    classRatingList = await candidateRestRequest.getRatings(context);
    setState(() {
      loaded = true;
      loading = false;
    });
  }

  var userDetails = UserDetails();
  UserModel? userModel;

  _getUserDetail() async {
    userModel = await userDetails.getDetail();
    setState(() {});
  }

  Future<void> getFeedbackString(String feedbackType) async {
    print("Getting feedback $feedbackType");
    String apiPath = "MeetingotpNew";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String authUrl = prefs.getString("auth_url") ?? "";
    String token = prefs.getString("jwtToken") ?? "";
    String finalUrl = authUrl + apiPath;

    http.Response res =
        await http.get(Uri.parse(finalUrl), headers: {"jwt": token});

    if (res.statusCode == 200) {
      if (kDebugMode) {
        print(
            "Fetching feedback ${authUrl}ClassRating/feedback?type=$feedbackType");
      }
      // gettting feedback array
      http.Response feedResponse = await http
          .get(Uri.parse("${authUrl}ClassRating/feedback?type=$feedbackType"));
      var feedbackList =
          json.decode(feedResponse.body)["feedback"] as List<dynamic>;
      List<String> feedbackStringList =
          feedbackList.map((feedback) => feedback.toString()).toList();

      switch (feedbackType) {
        case "courseMaterial":
          feedbackCourseMaterialStringList = feedbackStringList;
          break;
        case "trainer":
          feedbackTrainerStringList = feedbackStringList;
          break;
        case "classroom":
          feedbackClassroomStringList = feedbackStringList;
          break;
        default:
          break;
      }

      if (kDebugMode) {
        print("feedbackList: ${feedback.length}");
      }
    } else {
      return getFeedbackString(feedbackType);
    }
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    _getUserDetail();
    getRatings();
    super.initState();
  }

  String feedback = "";
  var overallRating = 5;
  var classroomRating = 5;
  var trainerRating = 5;
  var courseMaterialRating = 5;
  bool firstTime = true;
  bool showFeedback = false;

  showSnackBar(BuildContext context, String text) {
    Future.delayed(Duration.zero, () async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 500),
      ));
    });
  }

  Future<void> _refreshWithScaffold() async {
    if (kDebugMode) {
      print("refreshing");
    }
    await getRatings();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 700),
      content: const Text('Refreshed Succesfully'),
      action: SnackBarAction(
        label: 'Refresh Again',
        onPressed: () async {
          await getRatings();
          // Some code to undo the change.
        },
      ),
    ));
  }

  submitRating(int overallRating, int classroomRating, int trainerRating,
      intCourseMaterialRating, String classroomFeedback) async {
    context.read<RatingProviderAll>().submitted();
    String requestJson =
        '{"enrollment_id": "${selectedRating?.enrolment_id}","trainer_schedule_id": "${selectedRating?.trainer_schedule_id}", '
        '"training_feedback_date": "${selectedRating?.course_event_start_date}","course_event_id": "${selectedRating?.course_event_id}", '
        '"training_feedback_rating_overall": "$overallRating","training_feedback_rating_facility": "$classroomRating" ,'
        '"training_feedback_rating_trainer": "$trainerRating" ,"training_feedback_rating_material": "$intCourseMaterialRating", '
        '"training_feedback_comment":"$classroomFeedback"  }';

    showSnackBar(context, "Submitting rating");
    bool submitted = await candidateRestRequest.sendRating(context, requestJson);
    if (submitted) {
      feedbackController.text = "";
      _refreshWithScaffold();
      setState(() {
        showFeedback = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

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
      // if (kDebugMode) {
      //   print("allClassroomFeedback text $allClassroomFeedback");
      //   print("allTrainerFeedback text $allTrainerFeedback");
      //   print("allCourseMaterialFeedback text $allCourseMaterialFeedback");
      // }

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
    getOverallFeedback() {
      return FeedbackPopupAllClassroom(
        ratingList: ratingOverallList,
        rating: overallRating,
        type: "overall",
        feedbackList: const [],
        title: "",
        className: selectedRating!.course_name,
        trainerName: selectedRating!.trainer_name,
        startDate: selectedRating!.course_event_start_date,
        startTime: selectedRating!.course_event_start_time,
        endTime: selectedRating!.course_event_end_time,
      );
    }

    getClassroomFeedback() {
      return FeedbackPopupAllClassroom(
        ratingList: ratingClassroomList,
        rating: classroomRating,
        type: "classroom",
        feedbackList: feedbackClassroomStringList,
        title: "Classroom rating",
        className: selectedRating!.course_name,
        trainerName: selectedRating!.trainer_name,
        startDate: selectedRating!.course_event_start_date,
        startTime: selectedRating!.course_event_start_time,
        endTime: selectedRating!.course_event_end_time,
      );
    }

    getTrainerFeedback() {
      return FeedbackPopupAllClassroom(
        ratingList: ratingTrainerList,
        rating: trainerRating,
        type: "trainer",
        feedbackList: feedbackTrainerStringList,
        title: "Trainer rating",
        className: selectedRating!.course_name,
        trainerName: selectedRating!.trainer_name,
        startDate: selectedRating!.course_event_start_date,
        startTime: selectedRating!.course_event_start_time,
        endTime: selectedRating!.course_event_end_time,
      );
    }

    getCourseMaterialFeedback() {
      return FeedbackPopupAllClassroom(
        ratingList: ratingCourseMaterialList,
        rating: courseMaterialRating,
        type: "courseMaterial",
        feedbackList: feedbackCourseMaterialStringList,
        title: "Course material rating",
        className: "",
        trainerName: "",
        startDate: "",
        startTime: "",
        endTime: "",
      );
    }


    return WillPopScope(
      onWillPop: () async {
        if (kDebugMode) {
          print("Feedback is $showFeedback");
        }
        if (showFeedback) {
          showFeedback = false;
          overallRating = 0;
          overallRating = 0;
          _refreshWithScaffold();
          setState(() {});
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: CustomWidget.getDatamitesAppBar(context, userModel, 1),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            await _refreshWithScaffold();
          },
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                ):
              classRatingList.isEmpty ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No any rating found!"),
                    MaterialButton(
                        elevation: 1,
                      color: MainColor.darkGreen,
                        onPressed: getRatings,
                      child: const Text("Refresh", style: TextStyle(color: Colors.white),))
                  ],
                ),
              )

              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: showFeedback
                      ? Form(
                          key: _ratingFormKey,
                          child: Column(
                            children: [
                              getOverallFeedback(),
                              if (overallRating < totalRating)
                                getClassroomFeedback(),
                              if (overallRating < totalRating)
                                getTrainerFeedback(),
                              if (overallRating < totalRating)
                                getCourseMaterialFeedback(),
                              if (overallRating < totalRating)
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: feedbackController,
                                    focusNode: feedBackFocusNode,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.feedback),
                                      border: const OutlineInputBorder(),
                                      hintText:
                                          'Please give your feedback here',
                                      labelText: 'Feedback *',
                                    ),
                                    validator: (String? value) {
                                      return (value == null || value.isEmpty)
                                          ? 'Enter your feedback'
                                          : null;
                                    },
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 48,
                                  onPressed: () {
                                    context.read<RatingProviderAll>().submit =
                                        true;
                                  },
                                  color: MainColor.darkGreen,
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pageTitle,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            for (RatingModel rating in classRatingList)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: MainColor.lightGrey),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rating.course_name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      rating.course_event_name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today_sharp, size: 14,),
                                        SizedBox(width: 8,),
                                        Text(
                                          "Date: ${rating.course_event_start_date}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, size: 14,),
                                        SizedBox(width: 8,),
                                        Text(
                                          "${rating.course_event_start_time.length == 8 ? rating.course_event_start_time.substring(0,5):rating.course_event_start_time} "
                                              "to ${rating.course_event_end_time.length == 8 ? rating.course_event_end_time.substring(0,5):rating.course_event_end_time} (IST)",
                                          // "${rating.course_event_start_time}\tto ${rating.course_event_end_time} (IST)",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Trainer: ${rating.trainer_name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (rating
                                                  .training_feedback_rating_overall !=
                                              "0")
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 16, 0, 0),
                                                  child: Text(
                                                    "Your ratings:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Overall"),
                                                    RatingWidget(
                                                        // List.filled(totalRating, false)
                                                        rating: new List.from(
                                                            List.filled(
                                                                int.parse(rating
                                                                    .training_feedback_rating_overall),
                                                                true))
                                                          ..addAll(List.filled(
                                                              totalRating -
                                                                  int.parse(rating
                                                                      .training_feedback_rating_overall),
                                                              false)),
                                                        height: 30,
                                                        width: 30,
                                                        type: "no type"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Classroom"),
                                                    RatingWidget(
                                                        // List.filled(totalRating, false)
                                                        rating: new List.from(
                                                            List.filled(
                                                                int.parse(rating
                                                                    .training_feedback_rating_facility),
                                                                true))
                                                          ..addAll(List.filled(
                                                              totalRating -
                                                                  int.parse(rating
                                                                      .training_feedback_rating_facility),
                                                              false)),
                                                        height: 30,
                                                        width: 30,
                                                        type: "no type"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Trainer"),
                                                    RatingWidget(
                                                        // List.filled(totalRating, false)
                                                        rating: List.from(
                                                            List.filled(
                                                                int.parse(rating
                                                                    .training_feedback_rating_trainer),
                                                                true))
                                                          ..addAll(List.filled(
                                                              totalRating -
                                                                  int.parse(rating
                                                                      .training_feedback_rating_trainer),
                                                              false)),
                                                        height: 30,
                                                        width: 30,
                                                        type: "no type"),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                        "Course material"),
                                                    RatingWidget(
                                                        // List.filled(totalRating, false)
                                                        rating: new List.from(
                                                            List.filled(
                                                                int.parse(rating
                                                                    .training_feedback_rating_material),
                                                                true))
                                                          ..addAll(List.filled(
                                                              totalRating -
                                                                  int.parse(rating
                                                                      .training_feedback_rating_material),
                                                              false)),
                                                        height: 30,
                                                        width: 30,
                                                        type: "no type"),
                                                  ],
                                                )
                                              ],
                                            ),
                                          if (rating
                                                  .training_feedback_rating_overall ==
                                              "0")
                                            MaterialButton(
                                              onPressed: () {
                                                context
                                                    .read<RatingProviderAll>()
                                                    .setOverallRating(
                                                        totalRating);
                                                context
                                                    .read<RatingProviderAll>()
                                                    .setTrainerRating(
                                                        totalRating);
                                                context
                                                    .read<RatingProviderAll>()
                                                    .setClassroomRating(
                                                        totalRating);
                                                context
                                                    .read<RatingProviderAll>()
                                                    .setCourseMaterialRating(
                                                        totalRating);
                                                context
                                                    .read<RatingProviderAll>()
                                                    .deselectFeedback();
                                                selectedRating = rating;
                                                showFeedback = true;
                                                setState(() {});
                                              },
                                              color: MainColor.darkGreen,
                                              child: const Text(
                                                "Rate this class",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        )),
        ),
      ),
    );
  }
}
