import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EDialogType.dart';
import 'package:free_drive/models/payment/PendingPaymentModel.dart';
import 'package:lottie/lottie.dart';

class Utils {

  static timestampToDateTime(Timestamp timestamp) {
    if(timestamp == null)
      return null;
    else
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

  static showErrorDialog(String title, String content) {
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
              child: Text(content, textAlign: TextAlign.center)
          ),
          actions: [
            TextButton(child: Text("D'accord"), onPressed: () => navigatorKey.currentState.pop()),
          ],
        )
    );
  }

  static bool validatePaymentNumber(String phoneNumber) {
    if(phoneNumber.characters.length != 8)
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

  static showLocalNotification({@required String title, @required String bodyContent, @required payload}) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        NOTIFICATION_CHANNEL_ID, NOTIFICATION_MAIN_CHANNEL,
        channelDescription: NOTIFICATION_CHANNEL_DESC,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(0, title, bodyContent, platformChannelSpecifics, payload: payload);
  }

  static String convertPaymentStatusToHumanReadableFormat(int status) {
    String _convertedValue;
    switch(status) {
      case 0:
        _convertedValue = "Chargement Réussi";
        break;
      case 2:
        _convertedValue = "En Attente";
        break;
      case 4:
        _convertedValue = "Expiré";
        break;
      case 6:
        _convertedValue = "Annulé";
        break;
    }
    return _convertedValue;
  }

  static getPendingPaymentBadgeColor(PendingPaymentModel pendingPayment) {
    Color color;
    switch(pendingPayment.status) {
      case 0:
        color = Colors.green;
        break;
      case 2:
        color = Colors.amber;
        break;
      case 4:
        color = Colors.red;
        break;
      case 6:
        color = Colors.black;
        break;
    }
    return color;
  }

}