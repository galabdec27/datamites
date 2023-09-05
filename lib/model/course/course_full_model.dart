class CourseFullModel {
  final int course_id;
  final String course_name;
  final String course_shortname;
  final String course_frontdesc;

  final String course_desc;
  final String permalink;
  final int parent_course_flag;
  final String course_cimg;

  final String course_img;
  final String course_reviewcount;
  final String course_bloglink;
  final String course_mbannerdesc;
  final String course_training;
  final String course_mob_img_link;

  final String meta_title;
  final String meta_desc;
  final String meta_keyword;
  final int live_project_cnt;
  final String syllabus_link;

  final String course_desc_titile;
  final String course_recommended;
  final String course_classroom;
  final String course_trending_section;

  CourseFullModel({
    required this.course_id,
    required this.course_name,
    required this.course_shortname,
    required this.course_frontdesc,
    required this.course_desc,
    required this.permalink,
    required this.parent_course_flag,
    required this.course_cimg,
    required this.course_img,
    required this.course_reviewcount,
    required this.course_bloglink,
    required this.course_mbannerdesc,
    required this.course_training,
    required this.course_mob_img_link,
    required this.meta_title,
    required this.meta_desc,
    required this.meta_keyword,
    required this.live_project_cnt,
    required this.syllabus_link,
    required this.course_desc_titile,
    required this.course_recommended,
    required this.course_classroom,
    required this.course_trending_section,
  });

  factory CourseFullModel.fromJson(Map<String, dynamic> json) {
    return CourseFullModel(
      course_id: json['course_id'] as int,
      course_name: json['course_name'] as String,
      course_shortname: json['course_shortname'] as String,
      course_frontdesc: json['course_frontdesc'] as String,
      course_desc: json['course_desc'] as String,
      permalink: json['permalink'] as String,
      parent_course_flag: json['parent_course_flag'] as int,
      course_cimg: json['course_cimg'] as String,
      course_img: json['course_img'] as String,
      course_reviewcount: json['course_reviewcount'] as String,
      course_bloglink: json['course_bloglink'] as String,
      course_mbannerdesc: json['course_mbannerdesc'] as String,
      course_training: json['course_training'] as String,
      course_mob_img_link: json['course_mob_img_link'] as String,
      meta_title: json['meta_title'] as String,
      meta_desc: json['meta_desc'] as String,
      meta_keyword: json['meta_keyword'] as String,
      live_project_cnt: json['live_project_cnt'] as int,
      syllabus_link: json['syllabus_link'] as String,
      course_desc_titile: json['course_desc_titile'] as String,
      course_recommended: json['course_recommended'] as String,
      course_classroom: json['course_classroom'] as String,
      course_trending_section: json['course_trending_section'] as String,
    );
  }
}