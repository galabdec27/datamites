class ClassEventModel {
  final String class_id;
  final String class_name;
  final String class_date;
  final String trainer;

  ClassEventModel(
      {required this.class_id,
      required this.class_name,
      required this.class_date,
      required this.trainer});

  factory ClassEventModel.fromJson(Map<String, dynamic> json) {
    return ClassEventModel(
        class_id: json['class_id'] as String,
        class_name: json['class_name'] as String,
        class_date: json['class_date'] as String,
        trainer: json['trainer'] as String);
  }
}
