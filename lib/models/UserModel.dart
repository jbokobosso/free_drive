import 'package:free_drive/models/ClientModel.dart';
import 'package:free_drive/models/DriverModel.dart';
import 'package:free_drive/models/EUserType.dart';

abstract class UserModel {
  String id;
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

  static DriverModel driverFromMapOld(Map<String, dynamic> data) {
    return new DriverModel(
      data["displayName"],
      data["email"],
      data["phoneNumber"],
      data["address"],
      data["isActive"]
    );
  }

  static DriverModel driverFromMap(Map<String, dynamic> driver) {
    var driverObject = new DriverModel(
        driver["displayName"],
        driver["email"],
        driver["phoneNumber"],
        driver["address"],
        driver["isActive"]
    );
    return driverObject;
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