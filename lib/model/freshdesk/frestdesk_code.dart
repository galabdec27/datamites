import 'package:datamites/helper/color.dart';
import 'package:flutter/cupertino.dart';

class FreshDeskConstant {
  String getSourceName(int source) {
    switch (source) {
      case 1:
        return "Email";
      case 2:
        return "Portal";
      case 3:
        return "Phone";
      case 7:
        return "Chat";
      case 9:
        return "Feedback Widget";
      case 10:
        return "Outbound Email";
    }
    return "Unknown";
  }

  int getStatusCode(String status) {
    switch (status) {
      case "Open":
        return 2;
      case "Pending":
        return 3;
      case "Resolved":
        return 4;
      case "Closed":
        return 5;
    }
    return 3;
  }

  String getStatusName(int status) {
    switch (status) {
      case 2:
        return "Open";
      case 3:
        return "Pending";
      case 4:
        return "Resolved";
      case 5:
        return "Closed";
    }
    return "Unknown";
  }

  List<Color> getStatusColor(int status) {
    switch (status) {
      case 2:
        return [MainColor.lightBlue, MainColor.darkBlue];
      case 3:
        return [MainColor.lightBlue, MainColor.darkBlue];
      case 4:
        return [MainColor.lightGreen, MainColor.darkGreen];
      case 5:
        return [MainColor.lightRed, MainColor.darkRed];
        ;
    }
    return [MainColor.lightRed, MainColor.darkRed];
    ;
  }

  int getPriorityCode(String priority) {
    switch (priority) {
      case "Low":
        return 1;
      case "Medium":
        return 2;
      case "High":
        return 3;
      case "Urgent":
        return 4;
    }
    return 3;
  }

  String getPriorityName(int priority) {
    switch (priority) {
      case 1:
        return "Low";
      case 2:
        return "Medium";
      case 3:
        return "High";
      case 4:
        return "Urgent";
    }
    return "Unknown";
  }

  List<Color> getPriorityColor(int status) {
    switch (status) {
      case 1:
        return [MainColor.lightGrey, MainColor.textColorConst];
      case 2:
        return [MainColor.lightBlue, MainColor.darkBlue];
      case 3:
        return [MainColor.lightGreen, MainColor.darkGreen];
      case 4:
        return [MainColor.lightRed, MainColor.darkRed];
        ;
    }
    return [MainColor.lightRed, MainColor.darkRed];
    ;
  }
}

enum PriorityEnum { Low, Medium, High, Urgent }
