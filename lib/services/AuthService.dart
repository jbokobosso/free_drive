import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with IAuthService {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();

  @override
  Future<dynamic> registerByMail(String email, String password) async {
    try{
      UserCredential result = await this.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (exception) {
      return exception;
    }

  }

  @override
  Future<dynamic> authenticateByMail(String email, String password) async {
    try{
      UserCredential result = await this.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (exception) {
      return exception;
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
    return prefs.getBool(introPassed);
  }

  @override
  Future<bool> checkUserLoggedLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userIsLogged);
  }

  @override
  Future<bool> markIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(introPassed, true);
    return written;
  }

  @override
  Future<bool> markUserLoggedLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(userIsLogged, true);
    return written;
  }

}