import 'FacilityCentreModel.dart';

class ClassroomFacilityModel {
  final int classroom_facility_id;
  final String facility_name;
  final int has_projector;
  final int has_ac;
  final FacilityCentreModel facilityCentre;

  ClassroomFacilityModel(
      {required this.classroom_facility_id,
      required this.facility_name,
      required this.has_projector,
      required this.has_ac,
      required this.facilityCentre});

  factory ClassroomFacilityModel.fromJson(Map<String, dynamic> json) {

    return ClassroomFacilityModel(
      classroom_facility_id: json["classroom_facility_id"] ?? 0,
      facility_name: json["facility_name"] ?? "",
      has_projector: json["has_projector"] ?? 0,
      has_ac: json["has_ac"] ?? 0,
      facilityCentre: FacilityCentreModel.fromJson(json["centre"]),
    );
  }
}
