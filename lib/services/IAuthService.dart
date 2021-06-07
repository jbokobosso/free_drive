import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/models/EUserType.dart';
import 'package:free_drive/models/UserModel.dart';

abstract class IAuthService {

  Future<dynamic> registerByMail(String email, String password);
  Future<UserCredential> authenticateByMail(String email, String password);
  sendPasswordRecoveryMail(String email);
  confirmPasswordResetCode(String code, String newPassword);
  Future<bool> storeUserInfos(UserModel userModel);
}