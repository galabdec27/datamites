import 'package:datamites/pages/candidate_portal/data_model/ScheduleModel.dart';

import 'CourseModel.dart';

class CourseEventModel {
  final String course_event_id;
  final String course_event_name;
  final String course_event_start_date;
  final String course_event_start_time;
  final String course_event_end_time;
  final String course_event_type;
  final String course_duration;
  final String course_event_status;
  List<CourseModel> courses;
  List<ScheduleModel> schedules;

  CourseEventModel(
      {required this.course_event_id,
      required this.course_event_name,
      required this.course_event_start_date,
      required this.course_event_start_time,
      required this.course_event_end_time,
      required this.course_event_type,
      required this.course_duration,
      required this.course_event_status,
      required this.courses,
      required this.schedules});

  factory CourseEventModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> courseBody = json["course"] as List;
    List<dynamic> schedulesBody = json["schedules"] as List;
    return CourseEventModel(
        course_event_id: json["course_event_id"] ?? "",
        course_event_name: json["course_event_name"] ?? "",
        course_event_start_date: json["course_event_start_date"] ?? "",
        course_event_start_time: json["course_event_start_time"] ?? "",
        course_event_end_time: json["course_event_end_time"] ?? "",
        course_event_type: json["course_event_type"] ?? "",
        course_duration: json["course_duration"] ?? "",
        course_event_status: json["course_event_status"] ?? "",
        courses: courseBody
            .map((dynamic item) => CourseModel.fromJson(item))
            .toList(),
        schedules: schedulesBody
            .map((dynamic item) => ScheduleModel.fromJson(item))
            .toList());
  }
}
