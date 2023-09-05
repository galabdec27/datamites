import 'package:flutter/foundation.dart';

class CandidateModel {
  final String candidate_id;
  final String name;
  final String phone;
  final String email;
  final String status;
  final String created_date;

  CandidateModel({
    required this.candidate_id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    required this.created_date,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      candidate_id: json['candidate_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      created_date: json['created_date'] as String,
    );
  }
}
