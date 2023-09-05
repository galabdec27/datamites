
import 'package:datamites/model/course/course_price_mode_general.dart';
import 'package:datamites/model/course/online_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/contact_us.dart';

class TrainingScheduleCard extends StatefulWidget {
  late OnlineScheduleModel os;
  late List<OnlineScheduleModel> onlineSchedule;
  late String currencySymbol;
  late CoursePriceModelGeneral coursePriceModel;
  late BuildContext context;

  TrainingScheduleCard(
      OnlineScheduleModel? os,
      List<OnlineScheduleModel>? onlineSchedule,
      String? currencySymbol,
      CoursePriceModelGeneral? coursePriceModel,
      BuildContext? context, {Key? key}) : super(key: key) {
    this.os = os!;
    this.onlineSchedule = onlineSchedule!;
    this.currencySymbol = currencySymbol!;
    this.coursePriceModel = coursePriceModel!;
    this.context = context!;
  }

  @override
  _TrainingScheduleCardState createState() => _TrainingScheduleCardState();
}

class _TrainingScheduleCardState extends State<TrainingScheduleCard> {
  bool loaded = false;
  Color darkRed = const Color(0xFFe36b17);
  String getMonth(DateTime dateTime){
    String month = '';
    switch (dateTime.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sept";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }
    return month;
  }

  getTime(int hours, int minutes){
    String time;
    String hour = hours.toString();
    String minute = minutes.toString();
    String suffix;
    if(hours > 12){
      hour = (hours-12).toString();
      suffix = "PM";
    } else {

      hour = hours.toString();
      suffix = "AM";

    }
    if(minutes < 10){
      minute = "0$minute";
    }
    time = "$hour:$minute $suffix";
    return time;
  }

  @override
  Widget build(BuildContext context) {

    String startDateTime = widget.os.training_date+" "+widget.os.training_start_time;

    var time = DateTime.parse("${startDateTime}Z");
    DateTime utcTime = time.subtract(const Duration(hours: 5, minutes: 30));
    var currentTime = utcTime.toLocal();
    var timeZone = currentTime.timeZoneName;

    var endTime = DateTime.parse("${widget.os.training_date} ${widget.os.training_end_time}Z");

    Duration difference = endTime.difference(time);

    int totalMinuteDiff = difference.inMinutes;

    int hourDiff = totalMinuteDiff ~/ 60;
    int minuteDiff = totalMinuteDiff % 60;


    var width = MediaQuery.of(context).size.width;
    return GestureDetector(

        onTap: (){
          print("Card tapped");
        },
        child: Container(
          color: Color(0x49f6f6f6),
          width: width,
          padding: EdgeInsets.fromLTRB(8.0, 16, 0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width/4,
                child: Column(
                  children: <Widget>[
                    Text(currentTime.day.toString(), style: TextStyle(color: darkRed, fontSize: 24, fontWeight: FontWeight.w600),),
                    SizedBox(height: 4,),
                    Text(getMonth(currentTime), style: TextStyle(color: darkRed, fontSize: 14)),
                    SizedBox(height: 4,),
                    Text("("+timeZone+")", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                  child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(getTime(currentTime.hour, currentTime.minute), style: TextStyle(color: darkRed, fontSize: 18, fontWeight: FontWeight.w600),),
                                  Container(
                                    alignment: FractionalOffset.center,
                                    width: 80,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(hourDiff.toString()+"hr "+minuteDiff.toString()+"min", style: TextStyle(color: darkRed, fontSize: 12),),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8,),
                              Text(widget.os.training_name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                              const SizedBox(height: 8,),
                              Container(
                                width: double.infinity,
                                alignment: FractionalOffset.centerRight,
                                child: MaterialButton(
                                  elevation: 4,
                                  minWidth: 100,
                                  color: darkRed,

                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ContactUsScreen(title: "Enquire now", message: "I am interested in online training of ${widget.os.training_name}, starting from time ${widget.os.training_start_time}" )
                                    ));
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    child: Center(
                                      child: Text("Enquire", style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                      )
                  )
              ),

            ],
          ),
        )

    );
  }
}