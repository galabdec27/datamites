import '../pages/candidate_portal/data_model/RatingModel.dart';
import 'class_event.dart';

class ClassCodeV2Model {
  final int status;
  final String class_code;
  final String zoom_link;
  final String msg;
  final String background_color;
  final String front_color;
  final String payment_url;
  final String payment_amount;
  final String batch_id;
  final String batch_name;
  final String course_name;
  final int is_rating_needed;
  final List<RatingModel> ratings;

  ClassCodeV2Model(
      {required this.status,
      required this.class_code,
      required this.zoom_link,
      required this.msg,
      required this.background_color,
      required this.front_color,
      required this.payment_url,
      required this.payment_amount,
      required this.batch_id,
      required this.batch_name,
        required this.is_rating_needed,
        required this.course_name,
      required this.ratings,});

  factory ClassCodeV2Model.fromJson(Map<String, dynamic> json) {
    return ClassCodeV2Model(
      status: int.parse(json['status'].toString()),
      class_code: json['classcode'] as String,
      zoom_link: json['zoom_link'] as String,
      msg: json['msg'] as String,
      background_color: json['background_color'] as String,
      front_color: json['front_color'] as String,
      payment_url: json['payment_url'] as String,
      payment_amount: json['payment_amount'] as String,
      batch_id: json['batch_id'] as String,
      course_name: json['course_name'] as String,
      is_rating_needed: int.parse(json['is_rating_needed'].toString()),
      batch_name: json['batch_name'],
      ratings: (json['rating'] as List)
          .map(
            (dynamic item) => RatingModel.fromJson(item),
          )
          .toList(),

    );
  }
}
