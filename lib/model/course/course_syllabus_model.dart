class CourseSyllabusModel {
  final int course_syllabus_id;
  final int course_id;
  final int country_id;
  final int h_status;
  final String syllabus_title;
  final String syllabus_desc;

  CourseSyllabusModel({
    required this.course_syllabus_id,
    required this.course_id,
    required this.country_id,
    required this.h_status,
    required this.syllabus_title,
    required this.syllabus_desc,
  });

  factory CourseSyllabusModel.fromJson(Map<String, dynamic> json) {
    return CourseSyllabusModel(
      course_syllabus_id: json['course_syllabus_id'] as int,
      course_id: json['course_id'] as int,
      country_id: json['country_id'] as int,
      h_status: json['h_status'] as int,
      syllabus_title: json['syllabus_title'] as String,
      syllabus_desc: json['syllabus_desc'] as String,
    );
  }
}
