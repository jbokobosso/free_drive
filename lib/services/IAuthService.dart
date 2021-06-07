import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {

  Future<dynamic> registerByMail(String email, String password);
  Future<UserCredential> authenticateByMail(String email, String password);
  sendPasswordRecoveryMail(String email);
  confirmPasswordResetCode(String code, String newPassword);
  Future<bool> storeUserInfos(String firstname, String lastname, String email, String phoneNumber, String address, String password);
}