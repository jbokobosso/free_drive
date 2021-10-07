import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ExceptionService.dart';
import 'package:free_drive/services/ServiceLocator.dart';

class ProfileService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();
  ExceptionService _exceptionService = getIt.get<ExceptionService>();

  Future<bool> updateDisplayName(String newName) async {
    bool response = false;
    try {
      bool isClient = this._coreService.loggedUser.userType == EUserType.client;
      await this.firestore
          .collection(isClient ? FCN_clients : FCN_drivers)
          .doc(this.firebaseAuth.currentUser.uid)
          .update({"phoneNumber": newName});
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
          .update({"phoneNumber": newPhoneNumber});
      response = true;
    } catch(e) {
      _exceptionService.manageExCeption(e);
    }
    return response;
  }
}