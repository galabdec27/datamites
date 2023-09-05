import 'package:datamites/model/course/course_list_model.dart';
import 'package:datamites/widgets/card_course_preview.dart';
import 'package:flutter/material.dart';

class CourseListPage extends StatelessWidget {
  final List<CourseListModel> coursesList;
  final String title;
  const CourseListPage({required this.coursesList, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Text(title, style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700
              ),),
            ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: coursesList.map((course) => CardCoursePreview(course: course,))
                  .toList(),),
          )]
        ),
      ),
    );
  }
}
