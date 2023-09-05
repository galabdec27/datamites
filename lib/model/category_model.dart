class CategoryModel {
  final int course_id;
  final String course_name;
  final String course_shortname;
  final String course_frontdesc;
  final String course_shortdesc;
  final int course_status;
  final String permalink;
  final String course_cimg;
  final String course_reviewcount;
  final String course_mob_img_link;

  CategoryModel({
    required this.course_id,
    required this.course_name,
    required this.course_shortname,
    required this.course_frontdesc,
    required this.course_shortdesc,
    required this.course_status,
    required this.permalink,
    required this.course_cimg,
    required this.course_reviewcount,
    required this.course_mob_img_link,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      course_id: json['course_id'] as int,
      course_status: json['course_status'] as int,
      course_name: json['course_name'] as String,
      course_shortname: json['course_shortname'] as String,
      course_frontdesc: json['course_frontdesc'] as String,
      course_shortdesc: json['course_shortdesc'] as String,
      permalink: json['permalink'] as String,
      course_cimg: json['course_cimg'] as String,
      course_reviewcount: json['course_reviewcount'] as String,
      course_mob_img_link: json['course_mob_img_link'] as String,
    );
  }
}
