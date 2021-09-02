import 'package:flutter/cupertino.dart';
import 'package:free_drive/models/ERideType.dart';

class UserDashboardModel {
  ERideType activeRideType;
  double balance;
  bool activeRideExists;
  bool pendingRideExists;
  int completedRidesCount;

  UserDashboardModel({
    @required balance,
    @required this.activeRideExists,
    @required this.pendingRideExists,
    @required this.completedRidesCount,
    this.activeRideType
  });
}




class DriverDashboardModel {
  ERideType activeRideType;
  double balance;
  bool activeRideExists;
  bool pendingRideExists;
  int completedRidesCount;
  bool isActiveAccount;
  Note note;

  DriverDashboardModel({
    @required balance,
    @required this.activeRideExists,
    @required this.pendingRideExists,
    @required this.completedRidesCount,
    this.activeRideType,
    this.isActiveAccount,
    this.note
  });
}



class Note {

}