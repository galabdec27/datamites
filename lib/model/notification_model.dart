class NotificationModel {
  final String notification_id;
  final String title;
  final String description;
  final String user_id;
  final String action;
  final String? sub_action;
  final String? external_ur;
  final String? image;
  final String? external_action;
  final String? is_seen;
  final String? status;
  final String? created_at;

  NotificationModel(
      {required this.notification_id,
        required this.title,
        required this.description,
        required this.user_id,
        required this.action,
        this.sub_action,
        this.external_ur,
        this.image,
        this.external_action,
        this.is_seen,
        this.status,
        this.created_at});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        notification_id: json['notification_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        user_id: json['user_id'] as String,
        action: json['action'],
        sub_action: json['sub_acction'],
        external_ur: json['external_ur'],
        image: json['image']??"",
        external_action: json['external_action'],
        is_seen: json['is_seen'],
        status: json['status'],
        created_at: json['created_at']);
  }
}
