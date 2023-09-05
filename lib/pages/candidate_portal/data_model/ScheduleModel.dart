class ScheduleModel {
  final String trainer_id;
  final String trainer_name;
  final String classroom_facility_id;
  final String classroom_name;
  final String centre_name;
  final String centre_email;
  final String centre_phone;
  final String centre_address;
  final String event_start_date;
  final String event_start_time;
  final String event_end_time;

  ScheduleModel({
    required this.trainer_id,
    required this.trainer_name,
    required this.classroom_facility_id,
    required this.classroom_name,
    required this.centre_name,
    required this.centre_email,
    required this.centre_phone,
    required this.centre_address,
    required this.event_start_date,
    required this.event_start_time,
    required this.event_end_time,
    });


  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
        trainer_id: json["trainer_id"]??"",
        trainer_name: json["trainer_name"]??"",
        classroom_facility_id: json["classroom_facility_id"]??"",
        classroom_name: json["classroom_name"]??"",
        centre_name: json["centre_name"]??"",
        centre_email: json["centre_email"]??"",
        centre_phone: json["centre_phone"]??"",
        centre_address: json["centre_address"]??"",
        event_start_date: json["event_start_date"]??"",
        event_start_time: json["event_start_time"]??"",
        event_end_time: json["event_end_time"]??"",
    );
  }
}
