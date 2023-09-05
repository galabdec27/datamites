import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteConfigModel {
  final String appstore_url;
  final String auth_url;
  final String auth_url_tm;
  final String base_url;
  final String cash_credit;
  final String course_credit;
  final String force_update;
  final String ios_version;
  final String new_version;
  final String playstore_url;
  final String privacy_policy;
  final String tel;
  final String tos;
  final String update_reason;
  final String candidate_portal_url;
  final String freshdesk_key;
  final String add_firebase_token;

  RemoteConfigModel(
      {required this.appstore_url,
        required this.auth_url,
        required this.auth_url_tm,
        required this.base_url,
        required this.cash_credit,
        required this.course_credit,
        required this.force_update,
        required this.ios_version,
        required this.new_version,
        required this.playstore_url,
        required this.privacy_policy,
        required this.tel,
        required this.tos,
        required this.update_reason,
        required this.candidate_portal_url,
        required this.add_firebase_token,
        required this.freshdesk_key});


  @override
  String toString() {
    return 'RemoteConfigModel{appstore_url: $appstore_url, auth_url: $auth_url, auth_url_tm: $auth_url_tm, base_url: $base_url, cash_credit: $cash_credit, course_credit: $course_credit, force_update: $force_update, ios_version: $ios_version, new_version: $new_version, playstore_url: $playstore_url, privacy_policy: $privacy_policy, tel: $tel, tos: $tos, update_reason: $update_reason, candidate_portal_url: $candidate_portal_url, freshdesk_key: $freshdesk_key, add_firebase_token: $add_firebase_token}';
  }

  saveConfigToPrefs(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("appstore_url", appstore_url);
    prefs.setString("auth_url", auth_url);
    prefs.setString("auth_url_tm", auth_url_tm);
    prefs.setString("base_url", base_url);
    prefs.setString("cash_credit", cash_credit);
    prefs.setString("course_credit", course_credit);
    prefs.setString("force_update", force_update);
    prefs.setString("ios_version", ios_version);
    prefs.setString("new_version", new_version);
    prefs.setString("playstore_url", playstore_url);
    prefs.setString("privacy_policy", privacy_policy);
    prefs.setString("tel", tel);
    prefs.setString("tos", tos);
    prefs.setString("update_reason", update_reason);
    prefs.setString("candidate_portal_url", candidate_portal_url);
    prefs.setString("freshdesk_key", freshdesk_key);
    print("Setting $add_firebase_token");
    prefs.setString("add_firebase_token", add_firebase_token);
  }
}