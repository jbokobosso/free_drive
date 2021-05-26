import 'package:flutter/cupertino.dart';

class DashboardModel {
  bool activeRideExists;
  bool pendingRideExists;
  int completedRidesCount;

  DashboardModel({@required this.activeRideExists, @required this.pendingRideExists, @required this.completedRidesCount});
}