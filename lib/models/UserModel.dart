import 'package:free_drive/models/ClientModel.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';

abstract class UserModel {
  int id;
  String email;
  String password;
  String displayName;
  String phoneNumber;
  String address;
  EUserType userType;

  UserModel(this.displayName, this.email,this.phoneNumber, this.address, {this.password, this.id, this.userType});

  toMap({EUserType userType});

  static UserModel globalFromMap() {

  }

  static ClientModel clientFromMap(String displayName, String email, String phoneNumber, String address, String userType) {
    return new ClientModel(displayName, email, phoneNumber, address);
  }

  static ClientModel clientFromFirebase(Map<String, dynamic> jsonData) {
    return new ClientModel(
      jsonData["displayName"],
      jsonData["email"],
      jsonData["phoneNumber"],
      jsonData["address"],
      // jsonData["userType"] == "client" ? EUserType.client : EUserType.driver,
      // isActive: jsonData["isActive"]
    );
  }

  static DriverModel driverFromMap(String displayName, String email, String phoneNumber, String address, String userType, isActive) {
    return new DriverModel(displayName, email, phoneNumber, address, isActive);
  }

  static DriverModel driverFromFirebase(Map<String, dynamic> jsonData) {
    return new DriverModel(
        jsonData["displayName"],
        jsonData["email"],
        jsonData["phoneNumber"],
        jsonData["address"],
        jsonData["isActive"]
      // jsonData["userType"] == "client" ? EUserType.client : EUserType.driver,
    );
  }

}