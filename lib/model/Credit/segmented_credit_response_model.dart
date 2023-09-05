
import 'credit_model.dart';

class SegmentedCreditResponseModel {
  final int final_status;
  final int credit_amount;
  final bool success;
  final List<CreditModel> creditList;

  SegmentedCreditResponseModel(
      {required this.final_status,
      required this.credit_amount,
      required this.success,
      required this.creditList});

  factory SegmentedCreditResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> body = json['creditData'] as List;
    // print(body);
    return SegmentedCreditResponseModel(
        final_status: json['final_status'] as int,
        credit_amount: json['credit_amount'] as int,
        success: json['success'] as bool,
        creditList: body
            .map(
              (dynamic item) => CreditModel.fromJson(item),
            )
            .toList());
  }
}
