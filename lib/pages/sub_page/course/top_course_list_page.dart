import 'dart:convert';

import 'package:datamites/model/course/course_list_model.dart';
import 'package:datamites/pages/sub_page/course/course_list_page.dart';
import 'package:datamites/widgets/card_course_preview_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopCourseListPage extends StatefulWidget {
  final String title;
  const TopCourseListPage({required this.title});

  @override
  State<TopCourseListPage> createState() => _TopCourseListPageState(title: title);
}

class _TopCourseListPageState extends State<TopCourseListPage> {
  final String title;
  _TopCourseListPageState({required this.title});
  List<CourseListModel> coursesList = [];

  _getCourses() async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String baseUrl = await sharedPreferences.getString("base_url")??"";
    String url = "${baseUrl}api/datamiteCourse/allCourse";

    http.Response response = await http.get(Uri.parse(url));
    var resp;
    if (response.statusCode == 200) {
      resp = json.decode(response.body)['courses'];
      var test = resp
          .map(
            (dynamic item) => CourseListModel.fromJson(item),
      )
          .toList();
      coursesList = test.cast<CourseListModel>();
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(builder: (context, snapshot) {
      if (coursesList.length != 0)

        return Scaffold(
          appBar: AppBar(
            title: Text(""),
          ),
          body: FutureBuilder(builder: (BuildContext context, snapshot) {
            return CourseListPage(coursesList: coursesList, title: title) ;
          })
        );
      else
        return Scaffold(
          appBar: AppBar(
            title: Text(""),
          ),
          body: CardCoursePreviewShimmer(),
        );
      return new Text("no data yet");
    });
  }
}
