import 'package:datamites/model/candidate_payment_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../helper/color.dart';

class CandidatePaymentCard extends StatelessWidget {
  final CandidatePaymentModel candidatePaymentModel;

  const CandidatePaymentCard({required this.candidatePaymentModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
            candidatePaymentModel.eventName,
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
                "Rs. ${candidatePaymentModel.agreedPrice}",
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
                "Rs. ${int.parse(candidatePaymentModel.agreedPrice) - (candidatePaymentModel.firstPaymentAmount + candidatePaymentModel.secondPaymentAmount + candidatePaymentModel.thirdPaymentAmount + candidatePaymentModel.fourthPaymentAmount)}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MainColor.textColorConst),
              ),
            ],
          ),
          ExpandablePanel(
            theme: const ExpandableThemeData(hasIcon: false),
            header: Container(
              width: double.infinity,
              // color: Color(0x45eeeeee),
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
                    "Rs. ${candidatePaymentModel.firstPaymentAmount + candidatePaymentModel.secondPaymentAmount + candidatePaymentModel.thirdPaymentAmount + candidatePaymentModel.fourthPaymentAmount}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MainColor.darkGreen),
                  ),
                ],
              ),
            ),
            collapsed: const Text("Click to view history" , style: TextStyle(fontSize: 8, color: Colors.black54),),
            expanded: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [

                  if (candidatePaymentModel.firstPaymentAmount != 0 )
                    Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "First payment ${candidatePaymentModel.firstPaymentDate == "" ? "" : "(${candidatePaymentModel.firstPaymentDate})"}: ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Rs. ${candidatePaymentModel.firstPaymentAmount}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (candidatePaymentModel.secondPaymentAmount != 0 )
                    Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Second payment ${candidatePaymentModel.secondPaymentDate == "" ? "" : "(${candidatePaymentModel.secondPaymentDate})"}: ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Rs. ${candidatePaymentModel.secondPaymentAmount}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (candidatePaymentModel.thirdPaymentAmount != 0)
                    Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Third payment ${candidatePaymentModel.thirdPaymentDate == "" ? "" : "(${candidatePaymentModel.thirdPaymentDate})"}: ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Rs. ${candidatePaymentModel.thirdPaymentAmount}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (candidatePaymentModel.fourthPaymentAmount != 0)
                    Column(
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Fourth payment ${candidatePaymentModel.fourthPaymentDate == "" ? "" : "(${candidatePaymentModel.fourthPaymentDate})"}: ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Rs. ${candidatePaymentModel.fourthPaymentAmount}",
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
