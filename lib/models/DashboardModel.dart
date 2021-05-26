import 'package:flutter/cupertino.dart';

class DashboardModel {
  double balance;
  bool activeRideExists;
  bool pendingRideExists;
  int completedRidesCount;

  DashboardModel({@required balance, @required this.activeRideExists, @required this.pendingRideExists, @required this.completedRidesCount});
}