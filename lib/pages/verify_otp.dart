import 'dart:convert';

import 'package:datamites/helper/color.dart';
import 'package:datamites/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifyOtp extends StatefulWidget {
  final String email;

  const VerifyOtp({required this.email});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _otpController = TextEditingController();
  final _pageKey = GlobalKey<FormState>();
  bool loading = false;
  ResendOTPService resendOTPService = ResendOTPService();

  _verifyOTP() async {
    UserOTPService service = UserOTPService();
    service.setEmail = widget.email;
    service.setOTPkey = _otpController.text.toString();
    service.setContext = context;
    bool verified = await service.verifyOTP;
    setState(() {
      loading = false;
    });
    if(verified){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
    }
  }
  _resendOtp() async {
    setState(() {
      loading = true;
    });
    resendOTPService.context = context;
    resendOTPService.email = widget.email;
    await resendOTPService.resendOtp();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verify Otp",
          style: TextStyle(color: MainColor.textColorConst),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _pageKey,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Text(
                        "Please enter the otp sent to\n" + widget.email,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: true),
                        controller: _otpController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.code),
                          labelText: 'OTP Code',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid otp';
                          }
                          return null;
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (_pageKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          _verifyOTP();
                        }
                      },
                      child: SizedBox(
                        height: 48,
                        child: Center(
                          child: Text(
                            "Verify OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () {
                      _resendOtp();
                    },
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  MaterialButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: Text(
                          "Go back",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (loading)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white24,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class UserOTPService {
  late http.Response resp;
  late String authUrl;
  late String finalUrl;
  late String email;
  late String OTPkey;
  late SharedPreferences prefs;
  late BuildContext context;
  String apiPath = 'Verification/verifyOtp';

  set setEmail(String email) {
    this.email = email;
  }

  set setOTPkey(String OTPkey) {
    this.OTPkey = OTPkey;
  }

  set setContext(BuildContext context) {
    this.context = context;
  }

  Future<bool> get verifyOTP async {
    prefs = await SharedPreferences.getInstance();
    authUrl = prefs.getString("auth_url")??"";
    finalUrl = authUrl + apiPath;

    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['otp'] = OTPkey;


    try {
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        body: map,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: new Duration(milliseconds: 800),
          content: Text("Verification successful",
              textAlign: TextAlign.center),
        ));
        return true;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: new Duration(milliseconds: 800),
        content: Text(json.decode(response.body)['msg'],
            textAlign: TextAlign.center),
      ));
      return false;
    } catch (e) {
      print("Exception " + e.toString());
    }

    return false;
  }
}

class ResendOTPService {
  late String token;
  late String email;
  late String baseUrl;
  late String finalUrl;
  late BuildContext context;

  set setEmail(String email) {
    this.email = email;
  }

  set setContext(BuildContext context) {
    this.context = context;
  }

  final String apiPath = "verification/resendOtp";

  Future<bool> resendOtp() async {
    print("Sending otp: "+email );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString("auth_url")??"";
    finalUrl = baseUrl + apiPath + "?email=" + email;

    http.Response res = await http.get(Uri.parse(finalUrl));
    if (res.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(json.decode(res.body)['msg'], textAlign: TextAlign.center),
      ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(json.decode(res.body)['msg'], textAlign: TextAlign.center),
      ));
    }
    return false;
  }
}
