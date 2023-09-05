class FacilityCentreModel {
  final int centre_id;
  final String centre_name;
  final String centre_address;
  final String centre_map_link;
  final int centre_type;
  final String centre_contact_name;
  final String centre_contact_email;
  final String centre_contact_phone;

  FacilityCentreModel(
      {required this.centre_id,
      required this.centre_name,
      required this.centre_address,
      required this.centre_map_link,
      required this.centre_type,
      required this.centre_contact_name,
      required this.centre_contact_email,
      required this.centre_contact_phone});

  factory FacilityCentreModel.fromJson(Map<String, dynamic> json) {
    return FacilityCentreModel(
        centre_id: json["centre_id"] ?? 0,
        centre_type: json["centre_type"] ?? 0,
        centre_name: json["centre_name"] ?? "",
        centre_address: json["centre_address"] ?? "",
        centre_map_link: json["centre_map_link"] ?? "",
        centre_contact_name: json["centre_contact_name"] ?? "",
        centre_contact_email: json["centre_contact_email"] ?? "",
        centre_contact_phone: json["centre_contact_phone"] ?? "");
  }
}
