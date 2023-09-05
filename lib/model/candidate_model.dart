class CandidateModel {
  final String candidateId;
  final String candidateName;
  final String candidateEmail;
  final String candidatePhone;
  final String cityId;
  final String candidateCompany;
  final String candidateDesignation;
  final String candidateStatus;
  final String candidateReferralId;
  final String createdDate;
  final String updatedDate;
  final String candidateAddress;
  final String countryCode;
  final String blockStatus;

  CandidateModel({
    required this.candidateId,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidatePhone,
    required this.cityId,
    required this.candidateCompany,
    required this.candidateDesignation,
    required this.candidateStatus,
    required this.candidateReferralId,
    required this.createdDate,
    required this.updatedDate,
    required this.candidateAddress,
    required this.countryCode,
    required this.blockStatus,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      candidateId: json['candidate_id'] as String,
      candidateName: json['candidate_name'] as String,
      candidateEmail: json['candidate_email'] as String,
      candidatePhone: json['candidate_phone'] as String,
      cityId: json['city_id'] as String,
      candidateCompany: json['candidate_company'] as String,
      candidateDesignation: json['candidate_designation'] as String,
      candidateStatus: json['candidate_status'] as String,
      candidateReferralId: json['candidate_referal_id'] as String,
      createdDate: json['create_date'] as String,
      updatedDate: json['update_date'] as String,
      candidateAddress: json['candidate_address'] as String,
      countryCode: json['block_status'] as String,
      blockStatus: json['country_code'] as String,
    );
  }
}
