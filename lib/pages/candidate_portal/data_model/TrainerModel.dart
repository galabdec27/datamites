class TrainerModel {
  final int trainer_id;
  final String trainer_name;
  final String trainer_email;
  final String trainer_phone;

  TrainerModel({required this.trainer_id,
    required this.trainer_name,
    required this.trainer_email,
    required this.trainer_phone});


  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
        trainer_id: json["trainer_id"]??0,
        trainer_name: json["trainer_name"]??"",
        trainer_email: json["trainer_email"]??"",
        trainer_phone: json["trainer_phone"]??"");
  }
}
