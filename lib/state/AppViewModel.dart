import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ELicencePictureFace.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class AppViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();

  // Auth
  EUserType get userType => coreService.userType;
  chooseUserType(EUserType newValue) {
    coreService.userType = newValue;
    notifyListeners();
  }
  registerUser(EUserType chosenUserType) {
    coreService.userType = chosenUserType;
    navigatorKey.currentState.pushNamed('/validation');
  }

  // Driver
  pickLicencePicture(ELicencePictureFace licencePictureFace) {

  }


  // Dashboard
  cancelActiveRide() {
    this.coreService.dashboardState.activeRideExists = false;
    navigatorKey.currentState.pop();
    notifyListeners();
  }
  extendRide(extendRideFormKey, extendRideDaysCountController) {
    bool isValid = extendRideFormKey.currentState.validate();
    if(isValid) {
      navigatorKey.currentState.pop();
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          content: Text("Course prolongée de ${extendRideDaysCountController.text} jours")
      ));
    } else debugPrint("Form data invalid");
  }


  // Contact driver page
  bool contactedDriver = false;
  callDriver() async {
    var callSucceded = await this.contactDriverService.callDriver();
    if(callSucceded) contactedDriver = true;
    notifyListeners();
  }
  textDriver() {
    var textSucceded = this.contactDriverService.textDriver();
    if(textSucceded) this.contactedDriver = true;
    notifyListeners();
  }


  // App utils
  bool get activeRideExists => this.coreService.dashboardState.activeRideExists;
  double get deviceHeight => this._getDeviceHeight();
  double get deviceWidth => this._getDeviceWidth();
  double _getDeviceWidth() {
    return MediaQuery.of(navigatorKey.currentState.context).size.width;
  }
  double _getDeviceHeight() {
    return MediaQuery.of(navigatorKey.currentState.context).size.height;
  }


  // Login page
  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;
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