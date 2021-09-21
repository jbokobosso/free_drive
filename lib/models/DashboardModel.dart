import 'package:flutter/cupertino.dart';
import 'package:free_drive/models/ERideType.dart';
import 'package:free_drive/models/RideModel.dart';

class UserDashboardModel {
  ERideType activeRideType;
  double balance;
  bool activeRideExists;
  bool pendingRideExists;
  int completedRidesCount;
  RideModel activeRide;

  UserDashboardModel({
    @required balance,
    @required this.activeRideExists,
    @required this.pendingRideExists,
    @required this.completedRidesCount,
    this.activeRideType,
    this.activeRide
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
  RideModel activeRide;

  DriverDashboardModel({
    @required balance,
    @required this.activeRideExists,
    @required this.pendingRideExists,
    @required this.completedRidesCount,
    this.activeRideType,
    this.isActiveAccount,
    this.note,
    this.activeRide
  });
}



class Note {

}