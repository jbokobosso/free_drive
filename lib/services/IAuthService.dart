import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {

  Future<UserCredential> registerByMail(String email, String password);
  Future<UserCredential> authenticateByMail(String email, String password);
  sendPasswordRecoveryMail(String email);
  confirmPasswordResetCode(String code, String newPassword);

}