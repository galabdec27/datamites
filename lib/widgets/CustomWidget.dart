import 'package:datamites/model/user_model.dart';
import 'package:flutter/material.dart';

import '../pages/notification_page.dart';
import '../pages/update_profile_page.dart';

class CustomWidget {
  static AppBar getDatamitesAppBar(BuildContext context, UserModel? userModel, int refreshed) {
      return AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/datamites.png",
              height: 24,
              fit: BoxFit.contain,
            ),
            // Text(userModel?.userImage??""),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const NotificationPage()));
                    },
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.grey,
                    )),
                if (refreshed == 1 && userModel  != null)

                  SizedBox(
                    width: 40,
                    height: 40,
                    child: MaterialButton(
                        height: 40,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const UpdateProfileScreen()));
                        },
                        child: SizedBox(
                            width: 120.0,
                            height: 120.0,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: Image.network(userModel.userImage, fit: BoxFit.cover,),
                                // child: FadeInImage(
                                //   placeholder: AssetImage("assets/datamites_icon.png"),
                                //   image: NetworkImage(userModel.userImage),
                                //   fit: BoxFit.cover,
                                // )
                            ))),
                  )
              ],
            )
          ],
        ),
        elevation: 0.2,
      );
  }
}