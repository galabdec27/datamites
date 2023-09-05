import 'package:datamites/helper/auth.dart';
import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/freshdesk/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/user_details.dart';
import 'contact_us.dart';
import 'notification_page.dart';
import 'update_profile_page.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late String user_name,
      user_email,
      user_phone,
      user_dob,
      user_image,
      playstore_url;
  bool userLoaded = false;
  UserDetails userDetails = UserDetails();
  final UserAuth _userAuth = UserAuth();

  Future<void> _refresh() async {
    int refreshed = await _userAuth.tokenRefresh(context);
    if (refreshed == 1) refreshed = await _userAuth.tokenLogin(context);
  }

  _getUserDetail(context) async {
    await _refresh();
    var user = await userDetails.getDetail();
    user_name = user.userName;
    user_email = user.userEmail;
    user_phone = user.userPhone;
    user_dob = user.userDob;
    user_image = user.userImage;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    playstore_url = prefs.getString("appstore_url")??"";
    setState(() {
      userLoaded = true;
    });
  }

  @override
  void initState() {
    _getUserDetail(context);
    super.initState();
  }

  _restart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Phoenix.rebirth(context);
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  _gotoUrl(String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString(page)!;
    launch(url);
  }

  Future<void> _logout(BuildContext context) async {
    UserDetails userDetails = UserDetails();
    await userDetails.manualLogout(context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var userStyle = new TextStyle(
        color: MainColor.textColorConst,
        fontWeight: FontWeight.w600,
        fontSize: 18);
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userLoaded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width - 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                // color: Colors.green,
                                image: DecorationImage(
                                    image: NetworkImage(user_image), fit: BoxFit.cover)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                user_name,
                                style: userStyle,
                              ),
                              Text(user_phone,
                                  style: userStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                              Text(user_email,
                                  style: userStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400))
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0x45f6f6f6)),
                      child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfileScreen()));
                          },
                          child: const Icon(Icons.edit)),
                    )
                  ],
                ),
              const SizedBox(
                height: 32,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                "General",
                style: userStyle.copyWith(fontSize: 16),
              ),
              MaterialButton(
                height: 50,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: MainColor.textColorConst,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Notification",
                        style: userStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              MaterialButton(
                height: 50,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketPage(
                          )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      color: MainColor.textColorConst,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Tickets",
                        style: userStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              MaterialButton(
                height: 50,
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
                child: Row(
                  children: [
                    Icon(
                      Icons.question_answer_outlined,
                      color: MainColor.textColorConst,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Raise a ticket",
                        style: userStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              Text(
                "More",
                style: userStyle.copyWith(fontSize: 16),
              ),
              MaterialButton(
                height: 50,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _gotoUrl("privacy_policy");
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.security_sharp,
                      color: MainColor.textColorConst,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Privacy Policy",
                        style: userStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              MaterialButton(
                height: 50,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _gotoUrl('tos');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      color: MainColor.textColorConst,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Terms of services",
                        style: userStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              MaterialButton(
                height: 50,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _gotoUrl("appstore_url");
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: MainColor.textColorConst,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Rate this app",
                        style: userStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              MaterialButton(
                height: 50,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  _logout(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_sharp,
                      color: MainColor.darkRed,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text("Log out",
                        style: userStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MainColor.darkRed)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
