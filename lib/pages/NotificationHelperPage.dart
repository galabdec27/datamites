import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/color.dart';
import '../helper/notification_navigation_helper.dart';



class NotificationHelperPage extends StatelessWidget {
  final RemoteMessage remoteMessage;
  const NotificationHelperPage({Key? key, required this.remoteMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification"),),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.notifications_active_sharp, color: MainColor.darkGreen, size: 64,),
            SizedBox(height: 32,),
            Text("${remoteMessage.notification!.title}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24), textAlign: TextAlign.center,),
            SizedBox(height: 32,),
            Text("${remoteMessage.notification!.body}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.grey), textAlign: TextAlign.center,),

            SizedBox(height: 32,),
            MaterialButton(onPressed: (){
              NotificationNavigationHelper navigationHelper = NotificationNavigationHelper();
              navigationHelper.context = context;
              navigationHelper.action = remoteMessage.data['action'];
              navigationHelper.sub_action = remoteMessage.data['sub_action'];
              navigationHelper.external_url = remoteMessage.data['external_url'];
              navigationHelper.external_action = remoteMessage.data['external_action'];

              navigationHelper.processNotification(true);
            } , color: MainColor.darkGreen, child: Text("Open Notification", style: TextStyle(color: Colors.white),),)

          ],
        ),
      ),
    );
  }
}
