import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/DashboardModel.dart';
import 'package:free_drive/models/EPaymentMethod.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/RideModel.dart';
import 'package:free_drive/models/payment/LoadModel.dart';
import 'package:free_drive/models/payment/PendingPaymentModel.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/DashboardService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/ui/pages/dashboard/LoadWalletModal.dart';
import 'package:free_drive/ui/pages/dashboard/LoadsHistoryPage.dart';
import 'package:free_drive/ui/shared/Button.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:location/location.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  AuthService authService = getIt.get<AuthService>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DashboardService _dashboardService = getIt.get<DashboardService>();

  int extendRideDaysCount = 1 ;
  final extendRideFormKey = GlobalKey<FormState>();
  TextEditingController extendRideDaysCountController = new TextEditingController();

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

  List<PendingPaymentModel> pendingPayments = [];


  initUserViewPage() {
    this.initEyeAnimation();
    this.checkUserActiveRide();
  }

  initDriverViewPage() {
    this.initEyeAnimation();
    this.checkDriverActiveRide();
    this.checkDriverProfileIsActive();
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

  void loadUserActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = this._dashboardService.getUserActiveRide();
    querySnapshotStream.listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      this.coreService.showToastMessage("New Incoming message");
      if(querySnapshot.docs.isEmpty) {
        this.activeRide = null;
      } else {
        this.activeRide = RideModel.fromJSON(querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
        this.coreService.userDashboardState.activeRide = this.activeRide;
      }
      this.coreService.notifyForRideState(userType: EUserType.client);
      notifyListeners();
    });
  }

  Future<void> checkUserActiveRide() async {
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
    }
  }

  void loadDriverActiveRide() {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshotStream = this._dashboardService.getDriverActiveRide();
    querySnapshotStream.listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      this.coreService.showToastMessage("New Incoming message");
      if(querySnapshot.docs.isEmpty) {
        this.activeRide = null;
      } else {
        this.activeRide = RideModel.fromJSON(querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
        this.coreService.driverDashboardState.activeRide = this.activeRide;
      }
      this.coreService.notifyForRideState(userType: EUserType.driver);
      notifyListeners();
    });
  }

  Future<void> checkDriverActiveRide() async {
    {
      // if(this.coreService.alreadyLoadedActiveRideStream) return;
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
        // this.coreService.alreadyLoadedActiveRideStream = true; // ceci empêche de refaire le requete qui récupère le stream écoutant sur la course active
      }
    }
  }

  void showOrHideDriverActiveRideDetails() {
    this.driverShowPendingRideDetails = !this.driverShowPendingRideDetails;
    this.coreService.showToastMessage(this.driverShowPendingRideDetails.toString());
    notifyListeners();
  }

  Future<void> checkDriverProfileIsActive() async {
    bool profileActivOrNot = await this.authService.getDriverProfileStatusInLocal();
    this.driverProfileIsActive = profileActivOrNot;
  }

  Future<void> acceptRide() async {
    setBusy(true);
    bool success = await this._dashboardService.acceptRide(this.activeRide.id);
    if(success)
      this.coreService.showToastMessage("Course acceptée");
    else
      this.coreService.showToastMessage("Erreur, reéssayez");
    setBusy(false);
  }

  Future<void> startRide() async {
    setBusy(true);
    bool success = await this._dashboardService.startRide(this.activeRide.id);
    if(success)
      this.coreService.showToastMessage("Course demarrée");
    else
      this.coreService.showToastMessage("Erreur, reéssayez");
    setBusy(false);
  }

  Future<void> endRide() async {
    navigatorKey.currentState.pop();
    setBusy(true);
    bool success = await this._dashboardService.endRide(this.activeRide.id);
    if(success)
      this.coreService.showToastMessage("Course Terminée");
    else
      this.coreService.showToastMessage("Erreur, reéssayez");
    setBusy(false);
  }

  Future<void> extendRide() async {
    bool isValid = this.extendRideFormKey.currentState.validate();
    if(!isValid) return null;
    setBusy(true);
    DateTime newReturnBackDate = this.coreService.userDashboardState.activeRide.returnDate.add(Duration(days: this.extendRideDaysCount.toInt()));
    bool success = await this._dashboardService.extendRide(this.coreService.userDashboardState.activeRide.id, newReturnBackDate);
    if(!success) {
      this.coreService.showErrorDialog("Erreur", "Le processus n'a pas marché, veuillez reéssayer svp");
      return;
    }
    navigatorKey.currentState.pop();
    ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Course prolongée de ${this.extendRideDaysCountController.text} jours")
    ));
    setBusy(false);
  }

  Future<void> cancelActiveRide() async {
    setBusy(true);
    bool success = await this._dashboardService.cancelRide(this.coreService.userDashboardState.activeRide.id);
    if(!success) {
      this.coreService.showErrorDialog("Erreur", "Le processus n'a pas marché, veuillez reéssayer svp");
      return;
    }
    this.coreService.userDashboardState.activeRideExists = false;
    navigatorKey.currentState.pop();
    setBusy(false);
    notifyListeners();
  }

  buildShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => LoadWalletModal()
    );
  }

  Future<void> refreshPendingPayments() async {
    await this.loadPendingPayments();
  }

  loadPendingPayments() async {
    this.setBusy(true);
    List<PendingPaymentModel> _pendingPayments = [];
    List<String> _pendingPaymentsRefs = await this._dashboardService.getPendingPaymentReferences();
    if(_pendingPaymentsRefs.isEmpty) return;
    for(String ref in _pendingPaymentsRefs) {
      PendingPaymentModel pendingPayment = await this._dashboardService.loadPendingPayment(ref);
      if(pendingPayment != null) {
        _pendingPayments.add(pendingPayment);
      }
    }
    this.pendingPayments = _pendingPayments;
    this.pendingPayments.sort((a, b) {
      if(a.datetime != null && b.datetime != null) {
        return a.datetime.compareTo(b.datetime);
      } else return 0;
    });
    this.setBusy(false);
    notifyListeners();
  }

  Future<bool> requestUserLocation() async {
    setBusy(true);
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setBusy(false);
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setBusy(false);
        return false;
      }
    }

    _locationData = await location.getLocation();
    this.coreService.setLocationData(_locationData);
    setBusy(false);
    return true;
  }

  navigateToAskDriverPage() async {
    bool hasLocationPermission = await requestUserLocation();
    if(hasLocationPermission) navigatorKey.currentState.pushNamed('/askDriver');
  }
}