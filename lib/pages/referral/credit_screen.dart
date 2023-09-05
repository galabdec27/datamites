
import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/referral/service/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/Credit/segmented_credit_response_model.dart';
import 'referral_widgets/credit_card_segment.dart';

class CreditScreen extends StatefulWidget {
  final SegmentedCreditResponseModel segmentedCreditResponseModel;
  final String name;
  final int status;
  const CreditScreen(this.segmentedCreditResponseModel, this.name, {Key? key,required this.status})
      : super(key: key);

  @override
  _SegmentedReferralStcreenState createState() =>
      _SegmentedReferralStcreenState();
}

class _SegmentedReferralStcreenState extends State<CreditScreen> {
  late SegmentedCreditResponseModel segmentedCreditResponseModel;
  SegmentedCreditTransactionService segmentedCreditTransactionService = new SegmentedCreditTransactionService();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  _getData() async {
    segmentedCreditTransactionService.setContext = context;
    segmentedCreditTransactionService.setStatusId = widget.status;
    segmentedCreditTransactionService.setCreditSortAsc = 0;
    segmentedCreditResponseModel =
    (await segmentedCreditTransactionService.getSegmented)!;
    setState(() {
      print("Got referrals");
      _refreshController.refreshCompleted();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    segmentedCreditResponseModel = widget.segmentedCreditResponseModel;
    setState(() {


    });
    // TODO: implement initState
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _getData,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: segmentedCreditResponseModel.creditList.length,
            itemBuilder: (BuildContext context, int index) {
              print(index);
              // access element from list using index
              // you can create and return a widget of your choice
              return CreditCardSegment(
                  creditModel:
                  segmentedCreditResponseModel.creditList[index]);
            }),
      ),
    );
  }
}
