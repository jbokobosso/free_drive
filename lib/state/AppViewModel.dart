import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/ClientModel.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/ELicencePictureFace.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class AppViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  IAuthService authService = getIt.get<IAuthService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  // Dashboard
  loadUser() {

  }

  // Auth
  EUserType chosenUserType=EUserType.client;
  List<File> licencePictureFiles = [];
  String activePickedFileName;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  TextEditingController rectoPicture = TextEditingController();
  TextEditingController versoPicture = TextEditingController();
  TextEditingController displayNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneNumberCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();
  EUserType get userType => coreService.loggedUser.userType;
  UserModel get loggedUser => coreService.loggedUser;

  chooseUserTypeRadio(EUserType newChoice) {
    this.chosenUserType = newChoice;
    notifyListeners();
  }
  registerUser() async {
    setBusy(true);
    var isValid = this.signupFormKey.currentState.validate();
    if(!isValid) {setBusy(false); return;}

    UserModel user;

    if(chosenUserType == EUserType.driver) {
      user = new DriverModel(this.displayNameCtrl.text.trim(), this.emailCtrl.text.trim(), this.phoneNumberCtrl.text.trim(), this.addressCtrl.text.trim(), false);
    } else if(chosenUserType == EUserType.client) {
      user = new ClientModel(this.displayNameCtrl.text.trim(), this.emailCtrl.text.trim(), this.phoneNumberCtrl.text.trim(), this.addressCtrl.text.trim());
    }

    user.userType = this.chosenUserType;
    user.password = this.passCtrl.text.trim();
    bool registrationSucceeded = await this.authService.registerByMail(user, this.licencePictureFiles);
    if(registrationSucceeded) {
      if(user.userType == EUserType.client)
        navigatorKey.currentState.pushNamedAndRemoveUntil('/dashboard', (routeMatch) => false);
      else if(user.userType == EUserType.driver)
        navigatorKey.currentState.pushNamedAndRemoveUntil('/driverDashboard', (routeMatch) => false);
      else
        throw("Given user does not have correct user type. Something went wrong when getting user type from the signup form");
    }
    setBusy(false);
  }

  pickLicencePictures(ELicencePictureFace licencePictureFace) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'JPG', 'JPEG']);

    if(result != null) {
      this.licencePictureFiles.add(File(result.files.single.path));
      licencePictureFace == ELicencePictureFace.recto
          ? this.rectoPicture.text = result.files.single.name
          : this.versoPicture.text = result.files.single.name;
      this.notifyListeners();
    } else {
      return null;
    }
  }

  chooseUserType(EUserType choice) {
    this.chosenUserType = choice;
    notifyListeners();
  }
  
  login() async {
    setBusy(true);
    bool isValid = this.loginFormKey.currentState.validate();
    if(!isValid) {setBusy(false); return;}

    UserModel user;

    if(chosenUserType == EUserType.driver) {
      user = new DriverModel(
          this.displayNameCtrl.text.trim(),
          this.emailCtrl.text.trim(),
          this.phoneNumberCtrl.text.trim(),
          this.addressCtrl.text.trim(),
          false,
      );
    } else if(chosenUserType == EUserType.client) {
      user = new ClientModel(this.displayNameCtrl.text.trim(), this.emailCtrl.text.trim(), this.phoneNumberCtrl.text.trim(), this.addressCtrl.text.trim());
    }

    user.userType = this.chosenUserType;
    user.password = this.passCtrl.text.trim();

    UserModel userModel = await this.authService.authenticateByMail(user);
    if(userModel != null) {
      if(userModel.userType == EUserType.client)
        navigatorKey.currentState.pushNamedAndRemoveUntil('/dashboard', (route) => false);
      else if(userModel.userType == EUserType.driver)
        navigatorKey.currentState.pushNamedAndRemoveUntil('/driverDashboard', (route) => false);
      else
        this.coreService.showErrorDialog("Erreur Profil", "La base de données n'a pas pu \n fournir le type d'utilisateur. (client ou chauffeur)");
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


  // App utils
  bool get activeRideExists => this.coreService.userDashboardState.activeRideExists;


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