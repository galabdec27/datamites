
import 'candidate_model.dart';
import 'referral_status_model.dart';

class ReferralModel {
  final String candidate_id;
  final String referral_id;
  final String referral_amount;
  final String course_id;
  final String user_id;
  final String status;
  final String created_date;
  final CandidateModel candidateModel;
  final List<ReferralStatusModel> referralStatusModel;

  ReferralModel(
      {required this.candidate_id,
      required this.referral_id,
      required this.referral_amount,
      required this.course_id,
      required this.user_id,
      required this.status,
      required this.created_date,
      required this.candidateModel,
      required this.referralStatusModel});

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> body = json['referral_status'] as List;

    return ReferralModel(
        candidate_id: json['candidate_id'] as String,
        referral_id: json['referral_id'] as String,
        referral_amount: json['referral_amount'] as String,
        course_id: json['course_id'] as String,
        user_id: json['user_id'] as String,
        status: json['status'] as String,
        created_date: json['created_date'] as String,
        candidateModel: CandidateModel.fromJson(json['candidate']),
        referralStatusModel: body
            .map(
              (dynamic item) => ReferralStatusModel.fromJson(item),
            )
            .toList());
  }
}
