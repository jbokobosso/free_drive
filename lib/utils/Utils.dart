import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EDialogType.dart';
import 'package:lottie/lottie.dart';

class Utils {

  static timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static int getAgeFromBirthdate(DateTime birthdate) {
    Duration timeDifference = DateTime.now().difference(birthdate);
    return (timeDifference.inDays/365).ceil();
  }

  static String formatDateToHuman(DateTime datetime) {
    String result;
    String yearmonth;
    String weekday;
    if(datetime == null) return "";
    switch(datetime.weekday) {
      case 1 : weekday = "Lundi";break;
      case 2 : weekday = "Mardi";break;
      case 3 : weekday = "Mercredi";break;
      case 4 : weekday = "Jeudi";break;
      case 5 : weekday = "Vendredi";break;
      case 6 : weekday = "Samedi";break;
      case 7 : weekday = "Dimanche";break;
    }
    switch(datetime.month) {
      case 1: yearmonth = "Janvier";break;
      case 2: yearmonth = "Février";break;
      case 3: yearmonth = "Mars";break;
      case 4: yearmonth = "Avril";break;
      case 5: yearmonth = "Mai";break;
      case 6: yearmonth = "Juin";break;
      case 7: yearmonth = "Juillet";break;
      case 8: yearmonth = "Août";break;
      case 9: yearmonth = "Septembre";break;
      case 10: yearmonth = "Octobre";break;
      case 11: yearmonth = "Novembre";break;
      case 12: yearmonth = "Decembre";break;
    }
    result = "$weekday ${datetime.day.toString()} $yearmonth ${datetime.year.toString()}";
    return result;
  }

  static String formatTimeToHuman(TimeOfDay time) {
    if(time == null) return "";
    return "${time.hour}:${time.minute}";
  }

  static showRichTextDialog(String title, RichText richText) {
    showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
          ),
          titlePadding: EdgeInsets.all(0.0),
          title: Container(
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
            ),
            width: double.infinity,
            height: 30.0,
            child: Align(child: Text(title, style: TextStyle(color: Colors.white)), alignment: Alignment.center),
          ),
          content: SizedBox(
              child: richText
          ),
          actions: [
            TextButton(child: Text("D'accord"), onPressed: () => navigatorKey.currentState.pop()),
          ],
        )
    );
  }

  static showDialogBox(String title, String content, {EDialogType dialogType, String animationAsset}) {
    showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext,
        builder: (_) => SizedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
            ),
            titlePadding: EdgeInsets.all(0.0),
            title: Container(
              decoration: BoxDecoration(
                  color: dialogType == EDialogType.info ? Colors.blue : dialogType == EDialogType.error ? Colors.red : Colors.amberAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
              ),
              width: double.infinity,
              height: 30.0,
              child: Align(child: Text(title, style: TextStyle(color: Colors.white)), alignment: Alignment.center),
            ),
            content: SizedBox(
              height: deviceHeight*0.3,
              child: Column(
                children: [
                  animationAsset != null ? Expanded(child: Lottie.asset(animationAsset)) : Container(),
                  SizedBox(
                      child: Text(content, textAlign: TextAlign.center)
                  )
                ],
              ),
            ),
            actions: [
              TextButton(child: Text("D'accord"), onPressed: () => navigatorKey.currentState.pop()),
            ],
          ),
        )
    );
  }

  static bool validatePhoneNumber(String phoneNumber) {
    if(phoneNumber.characters.length != 12)
      return false;
    else
      return true;
  }

  static bool validateEmail(String email) {
    if(!email.contains("@"))
      return false;
    else
      return true;
  }

  static double deviceWidth = MediaQuery.of(navigatorKey.currentState.context).size.width;

  static double deviceHeight =MediaQuery.of(navigatorKey.currentState.context).size.height;

}