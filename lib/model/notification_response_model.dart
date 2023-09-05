import 'notification_model.dart';

class NotificationResponseModel {
  final String msg;
  final int statuscode;
  final List<NotificationModel> notificationList;

  NotificationResponseModel(
      {required this.msg,
        required this.statuscode,
        required this.notificationList});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> body = json['notification_details'] as List;
    // print(body);
    return NotificationResponseModel(
        msg: json['msg'] as String,
        statuscode: json['statuscode'] as int,
        notificationList: body
            .map(
              (dynamic item) => NotificationModel.fromJson(item),
        )
            .toList());
  }
}
