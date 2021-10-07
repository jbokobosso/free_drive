import 'package:flutter/material.dart';
import 'package:free_drive/main.dart';
import 'package:free_drive/models/EDialogType.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/ContactDriverService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:stacked/stacked.dart';

class AuthViewModel extends BaseViewModel {

  CoreService coreService = getIt.get<CoreService>();
  AuthService authService = getIt.get<AuthService>();
  ContactDriverService contactDriverService = getIt.get<ContactDriverService>();

  double get deviceWidth => this.coreService.deviceWidth;
  double get deviceHeight => this.coreService.deviceHeight;

  final recoveryFormKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();

  void recoverPassword() {
    bool isValid = this.recoveryFormKey.currentState.validate();
    if(!isValid) return;
    this.authService.recoverPassword(this.emailCtrl.text.trim());
    navigatorKey.currentState.pushNamedAndRemoveUntil('/login', (route) => false);
    this.coreService.showDialogBox("Infos", "Un mail vient de vous être envoyé au ${this.emailCtrl.text.trim()}.\nLes instructions pour le mot de passe y sont", dialogType: EDialogType.info);
  }
}