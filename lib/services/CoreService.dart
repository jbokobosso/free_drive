import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/DashboardModel.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/ui/pages/dashboard/DriverDashboardPage.dart';
import 'package:free_drive/ui/pages/dashboard/UserDashboardPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreService {

  double get deviceHeight => this._getDeviceHeight();
  double get deviceWidth => this._getDeviceWidth();

  UserModel loggedUser;

  DashboardModel userDashboardState = new DashboardModel(
    balance: 25000,
    activeRideExists: false,
    pendingRideExists: false,
    completedRidesCount: 0
  );

  DriverDashboardModel driverDashboardState = new DriverDashboardModel(
    balance: 25000,
    activeRideExists: false,
    pendingRideExists: true,
    completedRidesCount: 0,
    isActiveAccount: false,
  );

  List<Widget> navigationPages = [new DriverDashboardPage(), new UserDashboardPage(), new DriverDashboardPage()];

  setUserState(UserModel user) {

  }

  setDriverState(DriverModel driver) {
    this.driverDashboardState.isActiveAccount = driver.isActive;
  }

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

  showErrorDialog(String title, String content) {
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
          child: Text(content)
        ),
        actions: [
          TextButton(child: Text("D'accord"), onPressed: () => navigatorKey.currentState.pop()),
        ],
      )
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    if(phoneNumber.characters.length != 12)
      return false;
    else
      return true;
  }

  bool validateEmail(String email) {
    if(!email.contains("@"))
      return false;
    else
      return true;
  }

  double _getDeviceWidth() {
    return MediaQuery.of(navigatorKey.currentState.context).size.width;
  }

  double _getDeviceHeight() {
    return MediaQuery.of(navigatorKey.currentState.context).size.height;
  }

  showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<bool> storeProfilePictureUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(S_profilePictureUrl, url);
    return result;
  }

  Future<String> getProfilePictureUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(S_profilePictureUrl);
    return result;
  }

  fileIsImage(File file) {
    bool result = false;
    S_ALLOWED_PROFILE_IMAGES_EXTENSIONS.forEach((String extension) {
      if(file.path.endsWith(extension))
        result = true;
    });
    return result;
  }

}