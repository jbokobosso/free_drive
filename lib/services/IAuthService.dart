import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';

abstract class IAuthService {

  Future<dynamic> registerByMail(UserModel user, String email, String password);
  Future<dynamic> authenticateByMail(UserModel user, String email, String password);
  Future<bool> logout();
  Future<bool> storeFirebaseUserInfos(UserModel userModel);
  Future<bool> markIntroPassed();
  Future<bool> checkIntroPassed();
  Future<bool> markLoggedUserLocally(UserModel user, EUserType chosenUserType);
  Future<bool> markUserLoggedOut();
  Future<String> getLoggedUserTypeLocally();
  Future<UserModel> getLoggedUserLocally();
  Future<bool> checkUserLoggedLocally();
}