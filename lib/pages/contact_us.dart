import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:datamites/helper/color.dart';
import 'package:datamites/model/freshdesk/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../helper/text_validation.dart';


class ContactUsScreen extends StatefulWidget {
  final String message;
  final String title;
  const ContactUsScreen({required this.title, required this.message, Key? key}) : super(key: key);


@override
  // ignore: library_private_types_in_public_api
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class ContactUsService {
  late String token;
  late String sendJson;
  late String baseUrl;
  late String finalUrl;
  late BuildContext context;

  set setSendJson(String sendJson) {
    this.sendJson = sendJson;
  }

  set setContext(BuildContext context) {
    this.context = context;
  }

  final String apiPath = "contact";


  Future<bool> sendFreshDesk(FreshdeskMessageModel freshdeskMessageModel) async {
    FreshDeskStarterModel  freshDeskStarterModel = FreshDeskStarterModel();
    String jsonBody = freshDeskStarterModel.getFreshdeskJson(freshdeskMessageModel);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("freshdesk_key")??"";
    if (kDebugMode) {
      print("Key is $username");
    }

    String password = 'X';
    String basicAuth = base64.encode(utf8.encode('$username:$password'));
    String freshDeskUrl = "https://datamiteshelp.freshdesk.com/api/v2/tickets";
    http.Response res = await http.post(Uri.parse(freshDeskUrl), body: jsonBody, headers: {"Authorization": basicAuth, "Content-Type": "application/json"});
    if (kDebugMode) print("Freshdesk ${res.statusCode}");
    if (res.statusCode == 200) {
      print("Freshdesk body success");
      print(res.body);
      return true;
    } else {
      print("Freshdesk body");
      print(res.body);
      return false;
    }
  }

  Future<bool> sendForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString("auth_url")??"";
    finalUrl = baseUrl + apiPath;
    http.Response res = await http.post(Uri.parse(finalUrl), body: sendJson);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(json.decode(res.body)['msg'], textAlign: TextAlign.center),
      ));

      return true;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(json.decode(res.body)['msg'], textAlign: TextAlign.center),
      ));
    }
    return sendForm();
  }
}

class ChangePasswordService {
  late String token;
  late String oldP;
  late String newP;
  late String baseUrl;
  late String finalUrl;

  late BuildContext context;

  set setOldP(String setOldP) {
    oldP = setOldP;
  }

  set setNewP(String newP) {
    newP = newP;
  }

  set setContext(BuildContext context) {
    context = context;
  }

  final String apiPath = "password/reset";

  Future<bool> changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString("auth_url")!;
    token = prefs.getString("access_token")!;
    finalUrl = baseUrl + apiPath;
    if (kDebugMode) {
      print(finalUrl);
    }

    http.Response res = await http.post(Uri.parse(finalUrl),
        headers: {"jwt": token}, body: {"oldPass": oldP, "newPass": newP});
    // print(res.body);
    if (res.statusCode == 200) {
      // print(res.body);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(json.decode(res.body)['msg'], textAlign: TextAlign.center),
      ));
      return true;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(json.decode(res.body)['msg'], textAlign: TextAlign.center),
      ));
      return false;
    }
  }
}


class _ContactUsScreenState extends State<ContactUsScreen> {
  final errorStyle = const TextStyle(fontSize: 14.0, color: Colors.red);

  String location = "User lat-lng is: ";

  ContactUsService contactUsService = ContactUsService();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();
  final FocusNode _buttonFocusNode = FocusNode();

  bool validName = false;
  bool validPhone = false;
  bool validEmail = false;
  bool validMessage = false;

  bool contactClicked = false;

  bool b1 = false, b2 = false, b3 = false, b4 = false;
  String nameErrorText = "",
      phoneErrorText = "",
      emailErrorText = "",
      messageErrorText = "";

  TextValidation textValidation = TextValidation();

  String name = "", email = "", phone = "", countryCode = "+91", message = "";
  TextStyle textStyle1 = const TextStyle(fontSize: 20, color: Colors.black);
  TextStyle textStyle2 = const TextStyle(fontSize: 14, color: Colors.grey);

  _validateName(String name) {
    this.name = name;
    if (name.trim().length < 3) {
      setState(() {
        validName = false;
        nameErrorText = "Enter a valid name";
        if (contactClicked) b1 = true;
      });
    } else {
      setState(() {
        validName = true;
        this.name = name;
        b1 = false;
      });
    }
  }

  _validatePhone(String phone) {
    phoneErrorText = textValidation.validatePhone(phone);
    this.phone = phone;
    if (phoneErrorText == "Valid") {
      setState(() {
        b3 = false;
        validPhone = true;
      });
    } else {
      setState(() {
        validPhone = false;
        if (contactClicked) b3 = true;
      });
    }
  }

  _validateEmail(String email) {
    this.email = email;
    emailErrorText = textValidation.validateEmail(email);
    if (emailErrorText == "Valid") {
      setState(() {
        validEmail = true;
        b2 = false;
      });
    } else {
      setState(() {
        validEmail = false;
        if (contactClicked) b2 = true;
      });
    }
  }

  _validateMessage(String message) {
    this.message = message;
    if (message.trim().length < 10) {
      setState(() {
        validMessage = false;
        messageErrorText = "Enter a at least 10 character.";
        if (contactClicked) b4 = true;
      });
    } else {
      setState(() {
        validMessage = true;
        b4 = false;
      });
    }
  }

