
import 'package:datamites/helper/color.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/Referral/segmented_referral_response_model.dart';
import 'referral_widgets/referral_card_segment.dart';
import 'service/rest_service.dart';

class SegmentedReferralScreen extends StatefulWidget {
  final SegmentedReferralResponseModel segmentedReferralResponseModel;
  final String name;
  final int status;
  const SegmentedReferralScreen(this.segmentedReferralResponseModel, this.name,
      {Key? key, required this.status})
      : super(key: key);

  @override
  _SegmentedReferralStcreenState createState() =>
      _SegmentedReferralStcreenState();
}

class _SegmentedReferralStcreenState extends State<SegmentedReferralScreen> {
  late SegmentedReferralResponseModel segmentedReferralResponseModel;
  SegmentedReferralTransactionsService segmentedCreditTransactionService = new SegmentedReferralTransactionsService();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  _getData() async {
    segmentedCreditTransactionService.setContext = context;
    segmentedCreditTransactionService.setStatusId = widget.status;
    segmentedCreditTransactionService.setReferralSortAsc = 0;
    segmentedReferralResponseModel = (await segmentedCreditTransactionService.getSegmented)!;
    setState(() {
      print("Got referrals");
      _refreshController.refreshCompleted();
    });

  }

  @override
  void initState() {
    segmentedReferralResponseModel = widget.segmentedReferralResponseModel;
    setState(() {


    });
    // TODO: implement initState
    _getData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    print(
      "Referral Length",
    );
    print(segmentedReferralResponseModel.referralList.length);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MainColor.textColorConst,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          widget.name,
          style: TextStyle(color: MainColor.textColorConst),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.00,0,16.0,8),
        child: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _getData,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount:
              segmentedReferralResponseModel.referralList.length,
              itemBuilder: (BuildContext context, int index) {
                print(index);
                // access element from list using index
                // you can create and return a widget of your choice
                return ReferralCardSegment(
                    referralModel: segmentedReferralResponseModel.referralList[index]);
              }),

        ),
      ),
    );
  }
}
