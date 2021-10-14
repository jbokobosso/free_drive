import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:free_drive/constants/constants.dart';
import 'package:free_drive/models/ClientModel.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/CoreService.dart';
import 'package:free_drive/services/ServiceLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();


  Future<bool> uploadLicencePictures(List<File> files, EUserType userType) async {
    String destinationFolder = userType == EUserType.driver ? FS_driverLicencesLocation : FS_clientIdCardLocation;
    try {
      await this.firebaseStorage.ref("$destinationFolder/" + this.firebaseAuth.currentUser.uid + "recto").putFile(files[0]);
      await this.firebaseStorage.ref("$destinationFolder/" + this.firebaseAuth.currentUser.uid + "verso").putFile(files[1]);
    } catch (e) {
      this._coreService.showErrorDialog("Erreur Téléversement", e);
    }
  }

  Future<bool> registerByMail(UserModel user, List<File> files) async {
    try{
      await this.firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      await this.firebaseAuth.currentUser.updateDisplayName(user.displayName);
      await this.uploadLicencePictures(files, user.userType);
      bool storedFirebase = await this.storeFirebaseUserInfos(user);
      bool storedLocal = await this.storeLoggedUser(user);
      return storedFirebase && storedLocal;
    } on FirebaseAuthException catch (exception) {
      this._coreService.showErrorDialog(exception.code, exception.message);
      return false;
    } catch (e) {
      this._coreService.showErrorDialog("Error", e);
      return false;
    }

  }


  Future<UserModel> authenticateByMail(UserModel userModel) async {
    UserModel firebaseUser;
    try{
      await this.firebaseAuth.signInWithEmailAndPassword(email: userModel.email, password: userModel.password);
      if(userModel.userType == EUserType.client) {
        QuerySnapshot querysnapshot = await this.firestore.collection("clients").where("email", isEqualTo: userModel.email).get();
        firebaseUser = UserModel.clientFromMap(querysnapshot.docs.first.data());
      } else if(userModel.userType == EUserType.driver) {
        QuerySnapshot querysnapshot = await this.firestore.collection("drivers").where("email", isEqualTo: userModel.email).get();
        firebaseUser = UserModel.clientFromMap(querysnapshot.docs.first.data());
      } else {
        throw "Recognition error: the app could not determine if the user is a driver or a client. Verify that you gave it in the form of authentication";
      }
      firebaseUser.userType = userModel.userType;
      firebaseUser.password = userModel.password;
      await this.storeLoggedUser(firebaseUser);
      return firebaseUser;
    } on FirebaseAuthException catch (exception) {
      this._coreService.showErrorDialog(exception.code, exception.message);
    } catch (e) {
      if(e.toString() == "Bad state: No element")
        this._coreService.showErrorDialog("Erreur Profil", "Ce mail n'est pas inscrit. Sinon Vérifiez bien le profil choisi: client/chauffeur");
      else {
        this._coreService.showErrorDialog("Error", e.toString());
        throw e;
      }
    }
  }


  Future<bool> logout() async {
    try {
      await this.firebaseAuth.signOut();
      return await this.markUserLoggedOut();
    } catch (e) {
      this._coreService.showErrorDialog("Erreur Déconnexion", "Veuillez reéssayer s'il vous plait");
      return false;
    }
  }


  Future<bool> storeFirebaseUserInfos(UserModel userModel) async {
    this.firebaseAuth.currentUser.updateDisplayName(userModel.displayName);
    if(userModel.userType == EUserType.client) {
      var result = await this.firestore.collection(FCN_clients).doc(this.firebaseAuth.currentUser.uid).set(
          new ClientModel(
            "${userModel.displayName.trim()}",
            userModel.email.trim(),
            userModel.phoneNumber.trim(),
            userModel.address,
            userModel.wallet
          ).toMap()
      );
      return true;
    } else if(userModel.userType == EUserType.driver) {
      var result = await this.firestore.collection(FCN_drivers).doc(this.firebaseAuth.currentUser.uid).set(
          new DriverModel(
            "${userModel.displayName.trim()}",
            userModel.email.trim(),
            userModel.phoneNumber.trim(),
            userModel.address,
            userModel.wallet,
            false
          ).toMap()
      );
      return true;
    } else {
      throw "Error in storeing user infos on firebase firestore. Reason: The provide user type is neither driver nor client.";
    }
  }


  Future<bool> checkIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introPassed = prefs.getBool(S_introPassed);
    return introPassed;
  }


  Future<bool> checkUserIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAuth = prefs.getBool(S_userIsLogged);
    return isAuth;
  }


  Future<bool> markIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_introPassed, true);
    return written;
  }


  Future<bool> storeLoggedUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_userIsLogged, true);
    String toBeStoredString = jsonEncode(user.toMap(userType: user.userType));
    bool stored = await prefs.setString(S_loggedUser, toBeStoredString);
    this._coreService.loggedUser = user;
    if(written && stored) return true;
    else return false;
  }


  Future<bool> storeDriverProfileStatus(bool profileActiveOrNot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_driverProfileActieOrNot, profileActiveOrNot);
    if(written)
      return true;
    else
      return false;
  }


  Future<bool> getDriverProfileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic profileActiveOrNot = prefs.getBool(S_driverProfileActieOrNot);
    if(profileActiveOrNot == null || profileActiveOrNot == false)
      return false;
    return true;
  }


  Future<bool> markUserLoggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool cleared = await prefs.clear();
    // bool written = await prefs.setBool(S_userIsLogged, null);
    // bool stored = await prefs.setString(S_loggedUser, null);
    // bool userTypeWritten = await prefs.setString(S_loggedUserType, null);
    // if(written && stored && userTypeWritten) return true;
    if(cleared) return true;
    else return false;
  }


  Future<UserModel> getLoggedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringUser = prefs.getString(S_loggedUser);
    var userAsMapObject = jsonDecode(stringUser);
    UserModel user;
    if(userAsMapObject["userType"] == "driver") {
      user = UserModel.driverFromMap(userAsMapObject);
      user.userType = EUserType.driver;
    } else if(userAsMapObject["userType"] == "client") {
      user = UserModel.clientFromMap(userAsMapObject);
      user.userType = EUserType.client;
    }
    if(user.runtimeType == DriverModel || user.runtimeType == ClientModel)
      return user;
    else {
      this._coreService.showErrorDialog("Error Converting", "Error when converting json locally loged user from dart Map to UserModel");
      throw "Error Converting: Error when converting json locally loged user from dart Map to UserModel";
    }
  }


  Future<void> recoverPassword(String email) async {
    try {
      this.firebaseAuth.sendPasswordResetEmail(email: email);
    } catch(e) {
      this._coreService.showErrorDialog("Erreur", e.toString());
    }
  }

}