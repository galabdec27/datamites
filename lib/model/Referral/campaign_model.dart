import 'package:flutter/foundation.dart';

class Campaign {
  final String campaignId;
  final String courseName;
  final String courseAbbreviation;
  final String coursePrice;

  Campaign(
      {required this.campaignId,
      required this.coursePrice,
      required this.courseName,
      required this.courseAbbreviation});

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
        campaignId: json['id'] as String,
        coursePrice: json['coursePrice'] as String,
        courseName: json['ReferralCourse']['course_name'],
        courseAbbreviation: json['ReferralCourse']['course_abbr'] as String);
  }
}
