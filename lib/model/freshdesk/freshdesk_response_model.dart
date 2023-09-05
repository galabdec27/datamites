class FreshdeskResponseModel {
  int id;
  String type;
  String subject;
  int source;
  int status;
  int priority;
  String created_at;
  String updated_at;

  FreshdeskResponseModel({
    required this.id,
    required this.type,
    required this.subject,
    required this.source,
    required this.status,
    required this.priority,
    required this.created_at,
    required this.updated_at,
  });

  factory FreshdeskResponseModel.fromJson(Map<String, dynamic> json) {

    print(json['subject']);
    return FreshdeskResponseModel(
        id: json['id'] as int,
        type: json['type'] as String,
        subject: json['subject'] as String,
        source: json['source'] as int,
        status: json['status'] as int,
        priority: json['priority'] as int,
        created_at: json['created_at'] as String,
        updated_at: json['updated_at'] as String
    );
  }
}
