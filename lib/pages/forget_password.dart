
import 'dart:convert';

import 'package:datamites/pages/referral/referral_widgets/neomorphism.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/color.dart';
import '../helper/text_validation.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  bool disableEntry = false;
  TextValidation textValidation = TextValidation();
  final _resetFormKey = GlobalKey<FormState>();
  ResetPasswordService resetPasswordService = ResetPasswordService();

  @override
  Widget build(BuildContext context) {
    resetPasswordService.setContext = context;
    return Scaffold(
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: disableEntry,
          child: Container(
            padding: const EdgeInsets.all(32.0),
            height: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xfff6f6f6)),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back)),
                ).addNeumorphism(
                    blurRadius: 16, borderRadius: 16, offset: const Offset(2, 2)),
                const SizedBox(
                  height: 16.0,
                ),
                Text("Forget password?\nEnter email address",
                    style: TextStyle(
                        color: MainColor.textColorConst,
                        fontSize: 24)),
                const SizedBox(height: 16.0),
                Form(
                  key: _resetFormKey,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey[200]),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person_outlined),
                          border: InputBorder.none,
                          enabledBorder: null,
                          hintText: 'email address',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          value = value!.trim();
                          resetPasswordService.setEmail = value;

                          return ((textValidation.validateEmail(value) !=
                                  "Valid"))
                              ? 'please enter a valid email address'
                              : null;
                        },
                      )),
                ),
                const SizedBox(
                  height: 16,
                ),

                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Visibility(
                        visible: disableEntry,
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  MainColor.textColorConst,
                                )))),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                MaterialButton(
                  elevation: 0,
                  color: Colors.blue,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {});
                    if (!_resetFormKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Enter the valid input',
                            textAlign: TextAlign.center),
                      ));
                    } else {
                      disableEntry = true;
                      setState(() {});
                      _resetPassword(
                          context: context,
                          resetPasswordService: resetPasswordService);
                      // _sendRegistrationRequest(
                      //     userRegistrationService, context);
                    }
                  },
                  minWidth: double.infinity,
                  height: 55.0,
                  child: const Text(
                    "Send reset link",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16,),
                MaterialButton(
                  elevation: 1,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  minWidth: double.infinity,
                  height: 55.0,
                  child: const Text(
                    "Go back",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword(
      {required BuildContext context,
        required ResetPasswordService resetPasswordService}) async {
    resetPasswordService.setContext = context;
    var success = await resetPasswordService.resetPassword;
    // ignore: use_build_context_synchronously
    if (success) Navigator.pop(context);
    setState(() {
      disableEntry = false;
    });
  }
}

class ResetPasswordService {
  late http.Response resp;
  late String authUrl;
  late String finalUrl;
  late String email;
  late String jwtToken;
  late SharedPreferences prefs;
  late BuildContext context;
  String apiPath = 'password/forgotpass';

  set setEmail(String email) {
    // print("Setting email " + email);
    this.email = email;
  }

  set setContext(BuildContext context) {
    this.context = context;
  }

  Future<bool> get resetPassword async {
    // print("Resetting password");
    prefs = await SharedPreferences.getInstance();
    authUrl = prefs.getString("auth_url")??"";
    finalUrl = "$authUrl$apiPath?email=$email";
    // print(finalUrl);

    http.Response response = await http.get(Uri.parse(finalUrl));

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['msg'],
            textAlign: TextAlign.center),
      ));
      return true;
    }
    try {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['msg'],
            textAlign: TextAlign.center),
      ));
    } catch (e) {
      print("Exception $e");
    }

    return false;
  }
}

