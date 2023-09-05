import 'package:datamites/model/carousel_model.dart';

class CarouselResponseModel {
  final String msg;
  final int statuscode;
  final List<CarouselModel> carouselList;

  CarouselResponseModel(
      {required this.msg,
      required this.statuscode,
      required this.carouselList});

  factory CarouselResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> body = json['carousels'] as List;
    return CarouselResponseModel(
        msg: json['msg'] as String,
        statuscode: json['statuscode'] as int,
        carouselList: body
            .map(
              (dynamic item) => CarouselModel.fromJson(item),
            )
            .toList());
  }
}
