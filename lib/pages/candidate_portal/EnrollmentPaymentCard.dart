import 'package:datamites/model/candidate_payment_model.dart';
import 'package:datamites/pages/candidate_portal/data_model/PaymentDetailModel.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../helper/color.dart';


class EnrollmentPaymentCard extends StatelessWidget {
  final PaymentDetailModel paymentDetailModel;

  const EnrollmentPaymentCard({required this.paymentDetailModel, Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    int paidAmount = 0;
    try {
      totalAmount = int.parse(paymentDetailModel.agreed_price);
      paidAmount = 0;
      for (int i=0; i<paymentDetailModel.paymentModelList.length; i++){
        paidAmount += int.parse(paymentDetailModel.paymentModelList[i].paymentAmount);
      }
    }
    catch(err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.fromLTRB(16,16,16,16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            paymentDetailModel.bundle_name,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MainColor.textColorConst),
          ),
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Agreed Price: ",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MainColor.textColorConst),
              ),
              Text(
                "Rs. ${paymentDetailModel.agreed_price}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MainColor.textColorConst),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Balance Amount: ",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MainColor.textColorConst),
              ),
              Text(
                "Rs. ${totalAmount-paidAmount}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MainColor.darkRed),
              ),
            ],
          ),
          ExpandablePanel(
            theme: const ExpandableThemeData(hasIcon: false),
            header: Container(
              width: double.infinity,
              // color: Color(0x45eeeeee),
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Paid Amount: ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MainColor.darkGreen),
                  ),
                  Text(
                    "Rs. ${paidAmount}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MainColor.darkGreen),
                  ),
                ],
              ),
            ),
            collapsed: Container(
              child: Text( paymentDetailModel.paymentModelList.isEmpty ? "" : "Click to view history" , style: TextStyle(fontSize: 10, color: Colors.black54),)
            ),
            expanded: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Column(
                children: [

                  for (int i=0; i<paymentDetailModel.paymentModelList.length; i++) Column(
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment no ${i+1} : ${paymentDetailModel.paymentModelList[i].paymentDate}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          Text(
                            "Rs. ${paymentDetailModel.paymentModelList[i].paymentAmount}",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
