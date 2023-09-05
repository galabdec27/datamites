import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:datamites/helper/auth.dart';
import 'package:datamites/helper/user_details.dart';
import 'package:datamites/model/user_model.dart';
import 'package:datamites/pages/main_page.dart';
import 'package:datamites/pages/password_change_page.dart';
import 'package:datamites/pages/referral/referral_widgets/neomorphism.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../helper/color.dart';
import 'package:http_parser/http_parser.dart';

import 'dart:math';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

enum ConfirmAction { GALLERY, CAMERA }

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _emailFocusNode = new FocusNode();
  final FocusNode _nameFocusNode = new FocusNode();
  final FocusNode _phoneFocusNode = new FocusNode();
  final _registerKey = GlobalKey<FormState>();
  bool imageProgress = false;

  File? _image;
  var intentImage;
  bool imageUploaded = false;

  // FirebaseStorage storage = FirebaseStorage.instance;
  UserProfileUpdateService userProfileUpdateService =
      new UserProfileUpdateService();
  UserAuth userAuth = UserAuth();
  UserDetails userDetails = UserDetails();

  late String name, email, image, phone, dob;
  late String changedName, changedEmail, changedImage, changedPhone, changedDob;

  bool loaded = false;

  var fieldHeight = 50.0;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController dobController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  _getUserData(BuildContext context) async {
    setState(() {
      loaded = false;
    });
    await userAuth.tokenRefresh(context);
    await userAuth.tokenLogin(context);
    var user = await userDetails.getDetail();
    changedName = name = user.userName;
    nameController.text = user.userName;
    changedEmail = email = user.userEmail;
    emailController.text = user.userEmail;
    changedImage = image = user.userImage;
    print("Image url is $image");
    changedPhone = phone = user.userPhone;
    phoneController.text = user.userPhone;
    changedDob = dob = user.userDob;
    dobController.text = user.userDob;
    setState(() {
      loaded = true;
    });
  }

  late DateTime currentDate = DateTime.now();
  bool dateChoosen = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        dob = currentDate.year.toString() +
            "-" +
            currentDate.month.toString() +
            "-" +
            currentDate.day.toString();
        print(dob);
      });
    }
  }

  Future<Future<ConfirmAction?>> _asyncConfirmDialog(
      BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose one!'),
          content: const Text('Please select either gallery or camera'),
          actions: <Widget>[
            MaterialButton(
              child: const Text('GALLERY'),
              onPressed: () {
                Navigator.of(context).pop();
                getImage(context, ConfirmAction.GALLERY);
              },
            ),
            MaterialButton(
              child: const Text('CAMERA'),
              onPressed: () {
                Navigator.of(context).pop();
                getImage(context, ConfirmAction.CAMERA);
              },
            )
          ],
        );
      },
    );
  }

  Future getImage(BuildContext context, var action) async {
    print("Getting image");
    if (action == ConfirmAction.GALLERY) {
      intentImage = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 200);
      setState(() {
        _image = File(intentImage.path);
        imageProgress = true;
        _uploadImageToServer(_image!);
      });
    } else {
      try {
        intentImage = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 200);
        setState(() {
          _image = File(intentImage.path);
          imageProgress = true;
          _uploadImageToServer(_image!);
        });
      } catch (e) {
        // Fluttertoast.showToast(
        //     msg: e.toString(),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    }
    imageUploaded = true;
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  _uploadImageToServer(File imageFile) async {
    var prefs = await SharedPreferences.getInstance();
    var authUrl = prefs.getString("auth_url_tm")??"";
    String url = "${authUrl}ImageUpload/uploadImage";
    print(url);
    print(imageFile.path);
    var request = http.MultipartRequest("POST", Uri.parse(url))
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path,
          contentType: MediaType('image', 'jpg')));
    request.fields['width'] = '200';
    request.send().then((response) async {
      if (response.statusCode == 200) {
        print("Success uploading image");
        var str = await response.stream.bytesToString();
        print(str);
        var resp = json.decode(str);
        _changeImage(resp["data"]);
      } else {
        print("Failure");
        print(response.statusCode);
        var str = await response.stream.bytesToString();
        print(str);
      }
    });
  }

  _changeImage(String changedImage) async {
    print("Changing image");
    print(changedImage);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userImage", changedImage);
    UserProfileUpdateService updateService = UserProfileUpdateService();
    UserModel userModel = await userDetails.getDetail();
    updateService.setdob = userModel.getUserDob;
    updateService.setEmail = userModel.getUserEmail;
    updateService.setContext = context;
    updateService.setImage = changedImage;
    updateService.setName = userModel.userName;
    updateService.setPhone = userModel.getUserPhone;
    var updated = await updateService.updateuser;
    if (updated)
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Image is successful, we need to restart the application'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    else
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Failure'),
          content: const Text('We cannot upload your image'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    setState(() {
      imageProgress = false;
    });
  }

  @override
  void initState() {
    _getUserData(context);
    super.initState();
  }

  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    Future<void> _updateUser(
        UserProfileUpdateService userProfileUpdateService) async {
      bool update = await userProfileUpdateService.updateuser;
      setState(() {
        showProgress = false;
      });
      if (update) {
        UserDetails userDetails = UserDetails();
        UserModel userModel = UserModel();
        userModel.userName = changedName;
        userModel.userEmail = changedEmail;
        userModel.userDob = changedDob;
        userModel.userPhone = changedPhone;
        userModel.userImage = changedImage;
        userModel.userId = "";
        await userDetails.setDetail(userModel);
        showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Update'),
            content: const Text('User update is successful'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    if ((loaded)) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Update Profile"),
          ),
          body: SafeArea(
            child: AbsorbPointer(
              absorbing: showProgress,
              child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _registerKey,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ignore: sized_box_for_whitespace
                                SizedBox(height: 8,),
                                Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: Visibility(
                                        visible: showProgress,
                                        child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                              MainColor.textColorConst,
                                            )))),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    _image == null
                                        ? Container(
                                            // color: Colors.red,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(image),
                                                    fit: BoxFit.cover)),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(_image!),
                                                    fit: BoxFit.cover))),
                                    new BackdropFilter(
                                      filter: new ImageFilter.blur(
                                          sigmaX: 5.0, sigmaY: 5.0),
                                      child: new Container(
                                        decoration: new BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.0)),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xb3424242)),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        child: Visibility(
                                          visible: imageProgress,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.orange),
                                                ),
                                                height: 120.0,
                                                width: 126.0,
                                              ),
                                            ],
                                          ),
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          _asyncConfirmDialog(context);
                                          print("Tapped");
                                        },
                                        child: _image == null
                                            ? Container(
                                                width: 120.0,
                                                height: 120.0,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60.0),
                                                    child: FadeInImage(
                                                      placeholder: NetworkImage(
                                                          "https://cdn5.vectorstock.com/i/1000x1000/04/09/user-icon-vector-5770409.jpg"),
                                                      image:
                                                          NetworkImage(image),
                                                      fit: BoxFit.cover,
                                                    )))
                                            : Container(
                                                width: 120.0,
                                                height: 120.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60.0),
                                                    image: DecorationImage(
                                                        image:
                                                            FileImage(_image!),
                                                        fit: BoxFit.cover)),
                                              ),

                                        // Image.file(_image),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white54,
                                      height: 120.0,
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 120.0,
                                        height: 120.0,
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: (){
                                            _asyncConfirmDialog(context);
                                          },
                                          child: Text(
                                            "Click \nto \nupload",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   width: MediaQuery.of(context).size.width,
                                //   alignment: Alignment.center,
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       _asyncConfirmDialog(context);
                                //     },
                                //     child: _image == null
                                //         ? SizedBox(
                                //             width: 120.0,
                                //             height: 120.0,
                                //             child: ClipRRect(
                                //                 borderRadius:
                                //                     BorderRadius.circular(60.0),
                                //                 child: FadeInImage(
                                //                   placeholder: const NetworkImage(
                                //                       "https://firebasestorage.googleapis.com/v0/b/datamties-v3-a59d3.appspot.com/o/unnamed.jpg?alt=media&token=812fdfe6-7e2e-466c-97ad-55bc04e0d7ee"),
                                //                   image: NetworkImage(image),
                                //                   fit: BoxFit.cover,
                                //                 )))
                                //         : Container(
                                //             width: 120.0,
                                //             height: 120.0,
                                //             decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     BorderRadius.circular(60.0),
                                //                 image: DecorationImage(
                                //                     image: FileImage(_image!),
                                //                     fit: BoxFit.cover)),
                                //           ),
                                //
                                //     // Image.file(_image),
                                //   ),
                                // ),

                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 4, 4),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.grey[200]),
                                    child: TextFormField(
                                      focusNode: _nameFocusNode,
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person_outlined),
                                        border: InputBorder.none,
                                        enabledBorder: null,
                                        hintText: 'full name',
                                      ),
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(_emailFocusNode);
                                      },
                                      onSaved: (String? value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String? value) {
                                        changedName = value!.trim();
                                        // userRegistrationService.setName = value;
                                        return (value.length < 3)
                                            ? 'full name should be at least 3 character long'
                                            : null;
                                      },
                                    )),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 4, 4),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.grey[200]),
                                    child: TextFormField(
                                      focusNode: _emailFocusNode,
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.alternate_email_sharp),
                                        border: InputBorder.none,
                                        enabledBorder: null,
                                        hintText: 'email address',
                                      ),
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(_phoneFocusNode);
                                      },
                                      onSaved: (String? value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String? value) {
                                        changedEmail = value!.trim();
                                        // userRegistrationService.setEmail = value;
                                        return (!value.contains('@'))
                                            ? 'enter a valid mail'
                                            : null;
                                      },
                                    )),
                                Container(
                                    height: fieldHeight,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 4, 4),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.grey[200]),
                                    child: TextFormField(
                                      focusNode: _phoneFocusNode,
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(20),
                                        FilteringTextInputFormatter.deny(new RegExp(
                                            '[\\.|\\,|\\`|\\!|\\@|\\#|\\%|\\^|\\&|\\*|\\(|\\)|\\"|\\-|\\_|\\=|\\+|\\/|\\.|\\,|\\<|\\.|\\>|\\:|\\;|\\"|\\?|\\s]')),
                                      ],
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.phone_sharp),
                                        border: InputBorder.none,
                                        enabledBorder: null,
                                        hintText: 'phone number',
                                      ),
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                      onSaved: (String? value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String? value) {
                                        changedPhone = value!.trim();
                                        // userRegistrationService.setPhone = value!.trim();
                                        return (value.length < 7)
                                            ? 'enter a valid phone numver.'
                                            : null;
                                      },
                                    )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    padding: EdgeInsets.fromLTRB(8, 4, 4, 4),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.grey[200]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          padding: EdgeInsets.all(0.0),
                                          height: 55,
                                          elevation: 0.0,
                                          onPressed: () => _selectDate(context),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Icon(Icons.date_range_outlined,
                                                  color: Colors.grey[600]),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(dob,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 16.0,
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    // showError = true;
                                    setState(() {});
                                    print(
                                        _registerKey.currentState!.validate());
                                    if (imageProgress) {
                                      ScaffoldMessenger.of(context)
                                          // ignore: prefer_const_constructors
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            'Image is uploading, please wait',
                                            textAlign: TextAlign.center),
                                      ));
                                    } else if (!_registerKey.currentState!
                                        .validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      ScaffoldMessenger.of(context)
                                          // ignore: prefer_const_constructors
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            'Enter the valid input',
                                            textAlign: TextAlign.center),
                                      ));
                                    } else {
                                      if ((changedName == name) &&
                                          (changedEmail == email) &&
                                          (changedPhone == phone) &&
                                          (changedImage == image) &&
                                          (changedDob == dob)) {
                                        ScaffoldMessenger.of(context)
                                            // ignore: prefer_const_constructors
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              "No field(s) have been changed",
                                              textAlign: TextAlign.center),
                                        ));
                                      } else {
                                        showProgress = true;
                                        userProfileUpdateService.setName =
                                            changedName;
                                        userProfileUpdateService.setEmail =
                                            changedEmail;
                                        userProfileUpdateService.setImage =
                                            changedImage;
                                        userProfileUpdateService.setPhone =
                                            changedPhone;
                                        userProfileUpdateService.setContext =
                                            context;
                                        userProfileUpdateService.setdob = dob;
                                        _updateUser(userProfileUpdateService);
                                      }
                                      // _sendRegistrationRequest(
                                      //     userRegistrationService, context);
                                    }

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => MainPage(widget.analytics)));
                                  },
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  minWidth: double.infinity,
                                  height: 55.0,
                                ).addNeumorphism(
                                  blurRadius: 8,
                                  borderRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                MaterialButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasswordChangeScreen()));
                                  },
                                  child: const Text(
                                    "Change password",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  minWidth: double.infinity,
                                  height: 55.0,
                                ).addNeumorphism(
                                  blurRadius: 8,
                                  borderRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  color: Colors.white,
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Go back",
                                    style: TextStyle(
                                        color: MainColor.textColorConst,
                                        fontSize: 16),
                                  ),
                                  minWidth: double.infinity,
                                  height: 55.0,
                                ).addNeumorphism(
                                  blurRadius: 8,
                                  borderRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ));
    } else {
      return Scaffold(
        body: Center(
          child: Text("Loading"),
        ),
      );
    }
  }
}

