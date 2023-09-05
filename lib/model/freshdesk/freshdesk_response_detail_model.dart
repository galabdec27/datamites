import 'package:flutter_phoenix/generated/i18n.dart';

class FreshdeskResponseDetailModel {
  int id;
  String type;
  String subject;
  int source;
  int status;
  int priority;
  String created_at;
  String updated_at;
  String description;

  FreshdeskResponseDetailModel({
    required this.id,
    required this.type,
    required this.subject,
    required this.source,
    required this.status,
    required this.priority,
    required this.created_at,
    required this.updated_at,
    required this.description
  });

  factory FreshdeskResponseDetailModel.fromJson(Map<String, dynamic> json) {

    print(json['subject']);
    return FreshdeskResponseDetailModel(
        id: json['id'] as int,
        type: json['type'] as String,
        subject: json['subject'] as String,
        source: json['source'] as int,
        status: json['status'] as int,
        priority: json['priority'] as int,
        created_at: json['created_at'] as String,
        updated_at: json['updated_at'] as String,
        description: json["description"] as String
    );
  }
}
