import 'dart:convert';

import 'package:datamites/helper/color.dart';
import 'package:datamites/helper/user_details.dart';
import 'package:datamites/model/freshdesk/frestdesk_code.dart';
import 'package:datamites/pages/freshdesk/fresh_desk_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/freshdesk/freshdesk_response_detail_model.dart';

class TicketDetailPage extends StatefulWidget {
  final int id;
  const TicketDetailPage( this.id, {Key? key}) : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  UserDetails userDetails = new UserDetails();
  FreshDeskConstant freshDeskConstant = new FreshDeskConstant();

  Future<FreshdeskResponseDetailModel?> loadWidget() async {
    // FreshdeskResponseDetailModel freshdeskResponseDetailModel = new FreshdeskResponseDetailModel(id: 1, type: "type", subject: "subject", source: 1, status: 2, priority: 1, created_at: "created_at", updated_at: "updated_at", description: "description" ,style: titleStyle);
    return await getTicketDetail();
  }

  Future<FreshdeskResponseDetailModel?> getTicketDetail() async {
    FreshdeskResponseDetailModel? freshdeskResponseDetailModel;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("freshdesk_key")??"";
    // if (kDebugMode) {
    //   print("Key is $username");
    // }
    String password = 'X';
    String basicAuth = base64.encode(utf8.encode('$username:$password'));
    String freshDeskUrl =
        "https://datamiteshelp.freshdesk.com/api/v2/tickets/${widget.id}";
    // print(freshDeskUrl);
    http.Response res = await http
        .get(Uri.parse(freshDeskUrl), headers: {"Authorization": basicAuth});
    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      // if (kDebugMode) {
      //   print(response);
      // }
      freshdeskResponseDetailModel = FreshdeskResponseDetailModel.fromJson(response);
    }
    return freshdeskResponseDetailModel;
  }
  TextStyle titleStyle = new TextStyle(color: MainColor.textColorConst,fontWeight: FontWeight.w600);
  TextStyle descStyle = new TextStyle(color: MainColor.textColorConst);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket details: ${widget.id.toString()}"),
      ),
      backgroundColor: Colors.white,
      body:

      FutureBuilder(
        future: loadWidget(),
        builder: (BuildContext context,
            AsyncSnapshot<FreshdeskResponseDetailModel?> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            FreshdeskResponseDetailModel? detail = snapshot.data;
            children = Padding(
              padding: const EdgeInsets.fromLTRB(16,0,16,0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16,),
                    Container(
                      height: 32,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        color: freshDeskConstant
                          .getStatusColor(detail!.status)[1]
                      ),
                      child: Center(child: Text("Ticket ID: ${widget.id}" ,style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),),),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        border: Border.all(color: freshDeskConstant.getStatusColor(detail!.status)[1]),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Subject: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(detail!.subject ,style: descStyle)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: freshDeskConstant.getStatusColor(detail!.status)[0]
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Type: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(detail!.type,style: descStyle)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Source: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(freshDeskConstant.getSourceName(detail.source),style: descStyle)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: freshDeskConstant.getStatusColor(detail!.status)[0]
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Status: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(freshDeskConstant.getStatusName(detail.status),style: descStyle)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Priority: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(freshDeskConstant.getPriorityName(detail.priority),style: descStyle)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: freshDeskConstant.getStatusColor(detail!.status)[0]
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Description: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Html(
                                    data: detail.description,
                                    style: {
                                      "div": Style(color: MainColor.textColorConst)
                                    },
                                  ),),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Updated at: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(DateFormat()
                                      .format(DateTime.parse(detail.updated_at)),style: descStyle)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: freshDeskConstant.getStatusColor(detail!.status)[0],
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text("Created at: " ,style: titleStyle)),
                                  Expanded(flex: 4, child: Text(DateFormat()
                                      .format(DateTime.parse(detail.created_at)),style: descStyle)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                )
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            children = Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text("Something went wrong\nPlease restart the application" ,style: titleStyle),
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
