
import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/referral/referral_widgets/referral_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../model/Referral/referral_model.dart';
import '../../../provider/search_provider.dart';
import '../referral_list_page.dart';
import '../service/rest_service.dart';

class ReferralScreenRight extends StatefulWidget {
  var width;
  var search_query;
  late int count;
  var latestSelected;
  ReferralScreenRight(var width, int i) {
    this.width = width;
    count = i;
  }

  set setSearch(String search_query) {
    this.search_query = search_query;
    print("setting search");
  }

  set setLatestSelected(bool latestSelected) {
    this.latestSelected = latestSelected;
  }

  @override
  _ReferralScreenRightState createState() => _ReferralScreenRightState();
}

class _ReferralScreenRightState extends State<ReferralScreenRight> {
  Color lightBlue = Color(0xffe1f5fe);
  Color lightGreen = Color(0xffe8f5e9);
  Color lightRed = Color(0xffffebee);
  Color lightYellow = Color(0xfffffde7);
  late String search_query = '';
  late bool latestSelected = true;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  ReferralListService referralListService = new ReferralListService();
  List<ReferralModel> referralList = [];

  bool dataArrived = false;

  _getData() async {
    referralListService.setQuery_string = search_query;
    referralListService.setRererralSort = latestSelected;
    referralListService.context = context;
    referralList = (await referralListService.getReferralList)!;
    _refreshController.refreshCompleted();
    setState(() {
      dataArrived = true;
    });
  }

  @override
  void initState() {
    print(widget.search_query);

    // TODO: implement initState
    print("Getting data");
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool refresh = Provider.of<SearchProvider>(context).refreshReferral;
    var height = MediaQuery.of(context).size.height;
    var search = Provider.of<SearchProvider>(context).search_query;
    var latest = Provider.of<SearchProvider>(context).latestSelected;
    if (search_query != search) {
      search_query = search;
      _getData();
    }
    if (latestSelected != latest) {
      latestSelected = latest;
      _getData();
    }
    if (refresh) {
      print("Got refresh");
      _getData();
    }
    print("Refreshing value");
    return Material(
      child: Container(
        width: widget.width,
        child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _getData,
            child: (dataArrived)
                ? (referralList.length > 0)
                ? ((widget.count == 1)
                ? Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  width: widget.width,
                  color: MainColor.textColorConst,
                  child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReferralFullScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "See all referrals",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )),
                )
              ],
            )
                : ListView.builder(
                shrinkWrap: true,
                itemCount: referralList.length,
                itemBuilder: (BuildContext context, int index) {
                  print(index);
                  // access element from list using index
                  // you can create and return a widget of your choice
                  return ReferralCard(
                      referralModel: referralList[index]);
                }))
                : Container(
              child: Center(
                  child: Text("No referrals",
                      style: TextStyle(
                          color: MainColor.textColorConst,
                          fontSize: 12))),
            )
                : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )),
      ),
    );
  }
}
