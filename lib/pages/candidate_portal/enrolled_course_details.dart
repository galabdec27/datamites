import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/candidate_portal/candidate_rest_request.dart';
import 'package:datamites/pages/candidate_portal/course_schedules.dart';
import 'package:datamites/pages/candidate_portal/data_model/CourseEventModel.dart';
import 'package:datamites/pages/candidate_portal/data_model/EnrollmentModel.dart';
import 'package:datamites/pages/candidate_portal/data_model/ScheduleModel.dart';
import 'package:flutter/material.dart';

import '../../helper/connection.dart';
import '../../helper/user_details.dart';
import '../../model/user_model.dart';
import '../../widgets/CustomWidget.dart';
import '../main_page.dart';
import '../update_profile_page.dart';
import 'data_model/CourseModel.dart';

class EnrolledCourseDetails extends StatefulWidget {
  final EnrollmentModel enrollmentModel;

  // ignore: use_key_in_widget_constructors
  const EnrolledCourseDetails({required this.enrollmentModel});

  @override
  State<EnrolledCourseDetails> createState() => _EnrolledCourseDetailsState();
}

class _EnrolledCourseDetailsState extends State<EnrolledCourseDetails> {
  CandidateRestRequest candidateRestRequest = CandidateRestRequest();
  List<CourseEventModel> courses = [];
  bool loaded = false;
  bool loading = true;
  String startDate = "";
  String endDate = "";

  void getStartEndDate() {
    for (CourseEventModel course in courses) {
      for (ScheduleModel scheduleModel in course.schedules) {
        if (startDate.isEmpty) {
          if (scheduleModel.event_start_date.isNotEmpty) {
            startDate = scheduleModel.event_start_date;
          }
        }
        if (scheduleModel.event_start_date.isNotEmpty) {
          endDate = scheduleModel.event_start_date;
        }
      }
    }
    setState(() {});
  }

  void getCourses(String bundle_event_id) async {
    print("Getting courses");
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
      courses =
          await candidateRestRequest.getCourseDetails(context, bundle_event_id);
      getStartEndDate();
    }
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

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    _getUserDetail();
    getCourses(widget.enrollmentModel.bundle_event_id);
    super.initState();
  }

  getTag(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: selected ? MainColor.lightGreen : MainColor.lightRed,
          borderRadius: BorderRadius.circular(8.0)),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            color: selected ? MainColor.darkGreen : MainColor.darkRed,
            decoration: selected ? null : TextDecoration.lineThrough),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidget.getDatamitesAppBar(context, userModel, 1),
      body: loaded
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.enrollmentModel.bundle_name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start date: $startDate (IST)"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.my_library_books_outlined,
                                size: 18,
                              ),
                              Text(
                                  " ${courses.isNotEmpty ? courses.length : ""} ${courses.isEmpty ? "No course" : courses.length > 1 ? "courses" : "course"}")
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black38),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child:
                            Text("INR ${widget.enrollmentModel.agreed_price}"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  for (CourseEventModel course in courses)
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.courses.first.course_name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),

                            if (course.courses.first.course_code.isNotEmpty)
                              Text(
                                course.courses.first.course_code,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            if (course
                                .courses.first.course_description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Text(
                                  course.courses.first.course_description,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.black38),
                                ),
                              ),
                            if (course.courses.first.course_language.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.language,
                                    size: 18,
                                  ),
                                  Text(
                                      " ${course.courses.first.course_language}")
                                ],
                              ),
                            if (course.courses.first.course_duration.isNotEmpty) Row(
                              children: [
                                const Icon(
                                  Icons.access_time_outlined,
                                  size: 18,
                                ),
                                Text(
                                    " ${course.courses.first.course_duration} weeks")
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [


                                if (course.course_event_status != "" &&
                                    course.course_event_status.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 4, 8, 4),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        color: course.course_event_status ==
                                            "0" &&
                                            course.course_event_status
                                                .isNotEmpty
                                            ? MainColor.darkGreen
                                            : MainColor.darkRed),
                                    child: Text(
                                      course.course_event_status == "1"
                                          ? "Scheduled"
                                          : course.course_event_status ==
                                          "2"
                                          ? "Postponed"
                                          : course.course_event_status ==
                                          "3"
                                          ? "Completed"
                                          : course.course_event_status ==
                                          "4"
                                          ? "Cancelled"
                                          : course.course_event_status ==
                                          "5"
                                          ? "Audited"
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                if (course.courses.first.course_level !=
                                    "")
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 4, 8, 4),
                                    margin: const EdgeInsets.fromLTRB(
                                        4, 0, 0, 0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        color: course.courses.first
                                            .course_level ==
                                            "1"
                                            ? MainColor.darkGreen
                                            : course.courses.first
                                            .course_level ==
                                            "2"
                                            ? MainColor.datamiteOrange
                                            : MainColor.darkRed),
                                    child: Text(
                                      course.courses.first.course_level ==
                                          "1"
                                          ? "Beginner"
                                          : course.courses.first
                                          .course_level ==
                                          "2"
                                          ? "Intermediate"
                                          : course.courses.first
                                          .course_level ==
                                          "3"
                                          ? "Expert"
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Wrap(
                              spacing: 5,
                              runSpacing: 5.0,
                              children: [
                                if (course.courses.first.has_assessment != "")
                                  getTag(
                                      "assessment",
                                      course.courses.first.has_assessment ==
                                          "1"),
                                if (course.courses.first
                                        .has_placement_assistance !=
                                    "")
                                  getTag(
                                      "placement assessment",
                                      course.courses.first
                                              .has_placement_assistance ==
                                          "1"),
                                if (course.courses.first.has_internship != "")
                                  getTag(
                                      "internship",
                                      course.courses.first.has_internship ==
                                          "1"),
                                if (course.courses.first.has_projects != "")
                                  getTag("projects",
                                      course.courses.first.has_projects == "1"),
                                if (course.courses.first.has_coding != "")
                                  getTag("coding",
                                      course.courses.first.has_coding == "1"),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            MaterialButton(
                                onPressed: course.schedules.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CourseSchedules(
                                                        title: course.courses
                                                            .first.course_name,
                                                        courseSchedules:
                                                            course.schedules)));
                                      },
                                color: MainColor.darkGreen,
                                minWidth: double.infinity,
                                child: course.schedules.isNotEmpty
                                    ? const Text(
                                        "Check Schedule",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Text(
                                        "No Schedule",
                                        style: TextStyle(color: Colors.red),
                                      ))
                          ],
                        )),
                ],
              )),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
