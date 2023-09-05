import 'package:datamites/provider/rating_provider_all.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedBackItem extends StatelessWidget {
  final bool selected;
  final String feedbackString;
  final String type;
  const FeedBackItem({required this.selected, required this.feedbackString, Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Color greyLight = const Color(0xfffafafa);
    Color greyDark = const Color(0x45c7c7c7);
    Color greenLight = const Color(0x45f1f8e9);
    Color greenDark = const Color(0xff75a478);
    return MaterialButton(
      onPressed: (){
        context.read<RatingProviderAll>().changeFeedbackByType(type, feedbackString);
      },
      padding: const EdgeInsets.all(0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: (selected) ? greenLight: greyLight,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.done, color: (selected)? greenDark: greyDark ,),
            const SizedBox(width: 16.0,),
            SizedBox(
              width: width-152,
              child: Text(feedbackString),
            )
          ],
        ),

      ),
    );
  }
}
