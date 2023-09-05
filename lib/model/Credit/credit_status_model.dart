class CreditStatusModel {
  final String credit_status_id;
  final String credit_amt;
  final String status;
  final String created_date;

  CreditStatusModel(
      {required this.credit_status_id,
      required this.credit_amt,
      required this.status,
      required this.created_date});

  factory CreditStatusModel.fromJson(Map<String, dynamic> json) {
    return CreditStatusModel(
        credit_status_id: json['credit_status_id'] as String,
        credit_amt: json['credit_amt'] as String,
        status: json['status'] as String,
        created_date: json['created_date'] as String);
  }
}
