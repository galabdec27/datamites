import 'segmented_referral_model.dart';

class SegmentedReferralResponseModel {
  final int final_status;
  final int referral_amount;
  final bool success;
  final List<ReferralModelSegment> referralList;

  SegmentedReferralResponseModel(
      {required this.final_status,
      required this.referral_amount,
      required this.success,
      required this.referralList});

  factory SegmentedReferralResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> body = json['referralData'] as List;
    return SegmentedReferralResponseModel(
        final_status: json['final_status'] as int,
        referral_amount: json['referral_amount'] as int,
        success: json['success'] as bool,
        referralList: body
            .map(
              (dynamic item) => ReferralModelSegment.fromJson(item),
            )
            .toList());
  }
}
