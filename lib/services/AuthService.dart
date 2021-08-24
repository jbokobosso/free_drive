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
import 'package:free_drive/services/GetIt.dart';
import 'package:free_drive/services/IAuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends IAuthService {

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CoreService _coreService = getIt.get<CoreService>();

  @override
  Future<bool> uploadLicencePictures(List<File> files, EUserType userType) async {
    String destinationFolder = userType == EUserType.driver ? FS_driverLicencesLocation : FS_clientIdCardLocation;
    try {
      await this.firebaseStorage.ref("$destinationFolder/" + this.firebaseAuth.currentUser.uid + "recto").putFile(files[0]);
      await this.firebaseStorage.ref("$destinationFolder/" + this.firebaseAuth.currentUser.uid + "verso").putFile(files[1]);
    } catch (e) {
      this._coreService.showErrorDialog("Erreur Téléversement", e);
    }
  }

  @override
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

  @override
  Future<UserModel> authenticateByMail(UserModel userModel) async {
    UserModel firebaseUser;
    try{
      await this.firebaseAuth.signInWithEmailAndPassword(email: userModel.email, password: userModel.password);
      if(userModel.userType == EUserType.client) {
        QuerySnapshot querysnapshot = await this.firestore.collection("clients").where("email", isEqualTo: userModel.email).get();
        firebaseUser = UserModel.clientFromFirebase(querysnapshot.docs.first.data());
      } else if(userModel.userType == EUserType.driver) {
        QuerySnapshot querysnapshot = await this.firestore.collection("drivers").where("email", isEqualTo: userModel.email).get();
        firebaseUser = UserModel.clientFromFirebase(querysnapshot.docs.first.data());
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
        this._coreService.showErrorDialog("Erreur", "Vous avez mal choisi qui vous êtes: client/chauffeur");
      else {
        this._coreService.showErrorDialog("Error", e.toString());
        throw e;
      }
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
    if(userModel.userType == EUserType.client) {
      var result = await this.firestore.collection("clients").add(
          new ClientModel(
            "${userModel.displayName.trim()}",
            userModel.email.trim(),
            userModel.phoneNumber.trim(),
            userModel.address,
          ).toMap()
      );
      if(result != null)
        return true;
      else
        return false;
    } else if(userModel.userType == EUserType.driver) {
      var result = await this.firestore.collection("drivers").add(
          new DriverModel(
            "${userModel.displayName.trim()}",
            userModel.email.trim(),
            userModel.phoneNumber.trim(),
            userModel.address,
            false
          ).toMap()
      );
      if(result != null)
        return true;
      else
        return false;
    } else {
      throw "Error in storeing user infos on firebase firestore. Reason: The provide user type is neither driver nor client.";
    }
  }

  @override
  Future<bool> checkIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introPassed = prefs.getBool(S_introPassed);
    return introPassed;
  }

  @override
  Future<bool> checkUserIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAuth = prefs.getBool(S_userIsLogged);
    return isAuth;
  }

  @override
  Future<bool> markIntroPassed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_introPassed, true);
    return written;
  }

  @override
  Future<bool> storeLoggedUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool written = await prefs.setBool(S_userIsLogged, true);
    String toBeStoredString = jsonEncode(user.toMap(userType: user.userType));
    bool stored = await prefs.setString(S_loggedUser, toBeStoredString);
    this._coreService.loggedUser = user;
    if(written && stored) return true;
    else return false;
  }

  @override
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

  @override
  Future<UserModel> getLoggedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringUser = prefs.getString(S_loggedUser);
    var userAsMapObject = jsonDecode(stringUser);
    UserModel user;
    if(userAsMapObject["userType"] == "driver") {
      user = UserModel.driverFromMapOld(userAsMapObject["displayName"], userAsMapObject["email"], userAsMapObject["phoneNumber"], userAsMapObject["address"], userAsMapObject["userType"], userAsMapObject["isActive"]);
      user.userType = EUserType.driver;
    } else if(userAsMapObject["userType"] == "client") {
      user = UserModel.clientFromMap(userAsMapObject["displayName"], userAsMapObject["email"], userAsMapObject["phoneNumber"], userAsMapObject["address"], userAsMapObject["userType"]);
      user.userType = EUserType.client;
    }
    if(user.runtimeType == DriverModel || user.runtimeType == ClientModel)
      return user;
    else {
      this._coreService.showErrorDialog("Error Converting", "Error when converting json locally loged user from dart Map to UserModel");
      throw "Error Converting: Error when converting json locally loged user from dart Map to UserModel";
    }
  }

}