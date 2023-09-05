import 'dart:convert';

import 'package:datamites/pages/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _loginKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  bool loading = false;

  final FocusNode _monthFocusNode = FocusNode();
  final FocusNode _dayFocusNode = FocusNode();
  final FocusNode _yearFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  late DateTime currentDate = DateTime.now();
  String currentDateString = "Date of birth *";
  bool dateChoosen = false;
  bool showError = false;
  bool showDateError = false;

  int month = 0, day = 0, year = 0;

  _sendRegistration(String name, String email, String password, String phone,
      String dob) async {
    var prefs = await SharedPreferences.getInstance();
    var authUrl = prefs.getString("auth_url")??"";
    String apiPath = 'register';
    var finalUrl = "$authUrl$apiPath";
    var map = <String, dynamic>{};
    map['name'] = name;
    map['paswrd'] = password;
    map['mnumber'] = phone;
    map['profile_pic'] =
        'https://firebasestorage.googleapis.com/v0/b/datamties-v3-a59d3.appspot.com/o/unnamed.jpg?alt=media&token=812fdfe6-7e2e-466c-97ad-55bc04e0d7ee';
    map['dob'] = dob;
    map['email'] = email;

    try {
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        body: map,
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(response.body)['msg'],
              textAlign: TextAlign.center),
        ));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(response.body)['msg'],
              textAlign: TextAlign.center),
        ));
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: const Text("Something went wrong", textAlign: TextAlign.center),
      ));
    }


    return false;
  }

  Future<void> _registerUser() async {
    try {
      var name = _nameController.text.toString();
      var email = _emailController.text.toString();
      var phone = _phoneController.text.toString();
      var password = _passwordController.text.toString();
      var dob = "${_yearController.text}-${_monthController.text}-${_dayController.text}";

      var registered =
          await _sendRegistration(name, email, password, phone, dob);
      if (registered) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => VerifyOtp(email: email)));
      }
    } catch (err) {
      print(err);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _selectDate(BuildContext context, int currentYear) async {
    print(currentYear);
    if (currentYear < 1000 || currentYear == null || currentYear == "")
      currentYear = 2000;
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(currentYear),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      dateChoosen = true;
      setState(() {
        currentDate = pickedDate;
        day = currentDate.day;
        _dayController.text = day.toString();
        month = currentDate.month;
        _monthController.text = month.toString();
        year = currentDate.year;
        _yearController.text = year.toString();
        currentDateString = "$month/$day/$year";
        // userRegistrationService.setdob = currentDateString;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              color: Colors.white,
              child: Form(
                key: _loginKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Text(
                            "New to Datamites?\nPlease fill up the form.",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24),
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.person),
                              labelText: 'Name *',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid name';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.alternate_email),
                              labelText: 'Email *',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains("@")) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: Icon(Icons.phone),
                              labelText: 'Phone *',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 8) {
                                return 'Please enter valid phone';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.key),
                              labelText: 'Password *',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid password';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month, color: Colors.grey,),
                              Container(
                                width: width-106,
                                margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: showDateError? Colors.red: Colors.black38)
                                ),
                                child: MaterialButton(
                                  onPressed: (){
                                    _selectDate(context, year);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(currentDateString, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black54),)
                                    ],
                                  ),
                                )
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (day ==0 || month ==0 || year == 0){
                              setState(() {
                                showDateError = true;
                              });
                            } else {
                              setState(() {
                                showDateError = false;
                              });
                            }
                              if (_loginKey.currentState!.validate()) {

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content: Text('Processing Data')),
                              // );
                              if (day !=0 && month !=0 && year != 0) {
                                setState(() {
                                  loading = true;
                                });
                                _registerUser();
                              }
                            }
                          },
                          child: const SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                "Register",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
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
                ),
              )),
          if (loading)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white24,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
