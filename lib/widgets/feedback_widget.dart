import 'package:datamites/model/feedback_model.dart';
import 'package:flutter/material.dart';

class FeedbackWidget extends StatefulWidget {
  final List<String> feedbackList;

  const FeedbackWidget({required this.feedbackList});

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState(feedbackList);
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  List<FeedbackModel> feedbackModelList = [];

  _FeedbackWidgetState(List<String> feedbackList) {
    for (int i = 0; i < feedbackList.length; i++) {
      FeedbackModel feedback = FeedbackModel();
      feedback.setFeedback = feedbackList[i];
      feedback.setSelected = false;
      feedbackModelList.add(feedback);
    }
  }


  @override
  Widget build(BuildContext context) {
     return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: feedbackModelList.length,
        itemBuilder: (BuildContext context, int index) {
          bool selected = false;
          String feedback = feedbackModelList[index].getFeedback;
          if (feedbackModelList[index].getSelected) {
            selected = true;
          }
          Icon icon;
          icon = const Icon(
            Icons.check,
            color: Color(0xffffffff),
          );

          if (selected) {
            icon = const Icon(
              Icons.check,
              color: Color(0xff66bb6a),
            );
          }
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color(0x45c8e6c9),
            ),
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                icon,
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  padding: EdgeInsets.zero,
                  child: Text(
                    feedback,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
