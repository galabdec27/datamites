
import 'dart:convert';

import 'package:datamites/helper/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/Credit/segmented_credit_response_model.dart';
import '../../../model/Referral/campaign_model.dart';
import '../../../model/Referral/referral_model.dart';
import '../../../model/Referral/segmented_referral_response_model.dart';
import 'package:http/http.dart' as http;



_getDb(String dbPath) async {
  // print("Initializing db");
  var store = StoreRef.main();
  final appDocDir = await getApplicationDocumentsDirectory();
  Database db = await databaseFactoryIo
      .openDatabase(appDocDir.path + "/" + dbPath, version: 1);
  // print("Successfully initialized db");
  return db;
}

Future<void> _refreshToken(BuildContext context) async {
  UserAuth _userAuth = UserAuth();
  int refreshed = await _userAuth.tokenRefresh(context);
  if (refreshed == 1) refreshed = await _userAuth.tokenLogin(context);
}

class SegmentedReferralTransactionsService {
  late int statusId;
  late int referralSortAsc;
  late String jwt;
  late BuildContext context;
  late SharedPreferences prefs;
  late String authUrl, finalUrl;
  late Uri finalUri;

  set setContext(BuildContext context) {
    this.context = context;
  }

  set setStatusId(int statusId) {
    this.statusId = statusId;
  }

  set setReferralSortAsc(int referralSortAsc) {
    this.referralSortAsc = referralSortAsc;
  }

  set setPhone(String phone) {
    print(phone);
  }

  String apiPath = '';



  Future<SegmentedReferralResponseModel?> get getSegmented async {
    await _refreshToken(context);
    SegmentedReferralResponseModel? segRefModel;
    // if (kDebugMode) {
    //   print("Getting segmented");
    // }
    prefs = await SharedPreferences.getInstance();
    authUrl = prefs.getString("auth_url")??"";
    finalUrl = authUrl +
        'candidate/gettingSegmentedReferral?status_id=' +
        statusId.toString() +
        '&referral_sort_asc=' +
        referralSortAsc.toString();

    Map<String, String> qParams = {
      'status_id': statusId.toString(),
      'referral_sort_asc': referralSortAsc.toString()
    };

    Uri uri = Uri.parse(finalUrl);
    // finalUri = uri.replace(queryParameters: qParams); //USE THIS

    http.Response response = await http.get(Uri.parse(finalUrl),
        headers: {"jwt": prefs.getString("jwtToken")!});
    var segRef;
    Database db = await _getDb('datamite.db');
    var store = StoreRef.main();
    if (response.statusCode == 200) {
      segRef = json.decode(response.body);
      await store
          .record('referral_cash_' + statusId.toString())
          .put(db, segRef);
      // print("referral_cash_" + statusId.toString() + " written");
      segRefModel = SegmentedReferralResponseModel.fromJson(segRef);
    } else if (response.statusCode == 404) {
      // print("referral_cash_" + statusId.toString() + " writing");
      var dataToSave = json.decode(
          '{"referralData":[], "success":false, "message":"Data unavailable", "referral_amount":0, "final_status":' +
              statusId.toString() +
              '}');
      await store
          .record('referral_cash_' + statusId.toString())
          .put(db, dataToSave);
      // print("referral_cash_" + statusId.toString() + " written");
      // print("Returning null");
      return segRefModel;
    } else if (response.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['msg'],
            textAlign: TextAlign.center),
      ));
    } else {
      return getSegmented;
    }

    return segRefModel;
  }
}

class SegmentedCreditTransactionService {
  late int statusId;
  late int creditSortAsc;
  late String jwt;
  late BuildContext context;
  late SharedPreferences prefs;
  late String authUrl, finalUrl;
  late Uri finalUri;

  set setContext(BuildContext context) {
    this.context = context;
  }

  set setStatusId(int statusId) {
    this.statusId = statusId;
  }

  set setCreditSortAsc(int creditSortAsc) {
    this.creditSortAsc = creditSortAsc;
  }

  set setPhone(String phone) {
    print(phone);
  }

  String apiPath = '';



