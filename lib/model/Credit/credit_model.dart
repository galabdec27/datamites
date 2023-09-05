import '../Referral/candidate_model.dart';
import 'credit_status_model.dart';

class CreditModel {
  final String candidate_id;
  final String credit_id;
  final String credit_amt;
  final String course_id;
  final String user_id;
  final String status;
  final String created_date;
  final CandidateModel candidateModel;
  final List<CreditStatusModel> creditStatisList;

  CreditModel(
      {required this.candidate_id,
      required this.credit_id,
      required this.credit_amt,
      required this.course_id,
      required this.user_id,
      required this.status,
      required this.created_date,
      required this.candidateModel,
      required this.creditStatisList});

  factory CreditModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> body = json['credit_status'] as List;

    return CreditModel(
        candidate_id: json['candidate_id'] as String,
        credit_id: json['credit_id'] as String,
        credit_amt: json['credit_amt'] as String,
        course_id: json['course_id'] as String,
        user_id: json['user_id'] as String,
        status: json['status'] as String,
        created_date: json['created_date'] as String,
        candidateModel: CandidateModel.fromJson(json['candidate']),
        creditStatisList: body
            .map(
              (dynamic item) => CreditStatusModel.fromJson(item),
            )
            .toList());
  }
}
