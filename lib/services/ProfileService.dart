import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/AuthService.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:free_drive/utils/Utils.dart';

class ProfileService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();
  ExceptionService _exceptionService = getIt.get<ExceptionService>();
  AuthService _authService = getIt.get<AuthService>();

  Future<bool> updateDisplayName(String newName) async {
    bool response = false;
    try {
      bool isClient = this._coreService.loggedUser.userType == EUserType.client;
      await this.firestore
          .collection(isClient ? FCN_clients : FCN_drivers)
          .doc(this.firebaseAuth.currentUser.uid)
          .update({"phoneNumber": newName}); // finished updating on firebase
      Utils.showToast("Mis à jour en ligne");
      UserModel newUserModel = await this._authService.getLoggedUser();
      newUserModel.displayName = newName;
      await this._authService.storeLoggedUser(newUserModel);
      Utils.showToast("Mis à jour en local");
      response = true;
    } catch(e) {
      _exceptionService.manageExCeption(e);
    }
    return response;
  }

  Future<bool> updatePhoneNumber(String newPhoneNumber) async {
    bool response = false;
    try {
      bool isClient = this._coreService.loggedUser.userType == EUserType.client;
      await this.firestore
          .collection(isClient ? FCN_clients : FCN_drivers)
          .doc(this.firebaseAuth.currentUser.uid)
          .update({"phoneNumber": newPhoneNumber}); // finished updating on firebase
      Utils.showToast("Mis à jour en ligne");
      UserModel newUserModel = await this._authService.getLoggedUser();
      newUserModel.phoneNumber = newPhoneNumber;
      await this._authService.storeLoggedUser(newUserModel);
      Utils.showToast("Mis à jour en local");
      response = true;
    } catch(e) {
      _exceptionService.manageExCeption(e);
    }
    return response;
  }
}