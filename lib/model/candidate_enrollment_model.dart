class CandidateEnrollmentModel {
  final String enrollmentId;
  final String enrollmentName;
  final String eventCity;
  final String enrollmentDate;

  CandidateEnrollmentModel({
    required this.enrollmentId,
    required this.enrollmentName,
    required this.eventCity,
    required this.enrollmentDate,
  });

  factory CandidateEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return CandidateEnrollmentModel(
      enrollmentId: json['enroll_id'] as String,
      enrollmentName: json['event_name'] as String,
      eventCity: json['event_city_name'] as String,
      enrollmentDate: json['create_date'] as String,
    );
  }
}