class UserProfileUpdateService {
  late http.Response resp;
  late String authUrl;
  late String finalUrl;
  late String email;
  late String name;
  late String dobpassword;
  late String phone;
  late String dob;
  late String jwtToken;
  late String profileImageUrl;
  late SharedPreferences prefs;
  late BuildContext context;
  String apiPath = 'update';

  set setPhone(String phone) {
    this.phone = phone;
  }

  set setEmail(String email) {
    // print("Setting email " + email);
    this.email = email;
  }

  set setName(String name) {
    // print("Setting name " + name);
    this.name = name;
  }

  set setdob(String dob) {
    // print("Setting dob " + dob);
    this.dob = dob;
  }

  set setImage(String profileImageUrl) {
    // print("Setting profileImageUrl " + profileImageUrl);
    this.profileImageUrl = profileImageUrl;
  }

  set setContext(BuildContext context) {
    this.context = context;
  }

  Future<bool> get updateuser async {
    prefs = await SharedPreferences.getInstance();
    var authUrl = prefs.getString("auth_url")??"";
    jwtToken = prefs.getString("jwtToken") ?? "";
    finalUrl = authUrl + apiPath;
    // print(finalUrl);

    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['mnumber'] = phone;
    map['profile_pic'] = profileImageUrl;
    map['dob'] = dob;
    map['email'] = email;
    print(map);

    try {
      http.Response response = await http
          .post(Uri.parse(finalUrl), body: map, headers: {"jwt": jwtToken});
      prefs.setString("user_email", email);
      print("Profile upload status");
      print(response.statusCode);
      if (response.statusCode == 201) {
        return true;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json.decode(response.body)['msg'],
            textAlign: TextAlign.center),
      ));
    } catch (e) {
      print("Exception " + e.toString());
    }

    return false;
  }
}
