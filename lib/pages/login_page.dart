import 'dart:convert';

import 'package:datamites/pages/forget_password.dart';
import 'package:datamites/pages/main_page.dart';
import 'package:datamites/pages/register_page.dart';
import 'package:datamites/pages/verify_otp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool loading = false;

  Future<void> _loginService(var email, var password) async {
      var prefs = await SharedPreferences.getInstance();
      var authUrl = prefs.getString("auth_url")??"";
      var finalUrl = "${authUrl}login";
      if (kDebugMode) print("Login url is $finalUrl");

      var map = <String, dynamic>{};
      map['email'] = email;
      map['paswrd'] = password;

      http.Response response = await http.post(
        Uri.parse(finalUrl),
        body: map,
      );

      if (response.statusCode == 200) {
        var resp = json.decode(response.body);
        await prefs.setString("user_name", resp["user_data"]['name']);
        await prefs.setString("user_email", resp["user_data"]['email']);
        await prefs.setString("user_image", resp["user_data"]['profile_pic']);
        await prefs.setString("user_phone", resp["user_data"]['mnumber']);
        await prefs.setString("user_dob", resp["user_data"]['dob']??"");
        await prefs.setString("refreshToken", resp['refreshToken']);
        await prefs.setString("jwtToken", resp['jwtkey']);
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> const MainPage()), (route) => false);
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VerifyOtp(email: email)),
        );
      }
      try {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(json.decode(response.body)['msg'],
              textAlign: TextAlign.center),
        ));
      } catch (e) {
        if (kDebugMode) {
          print("Exception $e");
        }
      }

  }

  _loginUser() async {
    String email = emailController.text;
    String password = passwordController.text;


    setState(() {
      loading = true;
    });

    await _loginService(email, password);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: MainColor.textColorConst,
                                fontSize: 24),
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.alternate_email),
                              labelText: 'Email *',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty || !value.contains("@")) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: passwordController,
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
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (_loginKey.currentState!.validate()) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text('Processing Data')),
                              // );
                              _loginUser();
                            }
                          },
                          child: const SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                "Log in",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 8),
                        child: MaterialButton(
                          elevation: 1,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const RegisterPage())
                            );
                          },
                          child: SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                "Do not have an account? SIGN UP",
                                style: TextStyle(color: MainColor.textColorConst),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                        child: MaterialButton(
                          elevation: 1,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ResetScreen())
                            );
                          },
                          child: const SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                "Forget your password? RESET",
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),

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
                              style: TextStyle(color: MainColor.textColorConst),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          if(loading)Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white24,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
