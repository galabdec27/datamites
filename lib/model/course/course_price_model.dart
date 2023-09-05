import 'country_model.dart';

class CoursePriceModel {
  final int course_price_id;

  final String classroom_bprice;
  final String classroom_dprice;

  // final String classroom_desc;

  final String live_virtual_bprice;
  final String live_virtual_dprice;

  // final String live_virtual_desc;

  final String self_learning_bprice;
  final String self_learning_dprice;

  // final String self_learning_desc;

  final CountryModel countryModel;

  CoursePriceModel(
      {required this.course_price_id,
      required this.classroom_bprice,
      required this.classroom_dprice,
      // @required this.classroom_desc,

      required this.live_virtual_bprice,
      required this.live_virtual_dprice,
      // @required this.live_virtual_desc,

      required this.self_learning_bprice,
      required this.self_learning_dprice,
      // @required this.self_learning_desc,

      required this.countryModel
      });

  factory CoursePriceModel.fromJson(Map<String, dynamic> json) {
    return CoursePriceModel(
        course_price_id: json['course_price_id'] as int,
        classroom_bprice: json['classroom_bprice']??"" as String,
        classroom_dprice: json['classroom_dprice']??"" as String,
        // classroom_desc: json['classroom_desc'] as String,

        live_virtual_bprice: json['live_virtual_bprice']??"" as String,
        live_virtual_dprice: json['live_virtual_dprice']??"" as String,
        // live_virtual_desc: json['live_virtual_desc'] as String,

        self_learning_bprice: json['self_learning_bprice']??"" as String,
        self_learning_dprice: json['self_learning_dprice']??"" as String,
        // self_learning_desc: json['self_learning_desc'] as String,

        countryModel: CountryModel.fromJson(json['country'])
        );
  }
}
