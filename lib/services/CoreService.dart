import 'package:flutter/material.dart';
import 'package:free_drive/models/DashboardModel.dart';
import 'package:free_drive/ui/pages/dashboard/DashboardPage.dart';
import 'package:free_drive/ui/pages/driver/LicenceUploadPage.dart';

class CoreService {

  DashboardModel dashboardState = new DashboardModel(
    balance: 25000,
    activeRideExists: false,
    pendingRideExists: false,
    completedRidesCount: 0
  );

  List<Widget> navigationPages = [
    new LicenceUploadPage(),
    new DashboardPage(),
    new DashboardPage(),
  ];

  formatDate(DateTime datetime) {
    String result;
    String yearmonth;
    String weekday;
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

  formatTime(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }


}