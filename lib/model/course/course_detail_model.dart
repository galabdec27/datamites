import 'package:datamites/model/course/recommended_course_model.dart';

import 'country_model.dart';
import 'course_about_detail_model.dart';
import 'course_full_model.dart';
import 'course_price_mode_general.dart';
import 'course_syllabus_model.dart';
import 'online_schedule_model.dart';

class GeneralCourseDetailModel {
  final CourseFullModel courseModel;
  final CoursePriceModelGeneral coursePriceModel;

  final List<CourseSyllabusModel> courseSyllabusModel;
  final List<CourseAboutDetailModel> courseAboutDetailModel;

  final List<OnlineScheduleModel> onlineSchedule;
  final List<RecommendedCourseModel> recommendedCourse;
  final List<RecommendedCourseModel> trendingCourse;

  final CountryModel countryModel;

  GeneralCourseDetailModel(
      {required this.courseModel,
      required this.coursePriceModel,
      required this.courseSyllabusModel,
      required this.courseAboutDetailModel,
      required this.onlineSchedule,
      required this.recommendedCourse,
      required this.trendingCourse,
      required this.countryModel});

  factory GeneralCourseDetailModel.fromJson(Map<String, dynamic> json) {
    return GeneralCourseDetailModel(
      courseModel: CourseFullModel.fromJson(json["course"]),
      coursePriceModel: CoursePriceModelGeneral.fromJson(json["course_price"]),
      countryModel: CountryModel.fromJson(json["country"]),
      courseSyllabusModel: json["course_syllabus"]
          .map(
            (dynamic item) => CourseSyllabusModel.fromJson(item),
          )
          .toList()
          .cast<CourseSyllabusModel>(),
      courseAboutDetailModel: json["course_about_details"]
          .map(
            (dynamic item) => CourseAboutDetailModel.fromJson(item),
          )
          .toList()
          .cast<CourseAboutDetailModel>(),
      onlineSchedule: json["online_course"]
          .map(
            (dynamic item) => OnlineScheduleModel.fromJson(item),
          )
          .toList()
          .cast<OnlineScheduleModel>(),
      recommendedCourse: json["recommendedCourse"]
          .map(
            (dynamic item) => RecommendedCourseModel.fromJson(item),
          )
          .toList()
          .cast<RecommendedCourseModel>(),
      trendingCourse: json["trendingCourse"]
          .map(
            (dynamic item) => RecommendedCourseModel.fromJson(item),
          )
          .toList()
          .cast<RecommendedCourseModel>(),
    );
  }
}
