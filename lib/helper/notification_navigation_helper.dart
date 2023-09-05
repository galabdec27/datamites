import 'package:datamites/pages/candidate_portal/rating_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/candidate_portal/enrolled_course.dart';
import '../pages/candidate_portal/payment_page.dart';
import '../pages/freshdesk/ticket_page.dart';
import '../pages/login_page.dart';
import '../pages/referral/new_referral.dart';
import '../pages/referral/referral_page_scaffold.dart';
import '../pages/sub_page/course/course_detail_general.dart';
import '../pages/web_view.dart';
import 'auth.dart';

class NotificationNavigationHelper {
  late BuildContext _context;
  late String _action;
  late String _sub_action;
  late String _external_url;
  late String _external_action;
  late String image;

  BuildContext get context => _context;

  set context(BuildContext context) {
    _context = context;
  }

  String get action => _action;

  set action(String action) {
    _action = action;
  }

  String get sub_action => _sub_action;

  set sub_action(String subAction) {
    _sub_action = subAction;
  }

  String get external_url => _external_url;

  set external_url(String externalUrl) {
    _external_url = externalUrl;
  }

  String get external_action => _external_action;

  set external_action(String externalAction) {
    _external_action = externalAction;
  }

  Future<bool> checkLogin() async {
    UserAuth auth = UserAuth();
    if (await auth.tokenRefresh(context) == 1){
      if (await auth.tokenLogin(context) == 1){
        return true;
      }
    }
    return false;
  }

  gotoLogin(){
    Navigator.push(
        context, MaterialPageRoute(builder: (_context) => LoginPage()));
  }

  void processNotification(bool remove) async {
    print("processing");
    switch (action) {
      case "0":
        if ( await checkLogin()){
          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => AddReferral()), (route)=>route.isFirst);
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (_context) => AddReferral()));
          }

        } else{
          gotoLogin();
        }
        break;

      case "1":
        if (remove) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_context) => CourseDetailgeneral(
              external_action, 1, int.parse(_sub_action), external_url)), (route)=>route.isFirst);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_context) => CourseDetailgeneral(
                      external_action, 1, int.parse(_sub_action), external_url)));
        }

        break;

      case "2":
        if ( await checkLogin()){
          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => const ReferralScreenScaffold()), (route)=>route.isFirst);
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReferralScreenScaffold()));
          }


        } else{
          gotoLogin();
        }

        break;

      case "3":
        if (external_action == "0") {

          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => InternalWebView(external_url)), (route)=>route.isFirst);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InternalWebView(external_url)));
          }
        } else {
          launch(external_url);
        }
        break;
      case "4":
        if (external_action == "0") {
          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => EnrolledCourse()), (route)=>route.isFirst);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EnrolledCourse()));
          }

        } else if (external_action == "1") {

          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => const CandidatePaymentPage(pageTitle: "My Payments")), (route)=>route.isFirst);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CandidatePaymentPage(pageTitle: "My Payments")));
          }
        } else if (external_action == "2") {
          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => const RatingPage(pageTitle: "My Ratings")), (route)=>route.isFirst);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RatingPage(pageTitle: "My Ratings")));
          }

        }else if (external_action == "3") {
          if (remove) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_context) => const TicketPage()), (route)=>route.isFirst);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TicketPage()));
          }

        }
        break;
    }
  }
}