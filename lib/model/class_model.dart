class ClassModel {
  final int class_id;
  final String class_name;
  final String class_date;

  ClassModel(
      {required this.class_id,
      required this.class_name,
      required this.class_date});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
        class_id: int.parse(json['class_id']) ,
        class_name: json['class_name'] as String,
        class_date: json['class_date'] as String,
        );
  }
}
