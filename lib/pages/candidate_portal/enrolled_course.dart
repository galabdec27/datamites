import 'package:datamites/helper/color.dart';
import 'package:datamites/model/user_model.dart';
import 'package:datamites/pages/candidate_portal/candidate_rest_request.dart';
import 'package:datamites/pages/candidate_portal/data_model/EnrollmentModel.dart';
import 'package:datamites/pages/candidate_portal/enrolled_course_details.dart';
import 'package:flutter/material.dart';

import '../../helper/connection.dart';
import '../../helper/user_details.dart';
import '../../widgets/CustomWidget.dart';
import '../main_page.dart';

class EnrolledCourse extends StatefulWidget {
  const EnrolledCourse({Key? key}) : super(key: key);

  @override
  State<EnrolledCourse> createState() => _EnrolledCourseState();
}

class _EnrolledCourseState extends State<EnrolledCourse> {
  CandidateRestRequest candidateRestRequest = CandidateRestRequest();
  List<EnrollmentModel> enrolledCourses = [];
  bool loaded = false;
  bool loading = true;

  void loadData() async {
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
      enrolledCourses = await candidateRestRequest.getCourseEnrollment(context);
      setState(() {
        loaded = true;
        loading = false;
      });
    }
  }

  var userDetails = UserDetails();
  UserModel? userModel;

  _getUserDetail() async {
    userModel = await userDetails.getDetail();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    _getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: CustomWidget.getDatamitesAppBar(context, userModel, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(enrolledCourses.isNotEmpty) const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
                  child: Text(
                    "Enrolled Courses",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                if (loaded && enrolledCourses.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 64,
                        ),
                        const Text("No any enrollment found"),
                        const SizedBox(
                          height: 8,
                        ),
                        MaterialButton(
                          onPressed: () {
                            loadData();
                          },
                          color: MainColor.darkGreen,
                          child: const Text("Refresh", style: TextStyle(color: Colors.white),),
                        )
                      ],
                    ),
                  ),
                if (loaded && enrolledCourses.isNotEmpty)
                  for (EnrollmentModel enrolledCourse in enrolledCourses)
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EnrolledCourseDetails(
                                enrollmentModel: enrolledCourse)));
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enrolledCourse.bundle_name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(enrolledCourse.bundle_event_name),
                            Text(
                                "Duration: ${enrolledCourse.bundle_total_duration} weeks"),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("INR ${enrolledCourse.agreed_price}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
              ],
            ),
          ),
          if (loading)
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
