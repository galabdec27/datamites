import 'dart:ffi';

class CandidatePaymentModel {
  final String enrollmentId;
  final String fee;
  final String agreedPrice;
  final String eventName;
  final String invoiceNumber;
  final String enrollmentDate;

  final String firstPaymentId;
  final String secondPaymentId;
  final String thirdPaymentId;
  final String fourthPaymentId;

  final String firstPaymentDate;
  final String secondPaymentDate;
  final String thirdPaymentDate;
  final String fourthPaymentDate;

  final int firstPaymentAmount;
  final int secondPaymentAmount;
  final int thirdPaymentAmount;
  final int fourthPaymentAmount;

  CandidatePaymentModel({

    required this.enrollmentId,
    required this.fee,
    required this.agreedPrice,
    required this.eventName,
    required this.invoiceNumber,
    required this.enrollmentDate,

    required this.firstPaymentId,
    required this.secondPaymentId,
    required this.thirdPaymentId,
    required this.fourthPaymentId,

    required this.firstPaymentDate,
    required this.secondPaymentDate,
    required this.thirdPaymentDate,
    required this.fourthPaymentDate,

    required this.firstPaymentAmount,
    required this.secondPaymentAmount,
    required this.thirdPaymentAmount,
    required this.fourthPaymentAmount,
    
  });

  factory CandidatePaymentModel.fromJson(Map<String, dynamic> json) {
    return CandidatePaymentModel(
      enrollmentId: json['enroll_id']??"",
      fee: json['fee']??"",
      agreedPrice: json['agreed_price']??"",
      eventName: json['event_name']??"",
      invoiceNumber: json['invoice_number']??"",
      enrollmentDate: json['create_date']??"",

      firstPaymentId: json['first_payment_id']??"",
      secondPaymentId: json['second_payment_id']??"",
      thirdPaymentId: json['third_payment_id']??"",
      fourthPaymentId: json['fourth_payment_id']??"",

      firstPaymentDate: json['first_payment_date']??"",
      secondPaymentDate: json['second_payment_date']??"",
      thirdPaymentDate: json['third_payment_date']??"",
      fourthPaymentDate: json['fourth_payment_date']??"",

      firstPaymentAmount: int.parse(json['first_amt_paid']??"0"),
      secondPaymentAmount: int.parse(json['second_amt_paid']??"0"),
      thirdPaymentAmount: int.parse(json['third_amt_paid']??"0"),
      fourthPaymentAmount: int.parse(json['fourth_amt_paid']??"0"),
    );
  }
}
