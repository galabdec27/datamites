import 'dart:convert';

import 'package:datamites/model/course/course_list_model.dart';
import 'package:datamites/pages/sub_page/course/course_list_page.dart';
import 'package:datamites/widgets/card_course_preview_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchCourseListPage extends StatefulWidget {
  final String title;
  const SearchCourseListPage({required this.title});

  @override
  State<SearchCourseListPage> createState() => _SearchCourseListPageState(title: title);
}

class _SearchCourseListPageState extends State<SearchCourseListPage> {
  final String title;
  _SearchCourseListPageState({required this.title});
  List<CourseListModel> coursesList = [];
  bool loading = true;

  _getCourses() async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String baseUrl = await sharedPreferences.getString("base_url")??"";
    String url =
        "${baseUrl}api/datamiteCourse/search?term="+title;

    http.Response response = await http.get(Uri.parse(url));
    var resp;
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if(body["success"]){
        resp = body['courses'];
        var test = resp
            .map(
              (dynamic item) => CourseListModel.fromJson(item),
        )
            .toList();
        coursesList = test.cast<CourseListModel>();
      }

    }
    loading = false;
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
      if (loading){

      }
      if (coursesList.length != 0)

        return Scaffold(
            appBar: AppBar(
              title: Text(""),
            ),
            body: FutureBuilder(builder: (BuildContext context, snapshot) {
              return CourseListPage(coursesList: coursesList, title: "Search results for: $title") ;
            })
        );
      else
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: (loading) ? CardCoursePreviewShimmer(): Center(child: Text("No search result found."),),
        );
      return new Text("no data yet");
    });
  }
}
