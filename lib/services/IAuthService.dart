import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';

abstract class IAuthService {

  Future<dynamic> registerByMail(String email, String password);
  Future<dynamic> authenticateByMail(String email, String password);
  Future<bool> storeFirebaseUserInfos(UserModel userModel);
  Future<bool> markIntroPassed();
  Future<bool> checkIntroPassed();
  Future<bool> markLoggedUserLocally(EUserType chosenUserType);
  Future<String> getLoggedUserTypeLocally();
  Future<bool> checkUserLoggedLocally();
}