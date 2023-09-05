import 'dart:convert';

import 'package:datamites/helper/user_details.dart';
import 'package:datamites/pages/freshdesk/fresh_desk_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/freshdesk/freshdesk_response_model.dart';
import '../../model/user_model.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int page = 1;
  int limit = 30;
  List<FreshdeskResponseModel> deskList = [];
  UserDetails userDetails = new UserDetails();

  Future<List<FreshdeskResponseModel>> loadWidget() async {
    deskList = [];
    deskList = await getFreshdeskTickets(page, limit);
    return deskList;
  }

  Future<List<FreshdeskResponseModel>> getFreshdeskTickets(
      int page, int limit) async {
    List<FreshdeskResponseModel> deskList = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("freshdesk_key")??"";
    // if (kDebugMode) {
    //   print("Key is $username");
    // }
    String password = 'X';
    String basicAuth = base64.encode(utf8.encode('$username:$password'));
    UserModel userModel = await userDetails.getDetail();
    String freshDeskUrl =
        "https://datamiteshelp.freshdesk.com/api/v2/tickets?email=${userModel.userEmail}&page=$page&per_page=$limit";
    // print(freshDeskUrl);
    http.Response res = await http
        .get(Uri.parse(freshDeskUrl), headers: {"Authorization": basicAuth});
    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      // if (kDebugMode) {
      //   print(response);
      // }
      deskList =  List<FreshdeskResponseModel>.from(response
          .map(
            (dynamic item) => FreshdeskResponseModel.fromJson(item),
          )
          .toList());
    }
    return deskList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets"),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: loadWidget(),
        builder: (BuildContext context,
            AsyncSnapshot<List<FreshdeskResponseModel>> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            List<FreshdeskResponseModel>? freshdeskDatas = snapshot.data;
            if (freshdeskDatas!.length > 0) {
              children = ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: freshdeskDatas
                    .map((freshdeskData) => FreshDeskCard(freshdeskData))
                    .toList(),
              );
            } else {
              children = SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.note_outlined,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('No any tickets found', textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            children = Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text("Something went wrong\nPlease restart the application"),
              ),
            );
          } else {
            children = Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return children;
        },
      ),
    );
  }
}
