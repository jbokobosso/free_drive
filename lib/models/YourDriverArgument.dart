import 'package:flutter/foundation.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/RideModel.dart';

class YourDriverArgument {
  DriverModel driver;
  RideModel ride;

  YourDriverArgument({@required this.driver, @required this.ride});
}