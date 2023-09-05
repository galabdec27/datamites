class FreshdeskMessageModel {
  String description;
  String subject;
  String email;
  String phone;
  String priority;
  String source;
  String status;
  String type;

  FreshdeskMessageModel({
    required this.description,
    required this.subject,
    required this.email,
    required this.phone,
    required this.priority,
    required this.source,
    required this.status,
    required this.type,
  });
}

class FreshDeskStarterModel {
  getFreshdeskModel() {
    return FreshdeskMessageModel(
        description: "",
        subject: "",
        email: "",
        phone: "",
        priority: "3",
        source: "3",
        status: "2",
        type: "General Requests");
  }

  String getFreshdeskJson(FreshdeskMessageModel freshdeskMessageModel) {
    return  '{"description": "${freshdeskMessageModel.description}",'
        '"subject": "${freshdeskMessageModel.subject}",'
        '"email": "${freshdeskMessageModel.email}",'
        '"phone": "${freshdeskMessageModel.phone}",'
        '"priority": ${freshdeskMessageModel.priority},'
        '"status": ${freshdeskMessageModel.status},'
        '"source": ${freshdeskMessageModel.source},'
        '"type": "${freshdeskMessageModel.type}"}';
  }
}
