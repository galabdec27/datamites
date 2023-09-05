import 'dart:convert';

import 'package:datamites/model/course/course_detail_model.dart';
import 'package:datamites/model/course/course_price_mode_general.dart';
import 'package:datamites/widgets/course_detail_list_item.dart';
import 'package:datamites/widgets/syllabus_list_item.dart';
import 'package:datamites/widgets/training_schedule_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/course/course_about_detail_model.dart';
import '../../../model/course/course_syllabus_model.dart';
import '../../contact_us.dart';

class CourseDetailgeneral extends StatefulWidget {
  String? title;
  int? countryId;
  int? courseId;
  String? courseImage;

  // MainCourseCardModel courseModel;

  CourseDetailgeneral(
      String title, int countryId, int courseId, String courseImage) {
    this.title = title;
    this.countryId = countryId;
    this.courseId = courseId;
    this.courseImage = courseImage;
    print("Course detail called: " + title);
  }

  @override
  _CourseDetailgeneralState createState() => _CourseDetailgeneralState();
}

class _CourseDetailgeneralState extends State<CourseDetailgeneral> {
// dropdown
  List _courseType = [];

  List<DropdownMenuItem<String>>? _dropDownMenuItems;
  String? _currentCourseType;
  String b_price = "";
  String d_price = "";

// dropdown

  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
      new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 75; // set bottom bar height
  double _bottomBarOffset = 0;

  late GeneralCourseDetailModel generalCourseDetailModel;

  bool detailLoaded = false;
  String description = "";

  double syllabusDownHeight = 0;

  Color statusBarColor = Colors.black12;
  bool statusFullBlack = false;

  @override
  void initState() {
    super.initState();
    getData();
    myScroll();
  }

