import 'package:datamites/provider/rating_provider_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackPopup extends StatefulWidget {
  final List<bool> ratingList;
  final int rating;
  final List<String> feedbackList;
  final String className;
  final String trainerName;

  const FeedbackPopup(
      {required this.ratingList,
      required this.rating,
      required this.feedbackList,
      required this.className,
      required this.trainerName});

  @override
  State<FeedbackPopup> createState() => _FeedbackPopupState();
}

class _FeedbackPopupState extends State<FeedbackPopup> {
  @override
  Widget build(BuildContext context) {
    String className = widget.className;
    String trainerName = widget.trainerName;
    return Material(
      child: Container(
        width: double.infinity,
          margin: EdgeInsets.all(16),
          color: Color(0xffffffff),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Text("Please give feedback for the following"),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Class: $className\nTrainer: $trainerName'),
                  // RatingWidget(rating: widget.ratingList, height: 100,),
                  (widget.rating == 5)
                      ? Text("Please click submit")
                      : Column(
                          children: [
                            // FeedbackScreen(feedbackList: widget.feedbackList),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                              child: TextField(
                                maxLines: 4,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'add more feedback',
                                ),
                                onChanged: (text) {

                                },
                              ),
                            ),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 48,
                      onPressed: () {
                        context.read<RatingProviderAll>().submit = true;
                      },
                      child: Text("Submit", style: TextStyle(color: Colors.white),),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),

        ),
      ),
    );
  }
}
