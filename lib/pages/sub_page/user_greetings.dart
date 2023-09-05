import 'package:flutter/material.dart';

class UserGreetings extends StatelessWidget {
  final String userName;
  final String greetingText;
  final String userImage;

  const UserGreetings(
      {required this.userName, required this.greetingText, required this.userImage});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greetingText,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
          Text(userName,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
        ],
      ),
    );
  }
}