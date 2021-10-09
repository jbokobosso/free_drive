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
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/DashboardService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/ui/shared/Button.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  AuthService authService = getIt.get<AuthService>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DashboardService _dashboardService = getIt.get<DashboardService>();

  int extendRideDaysCount = 1 ;
  final extendRideFormKey = GlobalKey<FormState>();
  final loadWalletFormKey = GlobalKey<FormState>();
  TextEditingController extendRideDaysCountController = new TextEditingController();

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  Artboard eyeArtboard;
  Artboard logoArtboard;
  RiveAnimationController eyeAnimationController;
  RiveAnimationController logoAnimationController;
  TextEditingController amountCtrl = new TextEditingController();
  TextEditingController phoneNumberCtrl = new TextEditingController();
  EPaymentMethod chosenPaymentMethod;

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
    bool profileActivOrNot = await this.authService.getDriverProfileStatus();
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

  choosePaymentMethod(EPaymentMethod method) {
    this.chosenPaymentMethod = method;
    notifyListeners();
  }

  loadBalance() {
    bool isValid = this.loadWalletFormKey.currentState.validate();
    if(!isValid) return;
    Utils.showToast("En cours de conception...");
    // this._dashboardService.loadWallet(this.amountCtrl.text.trim(), this.phoneNumberCtrl.text.trim(), this.chosenPaymentMethod);
  }

  buildShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Charger Portefeuille"),
        content: SizedBox(
          height: Utils.deviceHeight*0.5,
          child: Form(
            key: this.loadWalletFormKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: this.amountCtrl,
                  decoration: customInputDecoration(context, label: 'Montant'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if(value.isEmpty) return "Montant requis";
                    return null;
                  },
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text('Flooz', style: TextStyle(fontSize: 12.0)),
                  leading: Radio<EPaymentMethod>(
                    activeColor: Theme.of(context).primaryColor,
                    value: EPaymentMethod.FLOOZ,
                    groupValue: this.chosenPaymentMethod,
                    onChanged: (EPaymentMethod value) => this.choosePaymentMethod(value),
                  ),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  title: const Text('TMoney', style: TextStyle(fontSize: 12.0)),
                  leading: Radio<EPaymentMethod>(
                    activeColor: Theme.of(context).primaryColor,
                    value: EPaymentMethod.TMONEY,
                    groupValue: this.chosenPaymentMethod,
                    onChanged: (EPaymentMethod value) => this.choosePaymentMethod(value),
                  ),
                ),
                this.chosenPaymentMethod != null ? TextFormField(
                  controller: this.phoneNumberCtrl,
                  decoration: customInputDecoration(
                    context,
                    label: 'Numéro ${EnumToString.convertToString(chosenPaymentMethod)}',
                    hint: 'Sans indicatif'
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if(value.isEmpty) return "Votre numéro ${EnumToString.convertToString(chosenPaymentMethod)} svp";
                    return null;
                  },
                ) : Container(),
                Button(loadBalance)
              ],
            ),
          ),
        ),
      )
    );
  }

}