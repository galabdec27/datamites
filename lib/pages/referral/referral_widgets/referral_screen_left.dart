import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/color.dart';
import '../../../model/Credit/segmented_credit_response_model.dart';
import '../../../model/Referral/segmented_referral_response_model.dart';
import '../../../provider/search_provider.dart';
import '../credit_screen.dart';
import '../new_referral.dart';
import '../referral_list_page.dart';
import '../segmente_referral_screen.dart';
import '../service/rest_service.dart';
import 'referral_screen_right.dart';

class ReferralScreenLeftMain extends StatefulWidget {
  final double width;
  final bool mobile;

  const ReferralScreenLeftMain(
      {Key? key, required this.width, required this.mobile})
      : super(key: key);

  @override
  _ReferralScreenLeftMainState createState() => _ReferralScreenLeftMainState();
}

class _ReferralScreenLeftMainState extends State<ReferralScreenLeftMain> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  Color lightBlue = Color(0xffe1f5fe);
  Color lightGreen = Color(0xffe8f5e9);
  Color lightRed = Color(0xffffebee);
  Color lightYellow = Color(0xfffffde7);
  int selected = 1;
  String totalAmount = "Loading";
  String courseCredit = "", cashCredit = "";
  Color? darkCashColor, lightCashColor, darkCourseColor, lightCourseColor;
  SegmentedReferralTransactionsService? segmentedReferralPending =
  SegmentedReferralTransactionsService();
  SegmentedReferralTransactionsService? segmentedReferralApproved =
  SegmentedReferralTransactionsService();
  SegmentedReferralTransactionsService? segmentedReferralSettled =
  SegmentedReferralTransactionsService();
  SegmentedReferralTransactionsService? segmentedReferralRejected =
  SegmentedReferralTransactionsService();

  SegmentedReferralResponseModel? pendingModel;
  SegmentedReferralResponseModel? approvedModel;
  SegmentedReferralResponseModel? settledModel;
  SegmentedReferralResponseModel? rejectedModel;

  SegmentedCreditTransactionService? segmentedCreditPending =
  SegmentedCreditTransactionService();
  SegmentedCreditTransactionService? segmentedCreditApproved =
  SegmentedCreditTransactionService();
  SegmentedCreditTransactionService? segmentedCreditSettled =
  SegmentedCreditTransactionService();
  SegmentedCreditTransactionService? segmentedCreditRejected =
  SegmentedCreditTransactionService();

  SegmentedCreditResponseModel? pendingCreditModel;
  SegmentedCreditResponseModel? approveCreditdModel;
  SegmentedCreditResponseModel? settledCreditModel;
  SegmentedCreditResponseModel? rejectedCreditModel;

  String historyText = 'Tap for history';
  String summarizedText = 'Tap for summarized view';
  String courseBannerText = '';
  String cashBannerText = '';

  bool dataloading = true;
  bool pendingLoadingCash = true;
  bool approvedLoadingCash = true;
  bool settledLoadingCash = true;
  bool rejectedLoadingCash = true;

  bool pendingLoadingCourse = true;
  bool approvedLoadingCourse = true;
  bool settledLoadingCourse = true;
  bool rejectedLoadingCourse = true;

  Future<bool> _getPendingCash(BuildContext) async {
    print("Pending cash");
    // pendingLoading = true;
    pendingModel = await segmentedReferralPending!.getSegmented;
    pendingLoadingCash = false;
    setState(() {});
    return true;
  }

  Future<bool> _getApprovedCash(BuildContext) async {
    print("approved cash");
    // approvedLoading = true;
    approvedModel = await segmentedReferralApproved!.getSegmented;
    approvedLoadingCash = false;
    setState(() {});
    return true;
  }

  Future<bool> _getSettledCash(BuildContext) async {
    print("settled cash");
    // settledLoading = true;
    settledModel = await segmentedReferralSettled!.getSegmented;
    settledLoadingCash = false;
    setState(() {});
    return true;
  }

  Future<bool> _getRejectedCash(BuildContext) async {
    print("rejectred cash");
    // rejectedLoading = true;
    rejectedModel = await segmentedReferralRejected!.getSegmented;

    rejectedLoadingCash = false;
    setState(() {});
    return true;
  }

  Future<bool> _getPendingCredit(BuildContext) async {
    print("Pending course");
    // pendingLoading = true;
    pendingCreditModel = await segmentedCreditPending!.getSegmented;
    pendingLoadingCourse = false;
    setState(() {});
    return true;
  }

  Future<bool> _getApprovedCredit(BuildContext) async {
    print("approved course");
    // approvedLoading = true;
    approveCreditdModel = await segmentedCreditApproved!.getSegmented;

    approvedLoadingCourse = false;
    setState(() {});
    return true;
  }

  Future<bool> _getSettledCredit(BuildContext) async {
    print("settled course");
    // settledLoading = true;
    settledCreditModel = await segmentedCreditSettled!.getSegmented;
    settledLoadingCourse = false;
    setState(() {});
    return true;
  }

  Future<bool> _getRejectedCredit(BuildContext) async {
    print("rejectred course");
    // rejectedLoading = true;
    rejectedCreditModel = await segmentedCreditRejected!.getSegmented;
    rejectedLoadingCourse = false;
    _refreshController.refreshCompleted();
    setState(() {});
    return true;
  }



  var referralScreen;

  void _setDataCash(BuildContext context) {
    // dataloading = true;
    segmentedReferralPending!.setReferralSortAsc = 0;
    segmentedReferralApproved!.setReferralSortAsc = 0;
    segmentedReferralSettled!.setReferralSortAsc = 0;
    segmentedReferralRejected!.setReferralSortAsc = 0;

    segmentedReferralPending!.setContext = context;
    segmentedReferralApproved!.setContext = context;
    segmentedReferralSettled!.setContext = context;
    segmentedReferralRejected!.setContext = context;

    segmentedReferralPending!.setStatusId = 0;
    segmentedReferralApproved!.setStatusId = 1;
    segmentedReferralSettled!.setStatusId = 2;
    segmentedReferralRejected!.setStatusId = 3;
    referralScreen = new ReferralScreenRight(widget.width, 1);

    courseBannerText = historyText;
    setState(() {});
  }

  void _setDataCredit(BuildContext context) {
    // dataloading = true;
    segmentedCreditPending!.setCreditSortAsc = 0;
    segmentedCreditApproved!.setCreditSortAsc = 0;
    segmentedCreditSettled!.setCreditSortAsc = 0;
    segmentedCreditRejected!.setCreditSortAsc = 0;

    segmentedCreditPending!.setContext = context;
    segmentedCreditApproved!.setContext = context;
    segmentedCreditSettled!.setContext = context;
    segmentedCreditRejected!.setContext = context;

    segmentedCreditPending!.setStatusId = 0;
    segmentedCreditApproved!.setStatusId = 1;
    segmentedCreditSettled!.setStatusId = 2;
    segmentedCreditRejected!.setStatusId = 3;

    setState(() {});
  }

  _fetchSegmentedCredit(BuildContext) async {
    print("Fetching segmented");
    await _getPendingCredit(context);
    await _getApprovedCredit(context);
    await _getSettledCredit(context);
    await _getRejectedCredit(context);
  }

  _fetchSegmentedCash(BuildContext) async {
    await _getPendingCash(context);
    await _getApprovedCash(context);
    await _getSettledCash(context);
    await _getRejectedCash(context);
  }

  double minWidth = 0, maxWidth = 0, cashWidth = 100, courseWidth = 0;

  _setWidth() {
    print("width");
    minWidth = widget.width / 4 - 12;
    maxWidth = widget.width / 2 - 20;
    creditHeight = minWidth;
    print("\n\n\n\n\n\n\n\n\n\n");
    print(minWidth);
    print(maxWidth);
    // cashWidth = minWidth + 8;
    // courseWidth = minWidth - 8;
    cashWidth = minWidth;
    courseWidth = minWidth;
    setState(() {});
    loaded = true;
  }

  bool loaded = false;

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    courseCredit = prefs.getString("course_credit") ?? "";
    cashCredit = prefs.getString("cash_credit") ?? "";
    setState(() {

    });
  }

  void checkForNewSharedLists() async {
    print("Fetching details");
    _setDataCash(context);
    _setDataCredit(context);
    await _fetchSegmentedCash(context);
    await _fetchSegmentedCredit(context);
  }

  _getDb(String dbPath) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    Database db = await databaseFactoryIo
        .openDatabase(appDocDir.path + "/" + dbPath, version: 1);
    return db;
  }

  _fetchOfflineData() async {
    print("Fetching offline data");
    Database db = await _getDb('datamite.db');
    var store = StoreRef.main();
    try {
      var data = await store.record('referral_cash_0').get(db) as Map<String, dynamic>;
      pendingModel = SegmentedReferralResponseModel.fromJson(data);
      if (pendingModel != null) {
        pendingLoadingCash = false;
        setState(() {});
      }

      data = await store.record('referral_cash_1').get(db) as Map<String, dynamic>;
      approvedModel = SegmentedReferralResponseModel.fromJson(data) ;
      if (approvedModel != null) {
        approvedLoadingCash = false;
      }
      data = await store.record('referral_cash_2').get(db) as Map<String, dynamic>;
      settledModel = SegmentedReferralResponseModel.fromJson(data);
      if (settledModel != null) {
        settledLoadingCash = false;
      }
      data = await store.record('referral_cash_3').get(db) as Map<String, dynamic>;
      rejectedModel = SegmentedReferralResponseModel.fromJson(data);
      if (rejectedModel != null) {
        rejectedLoadingCash = false;
      }

      data = await store.record('referral_credit_0').get(db) as Map<String, dynamic>;
      pendingCreditModel = SegmentedCreditResponseModel.fromJson(data);
      if (pendingCreditModel != null) {
        pendingLoadingCourse = false;
      }
      data = await store.record('referral_credit_1').get(db) as Map<String, dynamic>;
      approveCreditdModel = SegmentedCreditResponseModel.fromJson(data);
      if (approveCreditdModel != null) {
        approvedLoadingCourse = false;
      }
      data = await store.record('referral_credit_2').get(db) as Map<String, dynamic>;
      settledCreditModel = SegmentedCreditResponseModel.fromJson(data);
      if (settledCreditModel != null) {
        settledLoadingCourse = false;
      }
      data = await store.record('referral_credit_3').get(db) as Map<String, dynamic>;
      rejectedCreditModel = SegmentedCreditResponseModel.fromJson(data);
      if (rejectedCreditModel != null) {
        rejectedLoadingCourse = false;
      }
    } catch (err) {
      print(err);
    }
    setState(() {});
  }

  _getData() async {
    print("Getting data");
    await _fetchOfflineData();
    print("Got data");
    _setDataCash(context);
    _setDataCredit(context);
    _fetchSegmentedCash(context);
    _fetchSegmentedCredit(context);
    getPrefs();
  }

  late double cashInfWidth, courseInfWidth;

  @override
  void initState() {
    // TODO: implement initState
    cashInfWidth = widget.width;
    courseInfWidth = 0;

    referralScreen = new ReferralScreenRight(widget.width, 1);
    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => checkForNewSharedLists());

    _setWidth();

    darkCashColor = MainColor.textBlue;
    lightCashColor = MainColor.lightBlue;

    darkCourseColor = MainColor.darkGrey;
    lightCourseColor = MainColor.lightGrey;

    _getData();

    super.initState();
  }

  late Timer timer;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  bool courseSelected = false;
  bool cashSelected = true;
  double creditHeight = 0;
  double courseHeight = 0;

  _toggleWidthCash(bool isCash) {
    if (isCash) {
      // courseWidth = minWidth - 8;
      // cashWidth = minWidth + 8;
      creditHeight = 220;
      // bannerText = summarizedText;
      darkCashColor = MainColor.textBlue;
      lightCashColor = MainColor.lightBlue;
      darkCourseColor = MainColor.darkGrey;
      lightCourseColor = MainColor.lightGrey;
      cashSelected = true;
      courseSelected = false;
    } else {
      // courseWidth = minWidth + 8;
      // cashWidth = minWidth - 8;
      courseHeight = 220;
      // bannerText = summarizedText;
      darkCourseColor = MainColor.textBlue;
      lightCourseColor = MainColor.lightBlue;
      darkCashColor = MainColor.darkGrey;
      lightCashColor = MainColor.lightGrey;

      courseSelected = true;
      cashSelected = false;
    }
    setState(() {});
    _fetchSegmentedCash(context);
    _fetchSegmentedCredit(context);
  }

  bool courseShow = true;

  Future refresh(dynamic value) async {
    print("Refreshing");
    await _fetchSegmentedCash(context);
    await _fetchSegmentedCredit(context);
    print("#####################################");
    print(pendingModel!.referral_amount);
    print(approvedModel!.referral_amount);

    referralScreen = new ReferralScreenRight(widget.width, 1);
    setState(() {});
  }

  getCashCard(SegmentedReferralResponseModel? modelName, String title,
      bool loading, Color lightColor, Color darkColor) {
    return Container(
      height: 90,
      width: maxWidth - 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: lightColor),
      padding: EdgeInsets.all(8),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (modelName == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("No credits here", textAlign: TextAlign.center),
            ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SegmentedReferralScreen(
                        modelName, title,
                        status: modelName.final_status)));
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 10,
                              color: MainColor.textBlue,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(
                        height: 8,
                      ),
                      (loading)
                          ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                          : Text(
                        (modelName != null)
                            ? "INR " +
                            modelName.referral_amount.toString()
                            : "INR 0",
                        style: TextStyle(
                            color: MainColor.textBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: darkColor,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Tap for history",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCourseCard(SegmentedCreditResponseModel? modelName, String title,
      bool loading, Color lightColor, Color darkColor) {
    return Container(
      height: 90,
      width: maxWidth - 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), color: lightColor),
      padding: EdgeInsets.all(8),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (modelName == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("No credits here", textAlign: TextAlign.center),
            ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreditScreen(
                        modelName, title,
                        status: modelName.final_status)));
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 10,
                          color: MainColor.textBlue,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 8,
                  ),
                  (loading)
                      ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator())
                      : Text(
                    (modelName != null)
                        ? "INR " + modelName.credit_amount.toString()
                        : "INR 0",
                    style: TextStyle(
                        color: MainColor.textBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: darkColor,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Tap for history",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SearchProvider()),
        ],
        child: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: checkForNewSharedLists,
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0),
            width: widget.width,
            height: height,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
                  width: widget.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                            height: widget.width * 0.30,
                            decoration: BoxDecoration(
                                color: MainColor.datamiteOrange,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: MaterialButton(
                              // color: MainColor.datamiteOrange,
                              onPressed: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) => AddReferral());
                                Navigator.push(context, route).then(refresh);
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.person_add,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Add Referral",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            "Refer your friends and family.",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedContainer(
                                margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                duration: Duration(milliseconds: 100),
                                height: widget.width * 0.27,
                                width: cashWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: darkCashColor,
                                ),
                                child: MaterialButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      courseBannerText = historyText;
                                      cashBannerText = "";
                                      setState(() {});
                                      _toggleWidthCash(true);
                                    },
                                    child: Container(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 16,
                                              left: 0,
                                              right: 0,
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Cash Credit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "INR",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    (approvedLoadingCash)
                                                        ? SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                        CircularProgressIndicator())
                                                        : Text(
                                                      (approvedModel != null)
                                                          ? approvedModel!
                                                          .referral_amount
                                                          .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ]),
                                            ),
                                            Positioned(
                                              bottom: 8,
                                              right: 0,
                                              left: 0,
                                              child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      4, 0, 4, 0),
                                                  width: double.infinity,
                                                  height: 16,
                                                  color: lightCashColor,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .account_balance_wallet_outlined,
                                                          size: 16,
                                                          color: darkCashColor),
                                                      Text(
                                                        cashBannerText,
                                                        style: TextStyle(
                                                            color:
                                                            MainColor.textBlue,
                                                            fontSize: 8,
                                                            fontWeight:
                                                            FontWeight.w700),
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ))),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 100),
                                height: widget.width * 0.27,
                                width: courseWidth,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: darkCourseColor),
                                child: MaterialButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      _toggleWidthCash(false);
                                      cashBannerText = historyText;
                                      courseBannerText = "";
                                      courseInfWidth = widget.width;
                                      cashInfWidth = 0;
                                      setState(() {});
                                    },
                                    child: Container(
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 16,
                                              left: 0,
                                              right: 0,
                                              child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Course Credit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    const Text(
                                                      "INR",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    ),
                                                    (approvedLoadingCourse)
                                                        ? const SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child:
                                                        CircularProgressIndicator())
                                                        : Text(
                                                      (approveCreditdModel !=
                                                          null)
                                                          ? approveCreditdModel!
                                                          .credit_amount
                                                          .toString()
                                                          : "0",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600),
                                                    ),
                                                  ]),
                                            ),
                                            Positioned(
                                              bottom: 8,
                                              right: 0,
                                              left: 0,
                                              child: Container(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 0, 4, 0),
                                                  width: double.infinity,
                                                  height: 16,
                                                  color: lightCourseColor,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .account_balance_wallet_outlined,
                                                          size: 16,
                                                          color: darkCourseColor),
                                                      Text(
                                                        courseBannerText,
                                                        style: TextStyle(
                                                            color: darkCourseColor,
                                                            fontSize: 8,
                                                            fontWeight:
                                                            FontWeight.w700),
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ))),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cashSelected)
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                            child: Column(
                              children: [
                                ExpandablePanel(
                                  theme: ExpandableThemeData(
                                      iconColor: MainColor.textBlue,
                                      animationDuration:
                                      const Duration(milliseconds: 500)),
                                  header: Container(
                                    width: double.infinity,
                                    // color: Color(0x45eeeeee),
                                    padding: EdgeInsets.fromLTRB(
                                        8.0, 12.0, 8.0, 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "What is cash credit?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(Icons.info,
                                            color: MainColor.textBlue, size: 16)
                                      ],
                                    ),
                                  ),
                                  expanded: Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      alignment: Alignment.centerLeft,
                                      child: Html(
                                        data: cashCredit,
                                        style: {
                                          "p": Style(color: MainColor.textBlue)
                                        },
                                      )),
                                  collapsed: Text(""),
                                ),
                                if (cashSelected)
                                  Container(
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (!pendingLoadingCash)
                                              getCashCard(
                                                  pendingModel,
                                                  "Pending Cash Credit",
                                                  pendingLoadingCash,
                                                  MainColor.lightBlue,
                                                  MainColor.darkBlue),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            if (!approvedLoadingCash)
                                              getCashCard(
                                                  approvedModel,
                                                  "Approved Cash Credit",
                                                  approvedLoadingCash,
                                                  MainColor.lightGreen,
                                                  MainColor.darkGreen),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (!settledLoadingCash)
                                              getCashCard(
                                                  settledModel,
                                                  "Settled Cash Credit",
                                                  settledLoadingCash,
                                                  MainColor.lightOrange,
                                                  MainColor.darkOrange),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            if (!rejectedLoadingCash)
                                              getCashCard(
                                                  rejectedModel,
                                                  "Rejected Cash Credit",
                                                  rejectedLoadingCash,
                                                  MainColor.lightRed,
                                                  MainColor.darkRed),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (courseSelected)
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                            child: Column(
                              children: [
                                  ExpandablePanel(
                                    theme: ExpandableThemeData(
                                        iconColor: MainColor.textBlue,
                                        animationDuration:
                                        const Duration(milliseconds: 500)),
                                    header: Container(
                                      width: double.infinity,
                                      // color: Color(0x45eeeeee),
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 12.0, 8.0, 0.0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "What is course credit?",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(Icons.info,
                                              color: MainColor.textBlue,
                                              size: 16)
                                        ],
                                      ),
                                    ),
                                    expanded: Container(
                                        padding:
                                        EdgeInsets.fromLTRB(8, 0, 8, 8),
                                        alignment: Alignment.centerLeft,
                                        child: Html(
                                          data: courseCredit,
                                          style: {
                                            "p":
                                            Style(color: MainColor.textBlue)
                                          },
                                        )),
                                    collapsed: Text(""),
                                  ),
                                if (courseSelected)
                                  AnimatedContainer(
                                    duration: Duration(seconds: 5),
                                    width: courseInfWidth,
                                    child: Container(
                                      padding:
                                      EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              if (!pendingLoadingCourse)
                                                getCourseCard(
                                                    pendingCreditModel,
                                                    "Pending Course Credit",
                                                    pendingLoadingCourse,
                                                    MainColor.lightBlue,
                                                    MainColor.darkBlue),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              if (!approvedLoadingCourse)
                                                getCourseCard(
                                                    approveCreditdModel,
                                                    "Approved Course Credit",
                                                    approvedLoadingCourse,
                                                    MainColor.lightGreen,
                                                    MainColor.darkGreen),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              if (!settledLoadingCourse)
                                                getCourseCard(
                                                    settledCreditModel,
                                                    "Settled Course Credit",
                                                    settledLoadingCourse,
                                                    MainColor.lightOrange,
                                                    MainColor.darkOrange),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              if (!rejectedLoadingCourse)
                                                getCourseCard(
                                                    rejectedCreditModel,
                                                    "Rejected Course Credit",
                                                    rejectedLoadingCourse,
                                                    MainColor.lightRed,
                                                    MainColor.darkRed),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        // CarouselSliderMain(width: widget.width, class_id: 3),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 16, 16, 64),
                          width: double.infinity,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReferralFullScreen()));
                            },
                            color: MainColor.textBlue,
                            child: Text(
                              "See all referrals",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

