import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/color.dart';
import '../../provider/search_provider.dart';
import 'referral_widgets/referral_screen_right.dart';

class ReferralHistory extends StatefulWidget {
  late double width;
  late bool showText;
  ReferralHistory(double width, {required bool showText}) {
    this.width = width;
    this.showText = showText;
  }

  @override
  _ReferralHistoryState createState() => _ReferralHistoryState();
}

class _ReferralHistoryState extends State<ReferralHistory> {
  double contWidth = 100;
  double contHeight = 40;
  double contBorderRadius = 1.50;
  double dropDownHeight = 0;
  bool latestSelected = true;
  bool dropDownOpen = false;
  bool open = false;
  late FocusNode myFocusNode;
  String search_query = "";

  late ReferralScreenRight referralScreenRight;

  @override
  void initState() {
    referralScreenRight = ReferralScreenRight(widget.width, 2);
    // TODO: implement initState
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      double contWidth = 100.0;
      double contHeight = 30;
      double contBorderRadius = 1.50;
      bool open = false;
      dropDownHeight = 0;
      dropDownOpen = false;
      latestSelected = true;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    void toggleSearch() {
      if (!open) {
        print("Increasing size");
        open = true;
        setState(() {
          myFocusNode.requestFocus();
          contWidth = 5000;
          contHeight = 50.0;
          contBorderRadius = 12.0;
        });
      } else {
        setState(() {
          context.read<SearchProvider>().set_search_query = '';
          context.read<SearchProvider>().set_latestSelected = true;
          open = false;
          contWidth = 100.0;
          contHeight = 30.0;
          contBorderRadius = 25.0;
          dropDownHeight = 0;
          dropDownOpen = false;
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.showText)
          Container(
              padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
              width: double.infinity,
              child: Text(
                "Referrals",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )),
        SizedBox(
          height: 16,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: contHeight,
          width: contWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(contBorderRadius),
              color: (open) ? Color(0xfff6f6f6) : Colors.white),
          child: (!open)
              ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: MaterialButton(
              onPressed: () {
                toggleSearch();
              },
              child: Text("Filter"),
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      toggleSearch();
                      latestSelected = true;
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: MainColor.textColorConst,
                    )),
              ),
              Expanded(
                flex: 5,
                child: TextField(
                    focusNode: myFocusNode,
                    onChanged: (value) {
                      setState(() {
                        context.read<SearchProvider>().set_search_query =
                            value;
                        print(search_query);
                      });
                    },
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                    )),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      print(dropDownOpen);
                      if (dropDownOpen) {
                        dropDownHeight = 0;
                      } else {
                        dropDownHeight = 64;
                      }
                      dropDownOpen = !dropDownOpen;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.sort_rounded,
                      color: MainColor.textColorConst,
                    )),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedContainer(
            height: dropDownHeight,
            duration: const Duration(milliseconds: 400),
            // decoration: BoxDecoration(
            //     border: Border.all(color: MainColor.textColorConst)),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: MaterialButton(
                    color: (latestSelected)
                        ? MainColor.textColorConst
                        : Colors.white,
                    height: 30,
                    onPressed: () {
                      setState(() {
                        context.read<SearchProvider>().set_latestSelected =
                        false;
                        latestSelected = true;
                        dropDownHeight = 0;
                        dropDownOpen = false;
                      });
                    },
                    child: Text(
                      "Latest",
                      style: TextStyle(
                          color: (!latestSelected)
                              ? MainColor.textColorConst
                              : Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: MaterialButton(
                    color: (!latestSelected)
                        ? MainColor.textColorConst
                        : Colors.white,
                    height: 30,
                    onPressed: () {
                      setState(() {
                        context.read<SearchProvider>().set_latestSelected =
                        true;
                        latestSelected = false;
                        dropDownHeight = 0;
                        dropDownOpen = false;
                      });
                    },
                    child: Text(
                      "Oldest",
                      style: TextStyle(
                          color: (latestSelected)
                              ? MainColor.textColorConst
                              : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: referralScreenRight)
      ],
    );
  }
}
