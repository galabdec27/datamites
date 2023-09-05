import 'dart:convert';

import 'package:datamites/model/course/course_list_model.dart';
import 'package:datamites/pages/sub_page/course/course_list_page.dart';
import 'package:datamites/widgets/card_course_preview_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryCourseListPage extends StatefulWidget {
  final String title;
  final String categoryId;
  const CategoryCourseListPage({required this.title, required this.categoryId});

  @override
  State<CategoryCourseListPage> createState() => _CategoryCourseListPageState(title: title, categoryId: categoryId);
}

class _CategoryCourseListPageState extends State<CategoryCourseListPage> {
  final String title;
  final String categoryId;
  _CategoryCourseListPageState({required this.title, required this.categoryId});
  List<CourseListModel> coursesList = [];

  _getCourses() async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String baseUrl = await sharedPreferences.getString("base_url")??"";
    String url =
        "${baseUrl}api/datamiteCourse/categoryCourse?categoryId="+categoryId;

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