  void changedDropDownItem(String? selectedCourse) {
    if (selectedCourse == "Classroom") {
      d_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.classroom_dprice;
      b_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.classroom_bprice;

      // , style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600);
    } else if (selectedCourse == "Live Virtual") {
      d_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.live_virtual_dprice;
      b_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.live_virtual_bprice;
    } else {
      d_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.self_learning_dprice;
      b_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.self_learning_bprice;
    }
    setState(() {
      _currentCourseType = selectedCourse;
    });
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>>? getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String course in _courseType) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: course, child: new Text(course)));
    }
    return items;
  }

  String finalDate = '';

  getData() async {
    // generalCourseDetailService.courseId = widget.courseId;
    // generalCourseDetailService.countryId = widget.countryId;
    // generalCourseDetailModel = await generalCourseDetailService.getDetail();

    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String baseUrl = await sharedPreferences.getString("base_url")??"";
    String finalUrl =
        '${baseUrl}api/datamiteCourse/courseDetail?countryId=' +
            widget.countryId.toString() +
            "&courseId=" +
            widget.courseId.toString();

    http.Response res = await http.get(Uri.parse(finalUrl));

    if (res.statusCode == 200) {
      var detail = json.decode(res.body);
      CoursePriceModelGeneral coursePriceModel =
          CoursePriceModelGeneral.fromJson(detail['course_price']);
      generalCourseDetailModel = GeneralCourseDetailModel.fromJson(detail);
    }
    if (generalCourseDetailModel.coursePriceModel.classroom_bprice != '0') {
      _courseType.add("Classroom");
      d_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.classroom_dprice;
      b_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.classroom_bprice;
    } else {
      d_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.live_virtual_dprice;
      b_price = generalCourseDetailModel.countryModel.currency_symbol +
          " " +
          generalCourseDetailModel.coursePriceModel.live_virtual_bprice;
    }
    if (generalCourseDetailModel.coursePriceModel.live_virtual_dprice != '0') {
      _courseType.add("Live Virtual");
    }
    if (generalCourseDetailModel.coursePriceModel.self_learning_dprice != '0') {
      _courseType.add("Self Learning");
    }
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCourseType = _dropDownMenuItems![0].value;

    detailLoaded = true;

    widget.courseImage =
        generalCourseDetailModel.courseModel.course_mob_img_link;
    description = generalCourseDetailModel.courseModel.course_desc;
    setState(() {});
    // print(locationCourseDetailModel.lcourse_loc_desc);
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  double height = 60;
  var width;

  String direc = '';

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.pixels < width * 0.8) {
        syllabusDownHeight = 0;
        if (statusFullBlack) {
          print("setting");
          setState(() {
            statusBarColor = Colors.black12;
            iconColor = Colors.white;
            statusFullBlack = false;
          });
        }
      } else {
        syllabusDownHeight = 80;
        if (!statusFullBlack)
          setState(() {
            statusBarColor = Colors.white;
            iconColor = Colors.black;
            statusFullBlack = true;
          });
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          setState(() {
            isScrollingDown = true;
            height = 0;
          });
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          setState(() {
            isScrollingDown = false;
            height = 60;
          });
        }
      }
    });
  }

  Color mainColor = Color(0xFFe36b17);
  Color iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var enquireButton = Container(
      // elevation: 5.0,
      child: Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text("Classroom", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                  if (detailLoaded)
                    Text(
                      d_price,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  if (detailLoaded)
                    Row(
                      children: <Widget>[
                        Text(
                          b_price,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        SizedBox(
                          height: 20,
                          // ignore: unnecessary_new
                          child: new DropdownButtonHideUnderline(
                              child:
                                  // ignore: unnecessary_new
                                  new DropdownButton(
                            value: _currentCourseType,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                          )),
                        )
                      ],
                    ),
                ],
              ),
              new MaterialButton(
                elevation: 4,
                minWidth: 130,
                color: mainColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ContactUsScreen(title: "Enquire now", message: "I am interested in course: "+generalCourseDetailModel.courseModel.course_name)
                  ));
                },
                child: Container(
                  width: 130,
                  height: 50,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(25.0),
                  //   color: mainColor
                  // ),
                  child: Center(
                    child: Text(
                      "Enquire Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );

    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              controller: _scrollBottomBarController,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    // Image.asset(
                    //   "assets/2.jpg",
                    //   fit: BoxFit.cover,
                    //   width: width,
                    //   height: width * 0.8,
                    // ),
                    Image.network(
                      widget.courseImage!,
                      width: width,
                      height: width * 0.8,
                      fit: BoxFit.cover,
                      scale: 1.0,
                    ),
                    new Positioned(
                      child: Container(
                        alignment: FractionalOffset.topLeft,
                        width: width,
                        height: width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black26, Colors.black87]),
                        ),
                      ),
                    ),
                    new Positioned(
                        top: 0,
                        child: Container(
                            width: width,
                            height: width * 0.8,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  widget.title!,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                if (detailLoaded)
                                  Row(
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < 5
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow,
                                            size: 25,
                                          );
                                        }),
                                      ),
                                      Text(
                                        "(" +
                                            generalCourseDetailModel.courseModel
                                                .course_reviewcount +
                                            ")",
                                        style:
                                            new TextStyle(color: Colors.white),
                                      )

                                      // Text(widget.mainCourseCardModel.course_reviewcount, style: courseLoction,)
                                    ],
                                  ),
                                SizedBox(
                                  height: 32,
                                ),
                              ],
                            ))),
                  ],
                ),
                Container(
                  color: Color(0xfff7f7f7),
                  padding: EdgeInsets.all(4.0),
                  child: Stack(
                    children: <Widget>[
                      if (detailLoaded)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                              color: Colors.white,
                              padding: EdgeInsets.all(12),
                              child: enquireButton,
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      // color: Color(0x45eeeeee),
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 16.0, 8.0, 0.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Html(
                                      data: description,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      // color: Color(0x45eeeeee),
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 16.0, 8.0, 0.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "The Course Includes",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Html(
                                      data: generalCourseDetailModel
                                          .courseModel.course_training,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      // color: Color(0x45eeeeee),
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 16.0, 8.0, 0.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Pricing",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              "assets/t-1.png",
                                              width: width / 5,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "\t\tClassroom",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16),
                                                ),
                                                Container(
                                                  width: width - width / 5 - 32,
                                                  child: Html(
                                                    data:
                                                        generalCourseDetailModel
                                                            .coursePriceModel
                                                            .classroom_desc,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Container(
                                                    width:
                                                        width - width / 5 - 32,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Text(
                                                          generalCourseDetailModel
                                                                  .countryModel
                                                                  .currency_symbol +
                                                              " " +
                                                              generalCourseDetailModel
                                                                  .coursePriceModel
                                                                  .classroom_bprice,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black45,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          generalCourseDetailModel
                                                                  .countryModel
                                                                  .currency_symbol +
                                                              " " +
                                                              generalCourseDetailModel
                                                                  .coursePriceModel
                                                                  .classroom_dprice,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: mainColor),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    if (generalCourseDetailModel
                                            .coursePriceModel
                                            .live_virtual_dprice !=
                                        "0")
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Image.asset(
                                                "assets/t-2.png",
                                                width: width / 5,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "\t\Live Virtual",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                  Container(
                                                    width:
                                                        width - width / 5 - 32,
                                                    child: Html(
                                                      data:
                                                          generalCourseDetailModel
                                                              .coursePriceModel
                                                              .live_virtual_desc,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                      width: width -
                                                          width / 5 -
                                                          32,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            generalCourseDetailModel
                                                                    .countryModel
                                                                    .currency_symbol +
                                                                " " +
                                                                generalCourseDetailModel
                                                                    .coursePriceModel
                                                                    .live_virtual_bprice,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            generalCourseDetailModel
                                                                    .countryModel
                                                                    .currency_symbol +
                                                                " " +
                                                                generalCourseDetailModel
                                                                    .coursePriceModel
                                                                    .live_virtual_dprice,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    mainColor),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    if (generalCourseDetailModel
                                            .coursePriceModel
                                            .self_learning_dprice !=
                                        '0')
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Image.asset(
                                                "assets/t-3.png",
                                                width: width / 5,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "\t\tSelf Learning",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                  Container(
                                                    width:
                                                        width - width / 5 - 32,
                                                    child: Html(
                                                      data: generalCourseDetailModel
                                                          .coursePriceModel
                                                          .self_learning_desc,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Container(
                                                      width: width -
                                                          width / 5 -
                                                          32,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                            generalCourseDetailModel
                                                                    .countryModel
                                                                    .currency_symbol +
                                                                " " +
                                                                generalCourseDetailModel
                                                                    .coursePriceModel
                                                                    .self_learning_bprice,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black45,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            generalCourseDetailModel
                                                                    .countryModel
                                                                    .currency_symbol +
                                                                " " +
                                                                generalCourseDetailModel
                                                                    .coursePriceModel
                                                                    .self_learning_dprice,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    mainColor),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )),
                            if (generalCourseDetailModel.onlineSchedule.length >
                                0)
                              Container(
                                  margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        // color: Color(0x45eeeeee),
                                        padding: EdgeInsets.fromLTRB(
                                            8.0, 16.0, 8.0, 0.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Online Schedule",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      new ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: generalCourseDetailModel
                                            .onlineSchedule
                                            .map((os) => TrainingScheduleCard(
                                                os,
                                                generalCourseDetailModel
                                                    .onlineSchedule,
                                                generalCourseDetailModel
                                                    .countryModel
                                                    .currency_symbol,
                                                generalCourseDetailModel
                                                    .coursePriceModel,
                                                context))
                                            .toList(),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  )),
                            Container(
                                margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      // color: Color(0x45eeeeee),
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 16.0, 8.0, 0.0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "About This Course",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    new ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: generalCourseDetailModel
                                          .courseAboutDetailModel
                                          .map((CourseAboutDetailModel about) =>
                                              new CourseDetailListItem(about))
                                          .toList(),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.fromLTRB(4, 8, 4, 0),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      // color: Color(0x45eeeeee),
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 16.0, 8.0, 0.0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "Syllabus",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    // ignore: unnecessary_new
                                    new ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: generalCourseDetailModel
                                          .courseSyllabusModel
                                          .map((CourseSyllabusModel cat) =>
                                              new SyllabusListItem(cat))
                                          .toList(),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                )),

                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      if (!detailLoaded)
                        Padding(
                            padding: EdgeInsets.all(48),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                    ],
                  ),
                )
              ],
            ),
            AnimatedContainer(
                color: statusBarColor,
                width: width,
                height: height,
                // curve: Curves.bounceInOut,
                duration: Duration(milliseconds: 100),
                child: Visibility(
                    visible: !isScrollingDown,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: iconColor,
                              ),
                            ),
                            if (iconColor == Colors.black)
                              Image.asset("assets/datamites.png",
                                  width: width / 2.5,
                                  height: height - 1,
                                  fit: BoxFit.contain),
                            if (detailLoaded)
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: iconColor,
                                ),
                                onPressed: () {
                                  Share.share("https://www.datamites.com/" +
                                      generalCourseDetailModel
                                          .courseModel.permalink);
                                },
                              ),
                          ],
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    ))),
            if (detailLoaded)
              new Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: AnimatedContainer(
                        color: Colors.white,
                        width: double.infinity,
                        height: syllabusDownHeight,
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 300),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              height: 1,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                              child: enquireButton,
                            ),
                          ],
                        )),
                  ))
          ],
        ),
      ),
    );
  }
}
