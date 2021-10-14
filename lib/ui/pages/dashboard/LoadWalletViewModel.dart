import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:free_drive/ui/pages/dashboard/LoadWalletModal.dart';
import 'package:free_drive/ui/shared/Button.dart';
import 'package:free_drive/ui/shared/customShapes.dart';
import 'package:free_drive/utils/Utils.dart';
import 'package:location/location.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';

class LoadWalletViewModel extends BaseViewModel {

  EPaymentMethod chosenPaymentMethod;
  TextEditingController amountCtrl = new TextEditingController();
  TextEditingController phoneNumberCtrl = new TextEditingController();
  final loadWalletFormKey = GlobalKey<FormState>();
  DashboardService _dashboardService = getIt.get<DashboardService>();
  CoreService _coreService = getIt.get<CoreService>();

  loadBalance() {
    bool isValid = this.loadWalletFormKey.currentState.validate();
    if(!isValid) return;
    if(chosenPaymentMethod == null) {
      Utils.showToast("Choisir le moyen de payement");
      return;
    }
    if(!Utils.validatePaymentNumber(this.phoneNumberCtrl.text.trim())) {
      Utils.showToast("Format numéro ${EnumToString.convertToString(this.chosenPaymentMethod)} invalide");
      return;
    }
    // Utils.showToast("En cours de conception...");
    this._dashboardService.loadWallet(
      amount: double.tryParse(this.amountCtrl.text.trim()),
      phoneNumber: this.phoneNumberCtrl.text.trim(),
      paymentMethod: this.chosenPaymentMethod,
      clientWalletId:  FirebaseAuth.instance.currentUser.uid
    );
  }

  choosePaymentMethod(EPaymentMethod method) {
    this.chosenPaymentMethod = method;
    notifyListeners();
  }

}