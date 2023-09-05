import 'package:datamites/pages/candidate_portal/data_model/ScheduleModel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/user_details.dart';
import '../../model/user_model.dart';
import '../../widgets/CustomWidget.dart';

class CourseSchedules extends StatefulWidget {
  final String title;
  final List<ScheduleModel> courseSchedules;

  const CourseSchedules(
      {Key? key, required this.title, required this.courseSchedules})
      : super(key: key);

  @override
  State<CourseSchedules> createState() => _CourseSchedulesState();
}

class _CourseSchedulesState extends State<CourseSchedules> {
  _gotoUrl(String url) async {
    // ignore: deprecated_member_use
    launch(url);
  }



  var userDetails = UserDetails();
  UserModel? userModel;

  _getUserDetail() async {
    userModel = await userDetails.getDetail();
    setState(() {});
  }



  @override
  void initState() {
    _getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidget.getDatamitesAppBar(context, userModel, 1),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            for (ScheduleModel schedule in widget.courseSchedules)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black38),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(schedule.classroom_facility_id.isNotEmpty) Container(
                          child: (schedule.classroom_facility_id.isNotEmpty)
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.apartment,
                                      size: 32,
                                    ),
                                    Text(
                                        "\tCentre: ${schedule.centre_name}\n\tClassroom: ${schedule.classroom_name}")
                                  ],
                                )
                              : Text(""),
                        ),
                      ],
                    ),
                    // Text(
                    //   courseEvent.course_event_description,
                    //   style: const TextStyle(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 12,
                    //       color: Colors.black38),
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (schedule.event_start_date.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_sharp, size: 14,),
                          const SizedBox(width: 8,),
                          Text(
                            schedule.event_start_date,
                          ),
                        ],
                      ),
                    if (schedule.event_start_date.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14,),
                          const SizedBox(width: 8,),
                          Text("${schedule.event_start_time.length == 8 ? schedule.event_start_time.substring(0,5):schedule.event_start_time} "
                              "to ${schedule.event_end_time.length == 8 ? schedule.event_end_time.substring(0,5):schedule.event_end_time} (IST)"),
                        ],
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (schedule.classroom_facility_id.isNotEmpty)
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Center Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),

                                      if (schedule.centre_email.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              size: 18,
                                            ),
                                            Text(
                                                " ${schedule.centre_email}")
                                          ],
                                        ),

                                      if (schedule.centre_phone.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone_outlined,
                                              size: 18,
                                            ),
                                            Text(
                                                " ${schedule.centre_phone}")
                                          ],
                                        ),
                                      if (schedule.centre_address.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                            ),
                                            Text(
                                                " ${schedule.centre_address}")
                                          ],
                                        ),
                                    ],
                                  )),
                            if (schedule.trainer_id.isNotEmpty)
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Trainer Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if (schedule.trainer_name.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person_outline,
                                              size: 18,
                                            ),
                                            Text(
                                                " ${schedule.trainer_name}")
                                          ],
                                        ),
                                    ],
                                  )),
                          ],
                        ),
                      )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
