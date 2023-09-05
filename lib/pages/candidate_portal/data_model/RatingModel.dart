class RatingModel {
  final String rating_id;
  final String course_event_id;
  final String enrolment_id;
  final String trainer_schedule_id;
  final String course_event_start_date;
  final String course_event_start_time;
  final String course_event_end_time;
  final String training_feedback_rating_overall;
  final String training_feedback_rating_material;
  final String training_feedback_rating_trainer;
  final String training_feedback_rating_facility;
  final String trainer_name;
  final String course_name;
  final String course_event_name;

  RatingModel(
      {required this.rating_id,
      required this.course_event_id,
      required this.enrolment_id,
      required this.trainer_schedule_id,
      required this.course_event_start_date,
      required this.course_event_start_time,
      required this.course_event_end_time,
      required this.training_feedback_rating_overall,
      required this.training_feedback_rating_material,
      required this.training_feedback_rating_trainer,
      required this.training_feedback_rating_facility,
      required this.trainer_name,
      required this.course_name,
      required this.course_event_name});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
        rating_id: json["rating_id"] ?? "",
        course_event_id: json["course_event_id"] ?? "",
        enrolment_id: json["enrolment_id"] ?? "",
        trainer_schedule_id: json["trainer_schedule_id"] ?? "",
        course_event_start_date: json["course_event_start_date"] ?? "",
        course_event_start_time: json["course_event_start_time"] ?? "",
        course_event_end_time: json["course_event_end_time"] ?? "",
        training_feedback_rating_overall:
            (json["training_feedback_rating_overall"] ?? "0").isEmpty
                ? "0"
                : json["training_feedback_rating_overall"] ?? "0",
        training_feedback_rating_material:
            (json["training_feedback_rating_material"] ?? "0").isEmpty
                ? "0"
                : json["training_feedback_rating_material"] ?? "0",
        training_feedback_rating_trainer:
            (json["training_feedback_rating_trainer"] ?? "0").isEmpty
                ? "0"
                : json["training_feedback_rating_trainer"] ?? "0",
        training_feedback_rating_facility:
            (json["training_feedback_rating_facility"] ?? "0").isEmpty
                ? "0"
                : json["training_feedback_rating_facility"] ?? "0",
        trainer_name: json["trainer_name"] ?? "",
        course_name: json["course_name"] ?? "",
        course_event_name: json["course_event_name"] ?? "");
  }
}
