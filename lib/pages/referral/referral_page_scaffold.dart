import 'package:datamites/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/auth.dart';
import '../../helper/responsive_helper.dart';
import '../login_page.dart';
import 'referral_history.dart';
import 'referral_widgets/referral_screen_left.dart';

class ReferralScreenScaffold extends StatefulWidget {
  const ReferralScreenScaffold({Key? key}) : super(key: key);

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreenScaffold> {
  Color lightBlue = Color(0xffe1f5fe);
  Color lightGreen = Color(0xffe8f5e9);
  Color lightRed = Color(0xffffebee);
  Color lightYellow = Color(0xfffffde7);

  bool refreshing = true;
  bool showLogin = false;
  bool showError = false;
  UserAuth _userAuth = UserAuth();

  Future<void> _refresh() async {
    refreshing = true;
    int refreshed = await _userAuth.tokenRefresh(context);
    if (refreshed == 1) refreshed = await _userAuth.tokenLogin(context);
    if (refreshed == 0) {
      print("Not logged in");
      showLogin = true;
      showError = false;
    } else if (refreshed == 2) {
      showError = true;
      showLogin = false;
    } else {
      showError = false;
      showLogin = false;
    }
    refreshing = false;
    setState(() {});
  }

  Future<void> _refreshWithScaffold() async {
    await _refresh();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Refreshed Succesfully'),
      action: SnackBarAction(
        label: 'Refresh Again',
        onPressed: () {
          _refresh();
          // Some code to undo the change.
        },
      ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return refreshing
        ? Container(
            width: double.infinity,
            color: Colors.white,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : showError
            ? Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Text("Something went wrong!"),
                ),
              )
            : showLogin
                ? Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 100,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Seems like you are not logged in!!!"),
                        MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()))
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ))
                : Scaffold(
                    appBar: AppBar(
                        iconTheme: IconThemeData(
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        title: Text(
                          "Referral",
                          style: TextStyle(color: Colors.black),
                        )),
                    body: Container(
                      width: double.infinity,
                      child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                                create: (_) => SearchProvider()),
                          ],
                          child: Container(
                            color: Colors.white,
                            child: ResponsiveHelper(
                              mobile: Scaffold(
                                body: ReferralScreenLeftMain(
                                    width: width, mobile: true),
                              ),
                              tablet: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: ReferralScreenLeftMain(
                                          width: width / 2, mobile: false)),
                                  Expanded(
                                      flex: 1,
                                      child: ReferralHistory(width / 2,
                                          showText: true))
                                ],
                              ),
                              desktop: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: ReferralScreenLeftMain(
                                          width: width / 2, mobile: false)),
                                  Expanded(
                                      flex: 1,
                                      child: ReferralHistory(width / 2,
                                          showText: true))
                                ],
                              ),
                            ),
                          )),
                    ),
                  );
  }
}
