import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_drive/models/UserModel.dart';
import 'package:free_drive/services/IAuthService.dart';

class AuthService with IAuthService {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<dynamic> registerByMail(String email, String password) async {
    try{
      UserCredential result = await this.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (exception) {
      return exception;
    }

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

  @override
  Future<bool> storeUserInfos(
      String firstname,
      String lastname,
      String email,
      String phoneNumber,
      String address,
      String password) async {
    this.firebaseAuth.currentUser.updateDisplayName("$firstname $lastname");
    this.firebaseAuth.currentUser.updatePassword(password);
    var result = await this.firestore.collection("users")
        .add(new UserModel("$firstname $lastname", email, phoneNumber, address).toMap());
    if(result != null)
      return true;
    else
      return false;
  }

}