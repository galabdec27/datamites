
import 'package:datamites/model/course/course_syllabus_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SyllabusListItem extends StatefulWidget {
  CourseSyllabusModel? syl;
  SyllabusListItem(CourseSyllabusModel syl, {Key? key}) : super(key: key) {
    this.syl = syl;
  }

  @override
  _SyllabusListItemState createState() => _SyllabusListItemState(syl!);
}

class _SyllabusListItemState extends State<SyllabusListItem> {
  CourseSyllabusModel? syl;
  Color mainColor = const Color(0xFFe36b17);
  _SyllabusListItemState(this.syl);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
        alignment: Alignment.centerLeft,
        child: Text(
          syl!.syllabus_title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      expanded: Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 32),
          alignment: Alignment.centerLeft,
          child: Html(
            data: syl!.syllabus_desc,
          )),
      collapsed: const Text(""),
    );
  }
}
