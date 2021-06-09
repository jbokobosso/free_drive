import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/models/UserModel.dart';

abstract class IAuthService {

  Future<dynamic> registerByMail(String email, String password);
  Future<dynamic> authenticateByMail(String email, String password);
  Future<bool> storeFirebaseUserInfos(UserModel userModel);
  Future<bool> markIntroPassed();
  Future<bool> checkIntroPassed();
  Future<bool> markUserLoggedLocally();
  Future<bool> checkUserLoggedLocally();
}