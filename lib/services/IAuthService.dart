import 'dart:io';

import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';

abstract class IAuthService {

  Future<bool> uploadLicencePictures(List<File> files, EUserType userType);

  Future<bool> registerByMail(UserModel user, List<File> files);
  Future<UserModel> authenticateByMail(UserModel user);
  Future<void> recoverPassword(String email);
  Future<bool> logout();

  Future<bool> storeFirebaseUserInfos(UserModel userModel);

  Future<bool> markIntroPassed();
  Future<bool> checkIntroPassed();

  Future<bool> storeLoggedUser(UserModel user);
  Future<UserModel> getLoggedUser();
  Future<bool> storeDriverProfileStatus(bool profileActiveOrNot);
  Future<bool> getDriverProfileStatus();
  Future<bool> checkUserIsLogged();
  Future<bool> markUserLoggedOut();
}