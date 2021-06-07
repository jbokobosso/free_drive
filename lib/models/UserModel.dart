import 'package:free_drive/models/EUserType.dart';

class UserModel {
  String displayName;
  String email;
  String phoneNumber;
  String address;
  EUserType userType;
  String password;

  UserModel(this.displayName, this.email,this.phoneNumber, this.address, this.userType);

  toMap() {
    return {
      "displayName": this.displayName,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "address": this.address,
      "userType": this.userType == EUserType.client ? "client" : "driver"
    };
  }

  static fromMap(String displayName, String email, String phoneNumber, String address, String userType) {
    return new UserModel(displayName, email, phoneNumber, address, userType == "client" ? EUserType.client : EUserType.driver);
  }
}