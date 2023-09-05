import 'dart:convert';

import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/referral/service/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../helper/text_validation.dart';
import '../../model/Referral/campaign_model.dart';

class AddReferral extends StatefulWidget {
  @override
  _AddReferralState createState() => _AddReferralState();
}

class _AddReferralState extends State<AddReferral> {
  bool dialogVisible = false;
  String name = "";
  String email = "";
  String phone = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String title = "Congratulations";
  String description = "";
  bool validName = false;
  bool validEmail = false;
  bool validPhone = false;
  bool changedCourse = false;
  bool termsVisible = true;
  AddReferralService addReferralService = new AddReferralService();

  double anim_cont_height = 0;

  Color lightGreen = Color(0xffE2FFEE);
  Color darkGreen = Color(0xff00875A);
  late FocusNode myFocusNode;
  GetCampaignService getCampaignService = new GetCampaignService();
  bool visibleLoadingCourse = true;
  late String campaignId;
  bool showAmount = false;
  String referralAmount = "";
  bool backPressed = false;
  bool isChecked = false;
  bool sharedOption = false;
  var campList;
  TextValidation textValidation = new TextValidation();

  int refId = 0;

  var list;

  @override
  void initState() {
    super.initState();
    print("Getting Campaign");
    getCampaign();
    myFocusNode = FocusNode();
    getShared();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    backPressed = true;
    super.dispose();
  }

  String _value = 'Select';

  DropdownButton _normalDown() => DropdownButton<String>(
    items: [
      DropdownMenuItem(
        value: "1",
        child: Text(
          "Select",
        ),
      ),
      DropdownMenuItem(
        value: "2",
        child: Text(
          "First",
        ),
      ),
      DropdownMenuItem(
        value: "2",
        child: Text(
          "Second",
        ),
      ),
    ],
    onChanged: (value) {
      setState(() {
        _value = value!;
      });
    },
    value: _value,
  );

  TextStyle textStyle =
  new TextStyle(fontSize: 18.0, fontFamily: 'Roboto', color: Colors.black);

  // Drop down button
  List<String> _Courses = [];
  late String _selectedCourse = "Loading";

  Future<void> getCampaign() async {
    getCampaignService.context = context;
    campList = await getCampaignService.getCampaign;
    _Courses.clear();
    for (Campaign course in campList) {
      _Courses.add(course.courseName);
    }
    _selectedCourse = _Courses[0];
    showAmount = true;
    referralAmount = "Rs " +
        campList[_Courses.indexOf(_selectedCourse)].coursePrice.toString();
    campaignId = campList[_Courses.indexOf(_selectedCourse)].campaignId;
    if (!backPressed) {
      setState(() {
        visibleLoadingCourse = false;
      });
    }
  }

  removeDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDialog', false);
  }

  getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var option = prefs.getBool("showDialog");
    if (option == null)
      setState(() {
        sharedOption = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    getCampaignService.context = context;
    final Card nameCard = Card(
        child: Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8.0,
              ),
              Icon(
                Icons.person,
                color: Colors.grey,
              ),
              Divider(
                height: 10,
                color: Color(0xffeeeeee),
              ),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: new TextStyle(fontSize: 16.0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(color: Colors.white))),
                  onChanged: (text) {
                    name = text;
                    description = "Your referral for " + name + " has been noted.";
                    if (text.trim().length < 3) {
                      this.validName = false;
                    } else
                      validName = true;
                  },
                ),
              )
            ],
          ),
        ));
    final Card emailCard = Card(
        child: Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8.0,
              ),
              Icon(
                Icons.email,
                color: Colors.grey,
              ),
              Expanded(
                child: TextField(
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: new TextStyle(fontSize: 16.0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(color: Colors.white))),
                  onChanged: (text) {
                    email = text;
                    if (textValidation.validateEmail(text) == "Valid") {
                      validEmail = true;
                    } else {
                      validEmail = false;
                    }
                  },
                ),
              )
            ],
          ),
        ));
    final Card phoneCard = Card(
        child: Container(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8.0,
              ),
              Icon(
                Icons.phone,
                color: Colors.grey,
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                    FilteringTextInputFormatter(new RegExp(
                        '[\\.|\\,|\\`|\\!|\\@|\\#|\\%|\\^|\\&|\\*|\\(|\\)|\\"|\\-|\\_|\\=|\\+|\\/|\\.|\\,|\\<|\\.|\\>|\\:|\\;|\\"|\\?|\\s]'), allow: false),
                  ],
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: new TextStyle(fontSize: 16.0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(color: Colors.white))),
                  onChanged: (text) {
                    phone = text;
                    if (text.length < 7) {
                      validPhone = false;
                    } else
                      validPhone = true;
                  },
                ),
              )
            ],
          ),
        ));

    final DropdowdnCard = Card(
      // elevation: 5,
      child: Container(
        height: 58.0,
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        color: Colors.white,
        child: DropdownButton(
          isExpanded: true,
          hint: Text('Please choose a course'),
          // Not necessary for Option 1
          value: _selectedCourse,
          onChanged: (String? newValue) {
            setState(() {
              changedCourse = true;
              _selectedCourse = newValue!;
              showAmount = true;
              referralAmount = "Rs " +
                  campList[_Courses.indexOf(_selectedCourse)]
                      .coursePrice
                      .toString();
              campaignId =
                  campList[_Courses.indexOf(_selectedCourse)].campaignId;
            });
          },
          items: _Courses.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        ),
      ),
    );

    void _onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Visibility(
              visible: true,
              child: Dialog(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.orange)),
                        new Text(
                          "     Adding your referral.",
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  )));
        },
      );
    }

    _addReferral() async {
      FocusScope.of(context).requestFocus(FocusNode());
      _onLoading();
      addReferralService.setContext = context;
      addReferralService.setCourse = campaignId.toString();
      addReferralService.setEmail = email.trim();
      addReferralService.setName = name.trim();
      addReferralService.setPhone = phone.trim();

      bool refSuccess = await addReferralService.addReferral;
      // print(refSuccess);
      Navigator.pop(context);
      if (refSuccess) {
        setState(() {
          dialogVisible = true;
          anim_cont_height = 500;
        });
      }
      String sendJson = '{"name": "' +
          name +
          '","email": "' +
          email +
          '", "number": "' +
          phone +
          '", "course_id": "' +
          campaignId.toString() +
          '"}';
      // print(sendJson);
      // addReferralService.setJson = sendJson;
      // refId = await addReferralService.addReferral();
      // if (refId != 0) {
      //   setState(() {
      //     dialogVisible = true;
      //     anim_cont_height = 500;
      //   });
      // }
    }

    final referBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(12.0),
      color: Color(0xffe37528),
      child: MaterialButton(
        minWidth: 250.0,
        height: 50.0,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print(validName.toString() +
              validEmail.toString() +
              validPhone.toString());
          FocusScope.of(context).unfocus();
          if (validName & validEmail & validPhone) {
            _addReferral();
          } else {
            String msg = '';
            if (!validName) msg = "Invalid user name";
            if (!validEmail) msg = "Invalid user email";
            if (!validPhone) msg = "Invalid user phone";
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(msg, textAlign: TextAlign.center),
            ));
            // Toast.show("Please provide a valid input", context);
          }
        },
        child: Text("Refer",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.0)),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Refer".toUpperCase()),
          backgroundColor: Color(0xffe37528),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // MaterialButton(
                    //   onPressed: () async {
                    //     var status = await Permission.contacts.status;
                    //     if (!status.isGranted) {
                    //       // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    //       await Permission.contacts.request();
                    //       status = await Permission.contacts.status;
                    //       if(status.isGranted){

                    //         Contact? contact = await _contactPicker.selectContact();
                    //         setState(() {
                    //           _contact = contact;
                    //           name = _contact!.fullName!;
                    //           description = "Your referral for " + name + " has been noted.";
                    //           if (name.length > 4) {
                    //             validName = true;
                    //           }
                    //           phone =
                    //               _contact!.phoneNumbers![0].replaceAll("-", "");
                    //           phone = phone.replaceAll(" ", "");
                    //           phone = phone.replaceAll("+", "");
                    //           if (phone.length > 5) {
                    //             validPhone = true;
                    //           }
                    //           _nameController.text = name;
                    //           _phoneController.text = phone;
                    //         });

                    //       }
                    //     } else{

                    //       Contact? contact = await _contactPicker.selectContact();
                    //       setState(() {
                    //         _contact = contact;
                    //         name = _contact!.fullName!;
                    //         description = "Your referral for " + name + " has been noted.";
                    //         if (name.length > 4) {
                    //           validName = true;
                    //         }
                    //         phone =
                    //             _contact!.phoneNumbers![0].replaceAll("-", "");
                    //         phone = phone.replaceAll(" ", "");
                    //         phone = phone.replaceAll("+", "");
                    //         if (phone.length > 5) {
                    //           validPhone = true;
                    //         }
                    //         _nameController.text = name;
                    //         _phoneController.text = phone;
                    //       });

                    //     }

                    //   },
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //           width: 80,
                    //           height: 80,
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(60.0),
                    //               color: Color(0xffe37528)),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Icon(
                    //                 Icons.add,
                    //                 color: Colors.white,
                    //                 size: 32,
                    //               ),
                    //               Text(
                    //                 "Refer",
                    //                 style: TextStyle(
                    //                     color: Colors.white, fontSize: 10),
                    //               )
                    //             ],
                    //           )),
                    //       SizedBox(
                    //         width: 32.0,
                    //       ),
                    //       Container(
                    //         child: Center(
                    //             child: Text(
                    //           "Add From Contacts",
                    //           style: textStyle.copyWith(
                    //               fontWeight: FontWeight.w700),
                    //         )),
                    //       )
                    //     ],
                    //   ),
                    //   padding: EdgeInsets.all(0),
                    // ),
                    SizedBox(
                      height: 16,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SizedBox(
                    //       width: (width - 64) / 2 - 16,
                    //       child: Divider(),
                    //     ),
                    //     Text("or"),
                    //     SizedBox(
                    //       width: (width - 64) / 2 - 16,
                    //       child: Divider(),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Refer your friend",
                      style: textStyle.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "win exciting prices and cashbacks.",
                      style:
                      textStyle.copyWith(fontSize: 10, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    nameCard,
                    SizedBox(
                      height: 16,
                    ),
                    phoneCard,
                    SizedBox(
                      height: 16,
                    ),
                    emailCard,
                    SizedBox(
                      height: 16,
                    ),
                    Text("Please select a course to refer"),
                    SizedBox(
                      height: 4,
                    ),
                    Align(
                      alignment: FractionalOffset.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: (_Courses.length > 0)
                                ? DropdowdnCard
                                : Text("Loading"),
                          ),
                          // Expanded(
                          Visibility(
                              visible: visibleLoadingCourse,
                              child: SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.orange)))),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    new Align(
                      alignment: FractionalOffset.center,
                      child: referBtn,
                    ),

                    SizedBox(
                      height: 16,
                    ),
                    if (!visibleLoadingCourse)
                      Visibility(
                          visible: showAmount,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: MainColor.textColorFaint,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              "*The referral bonus $referralAmount for course " +
                                  campList[_Courses.indexOf(_selectedCourse)]
                                      .courseName +
                                  " will be credited to your wallet once your friend enrolls for the course",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          )),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: sharedOption,
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Container(
                      width: double.infinity,
                      color: Colors.black12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Card(
                                margin: EdgeInsets.all(16),
                                elevation: 5,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.7 -
                                          130,
                                      child: SingleChildScrollView(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Attention!!",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              new ListTile(
                                                leading: new MyBullet(),
                                                title: new Text(
                                                    'Once the referral is done Datamites will credit the referral amount to Digital Wallet.'),
                                              ),
                                              new ListTile(
                                                leading: new MyBullet(),
                                                title: new Text(
                                                    'Accounts will be settled on the last day of every month, payments for converted referrals will be done through bank transfer. '),
                                              ),
                                              new ListTile(
                                                leading: new MyBullet(),
                                                title: new Text(
                                                    'Referral is deemed completed only after the candidate makes the payment for the course. Datamites team will transfer the money after the month end cycle.'),
                                              ),
                                              new ListTile(
                                                leading: new MyBullet(),
                                                title: new Text(
                                                    'In case of part payment being incomplete or refund cases Datamites will debit the digital wallet and the same will be adjusted in the future payments. '),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Checkbox(
                                                value: isChecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked = !isChecked;
                                                  });
                                                },
                                                activeColor: Colors.orange,
                                                checkColor: Colors.white,
                                                tristate: false,
                                              ),
                                              Text(
                                                "\tDo not show this again",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 16.0, 0),
                                          alignment: Alignment.centerRight,
                                          child: MaterialButton(
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Color(0xffe37528),
                                            onPressed: () {
                                              setState(() {
                                                sharedOption = false;
                                                termsVisible = !termsVisible;
                                                if (isChecked) removeDialog();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          )
                        ],
                      ))),
            ),
            Visibility(
              visible: dialogVisible,
              child: Container(
                color: Color(0x99000000),
                height: MediaQuery.of(context).size.height,
              ),
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: anim_cont_height,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 32,
                    ),
                    new Stack(
                      children: <Widget>[
                        new Align(
                          alignment: Alignment.center,
                          child: new Container(
                            alignment: Alignment.center,
                            width: 128.0,
                            height: 128.0,
                            decoration: BoxDecoration(
                              color: Color(0x0Ae37528),
                              borderRadius: BorderRadius.circular(64.0),
                            ),
                          ),
                        ),
                        new Align(
                          alignment: Alignment.center,
                          child: new Container(
                            alignment: Alignment.center,
                            width: 128.0,
                            height: 128.0,
                            padding: EdgeInsets.all(30),
                            child: Icon(
                              Icons.check,
                              size: 64,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    new Text(
                      title,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    new Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Material(
                      //Wrap with Material
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 18.0,
                      color: Colors.green,
                      clipBehavior: Clip.antiAlias,
                      // Add This
                      child: MaterialButton(
                        minWidth: 180.0,
                        height: 48,
                        color: Colors.green,
                        child: new Text('OK',
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // Material(
                    //   //Wrap with Material
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(22.0)),
                    //   elevation: 18.0,
                    //   color: Color(0xffe37528),
                    //   clipBehavior: Clip.antiAlias, // Add This
                    //   child: MaterialButton(
                    //     minWidth: 180.0,
                    //     height: 48,
                    //     color: Color(0xffe37528),
                    //     child: new Text('Show Referrals',
                    //         style: new TextStyle(
                    //             fontSize: 16.0, color: Colors.white)),
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           CupertinoPageRoute(
                    //               builder: (context) => SegmentedReferral(
                    //                     status: 2,
                    //                     highlightCardId: refId,
                    //                   )));
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 10.0,
      width: 10.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}

class AddReferralService {
  late http.Response resp;
  late String authUrl;
  late String finalUrl;
  late String email;
  late String name;
  late String jwtToken;
  late String phone;
  late String course_id;
  late SharedPreferences prefs;
  late BuildContext context;
  String apiPath = 'candidate';

  set setEmail(String email) {
    this.email = email;
  }

  set setName(String name) {
    this.name = name;
  }

  set setPhone(String phone) {
    this.phone = phone;
  }

  set setCourse(String course_id) {
    this.course_id = course_id;
  }

  set setContext(BuildContext context) {
    this.context = context;
  }

  Future<bool> get addReferral async {
    print("Referring");
    prefs = await SharedPreferences.getInstance();
    authUrl = prefs.getString("auth_url")??"";
    finalUrl = authUrl + apiPath;

    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['number'] = phone;
    map['name'] = name;
    map['course_id'] = course_id;

    // print("Map");
    // print(map);

    http.Response response = await http.post(Uri.parse(finalUrl),
        body: map, headers: {"jwt": prefs.getString("jwtToken")!});

    if (response.statusCode == 201) {
      return true;
    } else {
      try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(response.body)['msg'],
              textAlign: TextAlign.center),
        ));
        return false;
      } catch (e) {
        print("Exception " + e.toString());
      }
    }

    return false;
  }
}