  void _onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Visibility(
            visible: true,
            child: Dialog(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.orange)),
                      Text(
                        "     Sending your queries!",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                )));
      },
    );
  }

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString("userName")??"";
    nameController.text = name;
    if (name.length>1){
      validName = true;
      this.name= name;
      b1 = false;
    }
    if(widget.message.length>1){
      messageController.text = widget.message;
      validMessage = true;
      message = widget.message;
      b4 = false;
    }

    var email = prefs.getString("userEmail")??"";
    emailController.text = email;
    if (email.length>1){
      validName = true;
      this.email=email;
      b3 = false;
    }
    validEmail = true;

    var phone = prefs.getString("userPhone")??"";
    phoneController.text = phone;
    if (phone.length>1){
      validPhone = true;
      this.phone=phone;
      b2 = false;
    }
    setState(() {

    });

  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Card nameCard = Card(
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 8.0,
            ),
            const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            const Divider(
              height: 10,
              color: Color(0xffeeeeee),
            ),
            Expanded(
              child: TextField(
                controller: nameController,
                focusNode: _nameFocusNode,
                obscureText: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: const TextStyle(fontSize: 16.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Colors.white))),
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_phoneFocusNode),
                onChanged: (text) {
                  _validateName(text);
                },
              ),
            )
          ],
        ));
    final Card emailCard = Card(
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 8.0,
            ),
            const Icon(
              Icons.email,
              color: Colors.grey,
            ),
            Expanded(
              child: TextField(
                controller: emailController,
                focusNode: _emailFocusNode,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(fontSize: 16.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Colors.white))),
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_messageFocusNode),
                onChanged: (text) {
                  _validateEmail(text);
                },
              ),
            )
          ],
        ));

    final phoneCard = Card(
      child: Row(
        children: <Widget>[
          CountryCodePicker(
            onChanged: (text) {
              if (kDebugMode) {
                print("Country code $text");
              }
              countryCode = text.toString();
            },
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            initialSelection: 'In',
            favorite: const ['+91', 'In'],
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
          ),
          Expanded(
            child: TextField(
              controller: phoneController,
              focusNode: _phoneFocusNode,
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              obscureText: false,
              keyboardType: TextInputType.phone,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                  hintText: "Phone",
                  hintStyle: const TextStyle(fontSize: 16.0),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(color: Colors.white))),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_emailFocusNode),
              onChanged: (text) {
                _validatePhone(text);
              },
            ),
          )
        ],
      ),
    );

    final Card messageCard = Card(
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 8.0,
            ),
            const Icon(
              Icons.message,
              color: Colors.grey,
            ),
            const Divider(
              height: 10,
              color: Color(0xffeeeeee),
            ),
            Expanded(
              child: TextField(
                controller: messageController,
                focusNode: _messageFocusNode,
                obscureText: false,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: const TextStyle(fontSize: 16.0),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(color: Colors.white))),
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_buttonFocusNode),
                onChanged: (text) {
                  _validateMessage(text);
                },
              ),
            )
          ],
        ));

    showAlert(){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success!"),
            content: const Text("Your form have been submitted!"),
            actions: [
              MaterialButton(
                child: const Text("Ok"),
                onPressed: (){Navigator.pop(context);Navigator.pop(context);},
              ),

            ],
            elevation: 5,

          );
        },
      );
    }

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xffe37528),
      child: MaterialButton(
        focusNode: _buttonFocusNode,
        minWidth: 150.0,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          contactClicked = true;
          setState(() {
            _validateEmail(email);
            _validateName(name);
            _validateMessage(message);
            _validatePhone(phone);
          });

          if (validEmail & validName & validPhone & validMessage) {
            FocusScope.of(context).requestFocus(FocusNode());
            _onLoading(context);
            String sendJson = '{"name": "$name","email": "${email.toLowerCase()}", "country_code": "$countryCode", "phone": "$phone","message": "$message"}';

            contactUsService.setSendJson = sendJson;
            contactUsService.setContext = context;


            // fresh desk integration
            FreshDeskStarterModel freshDeskStarterModel = FreshDeskStarterModel();
            FreshdeskMessageModel freshdeskMessageModel = freshDeskStarterModel.getFreshdeskModel();
            freshdeskMessageModel.subject = "Mobile query";
            freshdeskMessageModel.phone = "${countryCode.toString()}${phone.toString()}";
            freshdeskMessageModel.description = message;
            freshdeskMessageModel.email = email;

            print(freshdeskMessageModel);
            await contactUsService.sendFreshDesk(freshdeskMessageModel);

            if (await contactUsService.sendForm()) {
              Navigator.pop(context);
              showAlert();
            }
          } else {
            FocusScope.of(context).requestFocus(FocusNode());
            // Toast.show("Enter valid inputs!", context);
          }
        },
        child: const Text("Submit",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0,16,16,8),
              child: Text(
                widget.title.length == 0 ? "Contact us" : widget.title,
                style: textStyle1.copyWith(color: MainColor.textColorConst, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0,0,16,0),
              child: Text(
                "We are always happy to help you",
                style: textStyle1.copyWith( fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // SizedBox(height: 16,),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  nameCard,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Visibility(
                      visible: b1,
                      child: Text(
                        nameErrorText,
                        style: errorStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  phoneCard,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Visibility(
                      visible: b3,
                      child: Text(
                        phoneErrorText,
                        style: errorStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  emailCard,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Visibility(
                      visible: b2,
                      child: Text(
                        emailErrorText,
                        style: errorStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  messageCard,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                    child: Visibility(
                      visible: b4,
                      child: Text(
                        messageErrorText,
                        style: errorStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: submitButton,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
