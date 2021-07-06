import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ELicencePictureFace.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class AppViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  IAuthService authService = getIt.get<IAuthService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();

  // Auth
  UserModel loggedUser;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  TextEditingController displayNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneNumberCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();
  EUserType get userType => coreService.userType;

  chooseUserType(EUserType newValue) {
    coreService.userType = newValue;
    notifyListeners();
  }

  registerUser(EUserType chosenUserType) {
    setBusy(true);
    var isValid = this.signupFormKey.currentState.validate();
    if(isValid) {
      UserModel user = new UserModel(
          this.displayNameCtrl.text,
          this.emailCtrl.text,
          this.phoneNumberCtrl.text,
          this.addressCtrl.text,
          chosenUserType
      );
      coreService.userType = chosenUserType;
      dynamic result = this.authService.registerByMail(user, this.emailCtrl.text, this.passCtrl.text);
      result.then((userCredentials) async {
        if(userCredentials.runtimeType == FirebaseAuthException) {
          setBusy(false);
          this.coreService.showErrorDialog(userCredentials.code, userCredentials.message);
        } else {
          var isStored = await this.authService.storeFirebaseUserInfos(user);
          if(isStored) {
            await this.authService.markLoggedUserLocally(user, chosenUserType); // Mark locally that user is logged in for future checks
            if(userType == EUserType.client)
              navigatorKey.currentState.pushNamedAndRemoveUntil('/dashboard', (routeMatch) => false);
            else if(userType == EUserType.driver)
              navigatorKey.currentState.pushNamedAndRemoveUntil('/uploadDriverLicence', (routeMatch) => false);
            else
              print("Nothing to do");
          }
          setBusy(false);
        }
      });
    } else setBusy(false);
  }

  login(EUserType chosenUserType) async {
    setBusy(true);
    bool isValid = this.loginFormKey.currentState.validate();
    if(isValid) {
      UserModel user = new UserModel(
          this.displayNameCtrl.text,
          this.emailCtrl.text,
          this.phoneNumberCtrl.text,
          this.addressCtrl.text,
          chosenUserType
      );
      dynamic userCredential = await this.authService.authenticateByMail(user, this.emailCtrl.text, this.passCtrl.text);
      if(userCredential.runtimeType == FirebaseAuthException) {
        setBusy(false);
        this.coreService.showErrorDialog(userCredential.code, userCredential.message);
      } else{
        if(userCredential.user != null) {
          user.displayName = userCredential.user.displayName;
          var rst = await this.authService.markLoggedUserLocally(user, chosenUserType); // Mark locally that user is logged in for future checks
          if(this.userType == EUserType.client)
            navigatorKey.currentState.pushNamedAndRemoveUntil('/dashboard', (route) => false);
          else if(this.userType == EUserType.driver)
            navigatorKey.currentState.pushNamedAndRemoveUntil('/driverDashboard', (route) => false);
          else
            this.coreService.showErrorDialog("Incomplet", "Renseignez qui vous êtes: \nclient ou chauffeur ?");
        }
        setBusy(false);
      }
    }
    setBusy(false);
  }

  logout() async {
    setBusy(true);
    var isLoggout = await this.authService.logout();
    if(isLoggout) {
      setBusy(false);
      navigatorKey.currentState.pushNamedAndRemoveUntil('/login', (route) => false);
    } else {
      setBusy(false);
    }
  }

  // Driver
  pickLicencePicture(ELicencePictureFace licencePictureFace) {

  }

  loadLocallyLoggedUser() async {
    var result  = await this.authService.getLoggedUserLocally();
    this.loggedUser = result;
    notifyListeners();
  }


  // Dashboard
  completeRide() {
    this.coreService.driverDashboardState.activeRideExists = false;
    this.coreService.driverDashboardState.completedRidesCount++;
    navigatorKey.currentState.pop();
    navigatorKey.currentState.pushNamedAndRemoveUntil("/driverDashboard", (route) => false);
  }
  startRide() {
    this.coreService.driverDashboardState.pendingRideExists = false;
    this.coreService.driverDashboardState.activeRideExists = true;
    navigatorKey.currentState.pop();
    navigatorKey.currentState.pushNamedAndRemoveUntil("/driverDashboard", (route) => false);
  }
  cancelActiveRide() {
    this.coreService.userDashboardState.activeRideExists = false;
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
  bool get activeRideExists => this.coreService.userDashboardState.activeRideExists;
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