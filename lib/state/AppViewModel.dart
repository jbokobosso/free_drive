import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:stacked/stacked.dart';

class AppViewModel extends BaseViewModel {

  double get deviceHeight => this._getDeviceHeight();
  double get deviceWidth => this._getDeviceWidth();

  double _getDeviceWidth() {
    return MediaQuery.of(navigatorKey.currentState.context).size.width;
  }

  double _getDeviceHeight() {
    return MediaQuery.of(navigatorKey.currentState.context).size.height;
  }

}