import 'dart:io';

import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';

abstract class IAuthService {

  Future<bool> uploadLicencePictures(List<File> files, EUserType userType);
  Future<dynamic> registerByMail(UserModel user, List<File> files);
  Future<UserModel> authenticateByMail(UserModel user);
  Future<bool> logout();
  Future<bool> storeFirebaseUserInfos(UserModel userModel);
  Future<bool> markIntroPassed();
  Future<bool> checkIntroPassed();
  Future<bool> markLoggedUserLocally(UserModel user);
  Future<bool> markUserLoggedOut();
  Future<String> getLoggedUserTypeLocally();
  Future<UserModel> getLoggedUserLocally();
  Future<bool> checkUserLoggedLocally();
}