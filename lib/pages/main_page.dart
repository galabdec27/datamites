import 'package:datamites/helper/notification_navigation_helper.dart';
import 'package:datamites/helper/user_details.dart';
import 'package:datamites/model/user_model.dart';
import 'package:datamites/pages/account_page.dart';
import 'package:datamites/pages/home_page.dart';
import 'package:datamites/pages/join_code/join_code_v2.dart';
import 'package:datamites/pages/referral/referral_page.dart';
import 'package:datamites/provider/rating_provider_all.dart';
import 'package:datamites/widgets/CustomWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/auth.dart';
import '../helper/color.dart';
import '../helper/connection.dart';
import '../model/RemoteConfigModel.dart';
import 'NotificationHelperPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final UserAuth _userAuth = UserAuth();
  UserDetails userDetails = UserDetails();
  UserModel? userModel;
  bool refreshing = true;
  int _selectedIndex = 0;
  String searchText = "";
  int refreshed = 0;
  bool showUpdateDialog = false;
  bool forceUpdate = false;


  static List<Widget> _navigationOptions = <Widget>[
    const HomePage(),
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => RatingProviderAll()),
    ], child: const JoinCodeV2()),
  ];


  _firebaseMessaging() async {
    // var topic = "dm-test-2023-04-13";
    // if (kDebugMode) {
    //   print("Subscribing to topic $topic");
    // }
    // await FirebaseMessaging.instance.subscribeToTopic(topic);
    FirebaseMessaging.onMessage.listen((event) async {
      if (kDebugMode) {
        print(event);
      }
    });
  }



  Future<RemoteConfigModel> getConfig(BuildContext context) async {

    // await FirebaseMessaging.instance.subscribeToTopic("v3-test-feb-10");


    final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(
          minutes:
          5), // fetch parameters will be cached for a maximum of 1 hour
    ));

    await FirebaseRemoteConfig.instance.activate();
    await _remoteConfig.fetchAndActivate();
    return RemoteConfigModel(
        appstore_url: _remoteConfig.getString('appstore_url_v3'),
        auth_url: _remoteConfig.getString('auth_url_v3'),
        auth_url_tm: _remoteConfig.getString('auth_url_tm'),
        base_url: _remoteConfig.getString('base_url_v3'),
        candidate_portal_url: _remoteConfig.getString("candidate_portal_v3"),
        cash_credit: _remoteConfig.getString('cash_credit'),
        course_credit: _remoteConfig.getString('course_credit'),
        force_update: _remoteConfig.getString('force_update'),
        ios_version: _remoteConfig.getString('ios_version'),
        new_version: _remoteConfig.getString('new_version'),
        playstore_url: _remoteConfig.getString('playstore_url'),
        privacy_policy: _remoteConfig.getString('privacy_policy'),
        tel: _remoteConfig.getString('tel'),
        tos: _remoteConfig.getString('tos'),
        freshdesk_key: _remoteConfig.getString('freshdesk_key'),
        add_firebase_token: _remoteConfig.getString('add_firebase_token'),
        update_reason: _remoteConfig.getString('update_reason'));
  }



  _proceedFurther() async {
    await _checkLogin();
    // getCandidateDetails();
  }

  storeFirebaseToken(String firebaseToken) async {
    print("Token example");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var add_firebase_token = prefs.getString("add_firebase_token")!;
    var token = prefs.getString("jwtToken")??"";
    if (token.isNotEmpty){
      String json = '{"firebaseToken": "$firebaseToken"}';
      if (kDebugMode) {

        print(add_firebase_token);
        print(token);
        print("Token example");
        print(json);
      }
      Map<String, String> header = {"jwt": token, "Content-Type":"application/json"};
      Response res = await post(Uri.parse(add_firebase_token), headers: header, body: json);

      if (kDebugMode) {
        print("Response in token for firebase ${res.statusCode}");
      }
    }

  }


  _getConfig() async {
    RemoteConfigModel remoteConfigModel = await getConfig(context);
    await remoteConfigModel.saveConfigToPrefs(context);
    await setupMessaging();
    if (remoteConfigModel.ios_version != "1.0.7"){
      showUpdateDialog = true;
      if (remoteConfigModel.force_update == "true"){
        forceUpdate = true;
      }
    }

    FirebaseMessaging.instance.getToken().then((token) {
      // if (kDebugMode) print("token $token");
      storeFirebaseToken(token!);
    });
    
    if (showUpdateDialog){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Visibility(
              visible: true,
              child: Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("New version available: ${remoteConfigModel.ios_version}",style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 16,),
                        Html(data: remoteConfigModel.update_reason,),
                        SizedBox(height: 32,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!forceUpdate) MaterialButton(onPressed: ()  async {
                              Navigator.pop(context);
                              await _proceedFurther();
                            }, child: Text("Update Later"), ),
                            MaterialButton(onPressed: (){
                              launchUrl(Uri.parse(remoteConfigModel.appstore_url));
                              } , child: Text("Update", style: TextStyle(color: Colors.white),), color: MainColor.darkGreen, )
                          ],
                        )
                      ],
                    ),
                  )));
        },
      );
    } else{
      await _proceedFurther();
    }
  }


  _checkLogin() async {
    setState(() {
      refreshing = true;
    });
    refreshed = await _userAuth.tokenLogin(context);
    if (refreshed == 1) {
      _navigationOptions = <Widget>[
        const HomePage(),
        MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) => RatingProviderAll()),
        ], child: const JoinCodeV2()),
        // DTribePage(),
        const ReferralScreen(),
        const AccountScreen()
      ];
    } else{
      UserDetails userDetails = UserDetails();
      await userDetails.logoutOnly(context);
    }
    refreshing = false;
    _firebaseMessaging();
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void getCandidateDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("candidate_id","");
  //   String authUrl = prefs.getString("auth_url") ?? "";
  //   String apiPath = 'Candidate/';
  //   String finalUrl =
  //       "$authUrl${apiPath}getCandidateByEmail?email=${prefs.getString("user_email") ?? ""}";
  //
  //   http.Response response = await http.get(Uri.parse(finalUrl));
  //   print("Test");
  //   print(response.body);
  //
  //   try {
  //     var responseBody = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       prefs.setString("candidate_id", responseBody["data"]["candidate_id"]);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(responseBody['msg'], textAlign: TextAlign.center),
  //       ));
  //     }
  //   } catch (err) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(err.toString(), textAlign: TextAlign.center),
  //     ));
  //   }
  // }

  _getUserDetail() async {
    userModel = await userDetails.getDetail();
    setState(() {});
  }


  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await setupFlutterNotifications();
    showFlutterNotification(message);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print('Handling a background message ${message.messageId}');
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            tag: message.data["key"],
            subText: message.data["value"],
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  setupMessaging() async {
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('A new onMessageOpenedApp event was published!');
        print(message.data);
        NotificationNavigationHelper navigationHelper =
        NotificationNavigationHelper();
        navigationHelper.context = context;
        navigationHelper.action = message.data['action'];
        navigationHelper.sub_action = message.data['sub_action'];
        navigationHelper.external_url = message.data['external_url'];
        navigationHelper.external_action = message.data['external_action'];

        navigationHelper.processNotification(false);
      }
    });

    // FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              NotificationHelperPage(remoteMessage: message)));
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('A new onMessageOpenedApp event was published!');
        print(message.data);
        NotificationNavigationHelper navigationHelper =
        NotificationNavigationHelper();
        navigationHelper.context = context;
        navigationHelper.action = message.data['action'];
        navigationHelper.sub_action = message.data['sub_action'];
        navigationHelper.external_url = message.data['external_url'];
        navigationHelper.external_action = message.data['external_action'];

        navigationHelper.processNotification(false);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.data);
      NotificationNavigationHelper navigationHelper =
      NotificationNavigationHelper();
      navigationHelper.context = context;
      navigationHelper.action = message.data['action'];
      navigationHelper.sub_action = message.data['sub_action'];
      navigationHelper.external_url = message.data['external_url'];
      navigationHelper.external_action = message.data['external_action'];

      navigationHelper.processNotification(false);
    });
  }


  _doInitialization() async {
    bool connected = await ConnectionCheck.isAvailable();
    if (!connected) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Connection Lost"),
              content: const Text("Please check your internet connection"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                            (route) => false);
                  },
                  child: const Text("Ok"),
                )
              ],
            );
          });
    } else {
      await _getConfig();
    }


  }

  @override
  void initState() {
    _doInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getUserDetail();
    return (refreshing) ? Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Image.asset(
              "assets/datamites_icon.png",
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
          )
        ),
      ),
    ): Scaffold(
      appBar
          : CustomWidget.getDatamitesAppBar(context, userModel, refreshed),
      backgroundColor: Colors.white,
      body:IndexedStack(
              index: _selectedIndex,
              children: _navigationOptions,
            ),
      // body: _navigationOptions.elementAt(_selectedIndex),
      bottomNavigationBar: refreshing
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school_outlined),
                  label: 'Classroom',
                ),
              ],
            )
          : (refreshed == 1)
              ? BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school_outlined),
                      label: 'Classroom',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add_alt_rounded),
                      label: 'Referral',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.more_vert_rounded),
                      label: "More",
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.blue,
                  onTap: _onItemTapped,
                )
              : BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school_outlined),
                      label: 'Classroom',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.blue,
                  onTap: _onItemTapped,
                ),
    );
  }
}
