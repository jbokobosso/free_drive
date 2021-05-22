import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/main.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';

class AppViewModel extends BaseViewModel {

  double get deviceHeight => this._getDeviceHeight();
  double get deviceWidth => this._getDeviceWidth();
  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;

  double _getDeviceWidth() {
    return MediaQuery.of(navigatorKey.currentState.context).size.width;
  }

  double _getDeviceHeight() {
    return MediaQuery.of(navigatorKey.currentState.context).size.height;
  }

  initEyeAnimation() {
    rootBundle.load('assets/rive/close_open_eye.riv')
        .then(
          (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(eyeAnimationController = SimpleAnimation('close'));
        eyeArtboard = artboard;
        notifyListeners();
        eyeAnimationController.isActive = true;
        notifyListeners();
      },
    );
  }
  initTurnLogoAnimation() {
    rootBundle.load('assets/rive/logo.riv')
        .then(
          (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(logoAnimationController = SimpleAnimation('turn'));
        logoArtboard = artboard;
        notifyListeners();
        logoAnimationController.isActive = true;
        notifyListeners();
      },
    );
  }

}