import 'dart:convert';

import 'package:datamites/helper/color.dart';
import 'package:datamites/helper/user_details.dart';
import 'package:datamites/model/category_model.dart';
import 'package:datamites/model/course/course_list_model.dart';
import 'package:datamites/model/user_model.dart';
import 'package:datamites/pages/candidate_portal/enrolled_course.dart';
import 'package:datamites/pages/referral/new_referral.dart';
import 'package:datamites/pages/referral/referral_page_scaffold.dart';
import 'package:datamites/pages/sub_page/category_page.dart';
import 'package:datamites/pages/sub_page/course/course_list_page.dart';
import 'package:datamites/pages/sub_page/course/search_course_list_page.dart';
import 'package:datamites/provider/rating_provider_all.dart';
import 'package:datamites/widgets/car_category_shimmer.dart';
import 'package:datamites/widgets/card_course_preview_shimmer.dart';
import 'package:datamites/widgets/carousel.dart';
import 'package:datamites/widgets/carousel_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/connection.dart';
import '../model/carousel_model.dart';
import '../model/carousel_response_model.dart';
import 'candidate_portal/payment_page.dart';
import 'candidate_portal/rating_page.dart';
import 'contact_us.dart';
import 'main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userDetails = UserDetails();
  List<CarouselModel> carouselList = [];
  List<CourseListModel> coursesList = [];
  List<CategoryModel> categoryList = [];
  bool showSignIn = false;
  UserModel? userModel;
  String greeting = "Good Morning,";
  String date = "";
  String userName = "";
  final searchController = TextEditingController();
  bool loggedIn = false;
  String userImage =
      "https://www.sciencefriday.com/wp-content/uploads/2019/09/face-recognition-resized.png";

  _getUserDetail() async {
    userModel = await userDetails.getDetail();
    setState(() {
      userName =
      userModel!.getUserName == "" ? "Stranger" : userModel!.getUserName;
      loggedIn = userModel!.getUserName != "";
      var currentDate = DateTime.now();
      if (kDebugMode) {
        print(currentDate);
      }
      date = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
      if (currentDate.hour > 18) {
        greeting = "Good Evening,";
      } else if (currentDate.hour >= 12) {
        greeting = "Good Afternoon,";
      }
    });
  }

  _getCarousel() async {
    CarouselResponseModel responseModel =
    CarouselResponseModel(msg: "", statuscode: 0, carouselList: []);
    var prefs = await SharedPreferences.getInstance();
    var authUrl = prefs.getString("auth_url") ?? "";
    String url = "${authUrl}carousels?class_id=1";

    http.Response response = await http.get(Uri.parse(url),
        headers: {"jwt": prefs.getString("jwtToken") ?? ""});
    if (kDebugMode) {
      print(prefs.getString("jwtToken"));
    }
    // ignore: prefer_typing_uninitialized_variables
    var segRef;
    if (response.statusCode == 200) {
      segRef = json.decode(response.body);
      responseModel = CarouselResponseModel.fromJson(segRef);
      showSignIn = false;
    } else if (response.statusCode == 404) {
      responseModel = CarouselResponseModel.fromJson(json.decode('[]'));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(json.decode(response.body)['msg'],
      //       textAlign: TextAlign.center),
      // ));
      showSignIn = true;
    }

    carouselList = responseModel.carouselList;
    setState(() {});
  }

  _getCourses() async {
    var prefs = await SharedPreferences.getInstance();
    var baseUrl = prefs.getString("base_url") ?? "";
    String url = "${baseUrl}api/datamiteCourse/allCourse";

    http.Response response = await http.get(Uri.parse(url));
    // ignore: prefer_typing_uninitialized_variables
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

  _getCategory() async {
    var prefs = await SharedPreferences.getInstance();
    var baseUrl = prefs.getString("base_url") ?? "";
    String finalUrl = "${baseUrl}api/datamiteCourse/courseCategory";
    var resp = await http.get(Uri.parse(finalUrl));
    if (resp.statusCode == 200) {
      var categories = json.decode(resp.body);
      if (categories['success'] == true) {
        List<dynamic> body = categories['category'] as List;

        categoryList = body
            .map(
              (dynamic item) => CategoryModel.fromJson(item),
        )
            .toList();
      }
    }

    setState(() {});
  }

  Future<void> _refresh() async {
    await _getUserDetail();
    await _getCarousel();
    final snackBar = SnackBar(
      content: const Text('Home Refreshed Succesfully'),
      action: SnackBarAction(
        label: 'Refresh Again',
        onPressed: () {
          _refresh();
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String bannerUrl = "";
  String bannerLink = "";

  _getBanner() async {
    var prefs = await SharedPreferences.getInstance();
    var authUrl = prefs.getString("auth_url") ?? "";
    print("Auth url is ${authUrl}banner");
    var response = await http.get(Uri.parse("${authUrl}banner"));
    if (kDebugMode) {
      print("Got banner code ${response.statusCode}");
    }
    if (response.statusCode == 200) {
      setState(() {
        bannerUrl = json.decode(response.body)["banner"];
        bannerLink = json.decode(response.body)["url"];
      });
    }
  }

  _gotoUrl(String url) async {
    // ignore: deprecated_member_use
    launch(url);
  }

  Widget _futureBanner() {
    if (bannerUrl.isNotEmpty) {
      return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: MaterialButton(
            splashColor: Colors.green,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (kDebugMode) {
                print(bannerLink);
              }
              _gotoUrl(bannerLink);
            },
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                        bannerUrl,
                      ),
                      fit: BoxFit.fill)),
            ),
          ));
    } else {
      return Container();
    }
  }

  Widget _futureCarouselBuilder() {
    if (showSignIn) {
      return Container();
    } else {
      return FutureBuilder<String>(builder: (context, snapshot) {
        if (carouselList.isNotEmpty) {
          return FutureBuilder(builder: (BuildContext context, snapshot) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Carousel(carouselList: carouselList));
          });
        } else {
          return const CarouselShimmer();
        }
        return const Text("no data yet");
      });
    }
  }

  Widget _futureSuccessStories() {
    CarouselModel succesStory1 = CarouselModel(
        id: "1",
        image: "https://datamites.com/resource/images/mob/DM-mob-sc-2.png",
        action: "3",
        sub_action: "",
        external_url:
        "https://www.youtube.com/watch?v=rJd_aojJteA&list=PLeRUz657THGhmCfoGRMYCwXkwYLWijFwm&index=4&pp=iAQB",
        external_action: "1");
    CarouselModel succesStory2 = CarouselModel(
        id: "2",
        image: "https://datamites.com/resource/images/mob/DM-mob-sc-1.png",
        action: "3",
        sub_action: "",
        external_url:
        "https://www.youtube.com/watch?v=3ckToMAyFGY&list=PLeRUz657THGhmCfoGRMYCwXkwYLWijFwm&index=7&pp=iAQB",
        external_action: "1");
    var carouselsList = [succesStory1, succesStory2];
    return FutureBuilder<String>(builder: (context, snapshot) {
      if (showSignIn) {
        return FutureBuilder(builder: (BuildContext context, snapshot) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Carousel(carouselList: carouselsList));
        });
      } else {
        return Container();
      }
    });
    return Container();
  }

  Widget _futureCourseBuilder() {
    return FutureBuilder<String>(builder: (context, snapshot) {
      if (coursesList.isNotEmpty) {
        return FutureBuilder(builder: (BuildContext context, snapshot) {
          return CourseListPage(
            coursesList: coursesList,
            title: "Our Courses",
          );
        });
      } else {
        return const CardCoursePreviewShimmer();
      }
      return const Text("no data yet");
    });
  }

  Widget _userActivityBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const EnrollmentPage(pageTitle: "My Enrollment")));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EnrolledCourse()));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 8, 4),
                width: (MediaQuery.of(context).size.width - 48 - 16) / 3,
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffe8f5e9)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.history_edu,
                      color: Color(0xff00701a),
                      size: 40,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "My\nEnrollment",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff00701a)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            // MaterialButton(
            //   padding: const EdgeInsets.all(0),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const PaymentPage(pageTitle: "My Payment")));
            //   },
            //   child: Container(
            //     margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
            //     width: (MediaQuery.of(context).size.width-48)/2,
            //     padding: EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10.0),
            //         color: const Color(0xffe8eaf6)
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.payment_sharp, color: Color(0xff001970), size: 40,),
            //         SizedBox(height: 8.0,),
            //         Text("My Payment", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color:Color(0xff001970) ),)
            //       ],
            //     ),
            //   ),
            // ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                  create: (_) => RatingProviderAll()),
                            ],
                            child: const RatingPage(
                                pageTitle: "My Ratings"))));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                width: (MediaQuery.of(context).size.width - 48 - 16) / 3,
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xfffff8e1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.star,
                      color: Color(0xffbb4d00),
                      size: 40,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "My\nRatings",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffbb4d00)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CandidatePaymentPage(
                            pageTitle: "My\nPayment")));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                width: (MediaQuery.of(context).size.width - 48 - 16) / 3,
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffe8eaf6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.payment_sharp,
                      color: Color(0xff001970),
                      size: 40,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "My\nPayment",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff001970)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            // MaterialButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const EnrollmentPage(pageTitle: "My Assessment")));
            //   },
            //   child: Container(
            //     margin: EdgeInsets.fromLTRB(8, 8, 0, 4),
            //     width: (MediaQuery.of(context).size.width-48)/2,
            //     padding: EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10.0),
            //         color: const Color(0xfffff8e1)
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.task_outlined, color: Color(0xffbb4d00), size: 40,),
            //         SizedBox(height: 8.0,),
            //         Text("My Assessment", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color:Color(0xffbb4d00) ),)
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // MaterialButton(
            //   padding: const EdgeInsets.all(0),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const CandidatePaymentPage(pageTitle: "My Payment")));
            //   },
            //   child: Container(
            //     margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
            //     width: (MediaQuery.of(context).size.width-48)/2,
            //     padding: EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10.0),
            //         color: const Color(0xffe8eaf6)
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: const [
            //         Icon(Icons.payment_sharp, color: Color(0xff001970), size: 40,),
            //         SizedBox(height: 8.0,),
            //         Text("My Payment", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color:Color(0xff001970) ),)
            //       ],
            //     ),
            //   ),
            // ),
            MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReferralScreenScaffold()));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                width: (MediaQuery.of(context).size.width - 48 - 16) / 3,
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xfffbe9e7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person_add_alt_rounded,
                      color: Color(0xffe64a19),
                      size: 40,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "My\nReferral",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffe64a19)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsScreen(
                          title: "Raise a ticket",
                          message: "",
                        )));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                width: (MediaQuery.of(context).size.width - 48 - 16) / 3,
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xfffbf1e7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.question_answer_outlined,
                      color: Color(0xffcf6a04),
                      size: 40,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Raise a\nticket",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffcf6a04)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Coming soon", textAlign: TextAlign.center),
                ));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                width: (MediaQuery.of(context).size.width - 48 - 16) / 3,
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffe7e8fb)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.book_outlined,
                      color: Color(0xff3038c2),
                      size: 40,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Certificates",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3038c2)),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "(coming soon)",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff3038c2)),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _futureCategoryBuilder() {
    return FutureBuilder<String>(builder: (context, snapshot) {
      if (categoryList.isNotEmpty) {
        return FutureBuilder(builder: (BuildContext context, snapshot) {
          return CategoryPage(categoryList: categoryList);
        });
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                width: 200.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: const Color(0x45b6b6b6))),
            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [1, 2, 3, 4, 5]
                    .map((test) => const CardCategoryShimmer())
                    .toList(),
              ),
            )
          ],
        );
      }
    });
  }

  _refreshMain() async {
    bool connected = await ConnectionCheck.isAvailable();
    if (!connected) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Connection Lost"),
              content: const Text("Please check your internet connection"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                            (route) => false);
                  },
                  child: const Text("Ok"),
                )
              ],
            );
          });
    } else {
      _getUserDetail();
      _getCarousel();
      _getCourses();
      _getCategory();
      _getBanner();
    }
  }

  @override
  void initState() {
    _refreshMain();
    super.initState();
  }

  String searchText = "";

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    print("Updated");
    searchText = "";
    searchController.text = "";
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10.0),
                  // color: const Color(0xffffffff)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchCourseListPage(
                                  title: searchText,
                                )),
                          );
                        },
                        decoration: const InputDecoration(
                          hintText: "Search Course",
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          searchText = text;
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchCourseListPage(
                                  title: searchText,
                                )),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ))
                  ],
                ),
              ),
              if (!loggedIn)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Text(
                        "Success Stories",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    _futureSuccessStories(),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              if (loggedIn)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: _userActivityBuilder(),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    _futureCarouselBuilder(),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),


              _futureCategoryBuilder(),
              // const SizedBox(
              //   height: 16.0,
              // ),
              _futureBanner(),
              const SizedBox(
                height: 16.0,
              ),

              if (loggedIn)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => AddReferral());
                      Navigator.push(context, route);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all()),
                      child: Row(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                                color: MainColor.datamiteOrange,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Icon(
                                Icons.person_add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Refer your friends and family. Win exciting prices and cashbacks.",
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      "Click here to know more",
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 16,
              ),
              // _futureCarouselBuilder(),
              // _futureCourseBuilder()
            ],
          )),
    );
  }
}