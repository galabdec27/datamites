class CandidateActivitiesModel {
  final String activityId;
  final String activityName;
  final String activityDetail;
  final String activityStatus;
  final String activityComment;
  final String activityDate;

  CandidateActivitiesModel({
    required this.activityId,
    required this.activityName,
    required this.activityDetail,
    required this.activityStatus,
    required this.activityComment,
    required this.activityDate,
  });

  factory CandidateActivitiesModel.fromJson(Map<String, dynamic> json) {
    return CandidateActivitiesModel(
      activityId: json['candidate_activity_log_id']??"",
      activityName: json['name']??"",
      activityDetail: json['activity_desc']??"",
      activityStatus: json['activity_status']??"",
      activityComment: json['activity_comments']??"",
      activityDate: json['activity_date']??"" ,
    );
  }
}
