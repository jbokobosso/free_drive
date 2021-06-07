import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/services/IAuthService.dart';

class AuthService with IAuthService {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential> registerByMail(String email, String password) async {
    UserCredential result = await this.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return result;
  }

  @override
  Future<UserCredential> authenticateByMail(String email, String password) async {
    var result = await this.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return result;
  }

  @override
  sendPasswordRecoveryMail(String email) async {
    await this.firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  confirmPasswordResetCode(String code, String newPassword) async {
    await this.firebaseAuth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

}