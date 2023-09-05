class PaymentModel {
  final String paymentDate;
  final String paymentAmount;

  PaymentModel(
      {required this.paymentDate, required this.paymentAmount});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
        paymentDate: json["enrollment_payment_details_date"]??"",
        paymentAmount: json["enrollment_payment_details_amount"]??"0"
    );
  }
}

class PaymentDetailModel {
  final String bundle_name;
  final String agreed_price;
  final List<PaymentModel> paymentModelList;

  PaymentDetailModel(
      {required this.bundle_name, required this.agreed_price, required this.paymentModelList});

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> paymentDetails = json["payment_details"] as List;
    return PaymentDetailModel(
        bundle_name: json["bundle_event"]["bundle_name"]??"",
        agreed_price: json["enrollment_agreed_price"]??"0",
        paymentModelList: paymentDetails.map((dynamic item) => PaymentModel.fromJson(item)).toList()
    );
  }
}
