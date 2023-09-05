class ReferralStatusModel {
  final String referral_status_id;
  final String referral_id;
  final String referral_amt;
  final String status;
  final String created_date;
  String? comments;

  ReferralStatusModel(
      {required this.referral_status_id,
      required this.referral_id,
      required this.referral_amt,
      required this.status,
      this.comments,
      required this.created_date});

  factory ReferralStatusModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatusModel(
        referral_status_id: json['referral_status_id'] as String,
        referral_id: json['referral_id'] as String,
        referral_amt: json['referral_amt'] as String,
        status: json['status'] as String,
        comments: json['comments'],
        created_date: json['created_date'] as String);
  }
}
