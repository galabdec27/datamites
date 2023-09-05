import 'course_price_mode_general.dart';

import 'country_model.dart';
import 'course_price_model.dart';

class RecommendedCourseModel {
  final int course_id;
  final String course_name;
  final String course_shortname;
  final String course_frontdesc;
  final String course_cimg;
  final String course_reviewcount;
  final String course_mob_img_link;
  final CoursePriceModelGeneral coursePriceModel;
  // CountryModel countryModel;

  RecommendedCourseModel({
    required this.course_id,
    required this.course_name,
    required this.course_shortname,
    required this.course_frontdesc,
    required this.course_cimg,
    required this.course_reviewcount,
    required this.course_mob_img_link,
    required this.coursePriceModel,
    // @required this.countryModel,
  });

  factory RecommendedCourseModel.fromJson(Map<String, dynamic> json) {
    return RecommendedCourseModel(
      course_id: json['course_id'] as int,
      course_name: json['course_name'] as String,
      course_shortname: json['course_shortname'] as String,
      course_frontdesc: json['course_frontdesc'] as String,
      course_cimg: json['course_cimg'] as String,
      course_reviewcount: json['course_reviewcount'] as String,
      course_mob_img_link: json['course_mob_img_link'] as String,
      coursePriceModel: CoursePriceModelGeneral.fromJson(json['course_price']),
      // countryModel: json['countryModel'] as CountryModel,
    );
  }
}
