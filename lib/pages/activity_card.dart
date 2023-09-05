import 'package:datamites/model/candidate_activities_model.dart';
import 'package:flutter/material.dart';

import '../helper/color.dart';

class ActivityCard extends StatelessWidget {
  final CandidateActivitiesModel candidateActivitiesModel;
  final bool isAssessment;
  // ignore: use_key_in_widget_constructors
  const ActivityCard({required this.candidateActivitiesModel, required this.isAssessment});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(candidateActivitiesModel.activityName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MainColor.textColorConst),),
          const SizedBox(height: 8,),
          Row(
            children: [
              const Icon(Icons.description_outlined, size: 16),
              const SizedBox(width: 8,),
              Text(isAssessment ? candidateActivitiesModel.activityComment : candidateActivitiesModel.activityDetail, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: MainColor.textColorConst),),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16,),
              const SizedBox(width: 8,),
              Text(candidateActivitiesModel.activityDate, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: MainColor.textColorConst),),
            ],
          ),

        ],
      ),
    );
  }
}
