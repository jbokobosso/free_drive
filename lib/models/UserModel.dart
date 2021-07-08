import 'package:free_drive/models/EUserType.dart';

class UserModel {
  String displayName;
  String email;
  String phoneNumber;
  String address;
  EUserType userType;
  String password;
  bool isActive;

  UserModel(
      this.displayName,
      this.email,this.phoneNumber,
      this.address, this.userType,
      {this.isActive = true}
      );

  toMap() {
    return {
      "displayName": this.displayName,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "address": this.address,
      "userType": this.userType == EUserType.client ? "client" : "driver",
      "isActive": this.isActive
    };
  }

  static fromMap(String displayName, String email, String phoneNumber, String address, String userType, isActive) {
    return new UserModel(displayName, email, phoneNumber, address, userType == "client" ? EUserType.client : EUserType.driver, isActive: isActive);
  }
}