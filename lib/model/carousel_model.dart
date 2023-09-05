class CarouselModel {
  final String id;
  final String image;
  final String action;
  final String? sub_action;
  final String? external_url;
  final String? external_action;

  CarouselModel(
      {required this.id,
        required this.image,
        required this.action,
        this.sub_action,
        this.external_url,
        this.external_action});

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
        id: json['id'] as String,
        image: json['image'] as String,
        action: json['action'],
        sub_action: json['sub_action'],
        external_url: json['external_url'],
        external_action: json['external_action']);
  }
}
