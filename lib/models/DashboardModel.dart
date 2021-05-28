import 'package:flutter/cupertino.dart';
import 'package:free_drive/models/ERideType.dart';

class DashboardModel {
  ERideType activeRideType;
  double balance;
  bool activeRideExists;
  bool pendingRideExists;
  int completedRidesCount;

  DashboardModel({@required balance, @required this.activeRideExists, @required this.pendingRideExists, @required this.completedRidesCount, this.activeRideType});
}