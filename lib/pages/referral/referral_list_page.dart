
import 'package:datamites/pages/referral/referral_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/color.dart';
import '../../provider/search_provider.dart';

class ReferralFullScreen extends StatefulWidget {
  const ReferralFullScreen({Key? key}) : super(key: key);

  @override
  _ReferralFullScreenState createState() => _ReferralFullScreenState();
}

class _ReferralFullScreenState extends State<ReferralFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MainColor.textColorConst,
          ),
          backgroundColor: Colors.white,
          foregroundColor: MainColor.textColorConst,
          title: Text(
            "Referrals",
            style: TextStyle(color: MainColor.textColorConst),
          ),
        ),
        body: MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) => SearchProvider()),
        ], child: ReferralHistory(double.infinity, showText: false)));
  }
}