  Future<SegmentedCreditResponseModel?> get getSegmented async {
    await _refreshToken(context);
    SegmentedCreditResponseModel? segCreModel;
    print("Getting segmented");
    prefs = await SharedPreferences.getInstance();
    authUrl = prefs.getString("auth_url")??"";
    finalUrl = authUrl +
        'candidate/gettingSegmentedCredit?status_id=' +
        statusId.toString() +
        '&credit_sort_asc=' +
        creditSortAsc.toString();

    Uri uri = Uri.parse(finalUrl);

    http.Response response = await http.get(Uri.parse(finalUrl),
        headers: {"jwt": prefs.getString("jwtToken")!});
    // print("candidate/gettingSegmentedCredit?status_id=" +
    //     statusId.toString());
    var segRef;
    // print(response.statusCode);
    // print(response.body);
    Database db = await _getDb('datamite.db');
    var store = StoreRef.main();
    // print("cash reponse ");
    // print(statusId);
    // print(response.statusCode.toString());
    if (response.statusCode == 200) {
      segRef = json.decode(response.body);
      await store
          .record('referral_credit_' + this.statusId.toString())
          .put(db, segRef);
      // print(finalUrl);
      // print("referral_credit_" + this.statusId.toString() + " written");
      segCreModel = SegmentedCreditResponseModel.fromJson(segRef);

      // segRefModel = segRef.map(
      //   (dynamic item) => SegmentedReferralResponseModel.fromJson(item),
      // ) as SegmentedReferralResponseModel;
    } else if (response.statusCode == 404) {
      print(response.body);
      // print("referral_credit_" + statusId.toString() + " writing");
      var dataToSave = json.decode(
          '{"creditData":[], "success":false, "message":"Data unavailable", "credit_amount":0, "final_status":' +
              statusId.toString() +
              '}');
      // print(dataToSave);
      await store
          .record('referral_credit_' + statusId.toString())
          .put(db, dataToSave);
      // print("referral_credit_" + statusId.toString() + " written");
    } else if (response.statusCode == 403) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['msg'],
            textAlign: TextAlign.center),
      ));
    } else {
      try {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(json.decode(response.body)['msg'],
        //       textAlign: TextAlign.center),
        // ));
        return getSegmented;
      } catch (e) {
        print("Exception " + e.toString());
        return getSegmented;
      }
    }

    // try {
    //   print(segRefModel.msg);
    // } catch (err) {
    //   print(segRef);
    // }

    return segCreModel;
  }
}

class ReferralListService {
  late http.Response resp;
  late String base_url;
  late String final_url;
  late String token;
  late String query_string;
  late String referral_sort_asc;
  late BuildContext context;

  set setQuery_string(query_string) {
    this.query_string = query_string;
  }

  set setBuildContext(BuildContext context){
    this.context = context;
  }

  set setRererralSort(bool referral_sort_asc) {
    if (referral_sort_asc) {
      this.referral_sort_asc = '1';
    } else
      this.referral_sort_asc = '0';
  }

  Future<List<ReferralModel>?> get getReferralList async {
    await _refreshToken(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("access_token", prefs.getString("jwtToken")??"");
    base_url = prefs.getString("auth_url")??"";
    var token = prefs.getString("token");
    token = prefs.getString("access_token")!;
    // print(token);

    List<ReferralModel> referralList = [];

    resp = await http.get(
        Uri.parse(base_url +
            "candidate/getTotalRef?query_string=" +
            query_string +
            "&sort_asc=" +
            referral_sort_asc.toString()),
        headers: {"jwt": token});

    if (resp.statusCode == 200) {
      var referralData = json.decode(resp.body);
      List<dynamic> body = referralData['referralData'] as List;

      // print(body);

      try {
        referralList = body
            .map(
              (dynamic item) => ReferralModel.fromJson(item),
        )
            .toList();

        return referralList;
      } catch (e) {
        print("Exception " + e.toString());
        return getReferralList;
      }
    } else if (resp.statusCode == 404) {
      return referralList;
    } else {
      return getReferralList;
      // throw "Can't get referrals.";
    }
    return referralList;
  }
}

class GetCampaignService {
  late BuildContext context;

  void set contextLogin(BuildContext context) {
    this.context = context;
  }

  List<Campaign> campaignList = [];

  Future<List<Campaign>> get getCampaign async {
    await _refreshToken(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_url = prefs.getString("auth_url")??"";
    http.Response res =
    await http.get(Uri.parse(auth_url + "campaign"));

    if (res.statusCode == 200) {
      var campaigns = json.decode(res.body);
      var rest = campaigns["campaign"] as List;
      List<dynamic> body = rest;

      campaignList = body
          .map(
            (dynamic item) => Campaign.fromJson(item),
      )
          .toList();
      // print("Campaign list " + campaignList.toString());

      return campaignList;
    } else {
      // throw "Can't get referrals.";
      print("Error in getting referrals");
      return getCampaign;
    }
    return campaignList;
  }
}