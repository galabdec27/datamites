

import 'course_price_model.dart';

class CourseListModel {
  final int course_id;
  final int parent_course_id;
  final String course_name;
  final String course_shortname;
  final String course_cimg;
  final String course_frontdesc;
  final int live_project_cnt;
  final String course_reviewcount;
  final String course_mob_img_link;
  final CoursePriceModel coursePriceModel;

  CourseListModel({
    required this.course_id,
    required this.parent_course_id,
    required this.course_name,
    required this.course_shortname,
    required this.course_cimg,
    required this.course_frontdesc,
    required this.live_project_cnt,
    required this.course_reviewcount,
    required this.course_mob_img_link,
    required this.coursePriceModel
  });

  factory CourseListModel.fromJson(Map<String, dynamic> json) {
    return CourseListModel(
      course_id: json['course_id'] as int,
      parent_course_id: json['parent_course_id'] as int,
      course_name: json['course_name'] as String,
      live_project_cnt: json['live_project_cnt'] as int,
      course_shortname: json['course_shortname']??"" as String,
      course_cimg: json['course_cimg']??"" as String,
      course_frontdesc: json['course_frontdesc']??"" as String,
      course_reviewcount: json['course_reviewcount']??"" as String,
      course_mob_img_link: json['course_mob_img_link']??"" as String,
      coursePriceModel: CoursePriceModel.fromJson(json['course_price']),
    );
  }
}
