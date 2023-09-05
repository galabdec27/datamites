
import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/referral/referral_widgets/neomorphism.dart';
import 'package:flutter/material.dart';

import '../../../model/Referral/segmented_referral_model.dart';

class ReferralCardSegment extends StatelessWidget {
  Color lightBlue = Color(0xffDEEBFF);
  Color darkBlue = Color(0xff003399);
  Color lightGreen = Color(0xffE2FFEE);
  Color darkGreen = Color(0xff00875A);
  Color lightRed = Color(0xffFFEBE5);
  Color darkRed = Color(0xffDE350B);
  var lightOrange = Colors.yellow.shade100;
  Color darkOrange = Colors.deepOrange;
  final ReferralModelSegment referralModel;

  ReferralCardSegment({Key? key, required this.referralModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showColor;
    var showText;
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
    if (referralModel.status == 0) {
      showColor = lightBlue;
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                  Icon(Icons.person),
                  SizedBox(
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
              Icon(Icons.alternate_email),
              SizedBox(
                width: 4,
              ),
              Text(referralModel.candidateModel.email),
            ],
          ),
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(
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
                  Icon(Icons.calendar_today_rounded),
                  SizedBox(
                    width: 4,
                  ),
                  Text(referralModel.candidateModel.created_date),
                ],
              ),
              Text(
                "Rs. " + referralModel.referral_amt,
                style: TextStyle(color: showColor),
              )
            ],
          ),
          if(referralModel.referralStatusModel[0].comments != null) Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 8), child: Row(
            children: [
              Text("Remarks: ", style: TextStyle(color: MainColor.textColorConst, fontWeight: FontWeight.w700),),
              Text(referralModel.referralStatusModel[0].comments!, style: TextStyle(color: MainColor.textColorConst))
            ],
          ),),
          SizedBox(height: 8,),
        ],
      ),
    ).addNeumorphism(
      blurRadius: 12,
      borderRadius: 8,
      offset: Offset(2, 2),
    );
  }
}
