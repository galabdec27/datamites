
import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/referral/referral_widgets/neomorphism.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../model/Referral/referral_model.dart';

class ReferralCard extends StatelessWidget {
  final ReferralModel referralModel;
  ReferralCard({Key? key, required this.referralModel}) : super(key: key);

  Color lightBlue = const Color(0xffDEEBFF);
  Color darkBlue = const Color(0xff003399);
  Color lightGreen = const Color(0xffE2FFEE);
  Color darkGreen = const Color(0xff00875A);
  Color lightRed = const Color(0xffFFEBE5);
  Color darkRed = const Color(0xffDE350B);
  var lightOrange = Colors.yellow.shade100;
  Color darkOrange = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    var showColor;
    var showText;
    if (kDebugMode) {
      print('referralModel.status');
      print(referralModel.referralStatusModel[0].status);
    }
    switch (referralModel.referralStatusModel[0].status) {
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
    // if (referralModel.status == "0") {
    //   showColor = lightBlue;
    // }
    return Material(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
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
                      Text(referralModel.candidateModel.name),
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
                  Text(referralModel.candidateModel.email),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(referralModel.candidateModel.phone),
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
                      Text(referralModel.candidateModel.created_date),
                    ],
                  ),
                  Text(
                    "Rs. ${referralModel.referral_amount}",
                    style: TextStyle(color: showColor),
                  )
                ],
              ),
              if(referralModel.referralStatusModel[0].comments != null) Padding(padding: const EdgeInsets.fromLTRB(0, 16, 0, 8), child: Row(
                children: [
                  Text("Remarks: ", style: TextStyle(color: MainColor.textColorConst, fontWeight: FontWeight.w700),),
                  Text(referralModel.referralStatusModel[0].comments!, style: TextStyle(color: MainColor.textColorConst))
                ],
              ),),

              const SizedBox(height: 8,),
            ],
          ),
        ).addNeumorphism(
          blurRadius: 12,
          borderRadius: 8,
          offset: const Offset(2, 2),
        ));
  }
}
