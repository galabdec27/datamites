import 'package:flutter/material.dart';

import '../helper/color.dart';
import '../helper/notification_navigation_helper.dart';
import '../model/notification_model.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  NotificationNavigationHelper navHelper = NotificationNavigationHelper();

  late Icon showIcon;


  _forwardNotification(BuildContext context, String action, String subAction,
      String externalUrl, String externalAction) {
    navHelper.context = context;
    navHelper.action = action;
    navHelper.sub_action = subAction;
    navHelper.external_url = externalUrl;
    navHelper.external_action = externalAction;
    try {
      navHelper.processNotification(false);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (widget.notification.action == '0') {
      showIcon = Icon(
        Icons.person_add,
        size: 20,
        color: MainColor.textColorConst,
      );
    } else if (widget.notification.action == '1') {
      showIcon = Icon(
        Icons.library_books,
        size: 20,
        color: MainColor.textColorConst,
      );
    } else {
      showIcon = Icon(
        Icons.web,
        size: 20,
        color: MainColor.textColorConst,
      );
    }
    TextStyle titleStyle = TextStyle(
        color: MainColor.textColorConst,
        fontSize: 18,
        fontWeight: FontWeight.w600);
    TextStyle descStyle = TextStyle(
        color: MainColor.textColorConst,
        fontSize: 16,
        fontWeight: FontWeight.normal);
    return MaterialButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          _forwardNotification(
              context,
              widget.notification.action,
              widget.notification.sub_action ?? "",
              widget.notification.external_ur ?? "",
              widget.notification.external_action ?? "");
        },
        child: Container(
            width: width,
            // height: (widget.notification.image!="") ? 120 + width *9/16: 120,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: showIcon,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.notification.title,
                            style: titleStyle,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                        child: Text(
                          widget.notification.description,
                          style: descStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                if (widget.notification.image != "")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48 + 16, 0, 16, 8),
                    child: Image.network(widget.notification.image!,
                        width: double.infinity, fit: BoxFit.contain),
                  ),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.notification.created_at!.substring(0, 10),
                      style: descStyle.copyWith(fontSize: 10),
                    )),
                const Divider()
              ],
            )
        ));
  }
}


