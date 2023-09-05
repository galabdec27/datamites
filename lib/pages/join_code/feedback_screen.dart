import 'package:datamites/provider/rating_provider_all.dart';
import 'package:datamites/widgets/feedback_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FeedbackScreen extends StatelessWidget {
  final List<String> feedbackList;
  final String type;

  const FeedbackScreen({required this.feedbackList, Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var selectedFeedback = Provider.of<RatingProviderAll>(context).getFeedbackByType(type);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: feedbackList.length,
          itemBuilder: (BuildContext context, int index) {
            bool selected = false;
            String feedback = feedbackList[index];
            if (selectedFeedback.isNotEmpty) {
              if (selectedFeedback.contains(feedback)) {
                selected = true;
              }
            }
            return FeedBackItem(selected: selected, feedbackString: feedback, type: type);
          }),
    );
  }
}
