import 'package:datamites/provider/rating_provider_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/color.dart';
import '../../widgets/rating_widget.dart';
import 'feedback_screen.dart';

class FeedbackPopupAllClassroom extends StatefulWidget {
  final List<bool> ratingList;
  final int rating;
  final List<String> feedbackList;
  final String className;
  final String trainerName;
  final String title;
  final String type;
  final String startDate;
  final String startTime;
  final String endTime;

  const FeedbackPopupAllClassroom(
      {required this.ratingList,
      required this.rating,
      required this.feedbackList,
      required this.className,
      required this.trainerName,
      required this.title,
      required this.type,
      required this.startDate,
      required this.startTime,
      required this.endTime});

  @override
  State<FeedbackPopupAllClassroom> createState() =>
      _FeedbackPopupAllClassroomState();
}

class _FeedbackPopupAllClassroomState extends State<FeedbackPopupAllClassroom> {
  @override
  Widget build(BuildContext context) {
    String className = widget.className;
    String trainerName = widget.trainerName;
    return Material(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        color: const Color(0xffffffff),
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                if (widget.type == "overall")
                  Column(
                    children: [
                      Text(
                        "$className",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        'Trainer: $trainerName',
                        textAlign: TextAlign.center,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_sharp,
                            size: 14,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.startDate,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                              "${widget.startTime.length == 8 ? widget.startTime.substring(0,5):widget.startTime} to ${widget.endTime.length == 8 ? widget.endTime.substring(0,5):widget.endTime} (IST)"
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                if (widget.title.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                RatingWidget(
                    rating: widget.ratingList,
                    height: 40,
                    width: 40,
                    type: widget.type),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
