import 'CourseEventModel.dart';

class CourseModel {
  final String course_id;
  final String brands_details_id;
  final String course_name;
  final String course_shortname;
  final String course_type;
  final String cert_cost;
  final String course_material_url;
  final String course_exam_url;
  final String elearn_username;
  final String course_status;
  final String actual_cert_cost;
  final String mbook_cost;
  final String course_description;
  final String course_duration;
  final String course_code;
  final String has_assessment;
  final String has_placement_assistance;
  final String has_internship;
  final String has_projects;
  final String has_coding;
  final String course_language;
  final String course_level;


  CourseModel(
      {
        required this.course_id,
        required this.brands_details_id,
        required this.course_name,
        required this.course_shortname,
        required this.course_type,
        required this.cert_cost,
        required this.course_material_url,
        required this.course_exam_url,
        required this.elearn_username,
        required this.course_status,
        required this.actual_cert_cost,
        required this.mbook_cost,
        required this.course_description,
        required this.course_duration,
        required this.course_code,
        required this.has_assessment,
        required this.has_placement_assistance,
        required this.has_internship,
        required this.has_projects,
        required this.has_coding,
        required this.course_language,
        required this.course_level
      });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
        course_id: json["course_id"] ?? "",
        brands_details_id: json["brands_details_id"] ?? "",
        course_name: json["course_name"] ?? "",
        course_shortname: json["course_shortname"] ?? "",
        course_type: json["course_type"] ?? "",
        cert_cost: json["cert_cost"] ?? "",
        course_material_url: json["course_material_url"] ?? "",
        course_exam_url: json["course_exam_url"] ?? "",
        elearn_username: json["elearn_username"] ?? "",
        course_status: json["course_status"] ?? "",
        actual_cert_cost: json["actual_cert_cost"] ?? "",
        mbook_cost: json["mbook_cost"] ?? "",
        course_description: json["course_description"] ?? "",
        course_duration: json["course_duration"] ?? "",
        course_code: json["course_code"] ?? "",
        has_assessment: json["has_assessment"] ?? "",
        has_placement_assistance: json["has_placement_assistance"] ?? "",
        has_internship: json["has_internship"] ?? "",
        has_projects: json["has_projects"] ?? "",
        has_coding: json["has_coding"] ?? "",
        course_language: json["course_language"] ?? "",
        course_level: json["course_level"] ?? "",
    );
  }
}
