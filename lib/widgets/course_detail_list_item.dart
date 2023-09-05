
import 'package:datamites/model/course/course_about_detail_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CourseDetailListItem extends StatefulWidget {
  CourseAboutDetailModel? about;
  CourseDetailListItem(this.about, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseDetailListItemState createState() =>
      // ignore: no_logic_in_create_state
      _CourseDetailListItemState(about!);
}

class _CourseDetailListItemState extends State<CourseDetailListItem> {
  Color mainColor = const Color(0xFFe36b17);

  CourseAboutDetailModel? about;
  _CourseDetailListItemState(this.about);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(
          iconColor: Colors.red,
          animationDuration: Duration(milliseconds: 500)),
      header: Container(
        width: double.infinity,
        // color: Color(0x45eeeeee),
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
        alignment: Alignment.centerLeft,
        child: Text(
          about!.ad_title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      expanded: Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 32),
          alignment: Alignment.centerLeft,
          child: Html(
            data: about!.ad_descripition,
          )),
      collapsed: const Text(""),
    );
  }
}
