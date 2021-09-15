import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/DashboardModel.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/DashboardService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  IAuthService authService = getIt.get<IAuthService>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DashboardService _dashboardService = getIt.get<DashboardService>();

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;

  RideModel activeRide;
  RideModel pendingRide;

  bool driverShowPendingRideDetails = false;
  bool driverProfileIsActive = false;

  initUserViewPage() {
    this.initEyeAnimation();
    this.checkUserActiveRide();
    this.initNotification();
  }

  initDriverViewPage() {
    this.initEyeAnimation();
    this.checkDriverActiveRide();
    this.initNotification();
    this.checkDriverProfileIsActive();
  }

  Future<void> initNotification() async {
    if(this.coreService.alreadyRegisteredFCM) return;
    String token = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    this.coreService.alreadyRegisteredFCM = true;
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

  cancelActiveRide() {
    this.coreService.userDashboardState.activeRideExists = false;
    navigatorKey.currentState.pop();
    notifyListeners();
  }

  Future<void> checkUserActiveRide() async {
    if(this.coreService.alreadyLoadedActiveRideStream) return;
    setBusy(true);
    bool activeRideExists = await this._dashboardService.userActiveRideExists();
    setBusy(false);
    if(activeRideExists) {
      this.loadUserActiveRide();
      var state = new UserDashboardModel(
          balance: 0,
          activeRideExists: activeRideExists,
          pendingRideExists: !activeRideExists,
          completedRidesCount: 0
      );
      this.coreService.userDashboardState = state;
      notifyListeners();
      setBusy(false);
      this.coreService.alreadyLoadedActiveRideStream = true; // ceci empêche de refaire le requete qui récupère le stream écoutant sur la course active
    }
  }

  void loadUserActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = this._dashboardService.getActiveRide();
    querySnapshotStream.listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      this.activeRide = RideModel.fromJSON(querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      notifyListeners();
    });
  }

  Future<void> checkDriverActiveRide() async {
    {
      if(this.coreService.alreadyLoadedActiveRideStream) return;
      setBusy(true);
      bool activeRideExists = await this._dashboardService.driverActiveRideExists();
      setBusy(false);
      if(activeRideExists) {
        this.loadDriverActiveRide();
        var state = new DriverDashboardModel(
            balance: 0,
            activeRideExists: activeRideExists,
            pendingRideExists: !activeRideExists,
            completedRidesCount: 0
        );
        this.coreService.driverDashboardState = state;
        notifyListeners();
        setBusy(false);
        this.coreService.alreadyLoadedActiveRideStream = true; // ceci empêche de refaire le requete qui récupère le stream écoutant sur la course active
      }
    }
  }

  void loadDriverActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = this._dashboardService.getDriverActiveRide();
    querySnapshotStream.listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      this.activeRide = RideModel.fromJSON(querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      this.coreService.showToastMessage("New incoming data");
      notifyListeners();
    });
  }

  void showOrHideDriverActiveRideDetails() {
    this.driverShowPendingRideDetails = !this.driverShowPendingRideDetails;
    this.coreService.showToastMessage(this.driverShowPendingRideDetails.toString());
    notifyListeners();
  }

  Future<void> checkDriverProfileIsActive() async {
    bool profileActivOrNot = await this.authService.getDriverProfileStatus();
    this.driverProfileIsActive = profileActivOrNot;
  }

}