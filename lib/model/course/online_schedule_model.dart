class OnlineScheduleModel {
  final int training_list_id;
  final String training_name;
  final String training_date;
  final String training_start_time;
  final String training_end_time;

  OnlineScheduleModel({
    required this.training_list_id,
    required this.training_name,
    required this.training_date,
    required this.training_start_time,
    required this.training_end_time,
  });

  factory OnlineScheduleModel.fromJson(Map<String, dynamic> json) {
    return OnlineScheduleModel(
      training_list_id: json['training_list_id'] as int,
      training_name: json['training_name'] as String,
      training_date: json['training_date'] as String,
      training_start_time: json['training_start_time'] as String,
      training_end_time: json['training_end_time'] as String,
    );
  }
}
