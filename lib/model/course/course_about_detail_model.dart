class CourseAboutDetailModel {
  final int course_about_details_id;
  final int course_id;
  final int ad_status;
  final String ad_title;
  final String ad_descripition;

  CourseAboutDetailModel({
    required this.course_about_details_id,
    required this.course_id,
    required this.ad_status,
    required this.ad_title,
    required this.ad_descripition,
  });

  factory CourseAboutDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseAboutDetailModel(
      course_about_details_id: json['course_about_details_id'] as int,
      course_id: json['course_id'] as int,
      ad_status: json['ad_status'] as int,
      ad_title: json['ad_title'] as String,
      ad_descripition: json['ad_descripition'] as String,
    );
  }
}
