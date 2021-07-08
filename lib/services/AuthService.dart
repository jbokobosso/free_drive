import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with IAuthService {

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();

  @override
  Future<bool> uploadLicencePictures(List<File> files) async {
    try {
      await this.firebaseStorage.ref("driver_licences/" + this.firebaseAuth.currentUser.uid + "recto").putFile(files[0]);
      await this.firebaseStorage.ref("driver_licences/" + this.firebaseAuth.currentUser.uid + "verso").putFile(files[1]);
    } catch (e) {
      this._coreService.showErrorDialog("Erreur Téléversement", e);
    }
  }

  @override
  Future<dynamic> registerByMail(UserModel user, String email, String password, List<File> files) async {
    try{
      UserCredential result = await this.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await this.firebaseAuth.currentUser.updateDisplayName(user.displayName);
      await this.uploadLicencePictures(files);
      await this.markLoggedUserLocally(user, user.userType);
      return result;
    } on FirebaseAuthException catch (exception) {
      return exception;
    }

  }

  @override
  Future<dynamic> authenticateByMail(UserModel user, String email, String password) async {
    try{
      dynamic userCredential = await this.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      bool stored = await this.markLoggedUserLocally(user, user.userType);
      if(userCredential.runtimeType == FirebaseAuthException) {
        this._coreService.showErrorDialog(userCredential.code, userCredential.message);
      }
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      return exception;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await this.firebaseAuth.signOut();
      return await this.markUserLoggedOut();
    } catch (e) {
      this._coreService.showErrorDialog("Erreur Déconnexion", "Veuillez reéssayer s'il vous plait");
      return false;
    }
  }

  @override
  Future<bool> storeFirebaseUserInfos(UserModel userModel) async {
    this.firebaseAuth.currentUser.updateDisplayName(userModel.displayName);
    var result = await this.firestore.collection("users").add(
        new UserModel(
            "${userModel.displayName.trim()}",
            userModel.email.trim(),
            userModel.phoneNumber.trim(),
            userModel.address,
            userModel.userType)
            .toMap()
    );
    if(result != null)
      return true;
    else
      return false;
  }

  @override
  Future<bool> checkIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(S_introPassed);
  }

  @override
  Future<bool> checkUserLoggedLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(S_userIsLogged);
  }

  @override
  Future<bool> markIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_introPassed, true);
    return written;
  }

  @override
  Future<bool> markLoggedUserLocally(UserModel user, EUserType chosenUserType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_userIsLogged, true);
    bool stored = await prefs.setString(S_loggedUser, jsonEncode(user.toMap()));
    bool userTypeWritten = await prefs.setString(S_loggedUserType, chosenUserType == EUserType.client ? "client" : "driver");
    if(written && stored && userTypeWritten) return true;
    else return false;
  }

  @override
  Future<bool> markUserLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_userIsLogged, false);
    bool stored = await prefs.setString(S_loggedUser, "");
    bool userTypeWritten = await prefs.setString(S_loggedUserType, "");
    if(written && stored && userTypeWritten) return true;
    else return false;
  }

  @override
  Future<String> getLoggedUserTypeLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(S_loggedUserType);
  }

  @override
  Future<UserModel> getLoggedUserLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userAsMapObject = jsonDecode(prefs.getString(S_loggedUser));
    var user = UserModel.fromMap(
        userAsMapObject["displayName"],
        userAsMapObject["email"],
        userAsMapObject["phoneNumber"],
        userAsMapObject["address"],
        userAsMapObject["userType"],
        userAsMapObject["isActive"]
    );
    if(user.runtimeType == UserModel)
      return user;
    else {
      this._coreService.showErrorDialog("Error Converting", "Error when converting json locally loged user from dart Map to UserModel");
      throw "Error Converting: Error when converting json locally loged user from dart Map to UserModel";
    }
  }

}