
import 'package:datamites/pages/referral/referral_widgets/neomorphism.dart';
import 'package:flutter/material.dart';

import '../../../model/Credit/credit_model.dart';

class CreditCardSegment extends StatelessWidget {
  Color lightBlue = const Color(0xffDEEBFF);
  Color darkBlue = const Color(0xff003399);
  Color lightGreen = const Color(0xffE2FFEE);
  Color darkGreen = const Color(0xff00875A);
  Color lightRed = const Color(0xffFFEBE5);
  Color darkRed = const Color(0xffDE350B);
  var lightOrange = Colors.yellow.shade100;
  Color darkOrange = Colors.deepOrange;
  final CreditModel creditModel;
  CreditCardSegment({Key? key, required this.creditModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showColor;
    var showText;
    switch (creditModel.creditStatisList[0].status) {
      case '0':
        showColor = darkBlue;
        showText = "Pending";
        break;
      case '1':
        showColor = darkGreen;
        showText = "Approved";
        break;
      case '2':
        showColor = darkOrange;
        showText = "Settled";
        break;
      case '3':
        showColor = darkRed;
        showText = "Rejected";
        break;
    }
    // if (creditModel.status == "0") {
    //   showColor = lightBlue;
    // }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(creditModel.candidateModel.name),
                ],
              ),
              Text(
                showText,
                style: TextStyle(color: showColor, fontSize: 12),
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.alternate_email),
              const SizedBox(
                width: 4,
              ),
              Text(creditModel.candidateModel.email),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 4,
              ),
              Text(creditModel.candidateModel.phone),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(creditModel.candidateModel.created_date),
                ],
              ),
              Text(
                "Rs. ${creditModel.credit_amt}",
                style: TextStyle(color: showColor),
              )
            ],
          ),
        ],
      ),
    ).addNeumorphism(
      blurRadius: 12,
      borderRadius: 8,
      offset: const Offset(2, 2),
    );
  }
}
